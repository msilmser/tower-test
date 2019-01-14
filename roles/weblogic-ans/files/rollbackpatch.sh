#!/bin/sh

cd /users/mwe/tmp/files/PATCH_TOP/*

export PATH=$PATH:/users/mwe/weblogic12.2.1.3/OPatch

/users/mwe/weblogic12.2.1.3/OPatch/opatch nrollback -id $1 -silent -invPtrLoc /users/mwe/weblogic12.2.1.3/oraInst.loc | tee ./opatch.out 

