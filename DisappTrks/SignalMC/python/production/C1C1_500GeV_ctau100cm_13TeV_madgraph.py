# Settings based on https://github.com/CMS-SUS-XPAG/GenLHEfiles/blob/master/GridpackWorkflow/production/models/TChiWG/TChiWG_fragment.py
# and on https://github.com/cms-sw/genproductions/blob/master/python/ThirteenTeV/Hadronizer_TuneCUETP8M1_13TeV_MLM_5f_max1j_LHE_pythia8_cff.py
# as recommended by https://twiki.cern.ch/twiki/bin/viewauth/CMS/QuickGuideMadGraph5aMCatNLO#2_LO_with_jet_matching_multiple

import FWCore.ParameterSet.Config as cms

from Configuration.Generator.Pythia8CommonSettings_cfi import *
from Configuration.Generator.Pythia8CUEP8M1Settings_cfi import *

MCHI = 500  # GeV
CTAU = 100  # cm

generator = cms.EDFilter("Pythia8HadronizerFilter",
    maxEventsToPrint = cms.untracked.int32(1),
    pythiaPylistVerbosity = cms.untracked.int32(1),
    filterEfficiency = cms.untracked.double(1.0),
    pythiaHepMCVerbosity = cms.untracked.bool(False),
    comEnergy = cms.double(13000.),
    UseExternalGenerators = cms.untracked.bool(True),
    PythiaParameters = cms.PSet(
        pythia8CommonSettingsBlock,
        pythia8CUEP8M1SettingsBlock,
        processParameters = cms.vstring(
            'JetMatching:setMad = off',
            'JetMatching:scheme = 1',
            'JetMatching:merge = on',
            'JetMatching:jetAlgorithm = 2',
            'JetMatching:etaJetMax = 5.',
            'JetMatching:coneRadius = 1.',
            'JetMatching:slowJetPower = 1',
            'JetMatching:qCut = 76.', #this is the actual merging scale; taken from https://github.com/CMS-SUS-XPAG/GenLHEfiles/blob/master/GridpackWorkflow/production/models/TChiWG/TChiWG_fragment.py#L86#L94
            'JetMatching:nQmatch = 5', #4 corresponds to 4-flavour scheme (no matching of b-quarks), 5 for 5-flavour scheme
            'JetMatching:nJetMax = 2', #number of partons in born matrix element for highest multiplicity
            'JetMatching:doShowerKt = off', #off for MLM matching, turn on for shower-kT matching
        ),
        parameterSets = cms.vstring('pythia8CommonSettings',
                                    'pythia8CUEP8M1Settings',
                                    'processParameters',
                                    )
    ),
    # The following parameters are required by Exotica_HSCP_SIM_cfi:
    slhaFile = cms.untracked.string(''),   # value not used
    processFile = cms.untracked.string('SimG4Core/CustomPhysics/data/RhadronProcessList.txt'),
    useregge = cms.bool(False),
    hscpFlavor = cms.untracked.string('stau'),
    massPoint = cms.untracked.int32(MCHI),  # value not used
    particleFile = cms.untracked.string('DisappTrks/SignalMC/data/geant4_AMSB_chargino_%sGeV_ctau%scm.slha' % (MCHI, CTAU))
)

ProducerSourceSequence = cms.Sequence(generator)



