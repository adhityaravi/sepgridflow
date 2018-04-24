subroutine st_3d_he(fileName,zoneName)

  implicit none

  include 'cgnslib_f.h'

  ! INPUT PARAMETERS
  character(*), intent(in) :: fileName, zoneName

  ! COMPUTED/DUMMY PARAMETERS
  integer, dimension(3,3) :: isize
  integer :: iFile, iB, iZ, iFlow, cellDim, physDim, ier, iMeshVar, iFlowVar
  character :: basename*32, solname*32
  integer, dimension(3) :: iC, iField


  ! --------------------------------------------------------------------
  ! open CGNS file to write OR edit and create/read base

  ! !!!DO NOT CHANGE THE 'basename', AS THE FLOW IS LINKED TO THIS BASE NAME!!!
  ! ToDo: Pass the basename as an argument for more flexibility
  basename = 'GridBase'
  ! In 2D unstr.
  cellDim=3
  physDim=3

  if (writeType == 0) then

    call cg_open_f(fileName,cg_mode_write,iFile,ier)
    call check_cg_error_f(ier)

    ! write base
    call cg_base_write_f(iFile,basename,cellDim,physDim, iB,ier)
    call check_cg_error_f(ier)
  elseif (writeType == 1) then
    call cg_open_f(fileName,cg_mode_modify,iFile,ier)
    call check_cg_error_f(ier)

    ! Simply go to base
    iB = 1
    call cg_goto_f(iFile,iB,ier,'end')
    call check_cg_error_f(ier)
  endif


  ! ---------------------------------------------------------------------
  ! create ZONE (user can give any name)

  ! vertex size
  isize = 0
  isize(1,1)=ni
  isize(2,1)=nj
  isize(3,1)=nk
  ! cell size
  isize(1,2)=isize(1,1)-1
  isize(2,2)=isize(2,1)-1
  isize(3,2)=isize(3,1)-1
  ! Boundary vertex size (always zero for structured grids)
  isize(:,3)=0
  ! create zone
  call cg_zone_write_f(iFile,iB,zonename,isize, Structured,iZ,ier)
  call check_cg_error_f(ier)

  ! ---------------------------------------------------------------------
  ! write COORDINATES
  do iMeshVar = 1, nMeshVar
    call cg_coord_write_f(iFile, iB, iZ, RealDouble, XVar(iMeshVar), X(:,1,1,iMeshVar), iC(iMeshVar), ier)
    call check_cg_error_f(ier)
  enddo

  ! ---------------------------------------------------------------------
  ! Close file

  call cg_close_f(iFile,ier)
  call check_cg_error_f(ier)
end subroutine st_3d_he
