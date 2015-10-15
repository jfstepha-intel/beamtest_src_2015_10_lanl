
# This is the section used before switching over to 64 bit
    .text
   .global main
   .global vacant

.section text

#define MEMOFFSET  0xfff10000
#define ADDR_PML4  0xfef01000
#define ADDR_PDPTE 0xfef02000
#define ADDR_GDT   0xfef02200
#define ADDR_GDT_VAL 0xfef02230
#define ADDR_IDT   0xfef02300
#define ADDR_IDT_VAL 0xfef02240
#define ADDR_INT_HANDLE0 0xfff16641
#define INT_HANDLE_STEP 0x0e
#define STACK_TOP 0xfef3ffff


placeholder_main:
    # this was the old entry
    nop
    nop




  # PDPTE:
  # 0     : Present  (1)
  # 2:1   : reserved (0)
  # 3     : PWT: Page-level write through (0)

  # 4     : PCD: Page-level cache disable (0)
  # 8:5   : reserved (0)
  # 11:0  : ignored
  # X:12  : Physical address of page directory
  
.org 0x6000
main:

	## Get cpuid for the core on which the virus is executing

    # old apic method
	#xor %ebx, %ebx
	#mov $0x01, %eax
	#cpuid                 # id comes out on ebx
	#shr $25, %ebx

    # new apicx2 method
    xor %edx, %edx
	mov $0x0b, %eax
    xor %ecx, %ecx
    cpuid                # id comes out on edx
    mov %edx, %ebx


    mov %ebx, %ecx


    #shl $24, %ecx
    shl $9, %ecx
    add $1, %ecx

	stagger_delay_loop:
	   loop stagger_delay_loop

  set_stackpointer:
    mov $STACK_TOP, %edx
    mov %ebx, %ecx
    shl $10, %ecx
    sub %ecx, %edx
    mov %edx, %esp

    # print stack pointer
    lea (msg_64bit_sp+MEMOFFSET), %ebx
    push %ebx
    call print_string

    push %esp
    call print_hex_dword


    # setup  Page
setup_page_table:
    # print starting message
    lea (msg_64bit_start+MEMOFFSET), %ebx
    push %ebx
    call print_string

    # print cpuid
	xor %ebx, %ebx
	mov $0x01, %eax
	cpuid
#	shr $24, %ebx
	shr $25, %ebx
    push %ebx
    call print_hex_byte

    # set PML4 - entry 0
    mov $ADDR_PML4, %ebp
    mov $ADDR_PDPTE, %edx
    xor %ebx, %ebx
    or $3, %edx           # set present and r/w flags
    mov %edx, (%ebp)
    mov %ebx, 4(%ebp)     # clear upper level bits

    # set PDPTE
    mov $ADDR_PDPTE, %ebp
    mov $0, %edx
    or $0x83, %edx         # set present, r/w and page size flags
    mov $4, %ecx
  pdpte_loop:
    mov %edx, (%ebp)
    mov %ebx, 4(%ebp)     # clear upper level bits

    add $0x40000000, %edx
    add $8, %ebp
    loop pdpte_loop

    mov $4, %ecx
    add $1, %ebx
    cmp $0x10, %ebx
    jne pdpte_loop



switch_64:
    # switch to 64 bit
    # Set EFER NXE=>0, SCE=>1, LME=>1,
    mov $0xc0000080, %ecx  # Read EFER
    rdmsr
    or $0x0101, %eax
    and $0xfffffffffffff7ff, %eax
    wrmsr

    # Set CR4 PSE=>0, PAE=>1,
    mov %cr4, %eax
    or $0x20, %eax
    and $0xffffffffffffffef, %eax
    mov %eax, %cr4

    lea (ADDR_PML4), %eax    # this should be the right way to do it

    and  $0xFFFFF000, %eax   # set PCD=0, PWT=0
    mov %eax, %cr3

    mov %cr0, %eax
    or $0x80000000, %eax
    # this final mov moved to after the jump
    # we need to be in an identically mapped page when we do this write
    mov %eax, %cr0
 
    nop
    nop
    nop
    nop
    nop
    nop

