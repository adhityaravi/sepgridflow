
subroutine un_2d_tr(fileName,zoneName)

  implicit none

  include 'cgnslib_f.h'

  character(*), intent(in) :: fileName, zoneName

  integer :: ier, cellDim, physDim, nelem_start, nelem_end, nbdyelem 
  integer :: iFile, iB, iSection, iFlow, iMeshVar, iFlowVar
  integer, dimension(1,3) :: isize
  character(len=32) :: basename, solname
  integer, dimension(2) :: iC, iField


  ! --------------------------------------------------------------------
  ! open CGNS file to write OR edit and create/read base

  ! !!!DO NOT CHANGE THE 'basename', AS THE FLOW IS LINKED TO THIS BASE NAME!!!
  ! ToDo: Pass the basename as an argument for more flexibility
  basename = 'GridBase'

  ! In 2D unstr.
  cellDim=2
  physDim=2

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

  ! --------------------------------------------------------------------
  ! Create Zone
  ! vertex size
  isize(1,1)=ni
  ! cell size
  isize(1,2)=nCony
  ! boundary vertex size (zero if elements not sorted)
  isize(1,3)=0
  ! create zone
  call cg_zone_write_f(iFile,iB,zonename,isize, Unstructured,iZ,ier)
  call check_cg_error_f(ier)

  ! ---------------------------------------------------------------------
  ! write grid coordinates (user must use SIDS-standard names here)
  do iMeshVar = 1, nMeshVar
    call cg_coord_write_f(iFile, iB, iZ, RealDouble, XVar(iMeshVar), X(:,:,:,iMeshVar), iC(iMeshVar), ier)
    call check_cg_error_f(ier)
  enddo

  ! ---------------------------------------------------------------------
  ! Elements connectivity

  ! index no of first element
  nelem_start = 1
  nelem_end = nCony
  ! unsorted boundary elements
  nbdyelem=0

  call cg_section_write_f(iFile, iB, iZ, 'Elem', TRI_3, nelem_start, nelem_end, nbdyelem, conn, iSection,ier)
  call check_cg_error_f(ier)


  ! ----------------------------------------------------------
  ! close CGNS file
  call cg_close_f(iFile,ier)

end subroutine un_2d_tr
