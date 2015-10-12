# 1 "setup_64bit_64.S"
# 1 "<built-in>"
# 1 "<command line>"
# 1 "setup_64bit_64.S"



   .text
   .global main
   .global vacant

.section text

  .org 0x0502c

main64:
 xor %rax, %rax
 mov $0xdeadbeeffeed1234, %rax
 lea (msg_64bit_started+0xe080000), %ecx
 or $0xf0000000, %ecx # because i manually relocate code

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

  clear_mcas:
    # get the bank count:
    mov $0x179, %ecx
    rdmsr
    and $0xff, %eax
    mov %eax, %ebx
    # ebx now has the number of mca banks

    xor %edx, %edx
    xor %eax, %eax
    mov $0x400, %ecx

    clear_mca_bank_loop:
       # base is the CTL bank, so don't clear it.
       inc %ecx
       wrmsr # base + 1
       inc %ecx
       wrmsr # base + 2
       inc %ecx
       wrmsr # base + 3
       inc %ecx # for the next bank
       dec %ebx
       jnz clear_mca_bank_loop

  init_mcas:
    # get the bank count:
    mov $0x179, %ecx
    rdmsr
    and $0xff, %eax
    mov %eax, %ebx
    # ebx now has the number of mca banks

    mov $0xffffffff, %edx
    mov $0xffffffff, %eax
    mov $0x400, %ecx
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
    .ascii "64 bit mode stared.\r\n\0"

.org 0x6000
main:
nop
