import numpy as np
from os import path
from GridFlowSep.src.python.fortranLib.writeCGNSMesh import write_mesh

class CGNSWriter():

    def __init__(self, newMeshP, newFlowP, ZoneNames, cellDim):

        self.newMeshP = newMeshP
        self.newFlowP = newFlowP
        # --> Default Grid name
        self.meshName = 'Grid.cgns'
        self.ZoneNames = ZoneNames
        self.cellDim = cellDim


    def writeMesh(self, Mesh, connectivity, nZones, MeshVar, caseType):
        """Write the mesh"""

        meshFile = path.join(self.newMeshP, self.meshName)

        for iZ in range(nZones):

            write_mesh.init(Mesh[iZ],
                            connectivity[iZ],
                            iZ, 0,
                            MeshVar)

            # Run correct subroutine
            if caseType[iZ] == 'un-2d-2d-tr':
                write_mesh.un_2d_tr(meshFile, self.ZoneNames[iZ])
            elif caseType[iZ] == 'un-3d-3d-te':
                write_mesh.un_3d_te(meshFile, self.ZoneNames[iZ])
            elif caseType[iZ] == 'un-2d-2d-qu':
                write_mesh.un_2d_qu(meshFile, self.ZoneNames[iZ])
            elif caseType[iZ] == 'un-3d-3d-he':
                write_mesh.un_3d_he(meshFile, self.ZoneNames[iZ])
            elif caseType[iZ] == 'un-3d-3d-pe':
                write_mesh.un_3d_pe(meshFile, self.ZoneNames[iZ])
            elif caseType[iZ] == 'eq-2d-2d-qu' or \
                            caseType[iZ] == 'ca-2d-2d-qu' or \
                            caseType[iZ] == 'st-2d-2d-qu':
                write_mesh.st_2d_qu(meshFile, self.ZoneNames[iZ])
            elif caseType[iZ] == 'eq-3d-3d-he' or \
                            caseType[iZ] == 'ca-3d-3d-he' or \
                            caseType[iZ] == 'st-3d-3d-he':
                write_mesh.st_3d_he(meshFile, self.ZoneNames[iZ])
            elif caseType[iZ] == 'un-2d-2d-mi' or \
                            caseType[iZ] == 'un-3d-3d-mi':
                write_mesh.un_mi(meshFile, self.ZoneNames[iZ], self.cellDim)
            else:
                errorMsg = '\nMesh format not handled (yet)'
                raise Exception(errorMsg)

