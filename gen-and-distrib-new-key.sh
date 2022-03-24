#!/usr/bin/env bash
keytype=rsa
keybits=16384

if [ -z $1 ] ; then
    echo "Need a hostname"
    exit
fi
target=$1
echo target: ${target}
targetname=$( (echo $target | sed -e 's/\..*//') )
echo targetname=${targetname}
hostname=$( (hostname -s) )
echo hostname: ${hostname}
keyname=id_${hostname}-${targetname}
echo keyname: ${keyname}

#echo rm -f ${keyname}
#rm -f ${keyname}

#exit

mkdir -p ~/.ssh/newkeys
#echo rm -f ${keyname}
rm -f ~/.ssh/newkeys/${keyname}

ssh-keygen -t ${keytype} -b ${keybits} -V +6w -f ~/.ssh/newkeys/${keyname}

ssh ${target} "mkdir -p .ssh/incoming; rm -f .ssh/incoming/${keyname}" || exit
scp ~/.ssh/newkeys/${keyname}.pub ${target}:.ssh/incoming/id_${hostname}.pub || exit
rm ~/.ssh/newkeys/${keyname}.pub
ssh ${target} "mkdir -p .ssh/valid; mv .ssh/incoming/id_${hostname}.pub .ssh/valid; cat .ssh/valid/* > .ssh/authorized_keys" || exit
mv ~/.ssh/newkeys/${keyname} ~/.ssh/${keyname}
