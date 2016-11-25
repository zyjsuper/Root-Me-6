#!/bin/bash

WIP=/tmp/arthour
mkdir $WIP
cd $WIP

NAME=test.c
cat >$NAME <<EOF
#include <string.h>
#include <crypt.h>
#include <sys/types.h>
#include <unistd.h>

int main()
{
	char pid[16];
	snprintf(pid, sizeof(pid), "%i", getpid() + 1);
	printf("%s", crypt(pid, "\$1\$awesome"));
	return 0;
}
EOF

gcc $NAME -lcrypt -o test
cd -

./ch21 $($WIP/test)
