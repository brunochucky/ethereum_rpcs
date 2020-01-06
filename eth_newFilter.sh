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
	local first_option all_short_options='iftadsh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}
_arg_server=
_arg_id=
_arg_from=
_arg_to=
_arg_address=
_arg_topics=
print_help()
{
	printf '%s\n' "Ethereum JSON RPC API"
	printf 'Usage: %s [-i|--id <arg>] [-s|--server <arg>] [-f|--from <arg>] [-t|--to <arg>] [-a|--adddres <arg>] [-d|--topics <arg>] [-h|--help]\n' "$0"
	printf '\t%s\n' "-i, --id: optional argument (73)"
	printf '\t%s\n' "-f, --from: optional argument (0x1)"
	printf '\t%s\n' "-t, --to: optional argument (0x2)"
	printf '\t%s\n' "-a, --address: optional argument (0x8888f1f195afa192cfee860698584c030f4c9db1)"
	printf '\t%s\n' "-d, --topics: optional argument ([“0x0000000000000000000000000000000000000000000000000000000012341234”])"
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

			-f|--from)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_from="$2"
				shift
				;;
			--from=*)
				_arg_from="${_key##--from=}"
				;;
			-f*)
				_arg_from="${_key##-f}"
				;;


			-t|--to)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_to="$2"
				shift
				;;
			--to=*)
				_arg_to="${_key##--to=}"
				;;
			-t*)
				_arg_to="${_key##-t}"
				;;

			-a|--address)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_address="$2"
				shift
				;;
			--address=*)
				_arg_address="${_key##--address=}"
				;;
			-a*)
				_arg_address="${_key##-a}"
				;;

			-d|--topics)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_topics="$2"
				shift
				;;
			--topics=*)
				_arg_topics="${_key##--topics=}"
				;;
			-d*)
				_arg_topics="${_key##-d}"
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
    _arg_id="73"
fi

if [ -z "$_arg_from" ]
  then
    _arg_from="0x1"
fi


if [ -z "$_arg_to" ]
  then
    _arg_to="0x2"
fi


if [ -z "$_arg_address" ]
  then
    _arg_to="0x8888f1f195afa192cfee860698584c030f4c9db1"
fi


if [ -z "$_arg_topics" ]
  then
    _arg_to="["0x0000000000000000000000000000000000000000000000000000000012341234"]"
fi


if [ -z "$_arg_server" ]
  then
    _arg_server="localhost:8545"
fi

# Now call all the functions defined above that are needed to get the job done
parse_commandline "$@"

# echo "Value of --id: $_arg_id"

curl --data '{"jsonrpc":"2.0","method":"eth_newFilter","params":[{"fromBlock": "'_arg_from'","toBlock": "'_arg_to'","address": "'_arg_address'","topics": '_arg_topics'}],"id":'$_arg_id'}' -X POST $_arg_server