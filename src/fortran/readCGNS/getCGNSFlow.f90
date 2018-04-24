module flow_module

contains

  subroutine get_flow_f(      &
      U, ni, nj, nk, nFlowVar,&
      fileName,               &
      iZone,                  &
      physDim,                &
      meshType,               &
      zoneSize,               &
      UVar                    &
      )

  implicit none

  include 'cgnslib_f.h'

  real(kind=8), intent(inout), dimension(ni,nj,nk,nFlowVar) :: U

  character(*), intent(in) :: fileName
  integer, intent(in) :: iZone
  integer, intent(in) :: physDim
  integer, intent(in) :: meshType
  integer, intent(in), dimension(3,3) :: zoneSize
  character*9, intent(in), dimension(nFlowVar) :: UVar

  ! Local
  integer, allocatable, dimension(:) :: rangeMin, rangeMax
  integer :: iBase,iFile, ier, iFlow, nSols
  integer :: ni, nj, nk, &
             nFlowVar, iFlowVar
  
  !f2py intent(hide),depend(U) :: ni=shape(U,0),nj=shape(U,1),nk=shape(U,2),nFlowVar=shape(U,3)

  ! Suppose only one flow solution!
  iFlow = 1
  iBase = 1

  ! Open cgns file
  call cg_open_f(fileName, cg_mode_read, iFile, ier)
  call check_cg_error_f(ier)

  ! Check no of solution nodes
  call cg_nsols_f(iFile, iBase, iZone, nSols, ier) 
  call check_cg_error_f(ier)

  if (nSols == 0) then
    print *, 'No solution node in this zone'
  else

  if (meshType == Structured) then

    allocate(rangeMin(nFlowVar))
    allocate(rangeMax(nFlowVar))

    rangeMin = 1
    do iFlowVar = 1, nFlowVar
      rangeMax(iFlowVar) = zoneSize(1, iFlowVar)
    enddo

    ! read Flow
    do iFlowVar=1, nFlowVar

      call cg_field_read_f(iFile, iBase, iZone, iFlow, UVar(iFlowVar), RealDouble, rangeMin, rangeMax, U(:,:,:,iFlowVar), ier)
      call check_cg_error_f(ier)

    enddo


  elseif (meshType == Unstructured) then

    allocate(rangeMin(1))
    allocate(rangeMax(1))
    rangeMin = 1
    rangeMax(1) = zoneSize(1,1)

    ! read Flow
    do iFlowVar = 1, nFlowVar

      call cg_field_read_f(iFile, iBase, iZone, iFlow, UVar(iFlowVar), RealDouble, rangeMin, rangeMax, U(:,:,:,iFlowVar), ier)
      call check_cg_error_f(ier)

    enddo

  endif

  deallocate(rangeMin)
  deallocate(rangeMax)
  endif

  ! Close cgns file
  call cg_close_f(iFile, ier)
  call check_cg_error_f(ier)

  end subroutine get_flow_f

end module flow_module
