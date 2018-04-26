subroutine str_mgmt(NameIn, NameOut, nC)
    ! Converts an array of characters into a single string

    ! In
    integer, intent(in) :: nC

    character, intent(in), dimension(nC) :: NameIn

    ! InOut
    character(len=nC), intent(inout) :: NameOut

    ! Local
    integer :: i

    do i = 1, nC
        NameOut(i:i) = NameIn(i)
    enddo

end subroutine str_mgmt