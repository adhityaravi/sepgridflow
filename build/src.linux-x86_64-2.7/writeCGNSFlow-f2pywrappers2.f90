!     -*- f90 -*-
!     This file is autogenerated with f2py (version:2)
!     It contains Fortran 90 wrappers to fortran functions.

      subroutine f2py_write_flow_getdims_meshfilename(r,s,f2pysetdata,fl&
     &ag)
      use write_flow, only: d => meshfilename

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
      end subroutine f2py_write_flow_getdims_meshfilename
      subroutine f2py_write_flow_getdims_gridnodepath(r,s,f2pysetdata,fl&
     &ag)
      use write_flow, only: d => gridnodepath

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
      end subroutine f2py_write_flow_getdims_gridnodepath
      subroutine f2py_write_flow_getdims_conn(r,s,f2pysetdata,flag)
      use write_flow, only: d => conn

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
       allocate(d(s(1),s(2)))
      end if
      if (allocated(d)) then
         do i=1,r
            s(i) = size(d,i)
         end do
      end if
      flag = 1
      call f2pysetdata(d,allocated(d))
      end subroutine f2py_write_flow_getdims_conn
      subroutine f2py_write_flow_getdims_u(r,s,f2pysetdata,flag)
      use write_flow, only: d => u

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
       allocate(d(s(1),s(2),s(3),s(4)))
      end if
      if (allocated(d)) then
         do i=1,r
            s(i) = size(d,i)
         end do
      end if
      flag = 1
      call f2pysetdata(d,allocated(d))
      end subroutine f2py_write_flow_getdims_u
      subroutine f2py_write_flow_getdims_uvar(r,s,f2pysetdata,flag)
      use write_flow, only: d => uvar

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
      end subroutine f2py_write_flow_getdims_uvar
      subroutine f2py_write_flow_getdims_connnodepath(r,s,f2pysetdata,fl&
     &ag)
      use write_flow, only: d => connnodepath

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
      end subroutine f2py_write_flow_getdims_connnodepath
      
      subroutine f2pyinitwrite_flow(f2pysetupfunc)
      use write_flow, only : iz
      use write_flow, only : ncnp
      use write_flow, only : ngnp
      use write_flow, only : nmfn
      use write_flow, only : meshfilename
      use write_flow, only : gridnodepath
      use write_flow, only : conn
      use write_flow, only : ni
      use write_flow, only : nj
      use write_flow, only : nk
      use write_flow, only : writetype
      use write_flow, only : u
      use write_flow, only : uvar
      use write_flow, only : nflowvar
      use write_flow, only : nelem
      use write_flow, only : connnodepath
      use write_flow, only : init
      use write_flow, only : un_2d_tr
      use write_flow, only : un_3d_te
      use write_flow, only : un_2d_qu
      use write_flow, only : un_3d_he
      use write_flow, only : un_3d_pe
      use write_flow, only : st_2d_qu
      use write_flow, only : st_3d_he
      external f2pysetupfunc
      external f2py_write_flow_getdims_meshfilename
      external f2py_write_flow_getdims_gridnodepath
      external f2py_write_flow_getdims_conn
      external f2py_write_flow_getdims_u
      external f2py_write_flow_getdims_uvar
      external f2py_write_flow_getdims_connnodepath
      call f2pysetupfunc(iz,ncnp,ngnp,nmfn,f2py_write_flow_getdims_meshf&
     &ilename,f2py_write_flow_getdims_gridnodepath,f2py_write_flow_getdi&
     &ms_conn,ni,nj,nk,writetype,f2py_write_flow_getdims_u,f2py_write_fl&
     &ow_getdims_uvar,nflowvar,nelem,f2py_write_flow_getdims_connnodepat&
     &h,init,un_2d_tr,un_3d_te,un_2d_qu,un_3d_he,un_3d_pe,st_2d_qu,st_3d&
     &_he)
      end subroutine f2pyinitwrite_flow

