Weblogic
=========

1) Creates webapp and mwadmin linux users and related groups and directories.
2) Stages files in /users/mwe/tmp/files.
3) Installs latest update of JDK and creates symbolic links.
4) Installs and patches Weblogic 12.2.1.3 with latest security update.
5) Creates default Weblogic domain.
6) Configures autostart scripts for Weblogic.

Requirements
------------

Should be run on a new/clean VM.  Has not been tested on VM with existing installation.

Role Variables
--------------

These variables should be overridden.  Defaults in parens.
 app_id: (BB00000042)
 zone: (OZ)
 wls_username: (wlsadmin)
 wls_password: ()
 app_env: (DEV) [optional: needed for LDAP/AD groups]


Dependencies
------------

N/A

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: weblogic_hosts
      gather_facts: true 
      roles:
        - weblogic-ans

Example command line:
ansible-playbook -e app_id=AA00000042 -e zone=SNP -e app_env=DEV -e wls_username=wlsadmin -e wls_password=passwordabc123 weblogic-ans.yaml

License
-------

BSD

Author Information
------------------

N/A
