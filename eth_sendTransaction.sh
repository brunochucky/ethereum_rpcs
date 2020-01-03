#!/bin/bash
die()
{
	local _ret=$2
	test -n "$_ret" || _ret=1
	test "$_PRINT_HELP" = yes && print_help >&2
	echo "$1" >&2
	exit ${_ret}
}
begins_with_short_option()
{
	local first_option all_short_options='isftvgpdnh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

_arg_id=
_arg_server=
_arg_wallet_from=
_arg_wallet_to=
_arg_value=
_arg_gas=
_arg_gasPrice=
_arg_data=
_arg_nonce=
print_help()
{
	printf '%s\n' "Ethereum JSON RPC API"
	printf 'Usage: %s [-i|--id <arg>] [-s|--server <arg>] [-f|--wallet_from <arg>] [-t|--wallet_to <arg>] [-v|--value <arg>] [-h|--help]\n' "$0"
	printf '\t%s\n' "-i, --id: optional argument (0)"
	printf '\t%s\n' "-s, --server: optional argument (localhost:8545)"
	printf '\t%s\n' "-f, --wallet_from: optional argument (0x6B0c56d1Ad5144b4d37fa6e27DC9afd5C2435c3B)"
	printf '\t%s\n' "-t, --wallet_to: optional argument (0x00E3d1Aa965aAfd61217635E5f99f7c1e567978f)"
	printf '\t%s\n' "-v, --value: optional argument (0xde0b6b3a7640000)"
	printf '\t%s\n' "-g, --gas: optional argument (0x76c0)"
	printf '\t%s\n' "-p, --gasprice: optional argument (0x9184e72a000)"
	printf '\t%s\n' "-d, --data: optional argument (0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675)"
	printf '\t%s\n' "-n, --nonce: optional argument (0xde0b6b3a7640000)"
	printf '\t%s\n' "-h, --help: Prints help"
}
parse_commandline()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in

			-i|--id)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_id="$2"
				shift
				;;
			--id=*)
				_arg_id="${_key##--id=}"
				;;
			-i*)
				_arg_id="${_key##-i}"
				;;

			-s|--server)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_server="$2"
				shift
				;;
			--server=*)
				_arg_server="${_key##--server=}"
				;;
			-s*)
				_arg_server="${_key##-s}"
				;;
			-f|--wallet_from)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_wallet_from="$2"
				shift
				;;
			--wallet_from=*)
				_arg_wallet_from="${_key##--wallet_from=}"
				;;
			-f*)
				_arg_wallet_from="${_key##-f}"
				;;
			-t|--wallet_to)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_wallet_to="$2"
				shift
				;;
			--wallet_to=*)
				_arg_wallet_to="${_key##--wallet_to=}"
				;;
			-t*)
				_arg_wallet_to="${_key##-t}"
				;;
			-v|--value)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_value="$2"
				shift
				;;
			--value=*)
				_arg_value="${_key##--value=}"
				;;
			-v*)
				_arg_value="${_key##-v}"
				;;

			-d|--data)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_data="$2"
				shift
				;;
			--data=*)
				_arg_data="${_key##--data=}"
				;;
			-d*)
				_arg_data="${_key##-d}"
				;;

			-g|--gas)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_gas="$2"
				shift
				;;
			--gas=*)
				_arg_gas="${_key##--gas=}"
				;;
			-g*)
				_arg_gas="${_key##-g}"
				;;

			-p|--gasprice)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_gasPrice="$2"
				shift
				;;
			--gasprice=*)
				_arg_gasPrice="${_key##--gasprice=}"
				;;
			-p*)
				_arg_gasPrice="${_key##-p}"
				;;

			-n|--nonce)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_nonce="$2"
				shift
				;;
			--nonce=*)
				_arg_nonce="${_key##--nonce=}"
				;;
			-n*)
				_arg_nonce="${_key##-n}"
				;;
			
			-h|--help)
				print_help
				exit 0
				;;
			
			-h*)
				print_help
				exit 0
				;;
			*)
				_PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
				;;
		esac
		shift
	done
}


if [ -z "$_arg_id" ]
  then
    _arg_id="0"
fi

if [ -z "$_arg_server" ]
  then
    _arg_server="localhost:8545"
fi

if [ -z "$_arg_wallet_from" ]
  then
    _arg_wallet_from="0x6B0c56d1Ad5144b4d37fa6e27DC9afd5C2435c3B"
fi

if [ -z "$_arg_wallet_to" ]
  then
    _arg_wallet_to="0x00E3d1Aa965aAfd61217635E5f99f7c1e567978f"
fi

if [ -z "$_arg_value" ]
  then
    _arg_value="0xde0b6b3a7640000"
fi


if [ -z "$_arg_gas" ]
  then
    _arg_gas="0x76c0"
fi


if [ -z "$_arg_gasPrice" ]
  then
    _arg_gasPrice="0x9184e72a000"
fi


if [ -z "$_arg_data" ]
  then
    _arg_data="0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"
fi

if [ -z "$_arg_nonce" ]
  then
    _arg_nonce="0xde0b6b3a7640000"
fi



# Now call all the functions defined above that are needed to get the job done
parse_commandline "$@"

# echo "Value of --server: $_arg_server"

curl --data '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from":'$_arg_wallet_from',"to":'$_arg_wallet_to',"value":'$_arg_value',"gas":'$_arg_gas',"nonce":'$_arg_nonce'}],"id":'$_arg_id'}' -H "Content-Type: application/json" -X POST $_arg_server