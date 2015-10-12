BASE=print_inter

all: $(BASE).dis 

$(BASE).dis: $(BASE).l
	objdump -D $(BASE).l > $(BASE).dis

$(BASE).o: $(BASE).s
	as $(BASE).s -o $(BASE).o 

$(BASE).l: $(BASE).o 
	ld $(BASE).o -Ttext=0x87100 -o $(BASE).l -emain 
