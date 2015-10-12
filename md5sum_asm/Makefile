# make sure to set up compiler ars with
#source ~/bin/intel/bin/compilervars.sh intel64
# or
#source /opt/intel/bin/compilervars.sh intel64
CC=icc
BASE=md5sum

all: md5sum.dis md5test md5test.dis md5test_noouter md5test_short md5sum.o $(BASE)_noprint.out $(BASE)_serprint.o

%.long_dis: %.l
	objdump -D $< > $@

md5test.dis: md5test
	objdump -D $< > $@

%.l: %.o
	ld -Ttext  0xb000 --section-start .interp=0x01000 $< -o $@ -emain

%.o: %.S
	icc $^ -o $@ -DBINPRINT

%.dis: %.long_dis
	sed '/.interp/,$$d' $< > $@

md5test_orig: md5test.c md5sum_original.S
	$(CC) $^ -o $@

md5test: md5test.c md5sum.S
	$(CC) $^ -o $@ -DFORC -DBIOSPRINT

md5test_noouter: md5test.c md5sum.S
	$(CC) $^ -o $@ -DFORC -DNOPRINT -DOUTERLOOPS=1 -DNODELAY -DBIOSEXIT

md5test_short: md5test.c md5sum.S
	$(CC) $^ -o $@ -DFORC -DNOPRINT -DOUTERLOOPS=100 -DNODELAY -DBIOSEXIT

$(BASE)_noprint.out: $(BASE)_noprint.o
	ld -N -Ttext 0 -melf_x86_64 crt1_fish.64.o $(BASE)_noprint.o -o $(BASE)_noprint.out

$(BASE)_noprint.o: $(BASE).S
	$(CC) $(BASE).S -o $(BASE)_noprint.o -DNOPRINT -DNODELAY -DOUTERLOOPS=10000 -DBIOSEXIT -DINNERLOOPS=10000 -nostartfiles

$(BASE)_serprint.o: $(BASE).S
	$(CC) $(BASE).S -o $(BASE)_serprint.o -DSERPRINT -DNODELAY 
