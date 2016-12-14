#!/usr/bin/env bash

apt-get update
apt-get install -y imagemagick openjdk-6-jdk coreutils perl git figlet texinfo
cd /root || exit
git clone https://github.com/maandree/util-say
cd /root/util-say || exit
mkdir /root/util-say/tmp
make
sed -i'' 's@--import image@--import image --right 5 --top 1@g' /root/util-say/img2ponysay
export NAMES
NAMES=$(find /vagrant/src/images/*.png | sed 's@.*/@@g' | sed 's@.png@@g')
for i in ${NAMES}; do /root/util-say/ponytool --import image --magnified 1 --file "/vagrant/src/images/${i}.png" --balloon n --export ponysay --chroma 1 --platform xterm --right 5 > "/root/util-say/tmp/${i}-image.txt"; done
for i in ${NAMES}; do figlet "${i//-/ }" > /root/util-say/tmp/"${i}"-name.txt; cat /vagrant/host-data.txt >> /root/util-say/tmp/"${i}"-name.txt; done
for i in ${NAMES}; do paste /root/util-say/tmp/"${i}"-image.txt /root/util-say/tmp/"${i}"-name.txt > /vagrant/dist/templates/"${i}".motd; done
