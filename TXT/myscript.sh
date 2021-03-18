#!/bin/bash
# Copyright (C) 2020-2021 Cicak Bin Kadal
# https://www.youtube.com/watch?v=KAXK07ni9gU

# REV04 Mon 15 Mar 19:27:52 WIB 2021
# REV03 Sun 14 Mar 18:21:27 WIB 2021
# REV02 Fri 12 Mar 13:40:58 WIB 2021
# REV01 Tue 13 Oct 10:37:14 WIB 2020
# START Mon 28 Sep 21:05:04 WIB 2020

# "REC2" : my Public-Key Identity!

REC2="n.c.utami@gmail.com"
REC1="operatingsystems@vlsm.org"
FILES="my*.asc my*.txt my*.sh"
SHA="SHA256SUM"

[ -d $HOME/RESULT ] || mkdir -p $HOME/RESULT
# push directory
pushd $HOME/RESULT

for II in W?? ; do
    # pass if no files matching W??
    [ -d $II ] || continue
    TARFILE=my$II.tar.bz2
    TARFASC=$TARFILE.asc
    rm -f $TARFILE $TARFASC
    echo "tar cfj $TARFILE $II/"
    # create tar, list filename, filter archive through bzip2
    tar cfj $TARFILE $II/
    # encrypt tarfile and set recipient, armored
    echo "gpg --armor --output $TARFASC --encrypt --recipient $REC1 --recipient $REC2 $TARFILE"
    gpg --armor --output $TARFASC --encrypt --recipient $REC1 --recipient $REC2 $TARFILE
done

# pop directory
popd

rm -f $HOME/RESULT/fakeDODOL
for II in $HOME/RESULT/myW*.tar.bz2.asc $HOME/RESULT/fakeDODOL ; do
   echo "Check and move $II..."
   # move encrypted armored tars if exist to current dir (os211/TXT/)
   [ -f $II ] && mv -f $II .
done

# removes previous checksum and signed sum
echo "rm -f $SHA $SHA.asc"
rm -f $SHA $SHA.asc

# create checksum
echo "sha256sum $FILES > $SHA"
sha256sum $FILES > $SHA

# verify file integrity
echo "sha256sum -c $SHA"
sha256sum -c $SHA

# detached sign with ascii represetation of $SHA 
# and output to $SHA.asc
echo "gpg -o $SHA.asc -a -sb $SHA"
gpg -o $SHA.asc -a -sb $SHA

# verify $SHA with $SHA.asc
echo "gpg --verify $SHA.asc $SHA"
gpg --verify $SHA.asc $SHA

exit 0


