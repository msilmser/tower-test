import os
import os.path
from wlstModule import *

md5checksum = "/usr/bin/md5sum "

def deploy_app_noblock(appName, deployPath, *managed_servers):
  deploy_app(appName, deployPath, block_restart='false', md5log='', managed_servers=managed_servers)

def deploy_app(appName, deployPath , block_restart, md5log, *managed_servers):
  #
  block_restart = (str(block_restart)).lower()
  if (block_restart != 'true' and block_restart != 'false'):
    print "block_restart value is invalid: ",block_restart
    return
  print "block_restart: ",block_restart
  #
  if os.path.isfile(deployPath + '/' + appName + '.war'):
   appPath = deployPath + '/' + appName + '.war'
   print "appPath: ",appPath
  else:
   appPath = deployPath + '/' + appName + '.ear'
   print "appPath: ",appPath

  targets = ",".join(managed_servers)
  #
  print "appName: ",appName
  print " - targets: ",targets
  try:
    stopApplication(appName,block='true')
    print "SUCCESS...\n"
  except:
    print "FAIL...\n"
  #
  try:
    os.system('sleep 10')
    print "\nSUCCESS sleep...\n"
  except:
    print "\nFAIL sleep...\n"
  #
  try:
    print "undeploy(%s,targets='%s',block='true')" % (appName, targets)
    undeploy(appName,targets=targets,block='true')
    print "SUCCESS...\n"
  except:
    print "FAIL...\n"
  #
  try:
    os.system('sleep 10')
    print "\nSUCCESS sleep...\n"
  except:
    print "\nFAIL sleep...\n"
  #
  try:
    print "deploy(%s,%s,targets='%s',stageMode='stage',upload='true',block='true',timeout=1800000)" % (appName,appPath,targets)
    deploy(appName,appPath,targets=targets,stageMode='stage',upload='true',block='true',timeout=1800000)
    print "SUCCESS...\n"
  except:
    print "FAIL...\n"
  #
  try:
    os.system('sleep 10')
    print "\nSUCCESS sleep...\n"
  except:
    print "\nFAIL sleep...\n"
  #
  try:
    startApplication(appName,block='true')
    print "SUCCESS...\n"
  except:
    print "FAIL...\n"
  #
  try:
    os.system('sleep 10')
    print "\nSUCCESS sleep...\n"
  except:
    print "\nFAIL sleep...\n"
  #
  for managed1 in managed_servers:
    try:
      print "shutdown(%s,'Server',ignoreSessions='true',force='true',block=%s)" % (managed1,block_restart)
      shutdown(managed1,'Server',ignoreSessions='true',force='true',block=block_restart)
      print "\nSUCCESS...\n"
    except:
      print "\nFAIL...\n"
  #
  try:
    os.system('sleep 10')
    print "\nSUCCESS sleep...\n"
  except:
    print "\nFAIL sleep...\n"
  #
  for managed1 in managed_servers:
    try:
      print "start(%s,'Server',block=%s)" % (managed1,block_restart)
      start(managed1,'Server',block=block_restart)
      print "\nSUCCESS...\n"
    except:
      print "\nFAIL...\n"
  #
  try:
    os.system('date')
    print "\nSUCCESS...\n"
  except:
    print "\nFAIL...\n"
  #
  try:
    os.system('ls -la ' + deployPath)
    print "\nSUCCESS...\n"
  except:
    print "\nFAIL...\n"
  #
  if (md5log != ''):
    try:
      #os.system(md5checksum + deployPath + '*.?ar | tee ' + md5log)
      os.system(md5checksum + appPath + '| tee '  + md5log)
      print "\nSUCCESS...\n"
    except:
      print "\nFAIL...\n"
  #
  #SYNTAX: shutdown([name], [entityType], [ignoreSessions], [timeOut], [force], [block])
  #SYNTAX: start(name, [type], [url], [block])



