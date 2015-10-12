/* 
 * MD5 hash in x86-64 assembly
 * 
 * Copyright (c) 2014 Nayuki Minase
 * All rights reserved. Contact Nayuki for licensing.
 * http://nayuki.eigenstate.org/page/fast-md5-hash-implementation-in-x86-assembly
 */


/* 
 * Storage usage:
 *   Bytes  Location  Description
 *       4  eax       MD5 state variable A
 *       4  ebx       MD5 state variable B
 *       4  ecx       MD5 state variable C
 *       4  edx       MD5 state variable D
 *       4  esi       Temporary for calculation per round
 *       4  edi       Temporary for calculation per round
 *       8  rbp       Base address of block array argument (read-only)
 *       8  r8        Base address of state array argument (read-only)
 *       8  rsp       x86-64 stack pointer
 *      16  xmm0      Caller's value of rbx (only lower 64 bits are used)
 *      16  xmm1      Caller's value of rbp (only lower 64 bits are used)
 */
.text

#ifndef INNERLOOPS
#define INNERLOOPS 4000000
#endif

#ifndef OUTERLOOPS
#define OUTERLOOPS 0x0fffffffffffffff
#endif

#ifndef BIOSPRINT
#ifndef BINPRINT
#ifndef NOPRINT
#ifndef SERPRINT
One of BIOSPRINT, BINPRINT, SERPRINT or NOPRINT must be defined
#endif
#endif
#endif
#endif



#define ROUND0(a, b, c, d, k, s, t)  \
    movl  %c, %esi;         \
    addl  $0xbeef, %a;       \
    xorl  %d, %esi;         \
    andl  %b, %esi;         \
    xorl  %d, %esi;         \
    leal  t(%esi,%a), %a;   \
    roll  $s, %a;           \
    addl  %b, %a;

#define ROUND1(a, b, c, d, k, s, t)  \
    movl  %d, %esi;         \
    movl  %d, %edi;         \
    addl  $0xbeef, %a;  \
    notl  %esi;             \
    andl  %b, %edi;         \
    andl  %c, %esi;         \
    orl   %edi, %esi;       \
    leal  t(%esi,%a), %a;   \
    roll  $s, %a;           \
    addl  %b, %a;

#define ROUND2(a, b, c, d, k, s, t)  \
    movl  %c, %esi;         \
    addl  $0xbeef, %a;  \
    xorl  %d, %esi;         \
    xorl  %b, %esi;         \
    leal  t(%esi,%a), %a;   \
    roll  $s, %a;           \
    addl  %b, %a;

#define ROUND3(a, b, c, d, k, s, t)  \
    movl  %d, %esi;         \
    not   %esi;             \
    addl  $0xbeef, %a;       \
    orl   %b, %esi;         \
    xorl  %c, %esi;         \
    leal  t(%esi,%a), %a;   \
    roll  $s, %a;           \
    addl  %b, %a;


/* void md5_compress(uint32_t state[4], uint32_t block[16]) */
#ifdef FORC
.globl md5_compress
md5_compress:
    /* Save registers */
    movq  %rbx, %xmm0
    movq  %rbp, %xmm1
#else 
.globl main
main:
#endif
    ## Get cpuid for the core on which the virus is executing
    xor %rbx, %rbx
    xor %rax, %rax
    mov $0x01, %eax
    cpuid
    shr $24, %ebx
    mov %rbx, %r14

    ## delay added for the half of the parallel execution of the virus

#ifndef NODELAY
    xor %rcx, %rcx
    ##add $700000000, %rcx
    add %rbx, %rcx
    shl $25, %rcx
    add $7, %rcx
    loop_delay:
        nop
        loop loop_delay

no_delay:

#endif
    mov $OUTERLOOPS, %r12

    /* The main MD5 calculations */
loop_outer:
    xor %rax, %rax
    xor %rbx, %rbx
    xor %rcx, %rcx
    xor %rdx, %rdx

    mov $INNERLOOPS, %r11

    ## The main loop starts
