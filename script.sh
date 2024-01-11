#!/bin/bash

#Sets variables and functions#
##############################
scriptdir=$(cd $(dirname $0);pwd)
scriptname=$(basename "$0")
offset=auto
mountpoint="/tmp"
workdir=$scriptdir
Begin_dwarfs_universal=`awk '/^#__Begin_dwarfs_universal__/ {print NR + 1; exit 0; }' $scriptdir/$scriptname`
End_dwarfs_universal=`awk '/^#__End_dwarfs_universal__/ {print NR - 1; exit 0; }' $scriptdir/$scriptname`

sh_mount () {
  if [ ! -e "$mountpoint/RTTR-Portable" ]
     then

         mkdir -p $mountpoint/RTTR-Portable/mount-tools
         mkdir -p $mountpoint/RTTR-Portable/mnt 
         awk "NR==$Begin_dwarfs_universal, NR==$End_dwarfs_universal" $scriptdir/$scriptname > $mountpoint/RTTR-Portable/mount-tools/dwarfs-universal-0.7.3-Linux-x86_64 && chmod a+x $mountpoint/RTTR-Portable/mount-tools/dwarfs-universal-0.7.3-Linux-x86_64
         $mountpoint/RTTR-Portable/mount-tools/dwarfs-universal-0.7.3-Linux-x86_64 --tool=dwarfs $scriptdir/$scriptname $mountpoint/RTTR-Portable/mnt -o offset=$offset
fi
}

sh_unmount () {
  umount $mountpoint/RTTR-Portable/mnt
  rm -r $mountpoint/RTTR-Portable
}

sh_help () {
  export LD_LIBRARY_PATH="$mountpoint/RTTR-Portable/mnt/libs/:$mountpoint/RTTR-Portable/mnt/libs/x86_64-linux-gnu/"
  echo 'sh Options'
  echo '----------'
  echo '--mount                     Mounts the dwarfs filesystem in '$mountpoint''
  echo '                            (can be used with <--mountpoint>)'
  echo ''
  echo '--mountpoint=<path>         Defines the mount location for the dwarfs'
  echo '                            image.(Default mountpoint: </tmp>)'
  echo ''
  echo '--install                   Moves the image into your .local/share'
  echo '                            folder and creates an desktop entry.'
  echo '-------------------------------------------------------------------------'
  $mountpoint/RTTR-Portable/mnt/s25-RTTR/bin/s25client --help
  umount $mountpoint/RTTR-Portable/mnt
  rm -r $mountpoint/RTTR-Portable
  exit
}

sh_if_mounted () {
  if [ ! -e $mountpoint/RTTR-Portable ]
     then

         sh_mount
         echo -e "\033[1;32mImage mounted in $mountpoint\033[0;38m"
         exit

     else

         umount $mountpoint/RTTR-Portable/mnt
         rm -r $mountpoint/RTTR-Portable
         echo -e "\033[1;31mImage unmounted\033[0;38m"
         exit
fi
}

sh_start () {
  export HOME="$scriptdir/"
  export LD_LIBRARY_PATH="$mountpoint/RTTR-Portable/mnt/libs/:$mountpoint/RTTR-Portable/mnt/libs/x86_64-linux-gnu/"
  $mountpoint/RTTR-Portable/mnt/s25-RTTR/bin/s25client $launchargs
}

