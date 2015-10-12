BASE=stupid

all: $(BASE).dis $(BASE).exe

$(BASE)_long.dis: $(BASE).l
	objdump -z -D $(BASE).l > $(BASE)_long.dis

$(BASE).l: $(BASE).o 
	ld --section-start .interp=0x0b000 $(BASE).o -o $(BASE).l -emain 

$(BASE).o: $(BASE).c
	icc $(BASE).c -o $(BASE).o  -DDML

$(BASE).exe: $(BASE).c
	icc $(BASE).c -o $(BASE).exe 

$(BASE).dis: $(BASE)_long.dis
	sed '/__intel_proc_init/,$$d' $(BASE)_long.dis > $(BASE).dis
