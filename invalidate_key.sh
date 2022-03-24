#!/usr/bin/env bash

while [ ! -z $1 ]
do
    echo "We will delete the key for the system known as \"${1}\":"
    ls -l ~/.ssh/valid/id_${1}.pub
    echo "Press enter to continue..."
    read foobar

    rm -f ~/.ssh/valid/id_${1}.pub
    cat ~/.ssh/valid/id_*.pub > ~/.ssh/authorized_keys

    shift 1
done
