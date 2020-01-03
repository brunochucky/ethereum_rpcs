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
	local first_option all_short_options='idtsh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}
_arg_server=
_arg_id=
_arg_data=
_arg_tag=
print_help()
{
	printf '%s\n' "Ethereum JSON RPC API"
	printf 'Usage: %s [-i|--id <arg>] [-s|--server <arg>] [-d|--data <arg>] [-t|--tag <arg>] [-h|--help]\n' "$0"
	printf '\t%s\n' "-i, --id: optional argument (1)"
	printf '\t%s\n' "-d, --data: optional argument (0xc94770007dda54cF92009BFF0dE90c06F603a09f)"
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


if [ -z "$_arg_id" ]
  then
    _arg_id="1"
fi

if [ -z "$_arg_data" ]
  then
    _arg_data="0xc94770007dda54cF92009BFF0dE90c06F603a09f"
fi

if [ -z "$_arg_tag" ]
  then
    _arg_data="latest"
fi


if [ -z "$_arg_server" ]
  then
    _arg_server="localhost:8545"
fi

# Now call all the functions defined above that are needed to get the job done
parse_commandline "$@"

# echo "Value of --id: $_arg_id"

curl --data '{"jsonrpc":"2.0","method":"eth_getCode","params":["'$_arg_data'","'$_arg_tag'"],"id":'$_arg_id'}' -X POST $_arg_server