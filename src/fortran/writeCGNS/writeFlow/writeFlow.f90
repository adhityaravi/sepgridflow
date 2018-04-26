module write_flow

  integer :: ni, nj, nk, nFlowVar, writeType, iZ, nElem, nMFN, nGNP, nCNP

  real(kind=8), allocatable, dimension(:,:,:,:) :: U
  integer, allocatable, dimension(:,:) :: conn

  character (len=9), allocatable, dimension(:) :: UVar
  character, allocatable, dimension(:) :: meshFileName
  character, allocatable, dimension(:) :: gridNodePath
  character, allocatable, dimension(:) :: connNodePath


contains

  !~~~~~~~~~~~~~~~~~~
  ! SUBROUTINE init()
  !~~~~~~~~~~~~~~~~~~

  subroutine init(                            &
      UIn, niIn, njIn, nkIn, nFlowVarIn,      &
      iZone, writeTypeIn, nElemIn,            &
      UVarIn, meshFileNameIn, gridNodePathIn, &
      connNodePathIn,                         &
      nMFNIn, nGNPIn, nCNPIn                  &
      )

    implicit none

    ! Local
    integer :: niIn, njIn, nkIn, nFlowVarIn

    ! In
    real(kind=8), intent(in), dimension(niIn, njIn, nkIn, nFlowVarIn) :: UIn
    integer, intent(in) :: iZone, writeTypeIn, nMFNIn, nGNPIn, nElemIn, nCNPIn
    character*9, intent(in), dimension(nFlowVarIn) :: UVarIn
    character, intent(in), dimension(nMFNIn) :: meshFileNameIn
    character, intent(in), dimension(nGNPIn) :: gridNodePathIn
    character, intent(in), dimension(nCNPIn) :: connNodePathIn

    !f2py intent(hide),depend(XIn) :: niIn=shape(UIn,0),njIn=shape(UIn,1),nkIn=shape(UIn,2)
    !f2py intent(hide),depend(UIn) :: nFlowVarIn=shape(UIn,3)

    ! increment iZone to convert to fortran notation (+1 in comparison to python)
    iZ = iZone
    iZ = iZ + 1
    writeType = writeTypeIn

    ni = niIn
    nj = njIn
    nk = nkIn

    ! String management variables
    nMFN = nMFNIn
    nGNP = nGNPIn
    nCNP = nCNPIn

    nElem = nElemIn
    nFlowVar = nFlowVarIn

    if (allocated(U)) then
      deallocate(U)
      deallocate(UVar)
      deallocate(meshFileName)
      deallocate(gridNodePath)
      deallocate(connNodePath)
    endif

    allocate(U(ni, nj, nk, nFlowVar))
    allocate(UVar(nFlowVar))
    allocate(meshFileName(nMFN))
    allocate(gridNodePath(nGNP))
    allocate(connNodePath(nCNP))


    ! Arrays
    U = UIn
    UVar = UVarIn
    ! Note: Here the names are an array of characters which cannot be used as a string
    meshFileName = meshFileNameIn
    gridNodePath = gridNodePathIn
    connNodePath = connNodePathIn

  end subroutine init

  !~~~~~~~~~~~~~~~~~~~~~~
  ! SUBROUTINE un_2d_tr()
  !~~~~~~~~~~~~~~~~~~~~~~

  include 'un_2d_tr.f90'

  !~~~~~~~~~~~~~~~~~~~~~~
  ! SUBROUTINE un_3d_te()
  !~~~~~~~~~~~~~~~~~~~~~~

  include 'un_3d_te.f90'

  !~~~~~~~~~~~~~~~~~~~~~~
  ! SUBROUTINE un_2d_qu()
  !~~~~~~~~~~~~~~~~~~~~~~

  include 'un_2d_qu.f90'

  !~~~~~~~~~~~~~~~~~~~~~~
  ! SUBROUTINE un_3d_he()
  !~~~~~~~~~~~~~~~~~~~~~~

  include 'un_3d_he.f90'

  !~~~~~~~~~~~~~~~~~~~~~~
  ! SUBROUTINE un_3d_pe()
  !~~~~~~~~~~~~~~~~~~~~~~

  include 'un_3d_pe.f90'

  !!~~~~~~~~~~~~~~~~~~~~~~
  !! SUBROUTINE eq_2d_qu()
  !!~~~~~~~~~~~~~~~~~~~~~~

  !include 'eq_2d_qu.f90'

  !!~~~~~~~~~~~~~~~~~~~~~~
  !! SUBROUTINE eq_3d_he()
  !!~~~~~~~~~~~~~~~~~~~~~~

  !include 'eq_3d_he.f90'

  !~~~~~~~~~~~~~~~~~~~~~~
  ! SUBROUTINE st_2d_qu()
  !~~~~~~~~~~~~~~~~~~~~~~

  include 'st_2d_qu.f90'

  !~~~~~~~~~~~~~~~~~~~~~~
  ! SUBROUTINE st_3d_he()
  !~~~~~~~~~~~~~~~~~~~~~~

  include 'st_3d_he.f90'

end module write_flow
