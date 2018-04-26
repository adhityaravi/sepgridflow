from sepGridFlow import SepGridFlow


CurrentFilePath = 'TestCase/CylinderWake_Test/InputData/Snapshots/FullDomain/'
FlowVar = ['VelocityX', 'VelocityY']
MeshVar = ['CoordinateX', 'CoordinateY']
NewFilePath = 'TestCase/CylinderWake_GFS'
NewMeshFileName = 'Grid.cgns'
SepGridFlow(CurrentFilePath, NewFilePath, NewMeshFileName, FlowVar, MeshVar)

