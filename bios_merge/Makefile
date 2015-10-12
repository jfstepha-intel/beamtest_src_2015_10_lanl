B32=setup_64bit_32
B64=setup_64bit_64
BINT=print_inter
BWL1=lattice_64bit_hacked
BWL2=md5sum
BWL3=SDC_AVF_virus_14ww24_nolib
BWL4=SDC_AVF_virus_14ww25_nolib
BWL5=nop_nolib
BBASE=serbios_15ww41.6r4.bin
OO1=BIOS_MERGED_tmp.bin
OO2=BIOS_MERGED_tmp2.bin
OO3=BIOS_MERGED_tmp3.bin
OO4=BIOS_MERGED_tmp5.bin
OO5=BIOS_MERGED_tmp6.bin
OO6=BIOS_MERGED_tmp7.bin
OO7=BIOS_MERGED_tmp8.bin
OO8=BIOS_MERGED.bin
L="init"

INSPT_32=0xf10000
INSPT_64=0xf16400
INSPT_INT=0xf16500
INSPT_WL1=0xf17000
INSPT_WL2=0xf18000
INSPT_WL3=0xf19000
INSPT_WL4=0xf1a000
INSPT_WL5=0xf1b000

# old:
#INSPT_32=0xe00000
#INSPT_64=0xe06400
#INSPT_INT=0xe06500
#INSPT_WL1=0xe07000
#INSPT_WL2=0xe08000
#INSPT_WL3=0xe09000
#INSPT_WL4=0xe0a000

all: $(OO8)

$(B32).o: setup_64bit_biosmerge/$(B32).S
	cd setup_64bit_biosmerge && $(MAKE)

$(B64).o: setup_64bit_biosmerge/$(B64).S
	cd setup_64bit_biosmerge && $(MAKE)

$(BINT).o: interrupt_print/$(BINT).s
	cd interrupt_print && $(MAKE)

$(BWL1).o: ../lattice/$(BWL1).s
	cd ../interrupt_print && $(MAKE)
	
$(BWL2).o: ../md5sum_asm/$(BWL2).S
	cd ../md5sum_asm && $(MAKE)

$(BWL3).o: sdc_virus_14ww24/SDC_AVF_virus_14ww24.S
	cd sdc_virus_14ww24 && $(MAKE)
	
$(BWL4).o: sdc_virus_14ww25/SDC_AVF_virus_14ww25.S
	cd sdc_virus_14ww25 && $(MAKE)

$(BWL5).o: nop/nop.S
	cd nop && $(MAKE)

########### setup_64bit_32 #############################

$(B32).elflist: $(B32).o
	readelf -S $< > $@

$(B32)_text.bin: $(B32).o $(B32).elflist
	OFFSET=`grep ' text ' $(B32).elflist | tr -s ' ' | cut -d ' ' -f 6` ;\
	SIZE=`grep ' text ' $(B32).elflist | tr -s ' ' | cut -d ' ' -f 7` ;\
	echo OFFSET=$$OFFSET size=$$SIZE ;\
	echo $$OFFSET > $(B32)_offset.txt ;\
	echo $$SIZE > $(B32)_size.txt ;\
	dd if=$(B32).o of=$(B32)_text.bin skip=$$((0x$$OFFSET)) count=$$((0x$$SIZE)) bs=1

$(OO1): $(B32)_text.bin
	dd if=$(BBASE) of=$(OO1) count=$$(($(INSPT_32))) bs=1
	dd if=$(B32)_text.bin of=$(OO1) oflag=append conv=notrunc
	dd if=$(BBASE) of=$(OO1) oflag=append conv=notrunc skip=$$(($(INSPT_32)+0x`cat $(B32)_size.txt`)) bs=1
	
########### setup_64bit_64 #############################

$(B64).elflist: $(B64).o
	readelf -SW $< > $@

$(B64)_text.bin: $(B64).o $(B64).elflist
	OFFSET=`grep ' text ' $(B64).elflist | tr -s ' ' | cut -d ' ' -f 6` ;\
	SIZE=`grep ' text ' $(B64).elflist | tr -s ' ' | cut -d ' ' -f 7` ;\
	echo OFFSET=$$OFFSET size=$$SIZE ;\
	echo $$OFFSET > $(B64)_offset.txt ;\
	echo $$SIZE > $(B64)_size.txt ;\
	dd if=$(B64).o of=$(B64)_text.bin skip=$$((0x$$OFFSET)) count=$$((0x$$SIZE)) bs=1

