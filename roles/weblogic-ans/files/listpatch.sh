#!/bin/sh

cd /users/mwe/tmp/files/PATCH_TOP/*

export PATH=$PATH:/users/mwe/weblogic12.2.1.3/OPatch

/users/mwe/weblogic12.2.1.3/OPatch/opatch lsinventory -local -invPtrLoc /users/mwe/weblogic12.2.1.3/oraInst.loc | tee ./lsinventory.out 
  