setup_gdt:
    # first GDT entry is unused
    # .quad 0x0000000000000000
    lea (ADDR_GDT), %ebp
    mov $0x00000000, %ecx
    mov %ecx, (%ebp)
    mov $0x00000000, %ecx
    mov %ecx, 4(%ebp)

    # entry #08
    # Code segment
    add $8, %ebp
    # bits 31:16 = base address 15:0
    # bits 15:0 = segment limit 15:0
    mov $0x0000FFFF, %ecx
    mov %ecx, (%ebp)

    # 31:24 = base 31:24
    # 23 = Granularity
    # 22 = default operation size
    # 21 = L = 64 bit code segment
    # 20 = Available for system software
    # 19:16 = Segment limit 19:16
    # 15 = Present
    # 14:13 = Descriptor privledge level
    # 12 = Descriptor type (0 = system, 1 = code or data)
    # 7:0 = Base address 23:16
    mov $0xFFBF9AE0, %ecx
    mov %ecx, 4(%ebp)


    add $8, %ebp
    # .quad 0x000092000000FFFF
    mov $0x0000FFFF, %ecx
    mov %ecx, (%ebp)
    mov $0xFE009208, %ecx
    mov %ecx, 4(%ebp)


    add $8, %ebp
    # .quad 0xfe000b08a000ffff
    mov $0xa000ffff, %ecx
    mov %ecx, (%ebp)
    mov $0xfe000b08, %ecx
    mov %ecx, 4(%ebp)


    add $8, %ebp
    # .quad 0x0000000000000000
    mov $0x00000000, %ecx
    mov %ecx, (%ebp)
    mov $0x00000000, %ecx
    mov %ecx, 4(%ebp)

    # the lgdt seems to only take an indirect value.
    # so we need to put the address of the GDT into memory.
    # I am putting it at ADDR_GDT_VAL

    lea (ADDR_GDT_VAL), %ebp
    # first dword is GDT limit in upper 2 bytes, and lower bytes of address inthe lower two bytes
    mov $ADDR_GDT, %ecx
    and $0x0000ffff, %ecx
    shl $16, %ecx
    or $0x0040, %ecx
    mov %ecx, (%ebp)
    mov $ADDR_GDT, %ecx

    # next dword is upper bytes of address
    add $4, %ebp
    mov $ADDR_GDT, %ecx
    and $0xffff0000, %ecx
    shr $16, %ecx
    mov %ecx, (%ebp)

    # set the GDT base
    lgdt ADDR_GDT_VAL

 setup_idt:

    lea (ADDR_IDT), %ebp
    # bits 15:0  = offset 15:0
    mov $0xfff16641, %ebx #int_handle0
    call idt_sub
    mov $0xfff1664f, %ebx #int_handle1
    call idt_sub
    mov $0xfff1665d, %ebx #int_handle2
    call idt_sub
    mov $0xfff1666b, %ebx #int_handle3
    call idt_sub
    mov $0xfff16679, %ebx #int_handle4
    call idt_sub
    mov $0xfff16687, %ebx #int_handle5
    call idt_sub
    mov $0xfff16695, %ebx #int_handle6
    call idt_sub
    mov $0xfff166a3, %ebx #int_handle7
    call idt_sub
    mov $0xfff166b1, %ebx #int_handle8
    call idt_sub
    mov $0xfff166bd, %ebx #int_handle9
    call idt_sub
    mov $0xfff166cb, %ebx #int_handle10
    call idt_sub
    mov $0xfff166d7, %ebx #int_handle11
    call idt_sub
    mov $0xfff166e3, %ebx #int_handle12
    call idt_sub
    mov $0xfff166ef, %ebx #int_handle13
    call idt_sub
    mov $0xfff166fb, %ebx #int_handle14
    call idt_sub
    mov $0xfff16707, %ebx #int_handle15
    call idt_sub
    mov $0xfff16715, %ebx #int_handle16
    call idt_sub
    mov $0xfff16723, %ebx #int_handle17
    call idt_sub
    mov $0xfff1672f, %ebx #int_handle18
    call idt_sub
    mov $0xfff1673d, %ebx #int_handle19
    call idt_sub
    mov $0xfff1674b, %ebx #int_handle32
    jmp idt_set_bas_lim

  idt_sub:

    mov %ebx, %edx
    and $0xffff, %edx
    # bits 31:16 = segment selector
    or $0x00080000, %edx
    mov %edx, (%ebp)

    # bits 31:16 = offset 31:16
    mov %ebx, %edx
    and $0xffff0000, %edx
    or $0x8e00, %edx
    mov %edx, 4(%ebp)

    # offset 63:32
    xor %edx, %edx
    mov %edx, 8(%ebp)
    mov %edx, 12(%ebp)

    add $16, %ebp
    ret

  idt_set_bas_lim:


    # ###  set IDTBAS and IDTLIM
    lea (ADDR_IDT_VAL), %ebp
    # first dword is IDT limit in upper 2 bytes, and lower bytes of address inthe lower two bytes
    mov $ADDR_IDT, %ecx
    and $0x0000ffff, %ecx
    shl $16, %ecx
    or $0x0200, %ecx
    mov %ecx, (%ebp)
    mov $ADDR_IDT, %ecx

    # next dword is upper bytes of address
    add $4, %ebp
    mov $ADDR_IDT, %ecx
    and $0xffff0000, %ecx
    shr $16, %ecx
    mov %ecx, (%ebp)

    lidt ADDR_IDT_VAL

    nop

    # this long jump puts us into 64 bit mode
    ljmp $0x08, $(main_long_jump+0xfff10000)
    nop