$(OO2): $(B64)_text.bin $(OO1)
	dd if=$(OO1) of=$(OO2) count=$$(($(INSPT_64))) bs=1
	dd if=$(B64)_text.bin of=$(OO2) oflag=append conv=notrunc
	dd if=$(BBASE) of=$(OO2) oflag=append conv=notrunc skip=$$(($(INSPT_64)+0x`cat $(B64)_size.txt`)) bs=1
	
############# Interrupt_print ###########################

$(BINT).elflist: $(BINT).o
	readelf -SW $< > $@

$(BINT)_text.bin: $(BINT).o $(BINT).elflist
	OFFSET=`grep ' text ' $(BINT).elflist | tr -s ' ' | cut -d ' ' -f 7` ;\
	SIZE=`grep ' text ' $(BINT).elflist | tr -s ' ' | cut -d ' ' -f 8` ;\
	echo OFFSET=$$OFFSET size=$$SIZE ;\
	echo $$OFFSET > $(BINT)_offset.txt ;\
	echo $$SIZE > $(BINT)_size.txt ;\
	dd if=$(BINT).o of=$(BINT)_text.bin skip=$$((0x$$OFFSET)) count=$$((0x$$SIZE)) bs=1

$(OO3): $(BINT)_text.bin $(OO2)
	dd if=$(OO2) of=$(OO3) count=$$(($(INSPT_INT))) bs=1
	dd if=$(BINT)_text.bin of=$(OO3) oflag=append conv=notrunc
	dd if=$(BBASE) of=$(OO3) oflag=append conv=notrunc skip=$$(($(INSPT_INT)+0x`cat $(BINT)_size.txt`)) bs=1

############# lattice ###########################

$(BWL1).elflist: $(BWL1).o
	readelf -SW $< > $@

$(BWL1)_text.bin: $(BWL1).o $(BWL1).elflist
	OFFSET=`grep ' .text ' $(BWL1).elflist | tr -s ' ' | cut -d ' ' -f 6` ;\
	SIZE=`grep ' .text ' $(BWL1).elflist | tr -s ' ' | cut -d ' ' -f 7` ;\
	echo OFFSET=$$OFFSET size=$$SIZE ;\
	echo $$OFFSET > $(BWL1)_offset.txt ;\
	echo $$SIZE > $(BWL1)_size.txt ;\
	dd if=$(BWL1).o of=$(BWL1)_text.bin skip=$$((0x$$OFFSET)) count=$$((0x$$SIZE)) bs=1

$(OO4): $(BWL1)_text.bin $(OO3)
	dd if=$(OO3) of=$(OO4) count=$$(($(INSPT_WL1))) bs=1
	dd if=$(BWL1)_text.bin of=$(OO4) oflag=append conv=notrunc
	dd if=$(BBASE) of=$(OO4) oflag=append conv=notrunc skip=$$(($(INSPT_WL1)+0x`cat $(BWL1)_size.txt`)) bs=1

############# md5sum ###########################

$(BWL2).elflist: $(BWL2).o
	readelf -SW $< > $@

$(BWL2)_text.bin: $(BWL2).o $(BWL2).elflist
	OFFSET=`grep ' .text ' $(BWL2).elflist | tr -s ' ' | cut -d ' ' -f 6` ;\
	SIZE=`grep ' .text ' $(BWL2).elflist | tr -s ' ' | cut -d ' ' -f 7` ;\
	echo OFFSET=$$OFFSET size=$$SIZE ;\
	echo $$OFFSET > $(BWL2)_offset.txt ;\
	echo $$SIZE > $(BWL2)_size.txt ;\
	dd if=$(BWL2).o of=$(BWL2)_text.bin skip=$$((0x$$OFFSET)) count=$$((0x$$SIZE)) bs=1

$(OO5): $(BWL2)_text.bin $(OO4)
	dd if=$(OO4) of=$(OO5) count=$$(($(INSPT_WL2))) bs=1
	dd if=$(BWL2)_text.bin of=$(OO5) oflag=append conv=notrunc
	dd if=$(BBASE) of=$(OO5) oflag=append conv=notrunc skip=$$(($(INSPT_WL2)+0x`cat $(BWL2)_size.txt`)) bs=1

############# SDC virus 14ww24 ###########################

