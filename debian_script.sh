#!/bin/bash

echo "Hi, Please enter your inputs exactly like how it is mentioned in the examples(Eg)"

echo "Enter Series (Eg: 3.4)"
read SERIES

echo "Enter Version (Eg: 3.4.5, enter the full string(3.4.5) and not 5 alone)"
read VERSION

echo "Enter Release (Eg: 2)"
read RELEASE

echo "Enter the Debian Release name(wheezy/jessie/stretch)"
read RNAME

echo "You are trying to build glusterfs-${VERSION}-$RELEASE for $RNAME"

echo "Type yes to continue (y/n)"
read yesno

if [ $yesno = "n" ]; then
        echo "Exiting, you have entered something other than y"
        exit 1
fi

mkdir build packages glusterfs-$VERSION-$RELEASE

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

echo "This takes a few minutes pbuilder on work ;)"
sudo pbuilder --build glusterfs_${VERSION}-${RELEASE}.dsc

echo "We are almost done"

cd ~/packages

cp /var/cache/pbuilder/result/glusterfs*${VERSION}-${RELEASE}*.deb .

echo "Sign the packages with the RSA signing key passphrase. There are four packages to sign."

dpkg-sig -v -k 9BCD55B2 --sign builder glusterfs-*${VERSION}-${RELEASE}*.deb

cd /var/www/repos/apt/debian/

rm -rf pool/* dists/* db/*

for i in ~/packages/glusterfs-*${VERSION}-${RELEASE}*.deb; do
        reprepro includedeb $RNAME $i;
done

reprepro includedsc $RNAME ~/build/glusterfs_${VERSION}-${RELEASE}.dsc

tar czf ~/glusterfs-${VERSION}-${RELEASE}/apt-${VERSION}.tgz pool/ dists/

cd

mv build packages glusterfs-${VERSION}-${RELEASE}

echo "We are done, just give ls and you can see the package built"
