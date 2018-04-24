module infos_module

  implicit none

  integer :: cellDim
  integer :: physDim
  integer, allocatable, dimension(:) :: meshType
  integer, allocatable, dimension(:,:,:) :: meshDim
  integer :: nZones
  integer, allocatable, dimension(:) :: nElem
  integer, allocatable, dimension(:) :: nNodesElem
  integer, allocatable, dimension(:) :: elemType
  character(len=32), allocatable :: zoneNames(:)

contains

  subroutine get_cgns_infos_f(fileName)

    implicit none

    include 'cgnslib_f.h'

    character(*) :: fileName
    character :: baseName*32, zoneName*32, secName*32
    integer :: iFile, ier, elemStart, elemEnd, nBdry, parentFlag, elemTypeZ, nNodes
    integer :: iBase, iZone, iSection, nSection, meshTypeLoc
    integer, allocatable, dimension(:,:) :: meshDimLoc

    ! Check allocation
    call deallocateAll()

    ! ASSUMPTION: only one section!
    iSection = 1
    iBase = 1

    ! Open file
    call cg_open_f(fileName, cg_mode_read, iFile, ier)
    call check_cg_error_f(ier)

    ! get number of bases (handles only one base)
    call cg_nbases_f(iFile, iBase, ier) 
    call check_cg_error_f(ier)
    if (iBase /= 1) then
      print *, 'Error: xAMC can only handle cases with one base'
      call exit(1)
    endif

    ! get number of zones
    call cg_nzones_f(iFile, iBase, nZones, ier)
    call check_cg_error_f(ier)

    ! Allocation
    allocate(meshType(nZones))
    allocate(meshDim(nZones, 3,3))
    allocate(nElem(nZones))
    allocate(nNodesElem(nZones))
    allocate(elemType(nZones))
    allocate(zoneNames(nZones))

    ! initialize
    cellDim = 0
    physDim = 0
    meshType = 0
    meshDim = 0
    nElem = 0
    nNodesElem = 0
    elemType = 0

    ! Get zone dimensions
    call cg_base_read_f(iFile, iBase, baseName, cellDim, physDim, ier)
    call check_cg_error_f(ier)

    do iZone = 1, nZones

      ! Get meshTypeLoc (str, unstr)
      call cg_zone_type_f(iFile, iBase, iZone, meshTypeLoc, ier)
      call check_cg_error_f(ier)
      meshType(iZone) = meshTypeLoc

      if (meshTypeLoc == Unstructured) then
        call cg_section_read_f(iFile, iBase, iZone, iSection, secName, elemTypeZ, elemStart, elemEnd, nBdry, parentFlag, ier)
        call check_cg_error_f(ier)
        nElem(iZone) = elemEnd - elemStart + 1
        call cg_npe_f(elemTypeZ, nNodes, ier)
        call check_cg_error_f(ier)
        nNodesElem(iZone) = nNodes
        elemType(iZone) = elemTypeZ
      endif

      if (allocated(meshDimLoc)) then
        deallocate(meshDimLoc)
      endif

      ! Get meshDimLoc (2d, 3d)
      if (meshTypeLoc == Unstructured) then
        allocate(meshDimLoc(1,3))
      elseif (meshTypeLoc == Structured) then
        if (cellDim == 2) then
          allocate(meshDimLoc(2,3))
        elseif (cellDim == 3) then
          allocate(meshDimLoc(3,3))
        endif
      endif

      meshDimLoc = 0
      call cg_zone_read_f(iFile, iBase, iZone, zoneName, meshDimLoc, ier) 
      call check_cg_error_f(ier)

      meshDim(iZone, :,:) = meshDimLoc
      zoneNames(iZone) = zoneName

    enddo

    ! close file
    call cg_close_f(iFile, ier)
    call check_cg_error_f(ier)

  end subroutine get_cgns_infos_f

  subroutine deallocateAll()

    implicit none

    if (allocated(meshType)) then
      deallocate(meshType)
      deallocate(meshDim)
      deallocate(nElem)
      deallocate(nNodesElem)
      deallocate(elemType)
      deallocate(zoneNames)
    endif

  end subroutine deallocateAll

end module infos_module
