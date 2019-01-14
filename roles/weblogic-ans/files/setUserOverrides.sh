umask 022
if [ -f   ${DOMAIN_HOME}/bin/wls_app_config.properties ];then

echo "Updating custom application configuration for ${SERVER_NAME}"

.  ${DOMAIN_HOME}/bin/wls_app_config.properties

fi
