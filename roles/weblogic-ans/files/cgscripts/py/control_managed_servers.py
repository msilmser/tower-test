import os
from time import sleep

#function=os.getenv("_function")
#domain=os.getenv("_domain")

admin_map_file_name="/users/mwe/cgscripts/py/admin_map.txt"
domain_admin_map={}

def init_admin_map():
 lines=open(admin_map_file_name).readlines()
 for l in lines:
  if (l.startswith("#")):
   pass
  else:
   try:
    domain_admin_map[l.split("=")[0]]=l.split("=")[1].strip()
   except IndexError:
    pass

def start_mgd_servers(domain, mgd_servers):
 #Note: managed server names are passed in sys.argv[]
 try:
  connect(url="t3://"+domain_admin_map[domain],adminServerName=domain+"_adm")
 except WLSTException:
  print "connect failed - will retry after 30 seconds"
  sleep(30)
  try:
   connect(url="t3://"+domain_admin_map[domain],adminServerName=domain+"_adm")
  except WLSTException:
   print "connect failed - will retry after 30 seconds"
   sleep(30)
   try:
    connect(url="t3://"+domain_admin_map[domain],adminServerName=domain+"_adm")
   except WLSTException:
    print "connect failed - will retry after 60 seconds"
    sleep(60)
    connect(url="t3://"+domain_admin_map[domain],adminServerName=domain+"_adm")
 for mgd_server in mgd_servers[:]:
  #state(mgd_server)
  print "starting ",mgd_server
  start(mgd_server, block="true")
  state(mgd_server)
 disconnect()

def stop_mgd_servers(domain, mgd_servers):
 #Note: managed server names are passed in sys.argv[]
 try:
  connect(url="t3://"+domain_admin_map[domain],adminServerName=domain+"_adm")
 except WLSTException:
  print "connect failed - will retry after 15 seconds"
  sleep(15)
  connect(url="t3://"+domain_admin_map[domain],adminServerName=domain+"_adm")
 for mgd_server in mgd_servers[:]:
  #state(mgd_server)
  print "stopping ",mgd_server
  shutdown(mgd_server, "Server", timeOut=10000, force="true", block="true")
  state(mgd_server)
 disconnect()


def bounce_mgd_servers(domain, mgd_servers):
 try:
  connect(url="t3://"+domain_admin_map[domain],adminServerName=domain+"_adm")
 except WLSTException:
  print "connect failed - will retry after 15 seconds"
  sleep(15)
  connect(url="t3://"+domain_admin_map[domain],adminServerName=domain+"_adm")
 for mgd_server in mgd_servers[:]:
  print "stopping ",mgd_server
  try:
   shutdown(mgd_server, "Server", timeOut=10000, force="true", block="true")
  except WLSTException:
   # ignore exception - assume server was already stopped, and proceed with bounce
   print "..." ,
  state(mgd_server)
 sleep(30)
 for mgd_server in mgd_servers[:]:
  print "starting ",mgd_server
  start(mgd_server, block="true")
  state(mgd_server)
 disconnect()


def main():
 prompt("off")
 sys.ps1=""
 init_admin_map()
 function=sys.argv[1]
 domain=sys.argv[2]
 print function
 print domain
 mgd_server_list = []
 for mgd_server in sys.argv[3:]:
#  if (mgd_server.startswith(domain)):
   mgd_server_list.append(mgd_server)
#  else:
#   mgd_server_list.append(domain + "_" + mgd_server)
   
 if (function == "start"):
  start_mgd_servers(domain, mgd_server_list)
 elif (function == "stop"):
  stop_mgd_servers(domain, mgd_server_list)
 elif (function == "bounce"):
  bounce_mgd_servers(domain, mgd_server_list)
 exit()

if __name__ == "main":
 sys.exit(main())


