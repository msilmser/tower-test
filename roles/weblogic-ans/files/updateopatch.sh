#!/bin/sh

PATCH_PATH="/users/mwe/tmp/files/PATCH_TOP/6880880"

cd $PATCH_PATH 

export PATH=$PATH:/users/mwe/weblogic12.2.1.3/OPatch

/users/mwe/jdk/bin/java -jar $PATCH_PATH/opatch_generic.jar -silent ORACLE_HOME=/users/mwe/weblogic12.2.1.3 -invPtrLoc /users/mwe/weblogic12.2.1.3/oraInst.loc | tee ./updateopatch.out 

  
