#!/bin/bash -x

# irsync script
#
main ()
{
    #
    # This is the main function -- These lines will be executed each run
    #

    inject_atmo_vars
    copy_workshop_datasets
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

copy_workshop_datasets ()
{
  # Performs an irsync command to copy a test dataset folder to $ATMO_USER
  # desktop
  irsync -r i:/iplant/home/shared/cyverse_training/workshop_materials/atmosphere/test_data_01 /home/$ATMO_USER/Desktop/

  exit 0
}
# This line will start the execution of the script
main
