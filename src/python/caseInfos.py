from src.python.fortranLib.getCGNSInfos import infos_module
from os import listdir
import os
import re

class CaseInfos():
    """Read all the relevant information from the cgns file"""

    def __init__(self, snapshotsP, GridSpec=None):
        """Initialize class with the name of the cgns file"""

        self.snapshotsP = snapshotsP
        self.GridSpec = GridSpec
        self.DataFormat = ''

        self.getSnapshots()

        self.getCGNSInfo()

    def getSnapshots(self):
        """List, order and check the snapshots."""

        # Check folder/files
        snapshots = listdir(self.snapshotsP)

        if not snapshots:
            msg = "\nNo snapshots in '{}' format found!".format(self.DataFormat)
            raise Exception(msg)

        #self.snapshots = self._orderFiles(snapshots)
        snapshots.sort()
        self.snapshots = snapshots

        self.nSnap = len(self.snapshots)

        for iSnap in range(self.nSnap):
            self.snapshots[iSnap] = os.path.join(self.snapshots[iSnap], 'SubDom1.cgns')

        return self.snapshots

    def _orderFiles(self, snapshots):
        """Give the filenames in the right order"""
        digitAndNames = {}
        digitsList = []
        orderedSnapshots = []

        # Create re pattern to extract float
        numeric_const_pattern = r"""
            [-+]? # optional sign
            (?:
                    (?: \d* \. \d+ ) # .1 .12 .123 etc 9.1 etc 98.1 etc
                    |
                    (?: \d+ \.? ) # 1. 12. 123. etc 1 12 123 etc
                )
            # followed by optional exponent part if desired
            (?: [Ee] [+-]? \d+ ) ?
            """
        rx = re.compile(numeric_const_pattern, re.VERBOSE)

        for snapshotName in snapshots:

            # Check format
            keepSnap = True

            if (self.DataFormat == 'cgns') and \
                    (not snapshotName.endswith('.cgns')):
                keepSnap = False

            if keepSnap == True:
                # get digits
                nameDigits = []

                nameDigits = abs(float(rx.findall(snapshotName[:-(len(self.DataFormat) + 1)])[-1]))

                digitsList.append(nameDigits)
                digitAndNames[nameDigits] = snapshotName

        digitsList.sort()

        for digit in digitsList:
            orderedSnapshots.append(digitAndNames[digit])

        return orderedSnapshots

    def getCGNSInfo(self):
        """Read infos from cgns file

            Currently works only for a single cgns file"""

        name = '{}/{}'.format(self.snapshotsP, self.snapshots[0])
        #name = name.replace('.{}'.format(self.DataFormat), '.cgns')

        infos_module.get_cgns_infos_f(name)

        infos_module.get_cgns_infos_f(name)

        self.meshType = infos_module.meshtype.copy()
        self.meshDim = infos_module.meshdim.copy()
        self.nElem = infos_module.nelem.copy()
        self.nNodesElem = infos_module.nnodeselem.copy()
        self.elemType = infos_module.elemtype.copy()
        self.nZones = infos_module.nzones

        # zoneNames post-process
        ZoneNamesRawFortran = infos_module.zonenames.copy()  # .transpose()
        self.ZoneNames = [''.join(elt).rstrip() for elt in ZoneNamesRawFortran]

        # Get all infos that are global
        self.cellDim = infos_module.celldim
        self.physDim = infos_module.physdim

        return self.nSnap, self.nZones, self.physDim, self.meshType, \
            self.meshDim, self.cellDim, self.nNodesElem, self.nElem, self.ZoneNames

    def getCaseType(self):
        """Define the case type for each zone

        Following convention to define the case type is used:
        <mesh type>-<Mesh dimension>-<Physical dimension>-<Element type> with:
        - Mesh type:
            - un: unstructured
            - st: structured
            - ca: cartesian
            - eq: cartesian equidistant
        - Mesh dimension:
            - 2D or 3D
        - Physical dimension:
            - 2D or 3D
        - Element type:
            - tr: triangle
            - qu: quadrilateral
            - te: tetrahedron
            - py: pyramidal
            - pe: pentahedron
            - mi: mixed elements (zone made of more than one type of elements)
        """

        # Element type definition (from the cgns convention)
        elemTypeDef = {
            5: 'tr',
            7: 'qu',
            10: 'te',
            12: 'py',
            14: 'pe',
            17: 'he',
            20: 'mi'
        }

        self.caseType = []

        for iZ in range(self.nZones):
            self.caseType.append([])

            # Unstructured
            if self.meshType[iZ] == 3:
                # 2D
                if self.physDim == 2:
                    caseTypeLoc = 'un-2d-2d-' + \
                                  elemTypeDef[self.elemType[iZ]]
                # 3D
                elif self.physDim == 3:
                    caseTypeLoc = 'un-3d-3d-' + \
                                  elemTypeDef[self.elemType[iZ]]

            # Structured
            elif self.meshType[iZ] == 2:
                # 2D
                if self.physDim == 2:
                    # Cartesian
                    if self.GridSpec == 'Cartesian':
                        caseTypeLoc = 'ca-2d-2d-qu'
                    # equidistant
                    elif self.GridSpec == 'Equidistant':
                        caseTypeLoc = 'eq-2d-2d-qu'
                    # Structured
                    elif self.GridSpec == 'Standard':
                        caseTypeLoc = 'st-2d-2d-qu'

                # 3D
                elif self.physDim == 3:
                    # Cartesian
                    if self.GridSpec == 'Cartesian':
                        caseTypeLoc = 'ca-3d-3d-he'
                    # Equidistant
                    if self.GridSpec == 'Equidistant':
                        caseTypeLoc = 'eq-3d-3d-he'
                    # Structured
                    elif self.GridSpec == 'Standard':
                        caseTypeLoc = 'st-3d-3d-he'

            self.caseType[iZ] = caseTypeLoc

        return self.caseType

    def getDim(self):
        """Get a tuple to dimension the arrays for the field variables (U)
        """

        self.fieldDim = []

        for iZ in range(self.nZones):
            self.fieldDim.append([])

            ## Unstructured
            if (self.meshType[iZ] == 3):
                self.fieldDim[iZ] = (self.meshDim[iZ][0, 0], 1, 1)

            ## Structured
            elif (self.meshType[iZ] == 2):
                # 1D
                if (self.physDim == 1):
                    self.fieldDim[iZ] = (
                        self.meshDim[iZ][0, 0],
                        1,
                        1,
                    )
                # 2D
                elif (self.physDim == 2):
                    self.fieldDim[iZ] = (
                        self.meshDim[iZ][0, 0],
                        self.meshDim[iZ][1, 0],
                        1,
                    )
                    # 3D
                elif (self.physDim == 3):
                    self.fieldDim[iZ] = (
                        self.meshDim[iZ][0, 0],
                        self.meshDim[iZ][1, 0],
                        self.meshDim[iZ][2, 0],
                    )

        return self.fieldDim