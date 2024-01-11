#!/bin/bash

scriptdir=$(cd $(dirname $0);pwd)

if [ ! -e dwarfs-universal-0.7.3-Linux-x86_64 ]
   then

       wget https://github.com/mhx/dwarfs/releases/download/v0.7.3/dwarfs-universal-0.7.3-Linux-x86_64 && chmod a+x dwarfs-universal-0.7.3-Linux-x86_64
fi

wget https://www.siedler25.org/uploads/stable/s25rttr_0.9.5-397f2b2315e997504d4958bfbdea0af815ce559a-linux.x86_64.tar.bz2
tar -xf s25rttr*
rm -f s25rttr*
mv s25rttr*/* dwarfs/s25-RTTR/
rm -r s25rttr*
rm -r dwarfs/s25-RTTR/share/s25rttr/S2
ln -s ../../../Original-Settlers-2 dwarfs/s25-RTTR/share/s25rttr/S2

./dwarfs-universal-0.7.3-Linux-x86_64 --tool=mkdwarfs -i dwarfs -o dwarfs.dwarfs
cat script.sh dwarfs-universal-0.7.3-Linux-x86_64 1 dwarfs.dwarfs > Settlers-2-RTTR-Portable.sh && chmod a+x Settlers-2-RTTR-Portable.sh