$(BWL3).elflist: $(BWL3).o
	readelf -SW $< > $@

$(BWL3)_text.bin: $(BWL3).o $(BWL3).elflist
	OFFSET=`grep ' .text ' $(BWL3).elflist | tr -s ' ' | cut -d ' ' -f 7` ;\
	SIZE=`grep ' .text ' $(BWL3).elflist | tr -s ' ' | cut -d ' ' -f 8` ;\
	echo OFFSET=$$((0x$$OFFSET+0x6000)) size=$$((0x$$SIZE-0x6000)) ;\
	echo $$((0x$$OFFSET+0x6000)) > $(BWL3)_offset.txt ;\
	echo $$((0x$$SIZE-0x6000)) > $(BWL3)_size.txt ;\
	dd if=$(BWL3).o of=$(BWL3)_text.bin skip=$$((0x$$OFFSET+0x6000)) count=$$((0x$$SIZE-0x6000)) bs=1

$(OO6): $(BWL3)_text.bin $(OO5)
	dd if=$(OO5) of=$(OO6) count=$$(($(INSPT_WL3))) bs=1
	dd if=$(BWL3)_text.bin of=$(OO6) oflag=append conv=notrunc
	dd if=$(BBASE) of=$(OO6) oflag=append conv=notrunc skip=$$(($(INSPT_WL3)+`cat $(BWL3)_size.txt`)) bs=1

############# SDC virus 14ww24 ###########################

$(BWL4).elflist: $(BWL4).o
	readelf -SW $< > $@

$(BWL4)_text.bin: $(BWL4).o $(BWL4).elflist
	OFFSET=`grep ' .text ' $(BWL4).elflist | tr -s ' ' | cut -d ' ' -f 7` ;\
	SIZE=`grep ' .text ' $(BWL4).elflist | tr -s ' ' | cut -d ' ' -f 8` ;\
	echo OFFSET=$$((0x$$OFFSET+0x6000)) size=$$((0x$$SIZE-0x6000)) ;\
	echo $$((0x$$OFFSET+0x6000)) > $(BWL4)_offset.txt ;\
	echo $$((0x$$SIZE-0x6000)) > $(BWL4)_size.txt ;\
	dd if=$(BWL4).o of=$(BWL4)_text.bin skip=$$((0x$$OFFSET+0x6000)) count=$$((0x$$SIZE-0x6000)) bs=1

$(OO7): $(BWL4)_text.bin $(OO6)
	dd if=$(OO6) of=$(OO7) count=$$(($(INSPT_WL4))) bs=1
	dd if=$(BWL4)_text.bin of=$(OO7) oflag=append conv=notrunc
	dd if=$(BBASE) of=$(OO7) oflag=append conv=notrunc skip=$$(($(INSPT_WL4)+`cat $(BWL4)_size.txt`)) bs=1

############# nop ###########################

$(BWL5).elflist: $(BWL5).o
	readelf -SW $< > $@

$(BWL5)_text.bin: $(BWL5).o $(BWL5).elflist
	OFFSET=`grep ' .text ' $(BWL5).elflist | tr -s ' ' | cut -d ' ' -f 7` ;\
	SIZE=`grep ' .text ' $(BWL5).elflist | tr -s ' ' | cut -d ' ' -f 8` ;\
	echo OFFSET=$$((0x$$OFFSET+0x6000)) size=$$((0x$$SIZE-0x6000)) ;\
	echo $$((0x$$OFFSET+0x6000)) > $(BWL5)_offset.txt ;\
	echo $$((0x$$SIZE-0x6000)) > $(BWL5)_size.txt ;\
	dd if=$(BWL5).o of=$(BWL5)_text.bin skip=$$((0x$$OFFSET+0x6000)) count=$$((0x$$SIZE-0x6000)) bs=1

$(OO8): $(BWL5)_text.bin $(OO7)
	dd if=$(OO7) of=$(OO8) count=$$(($(INSPT_WL5))) bs=1
	dd if=$(BWL5)_text.bin of=$(OO8) oflag=append conv=notrunc
	dd if=$(BBASE) of=$(OO8) oflag=append conv=notrunc skip=$$(($(INSPT_WL5)+`cat $(BWL5)_size.txt`)) bs=1

clean:
	rm -f BIOS_MERGED*.bin
	rm -f *.elflist
	rm -f *_size.txt
	rm -f *_offset.txt
	rm -f *_text.bin
