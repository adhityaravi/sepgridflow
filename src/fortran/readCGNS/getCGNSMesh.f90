module mesh_module

contains

  subroutine get_mesh_f(           &
       X, ni, nj, nk, nMeshVar,    &
       connectivity, nConi, nConj, &
       fileName,                   &
       iZone,                      &
       baseDim,                    &
       meshType,                   &
       meshDim,                    &
       XVar                        &
       )
  
  implicit none

  include 'cgnslib_f.h'

  ! In
  real(kind=8), intent(inout), dimension(ni, nj, nk, nMeshVar) :: X

  integer, intent(inout), dimension(nConi,nConj) :: connectivity

  character(*), intent(in) :: fileName
  integer, intent(in) :: iZone
  integer, intent(in) :: baseDim
  integer, intent(in) :: meshType
  integer, intent(in), dimension(3,3) :: meshDim
  character*11, intent(in), dimension(nMeshVar) :: XVar
  
  ! Local
  integer :: iBase
  integer, allocatable, dimension(:) :: rangeMin, rangeMax
  integer :: iFile, ier, iSection, parentData
  integer :: ni, nj, nk,    &
             nConi, nConj,  &
             nMeshVar, iMeshVar
  
  !f2py intent(hide),depend(X) :: ni=shape(X,0),nj=shape(X,1),nk=shape(X,2),nMeshVar=shape(X,3)
  !f2py intent(hide),depend(connectivity) :: nConi=shape(connectivity,0),nConj=shape(connectivity,1)

  ! ASSUMPTION: 1 section
  iSection = 1
  iBase = 1

  
  if (allocated(rangeMin)) then
    deallocate(rangeMin)
  endif

  
  ! Open cgns file
  call cg_open_f(fileName, cg_mode_read, iFile, ier)
  call check_cg_error_f(ier)


  if (meshType == Structured) then

    !allocate(connectivity(1,1))
    connectivity = 0

    allocate(rangeMin(nMeshVar))
    allocate(rangeMax(nMeshVar))
 
    rangeMin = 1
    do iMeshVar = 1, nMeshVar	
    	rangeMax(iMeshVar) = meshDim(1, iMeshVar)
    enddo

    ! read coordinates
    do iMeshVar = 1, nMeshVar
    
    	call cg_coord_read_f(iFile, iBase, iZone, XVar(iMeshVar), RealDouble, rangeMin, rangeMax, X(:, :, :, iMeshVar), ier)
    	call check_cg_error_f(ier)
    
    enddo

  elseif (meshType == Unstructured) then

    call cg_elements_read_f(iFile, iBase, iZone, iSection, connectivity, parentData, ier)
    call check_cg_error_f(ier)

    allocate(rangeMin(1))
    allocate(rangeMax(1))
    rangeMin = 1
    rangeMax(1) = meshDim(1,1)

    ! read coordinates
    do iMeshVar = 1, nMeshVar
    
    	call cg_coord_read_f(iFile, iBase, iZone, XVar(iMeshVar), RealDouble, rangeMin, rangeMax, X(:, :, :, iMeshVar), ier)
    	call check_cg_error_f(ier)
    
    enddo
  
  endif
     
  deallocate(rangeMin)
  deallocate(rangeMax)

  ! close cgns file
  call cg_close_f(iFile, ier)
  call check_cg_error_f(ier)

  end subroutine get_mesh_f

end module mesh_module

