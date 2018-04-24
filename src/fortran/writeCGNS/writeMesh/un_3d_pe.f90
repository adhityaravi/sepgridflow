
subroutine un_3d_pe(fileName, zoneName)

  implicit none

  include 'cgnslib_f.h'

  ! Dummy
  integer :: nNodes, ier,  cellDim, physDim, nElem, nElemStart, nElemEnd, nBdyElem, i
  integer :: iFile, iB, iZ, iCX, iCY, iCZ, iS, iFlow, iU, iV, iW, iMeshVar, iFlowVar
  integer, dimension(1,3) :: isize
  character :: basename*32, solname*32
  character(*), intent(in) :: fileName, zoneName
  integer, dimension(3) :: iC, iField

  ! --------------------------------------------------------------------
  ! open CGNS file to write OR edit and create/read base

  ! !!!DO NOT CHANGE THE 'basename', AS THE FLOW IS LINKED TO THIS BASE NAME!!!
  ! ToDo: Pass the basename as an argument for more flexibility
  basename = 'GridBase'
  ! In 3d unstr.
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
    call cg_coord_write_f(iFile, iB, iZ, RealDouble, XVar(iMeshVar), X(:,1,1,iMeshVar), iC(iMeshVar), ier)
    call check_cg_error_f(ier)
  enddo

! ---------------------------------------------------------------------
! Elements connectivity

! index no of first element
  nElemStart = 1
  nElemEnd = nCony
! unsorted boundary elements
  nBdyElem=0

  call cg_section_write_f(iFile, iB, iZ, 'Elem', PENTA_6, nElemStart, nElemEnd, nBdyElem, conn, iS,ier)
  call check_cg_error_f(ier)


! ----------------------------------------------------------
! close CGNS file
  call cg_close_f(iFile,ier)

end subroutine un_3d_pe
