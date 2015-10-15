#define MSR_IA32_MCG_CAP 0x179 
#define MSR_MCi_CTL_BASE 0x400
#define MEMOFFSET  0xff16400
#define IDTBAS 0xfe082300

#define ADDR_IDT   0xfe082300
#define ADDR_IDT_VAL 0xfe082240

#define ADDR_INT_HANLDER 0xfe

   .text
   .global main
   .global vacant

  .org 0x06400
.section text


main64:
 xor %rax, %rax
 mov $0xdeadbeeffeed1234, %rax
 lea (msg_64bit_started+MEMOFFSET), %ecx
 or $0xf0000000, %ecx    # for some reason I cannot make MEMOFFSET this big like i'd like

  print_string_ser_poll:
    mov $0x3fd, %edx
    in %dx, %al
    test $0x20, %al
    jz print_string_ser_poll
    mov (%ecx), %al
    mov $0x3f8, %edx
    out %al, %dx
    inc %ecx
    mov (%ecx), %al
    test %al, %al
    jnz print_string_ser_poll
    nop

  endloop4:
    jmp endloop4    # do not do MCAs in this code

  clear_mcas:
    # get the bank count:
    mov $MSR_IA32_MCG_CAP, %ecx
    rdmsr
    and $0xff, %eax
    mov %eax, %ebx
    # ebx now has the number of mca banks
    
    xor %edx, %edx
    xor %eax, %eax
    mov $MSR_MCi_CTL_BASE, %ecx
    
    clear_mca_bank_loop:
       # base is the CTL bank, so don't clear it.
       inc %ecx
       wrmsr  # base + 1
       inc %ecx
       wrmsr  # base + 2
       inc %ecx
       wrmsr  # base + 3
       inc %ecx # for the next bank
       dec %ebx
       jnz clear_mca_bank_loop
 
  init_mcas:
    # get the bank count:
    mov $MSR_IA32_MCG_CAP, %ecx
    rdmsr
    and $0xff, %eax
    mov %eax, %ebx
    # ebx now has the number of mca banks
   
    mov $0xffffffff, %edx
    mov $0xffffffff, %eax
    mov $MSR_MCi_CTL_BASE, %ecx
    init_mca_bank_loop:
       wrmsr
       add $4, %ecx
       dec %ebx
       jnz init_mca_bank_loop

    # set bit 6 of cr4
    mov %cr4, %rax
    or $0x40, %eax
    mov %rax, %cr4

    
endloop3:
 jmp endloop3

msg_64bit_started:
    .ascii " - 64 bit mode started.\r\n\0"

main:
nop
