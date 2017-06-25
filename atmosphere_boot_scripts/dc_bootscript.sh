#!/bin/bash -x

# irsync script
#
main ()
{
    #
    # This is the main function -- These lines will be executed each run
    #

    init_irods
    inject_atmo_vars
    copy_dc_home_datasets
}

inject_atmo_vars ()
{
    #
    #
    #NOTE: For now, only $ATMO_USER will be provided to script templates (In addition to the standard 'env')
    #
    #

    # Source the .bashrc -- this contains $ATMO_USER
    PS1='HACK to avoid early-exit in .bashrc'
    . ~/.bashrc
    if [ -z "$ATMO_USER" ]; then
        echo 'Variable $ATMO_USER is not set in .bashrc! Abort!'
        exit 1 # 1 - ATMO_USER is not set!
    fi
    echo "Found user: $ATMO_USER"
}

copy_dc_home_datasets ()
{
  # Performs an irsync command to copy a test dataset folder to $ATMO_USER
  # desktop
  irsync -r i:/iplant/home/shared/cyverse_training/workshop_materials/genomics_data_carpentry/dcuser_home  /home/dcuser >/var/log/williams_bootscript.log 2>&1
  irsync -r i:/iplant/home/shared/cyverse_training/workshop_materials/genomics_data_carpentry/.dc_sampledata_lite   /home/dcuser/.dc_sampledata_lite  >/var/log/williams_bootscript.log 2>&1
  chown -R dcuser /home/dcuser

  exit 0
}

add_vnc_permissions ()
{
    # add dcuser as an authorized user to desktop
    vncserver --Permissions=dcuser

    exit 0
}

init_irods ()
{
	if [ ! -d "$HOME/.irods" ]; then
		mkdir -p $HOME/.irods
	fi

	if [ ! -e "$HOME/.irods/irods_environment.json" ]; then
		cat << EOF > $HOME/.irods/irods_environment.json
{
    "irods_host": "data.iplantcollaborative.org",
    "irods_zone_name": "iplant",
    "irods_port": 1247,
    "irods_user_name": "anonymous"
}
EOF
	fi

}
# This line will start the execution of the script
main