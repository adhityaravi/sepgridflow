!     -*- f90 -*-
!     This file is autogenerated with f2py (version:2)
!     It contains Fortran 90 wrappers to fortran functions.

      subroutine f2py_infos_module_getdims_meshtype(r,s,f2pysetdata,flag&
     &)
      use infos_module, only: d => meshtype

      integer flag
      external f2pysetdata
      logical ns
      integer r,i
      integer(8) s(*)
      ns = .FALSE.
      if (allocated(d)) then
         do i=1,r
            if ((size(d,i).ne.s(i)).and.(s(i).ge.0)) then
               ns = .TRUE.
            end if
         end do
         if (ns) then
            deallocate(d)
         end if
      end if
      if ((.not.allocated(d)).and.(s(1).ge.1)) then
       allocate(d(s(1)))
      end if
      if (allocated(d)) then
         do i=1,r
            s(i) = size(d,i)
         end do
      end if
      flag = 1
      call f2pysetdata(d,allocated(d))
      end subroutine f2py_infos_module_getdims_meshtype
      subroutine f2py_infos_module_getdims_nnodeselem(r,s,f2pysetdata,fl&
     &ag)
      use infos_module, only: d => nnodeselem

      integer flag
      external f2pysetdata
      logical ns
      integer r,i
      integer(8) s(*)
      ns = .FALSE.
      if (allocated(d)) then
         do i=1,r
            if ((size(d,i).ne.s(i)).and.(s(i).ge.0)) then
               ns = .TRUE.
            end if
         end do
         if (ns) then
            deallocate(d)
         end if
      end if
      if ((.not.allocated(d)).and.(s(1).ge.1)) then
       allocate(d(s(1)))
      end if
      if (allocated(d)) then
         do i=1,r
            s(i) = size(d,i)
         end do
      end if
      flag = 1
      call f2pysetdata(d,allocated(d))
      end subroutine f2py_infos_module_getdims_nnodeselem
      subroutine f2py_infos_module_getdims_meshdim(r,s,f2pysetdata,flag)
      use infos_module, only: d => meshdim

      integer flag
      external f2pysetdata
      logical ns
      integer r,i
      integer(8) s(*)
      ns = .FALSE.
      if (allocated(d)) then
         do i=1,r
            if ((size(d,i).ne.s(i)).and.(s(i).ge.0)) then
               ns = .TRUE.
            end if
         end do
         if (ns) then
            deallocate(d)
         end if
      end if
      if ((.not.allocated(d)).and.(s(1).ge.1)) then
       allocate(d(s(1),s(2),s(3)))
      end if
      if (allocated(d)) then
         do i=1,r
            s(i) = size(d,i)
         end do
      end if
      flag = 1
      call f2pysetdata(d,allocated(d))
      end subroutine f2py_infos_module_getdims_meshdim
      subroutine f2py_infos_module_getdims_elemtype(r,s,f2pysetdata,flag&
     &)
      use infos_module, only: d => elemtype

      integer flag
      external f2pysetdata
      logical ns
      integer r,i
      integer(8) s(*)
      ns = .FALSE.
      if (allocated(d)) then
         do i=1,r
            if ((size(d,i).ne.s(i)).and.(s(i).ge.0)) then
               ns = .TRUE.
            end if
         end do
         if (ns) then
            deallocate(d)
         end if
      end if
      if ((.not.allocated(d)).and.(s(1).ge.1)) then
       allocate(d(s(1)))
      end if
      if (allocated(d)) then
         do i=1,r
            s(i) = size(d,i)
         end do
      end if
      flag = 1
      call f2pysetdata(d,allocated(d))
      end subroutine f2py_infos_module_getdims_elemtype
      subroutine f2py_infos_module_getdims_nelem(r,s,f2pysetdata,flag)
      use infos_module, only: d => nelem

      integer flag
      external f2pysetdata
      logical ns
      integer r,i
      integer(8) s(*)
      ns = .FALSE.
      if (allocated(d)) then
         do i=1,r
            if ((size(d,i).ne.s(i)).and.(s(i).ge.0)) then
               ns = .TRUE.
            end if
         end do
         if (ns) then
            deallocate(d)
         end if
      end if
      if ((.not.allocated(d)).and.(s(1).ge.1)) then
       allocate(d(s(1)))
      end if
      if (allocated(d)) then
         do i=1,r
            s(i) = size(d,i)
         end do
      end if
      flag = 1
      call f2pysetdata(d,allocated(d))
      end subroutine f2py_infos_module_getdims_nelem
      subroutine f2py_infos_module_getdims_zonenames(r,s,f2pysetdata,fla&
     &g)
      use infos_module, only: d => zonenames

      integer flag
      external f2pysetdata
      logical ns
      integer r,i
      integer(8) s(*)
      ns = .FALSE.
      if (allocated(d)) then
         do i=1,r
            if ((size(d,i).ne.s(i)).and.(s(i).ge.0)) then
               ns = .TRUE.
            end if
         end do
         if (ns) then
            deallocate(d)
         end if
      end if
      if ((.not.allocated(d)).and.(s(1).ge.1)) then
       allocate(d(s(1)))
      end if
      if (allocated(d)) then
         do i=1,r
            s(i) = size(d,i)
         end do
         !s(r) must be equal to len(d(1))
      end if
      flag = 2
      call f2pysetdata(d,allocated(d))
      end subroutine f2py_infos_module_getdims_zonenames
      
      subroutine f2pyinitinfos_module(f2pysetupfunc)
      use infos_module, only : nzones
      use infos_module, only : physdim
      use infos_module, only : meshtype
      use infos_module, only : celldim
      use infos_module, only : nnodeselem
      use infos_module, only : meshdim
      use infos_module, only : elemtype
      use infos_module, only : nelem
      use infos_module, only : zonenames
      use infos_module, only : get_cgns_infos_f
      use infos_module, only : deallocateall
      external f2pysetupfunc
      external f2py_infos_module_getdims_meshtype
      external f2py_infos_module_getdims_nnodeselem
      external f2py_infos_module_getdims_meshdim
      external f2py_infos_module_getdims_elemtype
      external f2py_infos_module_getdims_nelem
      external f2py_infos_module_getdims_zonenames
      call f2pysetupfunc(nzones,physdim,f2py_infos_module_getdims_meshty&
     &pe,celldim,f2py_infos_module_getdims_nnodeselem,f2py_infos_module_&
     &getdims_meshdim,f2py_infos_module_getdims_elemtype,f2py_infos_modu&
     &le_getdims_nelem,f2py_infos_module_getdims_zonenames,get_cgns_info&
     &s_f,deallocateall)
      end subroutine f2pyinitinfos_module


