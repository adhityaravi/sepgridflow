import numpy as np
from sepGridFlow import SepGridFlow

FilePath = 'TestCase/CylinderWake_Test/InputData/Snapshots/FullDomain/'
FlowVar = ['VelocityX', 'VelocityY']
MeshVar = ['CoordinateX', 'CoordinateY']
NewMeshPath = 'TestCase/CylinderWake_GFS/Grid'
NewFlowPath = 'TestCase/CylinderWake_GFS/Flow'

SepGridFlow(FilePath, NewMeshPath, NewFlowPath, FlowVar, MeshVar)

