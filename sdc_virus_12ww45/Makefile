# make sure to set up compiler ars with
#source ~/bin/intel/bin/compilervars.sh intel64
# or
#source /opt/intel/bin/compilervars.sh intel64
CC=icc
B1=SDC_AVF_virus_ww45_serial_delay_nosp

OUT=my_md5

all: $(B1).dis

$(B1).dis: $(B1).l
	objdump -D $(B1).l > $(B1).dis

$(B1).l: $(B1).o
	ld -Ttext 0x6000 -Tdata 0x7000 $(B1).o -o $(B1).l -emain

$(B1).o: $(B1).s
	as $(B1).s -o $(B1).o
