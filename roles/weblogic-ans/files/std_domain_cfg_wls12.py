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
from time import sleep
import socket

"""
def initConfigToScriptRun():
  global startedNewServer
  hideDisplay()
  if connected=="false":
    stopExecution("You need to be connected.")
"""

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

def defineDomain(beahome, domainName, adminServer, user, pswd, listenPort, sslPort):
  readTemplate(beahome+"/wlserver/common/templates/wls/wls.jar")
  # Configure the Administration Server and SSL port.
  cd("Servers/AdminServer")
  cmo.setName(adminServer)
  hostName = socket.gethostname()
  cmo.setListenAddress(hostName)
  cmo.setListenPort(int(listenPort))
  cmo.setTunnelingEnabled(true)
  create(adminServer,"SSL")
  cd("/Servers/"+adminServer+"/SSL/"+adminServer)
  set("Enabled", "True")
  set("ListenPort", int(sslPort))
  set("HostnameVerificationIgnored", "True")
  set("HostnameVerifier", "None")
  # Define the user password for weblogic.
  cd("/Servers/"+adminServer)
  create(adminServer,"OverloadProtection")
  cd("/Servers/"+adminServer+"/OverloadProtection/"+adminServer)
  cmo.setPanicAction("system-exit")
  cd("/")
  cd("/Security/base_domain/User/weblogic")
  cmo.setName("wlsadmin")
  cmo.setPassword(pswd)
  cd("/")
  cmo.setConfigBackupEnabled(true)
  cmo.setArchiveConfigurationCount(5)
  cmo.setConfigurationAuditType("log")
  cd("/")
  cd ("NMProperties")
  set("ListenPort", int(nodeManagerSSLPort))
  set("ListenAddress", "")
  set("StartScriptEnabled", "true")
  # Write the domain and close the domain template.
  setOption("OverwriteDomain", "true")
  # New Node Manager Configuration Model in WLS 12.1.2
  setOption("NodeManagerType", "PerDomainNodeManager")
  writeDomain("/users/domains/"+domainName)
  closeTemplate()

def create_AuthenticationProvider_LDAP(path, beanName):
  cd(path)
  try:
    print "creating mbean of type AuthenticationProvider ... "
    theBean = cmo.lookupAuthenticationProvider(beanName)
    if theBean == None:
      cmo.createAuthenticationProvider(beanName,"weblogic.security.providers.authentication.LDAPAuthenticator")
  except java.lang.UnsupportedOperationException, usoe:
    pass
  except weblogic.descriptor.BeanAlreadyExistsException,bae:
    pass
  except java.lang.reflect.UndeclaredThrowableException,udt:
    pass

def setAttributes_UserLockoutManager(domain, realm):
  cd("/SecurityConfiguration/"+domain+"/Realms/"+realm+"/UserLockoutManager/UserLockoutManager")
  print "setting attributes for mbean type UserLockoutManager"
  set("LockoutDuration", "1")
  set("LockoutCacheSize", "10")
  set("LockoutResetDuration", "5")
  set("LockoutEnabled", "true")
  set("LockoutThreshold", "10")
  set("LockoutGCThreshold", "400")

def setAttributesFor_SecurityRealm(domain, realm):
  cd("/SecurityConfiguration/"+domain+"/Realms/"+realm)
  print "setting attributes for mbean type Realm"
  # set("EnableWebLogicPrincipalValidatorCache", "true")
  set("DeployRoleIgnored", "false")
  # set("MaxWebLogicPrincipalsInCache", "500")
  set("FullyDelegateAuthorization", "false")
  set("DeployPolicyIgnored", "false")
  set("CombinedRoleMappingEnabled", "true")
  set("SecurityDDModel", "DDOnly")
  set("DeployCredentialMappingIgnored", "false")
  set("DelegateMBeanAuthorization", "true")
  set("DelegateMBeanAuthorization", "false")
  # CertificateRegistry=getMBean("CertPathProviders/CertificateRegistry")
  # print CertificateRegistry
  # cmo.setCertPathBuilder(CertificateRegistry)

def setAttributesFor_CGLDAP(domain, realm, ldapHost, ldapPort, ldapAttrsList):
  cd("/SecurityConfiguration/"+domain+"/Realms/"+realm+"/AuthenticationProviders/CGLDAP")
  print "setting attributes for mbean type LDAPAuthenticator"
  set("PropagateCauseForLoginException", "false")
  set("Host", ldapHost)
  # set("AllGroupsFilter", "\"\"")
  set("GroupSearchScope", "onelevel")
  set("GroupBaseDN", "ou=groups,o=capgroup.com")
  set("ControlFlag", "SUFFICIENT")
  set("UserSearchScope", "onelevel")
  set("UserBaseDN", "ou=people,o=capgroup.com")
  set("GroupMembershipSearching", "limited")
  set("MaxGroupMembershipSearchLevel", 0)
  set("Port", ldapPort)
  for ldap_attribute in ldapAttrsList:
    attr, value = ldap_attribute.split(":")
    print "ldap attr: ",attr," -> value: ",value
    set(attr, value)

def setAttributesFor_DefaultAuthenticator(domain, realm):
  cd("/SecurityConfiguration/"+domain+"/Realms/"+realm+"/AuthenticationProviders/DefaultAuthenticator")
  print "setting attributes for mbean type DefaultAuthenticator"
  set("ControlFlag", "SUFFICIENT")
  set("PropagateCauseForLoginException", "false")


