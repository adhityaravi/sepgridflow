#!/usr/bin/env python2
# -*- coding: utf-8 -*-

from numpy.distutils.core import Extension
from numpy.distutils.core import setup
import sys

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cgnsVer = '3.1.4'
hdf5Ver = '1.8.16'
getCGNSInfos = Extension(
        name = 'getCGNSInfos',
        sources = [\
                'src/fortran/readCGNS/getCGNSInfos.f90',
                'src/fortran/readCGNS/checkCGNSError.f90',
                ],
        include_dirs = [
               #'/usr/include',
               #'/usr/local/include',
              '/home/daniel/.local/cgns/'+cgnsVer+'/include',
              '/home/daniel/.local/hdf5/'+hdf5Ver+'/include',
              ],
        library_dirs = [
              #'/usr/local/lib',
              #'/home/adhitya/Dokumente/xAMC/program/xAMC',
              '/home/daniel/.local/cgns/'+cgnsVer+'/lib',
              '/home/daniel/.local/hdf5/'+hdf5Ver+'/lib',
              ],
        libraries = ['cgns', 'hdf5'],
        #extra_f90_compile_args = ['-fcheck=all']
        )

getCGNSMesh = Extension(
        name = 'getCGNSMesh',
        sources = [\
                'src/fortran/readCGNS/getCGNSMesh.f90',
                'src/fortran/readCGNS/checkCGNSError.f90',
                ],
        include_dirs = [
               #'/usr/include',
               #'/usr/local/include',
              '/home/daniel/.local/cgns/'+cgnsVer+'/include',
              '/home/daniel/.local/hdf5/'+hdf5Ver+'/include',
              ],
        library_dirs = [
              #'/usr/local/lib',
              #'/home/adhitya/Dokumente/xAMC/program/xAMC',
              '/home/daniel/.local/cgns/'+cgnsVer+'/lib',
              '/home/daniel/.local/hdf5/'+hdf5Ver+'/lib',
              ],
        libraries = ['cgns', 'hdf5'],
        extra_f90_compile_args = ['-fcheck=all']
        )

getCGNSFlow = Extension(
        name = 'getCGNSFlow',
        sources = [\
                'src/fortran/readCGNS/getCGNSFlow.f90',
                'src/fortran/readCGNS/checkCGNSError.f90',
                ],
        include_dirs = [
               #'/usr/include',
               #'/usr/local/include',
              '/home/daniel/.local/cgns/'+cgnsVer+'/include',
              '/home/daniel/.local/hdf5/'+hdf5Ver+'/include',
              ],
        library_dirs = [
              #'/usr/local/lib',
              #'/home/adhitya/Dokumente/xAMC/program/xAMC',
              '/home/daniel/.local/cgns/'+cgnsVer+'/lib',
              '/home/daniel/.local/hdf5/'+hdf5Ver+'/lib',
              ],
        libraries = ['cgns', 'hdf5'],
        extra_f90_compile_args = ['-fcheck=all']
        )

writeCGNSMesh = Extension(
    name='writeCGNSMesh',
    sources=[ \
        'src/fortran/writeCGNS/writeMesh/writeMesh.f90',
        'src/fortran/writeCGNS/writeMesh/checkCGNSError.f90',
    ],
    include_dirs=[
        # '/usr/include',
        # '/usr/local/include',
        '/home/daniel/.local/cgns/' + cgnsVer + '/include',
        '/home/daniel/.local/hdf5/' + hdf5Ver + '/include',
    ],
    library_dirs=[
        # '/usr/local/lib',
        # '/home/adhitya/Dokumente/xAMC/program/xAMC',
        '/home/daniel/.local/cgns/' + cgnsVer + '/lib',
        '/home/daniel/.local/hdf5/' + hdf5Ver + '/lib',
    ],
    libraries=['cgns', 'hdf5'],
    extra_f90_compile_args=['-fcheck=all']
)

setup(name='f2py_example',
      description="Fortran subroutines for python",
      author="Daniel Fernex",
      author_email="d.fernex@tu-bs.de",
      ext_modules=[
          getCGNSInfos,
          getCGNSMesh,
          getCGNSFlow,
          writeCGNSMesh,])