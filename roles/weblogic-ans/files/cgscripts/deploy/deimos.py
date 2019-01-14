import os
import sys
from deploy_module import *

adminURL = 't3://x883619:12000'
managed1 = 'AA00001588_TST'
deployPath = '/users/domains/prsg/stage/'
appPath = deployPath + 'deimos.ear'
appName = 'deimos'
md5log = deployPath + '/md5checksum.log'

connect(url=adminURL,adminServerName='wtx883619_adm')

deploy_app(appName, deployPath, 'true', md5log, managed1)


