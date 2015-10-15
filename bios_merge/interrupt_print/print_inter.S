#define MEMOFFSET  0xfff16500
   .text
   .global main 

   .org 0x6500
   .section text
call_test:
    nop
    nop
    call subrout
    nop
    nop
    jmp call_test

subrout:
    nop
    ret

int_handle_return:
    cli
    sti
    iretq
    iret

/* The individual interrupt handlers just push */
/* an ascii version of the interupt number onto the */
/* stack, then call the main interrupt handler */
.macro ISR_NOERRCODE p
    nop
int_handle_\p:
    cli
    push $0
    push $msg_int_\p
    jmp isr_common_stub
.endm

.macro ISR_ERRCODE p
    nop
int_handle_\p:
    cli
    push $msg_int_\p
    jmp isr_common_stub
.endm

isr_common_stub:
   nop
    push %rbx
    push %rdx
    push %rcx
    push %rax

    xor %eax, %eax

    /* Print the interrupt message */
    /* Get the location of the message string */
    /* I want to do mov (%esp + 32), %ecx here, but that doesn't work */
    mov %esp, %eax
    add $32, %eax
    mov (%eax), %ecx
    add $MEMOFFSET, %ecx
   
    
ser_poll_i:

    mov $0x3fd, %edx
    in %dx, %al
    test $0x20, %al
    jz ser_poll_i
    mov (%ecx), %al
    mov $0x3f8, %edx
    out %al, %dx
    inc %ecx
    mov (%ecx), %al
    test %al, %al
    jnz ser_poll_i

    ## add some delay so we don't miss messages
    xor %rcx, %rcx
    add $70000000, %rcx
 loop_delay_int:
    nop
    loop loop_delay_int

    pop %rax
    pop %rcx
    pop %rdx
    pop %rbx

    add $16, %esp    ## remove the error code and string address from stack 
    
    sti
    iretq

force_int_32:
    nop
    sti 
    nop
    movl $msg_int_pre, %ecx
    add $MEMOFFSET, %ecx

ser_poll_3:
    mov $0x3fd, %edx
    in %dx, %al
    test $0x20, %al
    jz ser_poll_3
    mov (%ecx), %al
    mov $0x3f8, %edx
    out %al, %dx
    inc %ecx
    mov (%ecx), %al
    test %al, %al
    jnz ser_poll_3


    nop
    int $32
    nop

    movl $msg_int_post, %ecx
    add $MEMOFFSET, %ecx

ser_poll_4:
    mov $0x3fd, %edx
    in %dx, %al
    test $0x20, %al
    jz ser_poll_4
    mov (%ecx), %al
    mov $0x3f8, %edx
    out %al, %dx
    inc %ecx
    mov (%ecx), %al
    test %al, %al
    jnz ser_poll_4

    nop
int_done:
    nop
    jmp int_done

force_int_18:
    nop
    sti 
    nop
    movl $msg_int_pre, %ecx
    add $MEMOFFSET, %ecx


ser_poll_3a:
    mov $0x3fd, %edx
    in %dx, %al
    test $0x20, %al
    jz ser_poll_3a
    mov (%ecx), %al
    mov $0x3f8, %edx
    out %al, %dx
    inc %ecx
    mov (%ecx), %al
    test %al, %al
    jnz ser_poll_3a


    nop
    int $18
    nop

    movl $msg_int_post, %ecx
    add $MEMOFFSET, %ecx

ser_poll_4a:
    mov $0x3fd, %edx
    in %dx, %al
    test $0x20, %al
    jz ser_poll_4a
    mov (%ecx), %al
    mov $0x3f8, %edx
    out %al, %dx
    inc %ecx
    mov (%ecx), %al
    test %al, %al
    jnz ser_poll_4a

    nop
int_done_a:
    nop
    jmp int_done_a

send_ipi_32_to_all:

   mov $0xfee00310, %edx
   movl $0x00000000, (%edx)
   mov $0xfee00300, %edx
   movl $0x000c4020, (%edx)
ipi0_loop:
   jmp ipi0_loop

send_ipi_to_1:
   mov $0xfee00310, %edx
   movl $0x10000000, (%edx)
   mov $0xfee00300, %edx
   movl $0x00000020, (%edx)
ipi1_loop:
   jmp ipi1_loop
   
    



   /****************************/
   /* The main interrupt table */
   /****************************/
    ISR_NOERRCODE 0
    ISR_NOERRCODE 1
    ISR_NOERRCODE 2
    ISR_NOERRCODE 3
    ISR_NOERRCODE 4
    ISR_NOERRCODE 5
    ISR_NOERRCODE 6
    ISR_NOERRCODE 7
    ISR_ERRCODE 8
    ISR_NOERRCODE 9
    ISR_ERRCODE 10
    ISR_ERRCODE 11
    ISR_ERRCODE 12
    ISR_ERRCODE 13
    ISR_ERRCODE 14
    ISR_NOERRCODE 15
    ISR_NOERRCODE 16
    ISR_ERRCODE 17
    ISR_NOERRCODE 18
    ISR_NOERRCODE 19
    ISR_NOERRCODE 32



msg_start:
    .ascii "Starting\r\n\0"
msg_int_0: .ascii "\xfe Interrupt 0: #DE Divide Error\r\n\0"
msg_int_1: .ascii "\xfe Interrupt 1: #DB Reserved\r\n\0"
msg_int_2: .ascii "\xfe Interrupt 2:     NMI Interrupt\r\n\0"
msg_int_3: .ascii "\xfe Interrupt 3: #BP Breakpoint\r\n\0"
msg_int_4: .ascii "\xfe Interrupt 4: #OF Overflow\r\n\0"
msg_int_5: .ascii "\xfe Interrupt 5: #BR BOUND Range Exceeded\r\n\0"
msg_int_6: .ascii "\xfe Interrupt 6: #UD Invalid Opcode\r\n\0"
msg_int_7: .ascii "\xfe Interrupt 7: #NM Device not Available (No Math Coprocessor)\r\n\0"
msg_int_8: .ascii "\xfe Interrupt 8: #DF Double Fault\r\n\0"
msg_int_9: .ascii "\xfe Interrupt 9:     Coprocessor Segment Overrun (reserved)\r\n\0"
msg_int_10: .ascii "\xfe Interrupt 10: #TS Invalid TSS\r\n\0"
msg_int_11: .ascii "\xfe Interrupt 11: #NP Segment Not Present\r\n\0"
msg_int_12: .ascii "\xfe Interrupt 12: #SS Stack-Segment Fault\r\n\0"
msg_int_13: .ascii "\xfe Interrupt 13: #GP General Protection\r\n\0"
msg_int_14: .ascii "\xfe Interrupt 14: #PF Page Fault\r\n\0"
msg_int_15: .ascii "\xfe Interrupt 15:     Reserved\r\n\0"
msg_int_16: .ascii "\xfe Interrupt 16: #MF x87 Floating-point Error (Math Fault)\r\n\0"
msg_int_17: .ascii "\xfe Interrupt 17: #AC Alignment Check\r\n\0"
msg_int_18: .ascii "\xfe Interrupt 18: #MC Machine Check\r\n\0"
msg_int_19: .ascii "\xfe Interrupt 19: #XM SIMD Floating-Point Exception\r\n\0"
msg_int_32: .ascii "\xfe Interrupt 32:     User defined\r\n\0"
msg_error:
    .ascii "\xfe Error.\r\n\0"
msg_int_pre:
    .ascii "\xfe Asserting interrrupt\r\n\0"
msg_int_post:
    .ascii "\xfe After int\r\n\0"

main:
    nop