loop_main:
    /* 64 rounds of hashing */
    ROUND0(eax, ebx, ecx, edx,  0,  7, -0x28955B88)
    ROUND0(edx, eax, ebx, ecx,  1, 12, -0x173848AA)
    ROUND0(ecx, edx, eax, ebx,  2, 17,  0x242070DB)
    ROUND0(ebx, ecx, edx, eax,  3, 22, -0x3E423112)
    ROUND0(eax, ebx, ecx, edx,  4,  7, -0x0A83F051)
    ROUND0(edx, eax, ebx, ecx,  5, 12,  0x4787C62A)
    ROUND0(ecx, edx, eax, ebx,  6, 17, -0x57CFB9ED)
    ROUND0(ebx, ecx, edx, eax,  7, 22, -0x02B96AFF)
    ROUND0(eax, ebx, ecx, edx,  8,  7,  0x698098D8)
    ROUND0(edx, eax, ebx, ecx,  9, 12, -0x74BB0851)
    ROUND0(ecx, edx, eax, ebx, 10, 17, -0x0000A44F)
    ROUND0(ebx, ecx, edx, eax, 11, 22, -0x76A32842)
    ROUND0(eax, ebx, ecx, edx, 12,  7,  0x6B901122)
    ROUND0(edx, eax, ebx, ecx, 13, 12, -0x02678E6D)
    ROUND0(ecx, edx, eax, ebx, 14, 17, -0x5986BC72)
    ROUND0(ebx, ecx, edx, eax, 15, 22,  0x49B40821)
    ROUND1(eax, ebx, ecx, edx,  1,  5, -0x09E1DA9E)
    ROUND1(edx, eax, ebx, ecx,  6,  9, -0x3FBF4CC0)
    ROUND1(ecx, edx, eax, ebx, 11, 14,  0x265E5A51)
    ROUND1(ebx, ecx, edx, eax,  0, 20, -0x16493856)
    ROUND1(eax, ebx, ecx, edx,  5,  5, -0x29D0EFA3)
    ROUND1(edx, eax, ebx, ecx, 10,  9,  0x02441453)
    ROUND1(ecx, edx, eax, ebx, 15, 14, -0x275E197F)
    ROUND1(ebx, ecx, edx, eax,  4, 20, -0x182C0438)
    ROUND1(eax, ebx, ecx, edx,  9,  5,  0x21E1CDE6)
    ROUND1(edx, eax, ebx, ecx, 14,  9, -0x3CC8F82A)
    ROUND1(ecx, edx, eax, ebx,  3, 14, -0x0B2AF279)
    ROUND1(ebx, ecx, edx, eax,  8, 20,  0x455A14ED)
    ROUND1(eax, ebx, ecx, edx, 13,  5, -0x561C16FB)
    ROUND1(edx, eax, ebx, ecx,  2,  9, -0x03105C08)
    ROUND1(ecx, edx, eax, ebx,  7, 14,  0x676F02D9)
    ROUND1(ebx, ecx, edx, eax, 12, 20, -0x72D5B376)
    ROUND2(eax, ebx, ecx, edx,  5,  4, -0x0005C6BE)
    ROUND2(edx, eax, ebx, ecx,  8, 11, -0x788E097F)
    ROUND2(ecx, edx, eax, ebx, 11, 16,  0x6D9D6122)
    ROUND2(ebx, ecx, edx, eax, 14, 23, -0x021AC7F4)
    ROUND2(eax, ebx, ecx, edx,  1,  4, -0x5B4115BC)
    ROUND2(edx, eax, ebx, ecx,  4, 11,  0x4BDECFA9)
    ROUND2(ecx, edx, eax, ebx,  7, 16, -0x0944B4A0)
    ROUND2(ebx, ecx, edx, eax, 10, 23, -0x41404390)
    ROUND2(eax, ebx, ecx, edx, 13,  4,  0x289B7EC6)
    ROUND2(edx, eax, ebx, ecx,  0, 11, -0x155ED806)
    ROUND2(ecx, edx, eax, ebx,  3, 16, -0x2B10CF7B)
    ROUND2(ebx, ecx, edx, eax,  6, 23,  0x04881D05)
    ROUND2(eax, ebx, ecx, edx,  9,  4, -0x262B2FC7)
    ROUND2(edx, eax, ebx, ecx, 12, 11, -0x1924661B)
    ROUND2(ecx, edx, eax, ebx, 15, 16,  0x1FA27CF8)
    ROUND2(ebx, ecx, edx, eax,  2, 23, -0x3B53A99B)
    ROUND3(eax, ebx, ecx, edx,  0,  6, -0x0BD6DDBC)
    ROUND3(edx, eax, ebx, ecx,  7, 10,  0x432AFF97)
    ROUND3(ecx, edx, eax, ebx, 14, 15, -0x546BDC59)
    ROUND3(ebx, ecx, edx, eax,  5, 21, -0x036C5FC7)
    ROUND3(eax, ebx, ecx, edx, 12,  6,  0x655B59C3)
    ROUND3(edx, eax, ebx, ecx,  3, 10, -0x70F3336E)
    ROUND3(ecx, edx, eax, ebx, 10, 15, -0x00100B83)
    ROUND3(ebx, ecx, edx, eax,  1, 21, -0x7A7BA22F)
    ROUND3(eax, ebx, ecx, edx,  8,  6,  0x6FA87E4F)
    ROUND3(edx, eax, ebx, ecx, 15, 10, -0x01D31920)
    ROUND3(ecx, edx, eax, ebx,  6, 15, -0x5CFEBCEC)
    ROUND3(ebx, ecx, edx, eax, 13, 21,  0x4E0811A1)
    ROUND3(eax, ebx, ecx, edx,  4,  6, -0x08AC817E)
    ROUND3(edx, eax, ebx, ecx, 11, 10, -0x42C50DCB)
    ROUND3(ecx, edx, eax, ebx,  2, 15,  0x2AD7D2BB)
    ROUND3(ebx, ecx, edx, eax,  9, 21, -0x14792C6F)

    ## Jump to the main loop outer-loop counter is non-zero
    dec %r11
    cmp $0, %r11
    jnz loop_main    

    ################# end of inner loop ####################

    ## Check the results 
    cmp $0x7842f208, %eax
    jne incorrect_eax

    cmp $0x82d0037d, %ebx
    jne incorrect_ebx

    cmp $0x4bc6c467, %ecx
    jne incorrect_ecx

    cmp $0x20e01af8, %edx
    jne incorrect_edx

    ######## print correct message ############
    
