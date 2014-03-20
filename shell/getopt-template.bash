#!/bin/bash

TEMP=`getopt -o at:c: --long all,dry,targets:,command: -n 'getopt-template.bash' -- "$@"`
if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi
eval set -- "$TEMP"

while true ; do
  case "$1" in
    -a|--all)
      opt_a=1 ; shift
      ;;

    -t|--targets)
      opt_t=1
      arg_t=$2
      if [ "$2" == "--" ] ; then echo "$0: option requires an argument -- '$1'" ; exit 1 ; fi # catch if, mandantory argument missing before --
      if [ "$2" != "--" ] ; then shift 2 ; else shift 1 ; fi # shift only one if -- follows
      ;;

    -c|--command)
      opt_c=1
      arg_c=$2
      if [ "$2" == "--" ] ; then echo "$0: option requires an argument -- '$1'" ; exit 1 ; fi # catch if, mandantory argument missing before --
      if [ "$2" != "--" ] ; then shift 2 ; else shift 1 ; fi # shift only one if -- follows
      ;;

    --dry)
      opt_dry=1 ; shift
      ;;

    --)
      shift
      break
      ;;

    *)
      echo "Internal error!"
      exit 1
      ;;

  esac
done

# take cmd variable either from getopt-parsed argument or from leftover arguments
if [ ! "$opt_c" ] ; then for arg do cmd="$cmd $arg" ; done ; else cmd=$arg_c ; fi

# check given options sense.
# -a and -t conflict
if [ "$opt_a" ] && [ "$opt_t" ] ; then echo Options -a and -t both are given. ;exit ; fi


if [ $opt_dry ] ; then
  #dry run
  echo $cmd
else
  echo I would now do stuff.
fi
