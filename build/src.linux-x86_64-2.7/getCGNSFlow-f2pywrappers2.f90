!     -*- f90 -*-
!     This file is autogenerated with f2py (version:2)
!     It contains Fortran 90 wrappers to fortran functions.

      
      subroutine f2pyinitflow_module(f2pysetupfunc)
      use flow_module, only : get_flow_f
      external f2pysetupfunc
      call f2pysetupfunc(get_flow_f)
      end subroutine f2pyinitflow_module

