!     -*- f90 -*-
!     This file is autogenerated with f2py (version:2)
!     It contains Fortran 90 wrappers to fortran functions.

      
      subroutine f2pyinitmesh_module(f2pysetupfunc)
      use mesh_module, only : get_mesh_f
      external f2pysetupfunc
      call f2pysetupfunc(get_mesh_f)
      end subroutine f2pyinitmesh_module


