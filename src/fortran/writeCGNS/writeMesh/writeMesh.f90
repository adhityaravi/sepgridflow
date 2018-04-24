module write_mesh

  integer :: ni, nj, nk, nMeshVar, nFlowVar, nConx, nCony, writeType, iZ

  real(kind=8), allocatable, dimension(:,:,:,:) :: X

  integer, allocatable, dimension(:,:) :: conn

  character (len=11), allocatable, dimension(:) :: XVar


contains

  !~~~~~~~~~~~~~~~~~~
  ! SUBROUTINE init()
  !~~~~~~~~~~~~~~~~~~

  subroutine init(                      &
      XIn, niIn, njIn, nkIn, nMeshVarIn,&
      connIn, nConxIn, nConyIn,         &
      iZone, writeTypeIn,               &
      XVarIn                            &
      )

    implicit none

    ! Local
    integer :: niIn, njIn, nkIn, nMeshVarIn,  &
               nConxIn, nConyIn

    ! In
    real(kind=8), intent(in), dimension(niIn, njIn, nkIn, nMeshVarIn) :: XIn
    integer, intent(in), dimension(nConxIn, nConyIn) :: connIn
    integer, intent(in) :: iZone, writeTypeIn
    character*11, intent(in), dimension(nMeshVarIn) :: XVarIn

    !f2py intent(hide),depend(XIn) :: niIn=shape(XIn,0),njIn=shape(XIn,1),nkIn=shape(XIn,2),nMeshVarIn=shape(XIn,3)
    !f2py intent(hide),depend(UIn) :: nFlowVarIn=shape(UIn,3)
    !f2py intent(hide),depend(connIn) :: nConxIn=shape(connIn,0),nConyIn=shape(connIn,1)

    ! increment iZone to convert to fortran notation (+1 in comparison to python)
    iZ = iZone
    iZ = iZ + 1
    writeType = writeTypeIn

    ni = niIn
    nj = njIn
    nk = nkIn

    nMeshVar = nMeshVarIn

    nConx = nConxIn
    nCony = nConyIn

    if (allocated(X)) then
      deallocate(X)
      deallocate(conn)
      deallocate(XVar)
    endif

    allocate(X(ni, nj, nk, nMeshVar))
    allocate(conn(nConx,nCony))
    allocate(XVar(nMeshVar))

    ! Arrays
    X = XIn
    XVar = XVarIn

    conn = connIn

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

end module write_mesh
