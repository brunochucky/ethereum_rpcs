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
	local first_option all_short_options='sftvh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}
_arg_server=
_arg_wallet_from=
_arg_wallet_to=
_arg_value=
print_help()
{
	printf '%s\n' "Bash rpcs for Ethereum"
	printf 'Usage: %s [-s|--server <arg>] [-f|--wallet_from <arg>] [-t|--wallet_to <arg>] [-v|--value <arg>] [-h|--help]\n' "$0"
	printf '\t%s\n' "-s, --server: optional argument (localhost:8545)"
	printf '\t%s\n' "-f, --wallet_from: optional argument (0x6B0c56d1Ad5144b4d37fa6e27DC9afd5C2435c3B)"
	printf '\t%s\n' "-t, --wallet_to: optional argument (0x00E3d1Aa965aAfd61217635E5f99f7c1e567978f)"
	printf '\t%s\n' "-v, --value: optional argument (0xde0b6b3a7640000)"
	printf '\t%s\n' "-h, --help: Prints help"
}
parse_commandline()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
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



# Now call all the functions defined above that are needed to get the job done
parse_commandline "$@"

#echo "Value of --server: $_arg_server"
#echo "Value of --wallet_from: $_arg_wallet_from"
#echo "Value of --wallet_to: $_arg_wallet_to"
#echo "Value of --value: $_arg_value"

curl --data '{"jsonrpc":"2.0","method":"personal_sendTransaction","params":[{"from":'$_arg_wallet_from',"to":'$_arg_wallet_to',"value":'$_arg_value'}, ""],"id":0}' -H "Content-Type: application/json" -X POST $_arg_server