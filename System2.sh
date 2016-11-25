#!/bin/bash

WIP=/tmp/artour
mkdir $WIP
cd $WIP

NAME=test.c
cat >$NAME <<EOF
#include <fcntl.h>
#include <unistd.h>

int main(int ac, char **av)
{
	int fd = open (av[2], O_RDONLY);
	char buf[512];
	int size = read(fd, buf, sizeof(buf));
	write(1, buf, size);
	return 0;
}
EOF
gcc $NAME -o ls
cd -
PATH=$WIP ./ch12
