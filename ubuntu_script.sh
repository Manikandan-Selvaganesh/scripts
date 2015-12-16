#!/bin/bash

echo "Hi, Please enter your inputs exactly like how it is mentioned in the examples(Eg)"

echo "Enter Series (Eg: 3.4)"
read SERIES

echo "Enter Version (Eg: 3.4.5, enter the full string(3.4.5) and not 5 alone)"
read VERSION

echo "Enter Release (Eg: 2)"
read RELEASE

echo "Enter the Ubuntu Release name(trusty/precise/wily)"
read RNAME

echo "You are trying to build glusterfs-${VERSION}-$RELEASE for $RNAME"

echo "Type yes to continue (y/n)"
read yesno

if [ $yesno = "n" ]; then
        echo "Exiting, you have entered something other than y"
        exit 1
fi

mkdir build packages glusterfs-${VERSION}-${RELEASE}-${RNAME}

cd ~/build

wget http://download.gluster.org/pub/gluster/glusterfs/${SERIES}/${VERSION}/glusterfs-${VERSION}.tar.gz

ln -s glusterfs-${VERSION}.tar.gz glusterfs_${VERSION}.orig.tar.gz

tar xzf glusterfs-${VERSION}.tar.gz

cd glusterfs-${VERSION}

echo "Enter your username to copy the source debian"
read UNAME

cp -a /home/$UNAME/src/github/glusterfs-debian/debian .

echo "You might double check before proceeding that debian/changelog has the changes you made."
echo "Press y if your are done(y/n)"
read yesno

if [ $yesno = "n" ]; then
        echo "Exiting, you have entered something other than y"
        exit 1
fi

debuild -S -sa -k9BCD55B2

echo "Enter the passphrase twice"

cd ..

dput ppa:gluster/glusterfs-${SERIES} glusterfs_${VERSION}-ubuntu1~${RNAME}1_source.changes

cd ..

mv build packages glusterfs-${VERSION}-${RELEASE}-${RNAME}

echo "We are done, just give ls and you can see the package built"