def setProductionMode_And_FileCount(adminServer,productionModeFlag):
  cd('/')
  #Enable Production Mode --inyryk
  if ('y' == productionModeFlag):
    set("ProductionModeEnabled","true")
  #Limit the files to be retained --inyryk
  cd("/Servers/"+adminServer+"/Log/"+adminServer)
  set("FileCount","7")
def usage():
  print "argument required: config_file_name"


def main():
  if (len(sys.argv) == 0):
    usage()
    return -1
  propFile = sys.argv[1]
  loadProperties(propFile)  #1 = first argument, 0=name of script
  machine_list = machines.replace(",", " ").split()

  role_mapping_list = []   # note: initialize as empty list
  try:
    role_mapping_list = role_mappings.replace(";", " ").split()
  except NameError:
    pass  # don't complain if role_mappings missing from properties file
  ldap_attributes_list = []   # note: initialize as empty list
  try:
    ldap_attributes_list = ldap_attributes.replace(";", " ").split()
  except NameError:
    pass  # don't complain if ldap_attributes missing from properties file

  beahome = os.getenv("MW_HOME")
  print"BEA_HOME:",beahome
  wlhome = os.getenv("ORACLE_HOME")
  print"WL_HOME:",wlhome
  adminServerListenAddress = socket.gethostname()

  if ("" == passWord or passWord.isspace()):
    if (len(sys.argv) < 3):
      pswd=raw_input("Enter password for WLS domain --> ")
    else:
      pswd=sys.argv[2]
  else:
    pswd=passWord

  response=raw_input("Enter 'q' to Quit or 'c' to Continue domain creation --> ")
  if ('q' == response):
    return -1
  if ('y' == defineDomainFlag):
    print "Starting domain creation..."
    defineDomain(beahome, domain, adminServer, userName, pswd, adminServerListenPort, adminServerSSLPort)
  print "domain bin directory location: ", "/users/domains/"+domain+"/bin"
  if ('y' == configureDomainFlag):
    pass
  else:
    return 1
  print "Starting the new Admin Server... waiting 60 seconds."

  os.system("${WLST_SCRIPTS}/editWeblogicStartup.sh /users/domains/"+domain+"/bin")
  os.system("${WLST_SCRIPTS}/startWeblogicAdmin.sh '"+domain+"' '"+userName+"' '"+pswd+"'")
  # New logic to check server start and to connect to admin server
  sleep(60)
  response=raw_input("Enter 'q' to Quit or 'c' to Continue domain configuration --> ")
  if ('q' == response):
    return -1
  print "Starting domain configuration..."

  try:
    URL="t3://"+adminServerListenAddress+":"+adminServerListenPort
    connect(userName, pswd, URL)
  except WLSTException:
    print "Connect failed to Admin server - will retry after 60 seconds."
    sleep(60)
    try:
      connect(userName, pswd, URL)
    except WLSTException:
      print "Connect failed to Admin server - will retry after 200 seconds."
      sleep(200)
      try:
        connect(userName, pswd, URL)
      except WLSTException:
        print "Connect failed to Admin server - will retry after 300 seconds."
        sleep(300)
        try:
          connect(userName, pswd, URL)
        except WLSTException:
          print "Connect failed to Admin server - will retry after 300 seconds."
          sleep(300)
          try:
            connect(userName, pswd, URL)
          except WLSTException:
            print "Could not connect to Admin server! Aborting."
            return -1

  if connected=="true":
    print "connected"
    cd("SecurityConfiguration/"+domain+"/Realms/myrealm/RoleMappers/XACMLRoleMapper")
    #Add offshore group --inyryk
    #cmo.setRoleExpression(None,"Admin","Grp(mw_admin_group)|Grp(Administrators)|Grp(MWAdmin_Offshr)")
    #role_mapping_list = role_mappings.replace(";", " ").split()
    for role_mapping in role_mapping_list:
      role = role_mapping.split(":")[0]
      expr = role_mapping.split(":")[1]
      print "role: ",role," -> expr: ",expr
      #cmo.createRole(None,role,None)
      cmo.setRoleExpression(None,role,expr)
    startTransaction()
    # Create machines for remote node managers:
    print"MACHINE_LIST:",machine_list
    for machine in machine_list:
      cd('/')
      cmo.createUnixMachine(machine)
      cd("/Machines/"+machine+"/NodeManager/"+machine)
      cmo.setNMType("SSL")
      cmo.setListenPort(int(nodeManagerSSLPort))
      cmo.setListenAddress(machine)
      cmo.setDebugEnabled(true)
      print"MACHINE:",machine
    # Configure LDAP (Active Directory) authentication provider:
    realm="myrealm"
    ldapHost="ldap"
    ldapPort="636"
    setAttributesFor_DefaultAuthenticator(domain, realm)
    create_AuthenticationProvider_LDAP("/SecurityConfiguration/"+domain+"/Realms/"+realm,"CGLDAP")
    setAttributesFor_SecurityRealm(domain, realm)
    setAttributesFor_CGLDAP(domain, realm, ldapHost, ldapPort, ldap_attributes_list)
    setAttributes_UserLockoutManager(domain, realm)
    setProductionMode_And_FileCount(adminServer,productionModeFlag)
    endTransaction()
 #   shutdown()
    disconnect()

if __name__ == "main":
  sys.exit(main())