#ifdef BINPRINT
    ## Outputs cpuid in the most significant bit position (we right shift the content of rax from r14 by 10 bits to adjust the positions)
    ## and 00 in the least significant bit positions
    ## to acknowledge correct execution and jump to the outer-loop to initialize
    ## the counters and registers for next iteration
    xor %rax, %rax
    add %r14, %rax
    shl $2, %rax
    mov $0x3f8, %dx
    out %al, %dx
#endif

#ifdef BIOSPRINT
    ## Prints the _Correct_ message 
    ## the counters and registers for next iteration
    mov $4, %eax
    mov $1, %ebx
    mov $msg_correct, %ecx
    mov $len_correct, %edx
    int $0x80
#endif

#ifdef SERPRINT

    ### Correct: print "C\n\r"
    mov $67, %rax     # "C"
    mov $0x3f8, %dx
    out %al, %dx

    mov $13, %rax     # "\n"
    mov $0x3f8, %dx
    out %al, %dx

    mov $10, %rax     # "\r"
    mov $0x3f8, %dx
    out %al, %dx

#endif


    ## Jump to the main loop outer-loop counter is non-zero
    dec %r12
    cmp $0, %r12
    jnz loop_outer

    ############### end of outer loop ####################

    

#ifdef BIOSPRINT
    ## Prints the done message
    mov $4, %eax
    mov $1, %ebx
    mov $msg_done, %ecx
    mov $len_done, %edx
    int $0x80

#endif

#ifdef SERPRINT

    ### Done: print "D\n\r"
    mov $68, %rax     # "D"
    mov $0x3f8, %dx
    out %al, %dx

    mov $13, %rax     # "\n"
    mov $0x3f8, %dx
    out %al, %dx

    mov $10, %rax     # "\r"
    mov $0x3f8, %dx
    out %al, %dx

#endif

    jmp end_loop

################ print error messages ######################
#ifdef NOPRINT
incorrect_eax:
incorrect_ebx:
incorrect_ecx:
incorrect_edx:
    jmp end_loop
#endif


#ifdef BINPRINT
incorrect_eax:
incorrect_ebx:
incorrect_ecx:
incorrect_edx:

    xor %rax, %rax
    add %r14, %rax
    shr $10, %rax
    xor %rbx, %rbx
    add $1, %rbx
    or %rbx, %rax
    mov $0x3f8, %dx
    out %al, %dx
    jmp end_loop
#endif

#ifdef BIOSPRINT

incorrect_eax:
    mov $4, %eax
    mov $1, %ebx
    mov $msg_wrong_eax, %ecx
    mov $len_wrong_eax, %edx
    int $0x80
    jmp end_loop

incorrect_ebx:
    mov $4, %eax
    mov $1, %ebx
    mov $msg_wrong_ebx, %ecx
    mov $len_wrong_ebx, %edx
    int $0x80
    jmp end_loop

incorrect_ecx:
    mov $4, %eax
    mov $1, %ebx
    mov $msg_wrong_ecx, %ecx
    mov $len_wrong_ecx, %edx
    int $0x80
    jmp end_loop

incorrect_edx:
    mov $4, %eax
    mov $1, %ebx
    mov $msg_wrong_edx, %ecx
    mov $len_wrong_edx, %edx
    int $0x80
    jmp end_loop

#endif

#ifdef SERPRINT

incorrect_eax:
incorrect_ebx:
incorrect_ecx:
incorrect_edx:
    ### Error: print "E\n\r"
    mov $69, %rax     # "E"
    mov $0x3f8, %dx
    out %al, %dx

    mov $13, %rax     # "\n"
    mov $0x3f8, %dx
    out %al, %dx

    mov $10, %rax     # "\r"
    mov $0x3f8, %dx
    out %al, %dx

#endif
end_loop:

#ifdef BIOSEXIT
    ## exit via BIOS call
    mov $1, %eax
    mov $0, %ebx
    int $0x80
#endif
    jmp end_loop

msg_correct:  .ascii "Correct\n\0"
              .set len_correct, .-msg_correct

msg_wrong_eax: .ascii "Incorrect: EAX mismatch\n\0"
               .set len_wrong_eax, .-msg_wrong_eax

msg_wrong_ebx: .ascii "Incorrect: EBX mismatch\n\0"
              .set len_wrong_ebx, .-msg_wrong_ebx

msg_wrong_ecx: .ascii "Incorrect: ECX mismatch\n\0"
               .set len_wrong_ecx, .-msg_wrong_ecx

msg_wrong_edx: .ascii "Incorrect: EDX mismatch\n\0"
               .set len_wrong_edx, .-msg_wrong_edx

msg_done:      .ascii "Done\n\0"
               .set len_done, .-msg_done

