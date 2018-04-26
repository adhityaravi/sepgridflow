subroutine un_3d_te(fileName,zoneName)

  implicit none

  include 'cgnslib_f.h'

  ! Dummy
  integer :: nNodes, ier,  cellDim, physDim, nElemStart, nElemEnd, nBdyElem, i
  integer :: iFile, iB, iZ, iCX, iCY, iCZ, iS, iFlow, iMeshVar, iFlowVar
  integer, dimension(1,3) :: isize
  character :: basename*32, solname*32
  character(len=260) :: zoneNodePath
  character(len=nMFN) :: meshFileN
  character(len=nGNP) :: gridNodeP
  character(len=nCNP) :: connNodeP
  character(*), intent(in) :: fileName, zoneName
  integer, dimension(3) :: iC, iField

  ! Converting the names read from python, which are array of characters, to a string
  call str_mgmt(meshFileName, meshFileN, nMFN)
  call str_mgmt(gridNodePath, gridNodeP, nGNP)
  call str_mgmt(connNodePath, connNodeP, nCNP)

  ! --------------------------------------------------------------------
  ! open CGNS file to write OR edit and create/read base
  basename = 'FlowSolutionBase'
  ! In 3D unstr
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
  isize(1,2)=nElem
! boundary vertex size (zero if elements not sorted)
  isize(1,3)=0
! create zone
  call cg_zone_write_f(iFile,iB,zonename,isize, Unstructured,iZ,ier)
  call check_cg_error_f(ier)

  !---------------------------------------------------------------------
  ! Linking to a grid file
  ! Go to the current zone node
  zoneNodePath = '/' // trim(basename) // '/' // trim(zonename)
  call cg_gopath_f(iFile, trim(zoneNodePath), ier)
  call check_cg_error_f(ier)

  ! Link the zone node to the grid node of the specified grid file
  call cg_link_write_f('GridCoordinates', meshFileN, gridNodeP, ier)
  call check_cg_error_f(ier)

  ! Link the zone node to the elem node (connectivity) node of the specified grid file
  call cg_link_write_f('Elem', meshFileN, connNodeP, ier)
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

end subroutine un_3d_te
