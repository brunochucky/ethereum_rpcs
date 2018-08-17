#!/bin/bash

if [ -z "$1" ]
  then
    echo "No argument supplied"
    wallet1="0x6B0c56d1Ad5144b4d37fa6e27DC9afd5C2435c3B"
  else
  	wallet1="$1"
fi


if [ -z "$2" ]
  then
    echo "No argument supplied"
    wallet2="0x00E3d1Aa965aAfd61217635E5f99f7c1e567978f"
  else
  	wallet2="$2"
fi

curl --data '{"jsonrpc":"2.0","method":"personal_sendTransaction","params":[{"from":'$wallet1',"to":'$wallet2',"value":"0xde0b6b3a7640000"}, ""],"id":0}' -H "Content-Type: application/json" -X POST localhost:8545