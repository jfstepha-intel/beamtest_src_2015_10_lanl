# make sure to set up compiler ars with
#source ~/bin/intel/bin/compilervars.sh intel64
# or
#source /opt/intel/bin/compilervars.sh intel64
CC=icc
BASE=SDC_AVF_virus_14ww25

all: $(BASE).dis $(BASE)_biosprint $(BASE)_noprint.dis $(BASE)_noprint.out $(BASE)_nolib.o

$(BASE).dis: $(BASE).long_dis
	sed '/.interp/,$$d' $(BASE).long_dis | sed 's/50 \tlea    0x50/00    lea    0x00/' > $(BASE).dis
	awk 'BEGIN {v=0}; /<main>/ {v=1} ; /__libc_csu_fini/ {v=0} ; /<__data_start>/ {v=1} ; /<__dso_handle>/ {v=0} ; v==1 {print}' < $(BASE).long_dis | sed 's/50 \tlea    0x50/00    lea    0x00/' > $(BASE).dis

$(BASE).long_dis: $(BASE).l
	objdump -D $(BASE).l > $(BASE).long_dis

$(BASE).l: $(BASE).o
	ld -Ttext 0xb000 -Tdata 0x20000 --section-start .interp=0x1000 $(BASE).o -o $(BASE).l -emain
	#ld -Ttext 0xb000 --section-start .interp=0x1000 --section-start .data=0xb900 $(BASE).o -o $(BASE).l -emain 

$(BASE).o: $(BASE).S
	$(CC) $(BASE).S -o $(BASE).o  -DBINPRINT

$(BASE)_nolib.o: $(BASE).S
	$(CC) $(BASE).S -o $(BASE)_nolib.o  -DBINPRINT -nostdlib

$(BASE)_biosprint: $(BASE).S
	$(CC) $(BASE).S -o $(BASE)_biosprint -DBIOSPRINT -DBIOSEXIT

$(BASE)_noprint.o: $(BASE).S
	$(CC) $(BASE).S -o $(BASE)_noprint.o -DNOPRINT -DNODELAY -DOUTERLOOPS=100 -DBIOSEXIT -DINNERLOOPS=1000 -nostartfiles

$(BASE)_noprint.dis: $(BASE)_noprint.out
	objdump -D $(BASE)_noprint.out > $(BASE)_noprint.dis

$(BASE)_noprint.out: $(BASE)_noprint.o
	ld -N -Ttext 0 -melf_x86_64 crt1_fish.64.o $(BASE)_noprint.o -o $(BASE)_noprint.out
