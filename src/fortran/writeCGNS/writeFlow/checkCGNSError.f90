subroutine check_cg_error_f(ier)

implicit none

include 'cgnslib_f.h'

integer ier

if (ier .ne. CG_OK) then
  call cg_error_exit_f
endif

end
