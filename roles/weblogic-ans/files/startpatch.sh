#!/bin/sh

cd /users/mwe/tmp/files/PATCH_TOP/28298734

export PATH=$PATH:/users/mwe/weblogic12.2.1.3/OPatch

#if RHEL version 7+ then set this variable to fix patch bug.
if [ "$RHELVER" -ge 7 ]
then
  export OPATCH_NO_FUSER=true
fi

/users/mwe/weblogic12.2.1.3/OPatch/opatch napply -silent -force_conflict -invPtrLoc /users/mwe/weblogic12.2.1.3/oraInst.loc | tee ./opatch.out 

  
