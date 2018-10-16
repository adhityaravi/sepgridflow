import numpy as np
from os import path
import os
from src.python.fortranLib.writeCGNSMesh import write_mesh
from src.python.fortranLib.writeCGNSFlow import write_flow

class CGNSWriter():

    def __init__(self, newFilePath, meshFileName, ZoneNames, cellDim):

        self.newFilePath = newFilePath
        self.meshFileName = meshFileName
        self.ZoneNames = ZoneNames
        self.cellDim = cellDim
        self.meshFilePath = path.join(self.newFilePath, self.meshFileName)


    def writeMesh(self, Mesh, connectivity, nZones, MeshVar, caseType):
        """Write the mesh"""

        # --> Grid node path refers to the path of the GridCoordinates node inside the cgns file
        # (Note to self: The term grid is used when referring to mesh inside a cgns file)
        self.gridNodePath = []
        self.connNodePath = []

        for iZ in range(nZones):

            self.gridNodePath.append([])
            self.connNodePath.append([])
            # --> Note : The Base node of the grid file is hardcoded to be named as GridBase, and the name of the
            #            original grid node is always 'GridCoordinates', and the connectivity node \
            #            is always named 'Elem'
            self.gridNodePath[iZ] = path.join('GridBase', self.ZoneNames[iZ], 'GridCoordinates')
            self.connNodePath[iZ] = path.join('GridBase', self.ZoneNames[iZ], 'Elem')

            if path.exists(self.meshFilePath):
                writeType = 1
            else:
                writeType = 0

            write_mesh.init(Mesh[iZ],
                            connectivity[iZ],
                            iZ, writeType,
                            MeshVar)

            # Run correct subroutine
            if caseType[iZ] == 'un-2d-2d-tr':
                write_mesh.un_2d_tr(self.meshFilePath, self.ZoneNames[iZ])
            elif caseType[iZ] == 'un-3d-3d-te':
                write_mesh.un_3d_te(self.meshFilePath, self.ZoneNames[iZ])
            elif caseType[iZ] == 'un-2d-2d-qu':
                write_mesh.un_2d_qu(self.meshFilePath, self.ZoneNames[iZ])
            elif caseType[iZ] == 'un-3d-3d-he':
                write_mesh.un_3d_he(self.meshFilePath, self.ZoneNames[iZ])
            elif caseType[iZ] == 'un-3d-3d-pe':
                write_mesh.un_3d_pe(self.meshFilePath, self.ZoneNames[iZ])
            elif caseType[iZ] == 'eq-2d-2d-qu' or \
                            caseType[iZ] == 'ca-2d-2d-qu' or \
                            caseType[iZ] == 'st-2d-2d-qu':
                write_mesh.st_2d_qu(self.meshFilePath, self.ZoneNames[iZ])
            elif caseType[iZ] == 'eq-3d-3d-he' or \
                            caseType[iZ] == 'ca-3d-3d-he' or \
                            caseType[iZ] == 'st-3d-3d-he':
                write_mesh.st_3d_he(self.meshFilePath, self.ZoneNames[iZ])
            elif caseType[iZ] == 'un-2d-2d-mi' or \
                            caseType[iZ] == 'un-3d-3d-mi':
                write_mesh.un_mi(self.meshFilePath, self.ZoneNames[iZ], self.cellDim)

            else:
                errorMsg = '\nMesh format not handled (yet)'
                raise Exception(errorMsg)

    def linkAndWriteFlow(self, Flow, nZones, nElem, FlowVar, flowFileName, caseType):
        """Link the flow to mesh and write flow"""

        flowFilePath = path.join(self.newFilePath, flowFileName)
        pathToBeCreated, foo = path.split(flowFilePath)

        if not os.path.exists(pathToBeCreated):
            os.mkdir(pathToBeCreated)

        self.meshFileName = self.meshFilePath

        # Mesh file name specifications
        nMFN = len(self.meshFileName)
        meshFileName = [self.meshFileName]  # --> File name is put into a list for ease of use in Fortran

        for iZ in range(nZones):
            # Grid node path specifications
            nGNP = len(self.gridNodePath[iZ])
            gridNodePath = [self.gridNodePath[iZ]]
            # connectivity node path specifications
            nCNP = len(self.connNodePath[iZ])
            connNodePath = [self.connNodePath[iZ]]

            if path.exists(flowFilePath):
                writeType = 1
            else:
                writeType = 0

            write_flow.init(Flow[iZ],
                            iZ,
                            writeType, nElem[iZ],
                            FlowVar,
                            meshFileName, gridNodePath,
                            connNodePath,
                            nMFN, nGNP, nCNP)

            # Run correct subroutine
            if caseType[iZ] == 'un-2d-2d-tr':
                write_flow.un_2d_tr(flowFilePath, self.ZoneNames[iZ])
            elif caseType[iZ] == 'un-3d-3d-te':
                write_flow.un_3d_te(flowFilePath, self.ZoneNames[iZ])
            elif caseType[iZ] == 'un-2d-2d-qu':
                write_flow.un_2d_qu(flowFilePath, self.ZoneNames[iZ])
            elif caseType[iZ] == 'un-3d-3d-he':
                write_flow.un_3d_he(flowFilePath, self.ZoneNames[iZ])
            elif caseType[iZ] == 'un-3d-3d-pe':
                write_flow.un_3d_pe(flowFilePath, self.ZoneNames[iZ])
            elif caseType[iZ] == 'eq-2d-2d-qu' or \
                            caseType[iZ] == 'ca-2d-2d-qu' or \
                            caseType[iZ] == 'st-2d-2d-qu':
                write_flow.st_2d_qu(flowFilePath, self.ZoneNames[iZ])
            elif caseType[iZ] == 'eq-3d-3d-he' or \
                            caseType[iZ] == 'ca-3d-3d-he' or \
                            caseType[iZ] == 'st-3d-3d-he':
                write_flow.st_3d_he(flowFilePath, self.ZoneNames[iZ])
            elif caseType[iZ] == 'un-2d-2d-mi' or \
                            caseType[iZ] == 'un-3d-3d-mi':
                write_flow.un_mi(flowFilePath, self.ZoneNames[iZ], self.cellDim)

            else:
                errorMsg = '\nMesh format not handled (yet)'
                raise Exception(errorMsg)