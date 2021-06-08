#!/bin/bash

DOMAIN_NAME=`grep DOMAIN_NAME= ./srcs/.env | sed -e 's/^.*=//'`
if [ `echo ${#DOMAIN_NAME}` -eq 0 ]; then
    exit 1
fi

find() {
    grep -q "127.0.0.1 ${DOMAIN_NAME}" /etc/hosts
}

if [ "$1" = "setup" ]; then
    find
    if [ "$?" -eq 0 ]; then
        echo "Exists in /etc/hosts."
    else
        echo "127.0.0.1 ${DOMAIN_NAME}" | sudo tee -a /etc/hosts
    fi
elif [ "$1" = "fclean" ]; then
    find
    if [ "$?" -eq 0 ]; then
        sudo sed -ie "/^127.0.0.1 ${DOMAIN_NAME}$/d" /etc/hosts
    fi
fi
