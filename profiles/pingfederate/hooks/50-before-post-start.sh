#!/usr/bin/env sh
#
# Ping Identity DevOps - Docker Build Hooks
#
#- This is called after the start or restart sequence has finished and before 
#- the server within the container starts
#

# shellcheck source=pingcommon.lib.sh
. "${HOOKS_DIR}/pingcommon.lib.sh"

# Do some text replacements to enable LDAP for:
# - OAuth Clients
# - OAuth Grants
# - AuthN Sessions
# These are mapped later in the /config-store API calls

sed -e "s#<construct class=\"org.sourceid.oauth20.domain.ClientManagerXmlFileImpl\"/>#<construct class=\"org.sourceid.oauth20.domain.ClientManagerLdapImpl\"/>#" \
    -e "s#<create-instance class=\"org.sourceid.oauth20.token.AccessGrantManagerJdbcImpl\"/>#<create-instance class=\"org.sourceid.oauth20.token.AccessGrantManagerLDAPPingDirectoryImpl\"/>#" \
    -e "s#<construct class=\"org.sourceid.saml20.service.session.data.impl.SessionStorageManagerJdbcImpl\"/>#<construct class=\"org.sourceid.saml20.service.session.data.impl.SessionStorageManagerLdapImpl\"/>#"\
    "/opt/out/instance/server/default/conf/META-INF/hivemodule.xml" > "/opt/out/instance/server/default/conf/META-INF/hivemodule.xml-modified"

mv /opt/out/instance/server/default/conf/META-INF/hivemodule.xml-modified /opt/out/instance/server/default/conf/META-INF/hivemodule.xml

# echo "##########
# "
# cat /opt/out/instance/server/default/conf/META-INF/hivemodule.xml
# echo "
# ##########"

# Delete bundled files so that Server Profile can apply newer ones
echo Removing bundled files
# AuthN API
echo PF AuthN API
rm -f /opt/out/instance/server/default/lib/pf-authn-api-sdk-1.0.0.35.jar
rm -f /opt/out/instance/server/default/lib/pf-authn-api-sdk-1.0.0.54.jar

rm -f /opt/out/instance/server/default/deploy/pf-pingone-mfa-adapter-1.3.2.jar
rm -f /opt/out/instance/server/default/deploy/pf-pingone-quickconnection-2.1.jar
rm -f /opt/out/instance/server/default/deploy/pf-pingone-risk-management-adapter-1.1.jar