main_long_jump:
    nop

    jmp main64
    # we should never get here

main_end:
    jmp main_end


############################
### Print String
############################

print_string:
    push %ebp          # save the old base pointer value
    mov %esp, %ebp     # set the new base pointer value

    mov 8(%ebp), %ecx       # parameter: address of the string to be printed

    # subroutine body
print_string_loop:
    mov (%ecx), %al
    cmp $0, %al
    je print_string_proc_end

    push %eax
    call print_char
    add $4, %esp

    inc %ecx
    jmp print_string_loop

print_string_proc_end:
    # subroutine Epilogue
    mov %ebp, %esp     # deallocate
    pop %ebp           # restore callers base pointer
    ret
#######################################
### Print Char
#######################################

print_char:
    push %ebp             # save the old base pointer
    mov %esp, %ebp        # set the new base pointer value

    push %ebx             # save ebx

    mov 8(%ebp), %ebx    # parameter: char to print

    # subroutine body
    ser_poll1:
       mov $0x3fd, %edx     # address of serial port status
       in %dx, %al          # get serial port status
       test $0x20, %al      # test to see if it is ready
       jz ser_poll1

       xchg %ebx, %eax      # get character into al
       mov $0x3f8, %edx     # address of serial port
       out %al, %dx         # send character out

       # subroutine Epilogue
       pop %ebx

       mov %ebp, %esp       # deallocate
       pop %ebp             # restore caller base pointer
       ret

##########################
###### print hex nibble
##########################
    print_hex_nibble:
        # subroutine prologue
        push %ebp
        mov %esp, %ebp
        mov 8(%ebp), %eax

        # subroutine body
        and $0xf, %eax           # do only lower nibble
        cmp $0x9, %al            # if value is > 0,
        jg print_hex_nibble_gt9  # jump
        add $0x30, %al           # if value is 9 or less, add 0x30)
        jmp print_hex_nibble_skip
    print_hex_nibble_gt9:
        add $0x37, %al
    print_hex_nibble_skip:
        push %eax
        call print_char
        add $4, %esp
    # subroutine epilogue
    mov %ebp, %esp
    pop %ebp
    ret

##########################
###### print hex byte
##########################
    print_hex_byte:
        # subroutine prologue
        push %ebp
        mov %esp, %ebp
        push %ebx

        mov 8(%ebp), %ebx

        # subroutine body
        shr $4, %ebx
        push %ebx
        call print_hex_nibble
        sub $4, %esp

        mov 8(%ebp), %ebx
        push %ebx
        call print_hex_nibble
        sub $4, %esp

        # subroutine epilogue
        pop %ebx
        mov %ebp, %esp
        pop %ebp
        ret

##########################
###### print hex word
##########################
    print_hex_word:
        # subroutine prologue
        push %ebp
        mov %esp, %ebp

        push %ebx

        mov 8(%ebp), %ebx

        # subroutine body
        shr $8, %ebx
        push %ebx
        call print_hex_byte
        sub $4, %esp

        mov 8(%ebp), %ebx
        push %ebx
        call print_hex_byte
        sub $4, %esp

        # subroutine epilogue
        pop %ebx
        mov %ebp, %esp
        pop %ebp
        ret
##########################
###### print hex dword
##########################
    print_hex_dword:
        # subroutine prologue
        push %ebp
        mov %esp, %ebp
        mov 8(%ebp), %ebx

        push %ebx

        # subroutine body
        shr $16, %ebx
        push %ebx
        call print_hex_word
        sub $4, %esp

        mov 8(%ebp), %ebx
        push %ebx
        call print_hex_word
        sub $4, %esp

        # subroutine epilogue
        pop %ebx
        mov %ebp, %esp
        pop %ebp
        ret

##########################
###### print hex qword
##########################
    print_hex_qword:
        # subroutine prologue
        push %ebp
        mov %esp, %ebp

        push %ebx

        mov 8(%ebp), %ebx

        # subroutine body
        shr $32, %ebx
        push %ebx
        call print_hex_dword
        sub $4, %esp

        mov 8(%ebp), %ebx
        push %ebx
        call print_hex_dword
        sub $4, %esp

        # subroutine epilogue
        pop %ebx
        mov %ebp, %esp
        pop %ebp
        ret

msg_64bit_start:  .ascii " Switching to 64bit cpuid: \0"
msg_64bit_sp:  .ascii "SP: 0x\0"
msg_64bit_done:  .ascii " done. \r\n\0"


  .org 0x06400
main64:

