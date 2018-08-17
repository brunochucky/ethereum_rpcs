#!/bin/bash

if [ -z "$1" ]
  then
    echo "No argument supplied"
    wallet="0x6B0c56d1Ad5144b4d37fa6e27DC9afd5C2435c3B"
  else
  	wallet="$1"
fi


if [ -z "$2" ]
  then
    echo "No argument supplied"
    tag="latest"
  else
    tag="$2"
fi

curl -X POST --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["'$wallet'", "'$tag'"],"id":1}'