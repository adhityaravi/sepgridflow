import numpy as np
from src.python.caseInfos import CaseInfos
from src.python.CGNSReader import CGNSReader
from src.python.CGNSWriter import CGNSWriter

class SepGridFlow():

    def __init__(self, snapshotsP, newMeshP, newFlowP, FlowVar, MeshVar, GridSpec=None):
        """Initialize with path where the cgns files are stored, flow variables, grid variables, and grid specification

            Grid specification can be used to specify if the mesh is cartesian or equidistant or standard"""

        # --> Fetching case infos
        self.CI = CaseInfos(snapshotsP, GridSpec)
        self.snapshots = self.CI.getSnapshots()
        self.caseType = self.CI.getCaseType()
        self.nSnap, self.nZones, self.physDim, self.meshType, \
            self.meshDim, self.cellDim, self.nNodesElem, self.nElem, self.ZoneNames = self.CI.getCGNSInfo()
        self.fieldDim = self.CI.getDim()

        print self.caseType
        exit()

        # --> Initializing CGNSReader
        self.CR = CGNSReader(snapshotsP)
        # --> Initializing CGNSWriter
        self.CW = CGNSWriter(newMeshP, newFlowP, self.ZoneNames, self.cellDim)

        # --> Flow and mesh variables check
        self.FlowVar = FlowVar
        self._checkCGNSFlowVar(self.FlowVar)
        self.MeshVar = MeshVar
        self._checkCGNSMeshVar(self.MeshVar)

        # --> Reading mesh
        self._readMesh()
        # --> Writing Mesh in the new file
        self._writeMesh()

        # --> Reading and Re-writing Flow with a link to the Grid file
        self._readLinkAndRewriteFlow()



    def _readMesh(self):

        # --> Initialize
        self.Mesh = []
        self.Conn = []

        self._initializeMesh(self.Mesh, self.Conn)

        self.CR.readMesh(self.snapshots[0], self.Mesh, self.Conn, self.nZones, self.cellDim,
                         self.meshType, self.meshDim, self.MeshVar)

    def _initializeMesh(self, Mesh, Conn):
        """Initialize the mesh arrays"""

        for iZ in range(self.nZones):
            Mesh.append([])
            Conn.append([])

            # --> Initialize coords
            nMeshVar = len(self.MeshVar)
            Mesh[iZ] = np.ndarray((self.fieldDim[iZ] + (nMeshVar,)), order='F')

            # --> Initialize connectivity
            if self.meshType[iZ] == 2:
                Conn[iZ] = np.ndarray((2, 2), order='F', dtype='int32')
            else:
                # If mixed: don't initialize the connectivity, because it will
                # be overwritten in readMesh()
                if self.caseType[iZ].endswith('mi'):
                    pass
                else:
                    Conn[iZ] = np.ndarray((self.nNodesElem[iZ], self.nElem[iZ]), order='F',
                                          dtype='int32')

    def _readLinkAndRewriteFlow(self):
        """Get all the Flow data from the cgns files"""

        # --> Initialize arrays
        self.Flow = []

        for iSnap in range(self.nSnap):
            # --> Initializing Flow
            self._initializeFlow(self.Flow)
            # --> Reading Flow
            self.CR.readFlow(self.snapshots[iSnap], self.Flow, self.nZones, self.physDim,
                             self.meshType, self.meshDim, self.FlowVar)


    def _initializeFlow(self, Data, nDim=None):
        """Initialize flow with appropriate dimensions"""

        for iZ in range(self.nZones):
            Data.append([])

            # --> Fetching the number of FLow Variables
            nFlowVar = len(self.FlowVar)

            # --> Currently nDim is not utilized whatsoever!
            if nDim:
                dim = self.fieldDim[iZ] + (nFlowVar,) + (nDim,)
            else:
                dim = self.fieldDim[iZ] + (nFlowVar,)

            Data[iZ] = np.ndarray(dim, order='F')

    def _writeMesh(self):
        """Write the extracted Mesh in the new file"""

        self.CW.writeMesh(self.Mesh, self.Conn, self.nZones, self.MeshVar, self.caseType)

    def _checkCGNSFlowVar(self, FlowVar):
        """Checks if the flow variables have the right name for the CGNS format"""

        for iFlowVar in range(len(FlowVar)):
            if FlowVar[iFlowVar] in ['VelocityX', 'VelocityY', 'VelocityZ']:
                continue
            else:
                raise ValueError(
                    '\n\tFlow variable names (FlowVar in ConfigFile) are not according to the CGNS standard\n'
                    '\tCGNS standard flow variable names : VelocityX, VelocityY, VelocityZ')

    def _checkCGNSMeshVar(self, MeshVar):
        """Checks if the mesh variables have the right name for the CGNS format"""

        for iMeshVar in range(len(MeshVar)):
            if MeshVar[iMeshVar] in ['CoordinateX', 'CoordinateY', 'CoordinateZ']:
                continue
            else:
                raise ValueError(
                    '\n\tMesh variable names (MeshVar in ConfigFile) are not according to the CGNS standard\n'
                    '\tCGNS standard mesh variable names : CoordinateX, CoordinateY, CoordinateZ')


