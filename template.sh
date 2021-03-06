#!/bin/bash
# cms software setup
export SCRAM_ARCH=slc6_amd64_gcc491
echo "working directory"
tar xvf loot.tar
cd CMSSW_7_1_25_patch1/src
scram b ProjectRename
eval `scramv1 runtime -sh`
cd ../../
cmsDriver.py LLP_SIGID_cff.py --fileout file:SIGID_step0_GENSIM_n0.root --mc --eventcontent RAWSIM --customise SLHCUpgradeSimulations/Configuration/postLS1Customs.customisePostLS1,Configuration/DataProcessing/Utils.addMonitoring,SimG4Core/CustomPhysics/Exotica_HSCP_SIM_cfi,DisappTrks/SignalMC/genParticlePlusGeant.customizeProduce,DisappTrks/SignalMC/genParticlePlusGeant.customizeKeep --datatier GEN-SIM --conditions MCRUN2_71_V1::All --beamspot Realistic50ns13TeVCollision --step GEN,SIM --magField 38T_PostLS1 --python_filename SIGID_GENSIM.py --no_exec -n NUMEVENTS
python ShortTrackSusy/python/edit_config.py SIGID_GENSIM.py
bash ShortTrackSusy/python/replace_storage.sh SIGID_GENSIM.py SIGID_GENSIMb.py
mv SIGID_GENSIMb.py SIGID_GENSIM.py
cmsRun SIGID_GENSIM.py

cd CMSSW_8_0_21/src
scram b ProjectRename
eval `scramv1 runtime -sh`
cd ../../
cmsDriver.py step1 --filein file:SIGID_step0_GENSIM_n0.root --fileout file:SIGID_step1_GENSIMRAW_n0.root --pileup_input "dbs:/Neutrino_E-10_gun/RunIISpring16FSPremix-PUSpring16_80X_mcRun2_asymptotic_2016_v3-v1/GEN-SIM-DIGI-RAW" --mc --eventcontent PREMIXRAW --datatier GEN-SIM-RAW --conditions 80X_mcRun2_asymptotic_2016_TrancheIV_v6 --step DIGIPREMIX_S2,DATAMIX,L1,DIGI2RAW,HLT:@frozen2016 --nThreads 4 --datamix PreMix  --era Run2_2016 --python_filename SIGID_step1.py --customise Configuration/DataProcessing/Utils.addMonitoring,DisappTrks/SignalMC/genParticlePlusGeant.customizeKeep,DisappTrks/SignalMC/genParticlePlusGeant.customizeProduce -n NUMEVENTS

cmsDriver.py step2 --filein file:SIGID_step1_GENSIMRAW_n0.root --fileout file:SIGID_step2_AODSIM_n0.root --mc --eventcontent AODSIM --runUnscheduled --datatier AODSIM --conditions 80X_mcRun2_asymptotic_2016_TrancheIV_v6 --step RAW2DIGI,RECO,EI --nThreads 4 --era Run2_2016 --python_filename AOD_cfg.py --customise Configuration/DataProcessing/Utils.addMonitoring,DisappTrks/SignalMC/genParticlePlusGeant.customizeProduce,DisappTrks/SignalMC/genParticlePlusGeant.customizeKeep -n NUMEVENTS

xrdcp SIGID_step2_AODSIM_n0.root root://cmseos.fnal.gov//store/user/lpcsusyhad/sbein/LongLiveTheChi/aodsim/smallchunks/

cmsDriver.py step3 --conditions auto:run2_mc --fast --eventcontent MINIAODSIM --runUnscheduled --filein file:SIGID_step2_AODSIM_n0.root --fileout file:SIGID_step3_miniAODSIM_n0.root -s PAT --datatier MINIAODSIM --customise SLHCUpgradeSimulations/Configuration/postLS1Customs.customisePostLS1 --customise Configuration/DataProcessing/Utils.addMonitoring,DisappTrks/SignalMC/genParticlePlusGeant.customizeProduce,DisappTrks/SignalMC/genParticlePlusGeant.customizeKeep --mc -n NUMEVENTS

xrdcp SIGID_step3_miniAODSIM_n0.root root://cmseos.fnal.gov//store/user/lpcsusyhad/sbein/LongLiveTheChi/miniaodsim/smallchunks/

rm *.py 
rm SIGID*.root

#try going back to scratch area before running code
