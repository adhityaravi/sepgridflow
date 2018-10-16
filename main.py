from sepGridFlow import SepGridFlow


CurrentFilePath = '/home/daniel/adhitya/SepGridFlow/TestCase/CylinderWake_Test/InputData/Snapshots'
FlowVar = ['VelocityX', 'VelocityY']
MeshVar = ['CoordinateX', 'CoordinateY']
NewFilePath = '/home/daniel/adhitya/SepGridFlow/TestCase/CylinderWake_GFS'
NewMeshFileName = 'SubDom1Grid.cgns'
SepGridFlow(CurrentFilePath, NewFilePath, NewMeshFileName, FlowVar, MeshVar)

