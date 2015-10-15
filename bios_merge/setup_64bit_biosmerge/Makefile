BASE=setup_64bit


all: $(BASE).dis 
	echo $(BASE) done
	echo

$(BASE).dis: $(BASE)_32.long_dis $(BASE)_64.long_dis
	awk 'BEGIN {keep=0}; /<placeholder_main>/ {keep=1} ; /e085029/ {keep=0} ; keep==1 {print}' < $(BASE)_32.long_dis > $(BASE).dis
	awk 'BEGIN {keep=0}; /<main64>/ {keep=1} ; /^ e0850d7/ {keep=0} ; keep==1 {print}' < $(BASE)_64.long_dis >> $(BASE).dis
	awk 'BEGIN {keep=0}; /<main>/ {keep=1} ; keep==1 {print}' < $(BASE)_32.long_dis >> $(BASE).dis
#	awk 'BEGIN {keep=0}; /<placeholder_main>/ {keep=1} ; /<main>/ {keep=0} ; keep==1 {print}' < $(BASE)_32.long_dis > $(BASE).dis
#	awk 'BEGIN {keep=0}; /<main64>/ {keep=1} ; /<main>/ {keep=0} ; keep==1 {print}' < $(BASE)_64.long_dis >> $(BASE).dis


$(BASE)_32.long_dis: $(BASE)_32.l
	objdump -z -D $(BASE)_32.l > $(BASE)_32.long_dis


$(BASE)_32.o: $(BASE)_32.S
	gcc  $(BASE)_32.S -o $(BASE)_32.o  -m32

$(BASE)_32.l: $(BASE)_32.o 
	ld -belf32-i386 -T$(BASE)_32.link $(BASE)_32.o -o $(BASE)_32.l 
    
    
#$(BASE)_64.dis: $(BASE)_64.long_dis
#	awk 'BEGIN {keep=0}; /<main64>/ {keep=1} ; keep==1 {print}' < $(BASE)_64.long_dis > $(BASE)_64.dis

$(BASE)_64.o: $(BASE)_64.S
	gcc  $(BASE)_64.S -o $(BASE)_64.o 
    
$(BASE)_64.l: $(BASE)_64.o 
	ld -T$(BASE)_64.link $(BASE)_64.o -o $(BASE)_64.l 

#$(BASE)_64.o: $(BASE)_64.s
#	gcc  $(BASE)_64.s -o $(BASE)_64.o

$(BASE)_64.long_dis: $(BASE)_64.l
	objdump -z -D $(BASE)_64.l > $(BASE)_64.long_dis

clean:
	rm *.o *.l *.dis

