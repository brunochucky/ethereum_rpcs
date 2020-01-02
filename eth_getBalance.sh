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
	local first_option all_short_options='wtsh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}
_arg_server=
_arg_wallet=
_arg_tag=
print_help()
{
	printf '%s\n' "Ethereum JSON RPC API"
	printf 'Usage: %s [-w|--wallet <arg>] [-t|--tag <arg>] [-s|--server <arg>] [-h|--help]\n' "$0"
	printf '\t%s\n' "-w, --wallet: optional argument (0x00E3d1Aa965aAfd61217635E5f99f7c1e567978f)"
	printf '\t%s\n' "-t, --tag: optional argument (latest)"
	printf '\t%s\n' "-s, --server: optional argument (localhost:8545)"
	printf '\t%s\n' "-h, --help: Prints help"
}
parse_commandline()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-w|--wallet)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_wallet="$2"
				shift
				;;
			--wallet=*)
				_arg_wallet="${_key##--wallet=}"
				;;
			-w*)
				_arg_wallet="${_key##-w}"
				;;
			-t|--tag)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_tag="$2"
				shift
				;;
			--tag=*)
				_arg_tag="${_key##--tag=}"
				;;
			-t*)
				_arg_tag="${_key##-t}"
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


if [ -z "$_arg_wallet" ]
  then
    _arg_wallet="0x00E3d1Aa965aAfd61217635E5f99f7c1e567978f"
fi

if [ -z "$_arg_tag" ]
  then
    _arg_tag="latest"
fi

if [ -z "$_arg_server" ]
  then
    _arg_server="localhost:8545"
fi

# Now call all the functions defined above that are needed to get the job done
parse_commandline "$@"

#echo "Value of --wallet: $_arg_wallet"
#echo "Value of --tag: $_arg_tag"
#echo "Value of --server: $_arg_server"

curl --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["'$_arg_wallet'", "'$_arg_tag'"],"id":1}' -X POST $_arg_server