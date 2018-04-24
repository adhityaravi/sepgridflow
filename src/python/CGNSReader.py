import numpy as np
from os import path
from src.python.fortranLib.getCGNSFlow import flow_module
from src.python.fortranLib.getCGNSMesh import mesh_module

class CGNSReader():

    def __init__(self, path_):

        self.nFlows = 1  # --> Temporary Fix
        self.path = path_

    def readMesh(self, name, Mesh, connectivity, nZones, cellDim, meshType, meshDim, MeshVar):
        """Read the mesh"""

        for iZ in range(nZones):

            # --> Read coordinates and connectivity for one zone
            fileName = path.join(self.path, name)
            mesh_module.get_mesh_f(
                     Mesh[iZ],
                     connectivity[iZ],
                     fileName,
                     (iZ +1),
                     cellDim,
                     meshType[iZ],
                     np.transpose(meshDim[iZ]),
                     MeshVar
                     )

    def readFlow(self, name, Flow, nZones, physDim, meshType, meshDim, FlowVar):
        """Read the flow"""

        for iZ in range(nZones):

            if self.nFlows == 1:

                fileName = path.join(self.path, name)

                flow_module.get_flow_f(
                            Flow[iZ],
                            fileName,
                            iZ + 1,
                            physDim,
                            meshType[iZ],
                            np.transpose(meshDim[iZ]),
                            FlowVar
                            )

            # --> Not used (but not removed, for future reference)
            elif self.nFlows > 1:

                for iF in range(self.nFlows):

                    # This way to proceed doesn't create a new array => ok for
                    # RAM
                    fileName = path.join(self.path, self.name[iF])

                    flow_module.get_flow_f(
                                Flow[iZ][:,:,:,:,iF],
                                fileName,
                                iZ + 1,
                                physDim,
                                meshType[iZ],
                                np.transpose(meshDim[iZ]),
                                FlowVar
                                )