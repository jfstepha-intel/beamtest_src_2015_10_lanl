BASE=print_inter

all: $(BASE).dis 

$(BASE).dis: $(BASE).l
	objdump -D $(BASE).l > $(BASE).dis

$(BASE).o: $(BASE).S
	gcc $(BASE).S -o $(BASE).o -nostdlib

$(BASE).l: $(BASE).o 
	ld -T$(BASE).link $(BASE).o -o $(BASE).l -emain  -nostdlib
