from weblogic.descriptor import BeanAlreadyExistsException
from java.lang.reflect import UndeclaredThrowableException
from java.lang import System
import javax
from javax import management
from javax.management import MBeanException
from javax.management import RuntimeMBeanException
import javax.management.MBeanException
from java.lang import UnsupportedOperationException
import string
import sys
import os

def initScriptRun():
  global startedNewServer
  hideDisplay()
  if connected=="false":
    stopExecution("You need to be connected.")

def startTransaction():
  edit()
  startEdit()

def endTransaction():
  startEdit()
  save()
  activate(block="true")

from javax.management import InstanceAlreadyExistsException
from java.lang import Exception
from jarray import array

def create_Server(path, beanName):
  cd(path)
  try:
    print "creating mbean of type Server ... "
    theBean = cmo.lookupServer(beanName)
    if theBean == None:
      cmo.createServer(beanName)
  except java.lang.UnsupportedOperationException, usoe:
    pass
  except weblogic.descriptor.BeanAlreadyExistsException,bae:
    pass
  except java.lang.reflect.UndeclaredThrowableException,udt:
    pass

def setAttributesFor_Managed_Server(managedServerName, listenPort, sslPort, machine):
  cd("/Servers/"+managedServerName)
  print "setting attributes for mbean type Server"
  set("ListenPort", int(listenPort))
  set("ListenAddress", machine)
  bean = getMBean("/Machines/"+machine)
  cmo.setMachine(bean)
  cd("/Servers/"+managedServerName+"/ServerStart/"+managedServerName)
  # cmo.setArguments("-Xms1024m -Xmx1024m -XXtlasize:64k -XXlargeobjectlimit:64k")
  # cmo.setArguments("-Xms1024m -Xmx1024m -XX:PermSize=256m  -XX:MaxPermSize=256m ")
  cmo.setArguments("-Xms1024m -Xmx1024m -XX:PermSize=512m -XX:MaxPermSize=512m -XX:+UseParallelGC -XX:+UseParallelOldGC -XX:+DisableExplicitGC -XX:+HeapDumpOnOutOfMemoryError -XX:+PrintGCTimeStamps -XX:+PrintGCDetails -XX:+PrintCommandLineFlags -XX:HeapDumpPath=/users/domains/"+domain+"/servers/"+managedServerName+"/logs -Xloggc:/users/domains/"+domain+"/servers/"+managedServerName+"/logs/gc.log")
  cd("/Servers/"+managedServerName+"/SSL/"+managedServerName)
  print "setting attributes for mbean type SSL"
  set("Enabled", "true")
  set("ListenPort", int(sslPort))
  #set("ListenAddress", machine)
  cd('/Servers/'+managedServerName+'/OverloadProtection/'+managedServerName)
  cmo.setPanicAction('system-exit')

"""
def setAttributes_Log():
  cd("/Servers/crewweb/Log/crewweb")
  print "setting attributes for mbean type Log"
  set("FileMinSize", "10240")

  def setAttributes_SSL():
  cd("/Servers/crewweb/SSL/crewweb")
  print "setting attributes for mbean type SSL"
  set("Enabled", "false")
"""

"""
def addDataSourceTarget(dsname, managedServerName):
  refBean0 = getMBean("/Servers/"+managedServerName)
  cd("/JDBCSystemResources/"+dsname)
  print "setting target for JDBC SystemResource - for ",dsname
  cmo.addTarget(refBean0)
"""

def configureManagedServer():
  initScriptRun()
  startTransaction()
  create_Server("/", managedServer)
  setAttributesFor_Managed_Server(managedServer, managedServerListenPort, managedServerSSLPort, machine)
  #addDataSourceTarget("XXXXDB", managedServer)
  endTransaction()

def usage():
  print "argument required: config_file_name"

def main():
  if (len(sys.argv) == 0):
    usage()
    return -1
  propFile = sys.argv[1]
  loadProperties(propFile)  #1 = first argument, 0=name of script
  #For wls 12 --inyryk
  beahome = os.getenv("MW_HOME")
  print"BEA_HOME:",beahome
  wlhome = os.getenv("ORACLE_HOME")
  print"WL_HOME:",wlhome
  #javahome = beahome + "/jdk1.7.0_25"
  #print "java home: ",javahome
  print "Start AdminServer now, if it is not running..."
  response=raw_input("Enter 'q' to Quit or 'c' to Continue domain configuration --> ")
  if ('q' == response):
    return -1
  print "Starting domain configuration..."
  try:
    URL="t3://"+adminServerListenAddress+":"+adminServerListenPort
    connect(url="t3://"+adminServerListenAddress+":"+adminServerListenPort, adminServerName=adminServer)
   #connect(userName, pswd, URL)
  except WLSTException:
    print "Could not connect to server! Aborting."
    return -1
  if connected=="true":
    print "connected"
    configureManagedServer()
#    try:
#      deploy(sample_app, '/plateng/transfer/' + sample_app + '.war', targets = managedServer)
#    except NameError:
#      pass  # don't complain if sample_app missing from properties file

    disconnect()

if __name__ == "main":
  sys.exit(main())


