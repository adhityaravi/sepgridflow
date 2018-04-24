
subroutine un_3d_he(fileName, zoneName)

  implicit none

  include 'cgnslib_f.h'

  ! Dummy
  integer :: nNodes, ier,  cellDim, physDim, nElem, nElemStart, nElemEnd, nBdyElem, i
  integer :: iFile, iB, iZ, iS, iFlow, iMeshVar, iFlowVar
  integer, dimension(1,3) :: isize
  character :: basename*32, solname*32
  character(*), intent(in) :: fileName, zoneName
  integer, dimension(3) :: iC, iField

  ! --------------------------------------------------------------------
  ! open CGNS file to write OR edit and create/read base

  basename = 'Base'
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

  call cg_section_write_f(iFile, iB, iZ, 'Elem', HEXA_8, nElemStart, nElemEnd, nBdyElem, conn, iS,ier)
  call check_cg_error_f(ier)

! ---------------------------------------------------------------------
! Flow Solution


  ! define flow solution node name (user can give any name)
  solname = 'FlowSolution'
  ! create flow solution node
  call cg_sol_write_f(iFile, iB, iZ, solname, Vertex,iFlow,ier)
  call check_cg_error_f(ier)

  ! write flow solution (user must use SIDS-standard names here)
  do iFlowVar = 1, nFlowVar
    call cg_field_write_f(iFile, iB, iZ, iFlow, RealDouble, UVar(iFlowVar), U(:,1,1,iFlowVar), iField(iFlowVar), ier)
    call check_cg_error_f(ier)
  enddo


! ----------------------------------------------------------
! close CGNS file
  call cg_close_f(iFile,ier)

end subroutine un_3d_he