sh_install () {
  if [ -e ~/.local/share/RTTR-Portable ]
     then

         echo -e "\033[1;31mFolder RTTR-Portable already exists in ~/.local/share\033[0;38m"
         if [ ! -e ~/.local/share/applications/RTTR.desktop ]; then sh_create_entry && echo -e "\033[1;32mFixed missing desktop entry\033[0;38m"; fi
         echo -e "\033[1;31mCan't install in ~/.local/share\033[0;38m"
         echo -e "\033[1;31mAlready installed\033[0;38m"
         echo -e "\033[1;31mWould you like to uninstall? All data will be removed![Y/n]\033[0;38m"
         read input
         case $input in
             y|yes)
             sh_uninstall
             ;;
             n|no)
             echo -e "\033[1;31mAborting\033[0;38m"
             ;;
             *)
             echo -e "\033[1;31mAborting\033[0;38m"
             ;;
         esac
         exit

     else

         echo -e "\033[1;32mInstalling RTTR in ~/.local/share...\033[0;38m"
         sh_mount
         mkdir -p ~/.local/share/RTTR-Portable
         cp $scriptdir/$scriptname ~/.local/share/RTTR-Portable
         cp  $mountpoint/RTTR-Portable/mnt/install/RTTR.png ~/.local/share/RTTR-Portable/
         if [ -e ~/.local/share/applications/RTTR.desktop ]; then rm ~/.local/share/applications/RTTR.desktop; fi
         echo -e "\033[1;32mCreating desktop entry...\033[0;38m"
         sh_create_entry
         echo -e "\033[1;32mDone\033[0;38m"
         sh_unmount
         echo -e "\033[1;32mFinished installing RTTR in ~/.local/share...\033[0;38m"
fi
}

sh_uninstall () {
  echo -e "\033[1;32mUninstalling RTTR in ~/.local/share...\033[0;38m"
  echo -e "\033[1;31mAll data will be removed in\033[0;38m"
  sleep 1s
  echo -e "\033[1;31m3		Press ctrg+c to abort\033[0;38m"
  sleep 1s
  echo -e "\033[1;31m2		Press ctrg+c to abort\033[0;38m"
  sleep 1s
  echo -e "\033[1;31m1		Press ctrg+c to abort\033[0;38m"
  sleep 1s
  
  echo -e "\033[1;32mRemoving data...\033[0;38m"
  rm -r ~/.local/share/RTTR-Portable
  echo -e "\033[1;32mRemoving desktop entry...\033[0;38m"
  rm ~/.local/share/applications/RTTR.desktop
  echo -e "\033[1;32mFully uninstalled RTTR in ~/.local/share\033[0;38m"
}

sh_create_entry () {
  echo '[Desktop Entry]'							   	 >> ~/.local/share/applications/RTTR.desktop
  echo 'Name=Settlers 2 RTTR'							   	 >> ~/.local/share/applications/RTTR.desktop
  echo 'Name[de]=Siedler 2 RTTR'						   	 >> ~/.local/share/applications/RTTR.desktop
  echo 'Exec='$HOME'/.local/share/RTTR-Portable/Settlers-2-RTTR-Portable.sh' 	         >> ~/.local/share/applications/RTTR.desktop
  echo 'Type=Application'							   	 >> ~/.local/share/applications/RTTR.desktop
  echo 'Categories=Games;'							   	 >> ~/.local/share/applications/RTTR.desktop
  echo 'Comment=An open source remake of the famous dos game "The settlers 2"'     	 >> ~/.local/share/applications/RTTR.desktop
  echo 'Comment[de]=Ein open source remake von dem bekannten dos Spiel "Die Siedler 2"'  >> ~/.local/share/applications/RTTR.desktop
  echo 'Icon='$HOME'/.local/share/RTTR-Portable/RTTR.png'			  	 >> ~/.local/share/applications/RTTR.desktop
}
#Scriptstart#
#############
for i in "$@"
do
case $i in
    "-?"|-h|--h|--help)
    help=1
    ;;
    --mount)
    mount=1
    ;;
    --mountpoint=*)
    mountpoint="${i#*=}"
    ;;
    --install)
    install=1
    ;;
    *)
    launchargs="$launchargs $i"
    ;;
esac
done

if [ "$help" == "1" ]; then sh_mount && sh_help; fi
if [ "$install" == "1" ]; then sh_install && exit; fi
if [ "$mount" == "1" ]; then sh_if_mounted; else sh_mount && sh_start && sh_unmount ; fi


exit
#__Begin_dwarfs_universal__
