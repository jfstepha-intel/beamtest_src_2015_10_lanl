# 1 "../lattice/lattice_64bit_hacked.S"
# 1 "<built-in>"
# 1 "<command line>"
# 1 "../lattice/lattice_64bit_hacked.S"
# This was created from the .c code with the Makefile_c
# then hacked.
# 17 "../lattice/lattice_64bit_hacked.S"
One of BIOSPRINT, BINPRINT, SERPRINT or NOPRINT must be defined






.extern main
.text
    .global main
main:
    # old apic method
 #xor %rbx,%rbx
 #xor %eax,%eax
 #mov $0x1,%eax
 #shr $24,%ebx
 #cpuid

    # new apicx2 method
    xor %edx, %edx
    mov $0x0B, %eax
    xor %ecx, %ecx
    cpuid # id comes out on edx
    mov %edx, %ebx

    mov %rbx, %r14


 xor %rcx,%rcx
 add %rbx,%rcx
 #shl $0x18,%rcx
 shl $0x4,%rcx
 add $0x7,%rcx
    delay_loop:
        nop
        loop delay_loop ## loop b704 <main+0x44>


    xor %r15, %r15

loop_outer: # b707
    mov $0x7fffffffffffffff, %r13
 # movsd 9049(%rip),%xmm5 # da68 <_IO_stdin_used+0x8>
    mov $0x4022000000000000, %rax
    movq %rax, %xmm5

 # movsd 9049(%rip),%xmm4 # da70 <_IO_stdin_used+0x10>
    mov $0x4000000000000000, %rax
    movq %rax, %xmm4

    # movsd 9049(%rip),%xmm3 # da78 <_IO_stdin_used+0x18>
    mov $0x3f847ae147ae147b, %rax
    movq %rax, %xmm3

 # movsd 9049(%rip),%xmm2 # da80 <_IO_stdin_used+0x20>
    mov $0x3f747ae147ae147b, %rax
    movq %rax, %xmm2

 xor %r12d,%r12d

    # movsd 9046(%rip),%xmm1 # da88 <_IO_stdin_used+0x28>
 mov $0x3cd203af9ee75616, %rax
    movq %rax, %xmm1

    # movsd 9046(%rip),%xmm0 # da90 <_IO_stdin_used+0x30>
    mov $0x3fe0000000000000, %rax
    movq %rax, %xmm0

 # movsd 9046(%rip),%xmm6 # da98 <_IO_stdin_used+0x38>
    mov $0x430c6bf526340000, %rax
    movq %rax, %xmm6

loop_inner: # b742
 # movsd 8990(%rip),%xmm7 # da68 <_IO_stdin_used+0x8>
    mov $0x4022000000000000, %rax
    movq %rax, %xmm7

 movaps %xmm7,%xmm6
 # movsd 9026(%rip),%xmm10 # da98 <_IO_stdin_used+0x38>
    mov $0x430c6bf526340000, %rax
    movq %rax, %xmm10

 # movsd 9010(%rip),%xmm0 # da90 <_IO_stdin_used+0x30>
    mov $0x3fe0000000000000, %rax
    movq %rax, %xmm0

 xor %r10, %r10
 pxor %xmm5,%xmm5

 # movsd 8988(%rip),%xmm1 # da88 <_IO_stdin_used+0x28>
    mov $0x3cd203af9ee75616, %rax
    movq %rax, %xmm1


 # movsd 8972(%rip),%xmm2 # da80 <_IO_stdin_used+0x20>
 mov $0x3f747ae147ae147b, %rax
    movq %rax, %xmm2

    # movsd 8956(%rip),%xmm3 # da78 <_IO_stdin_used+0x18>
    mov $0x3f847ae147ae147b, %rax
    movq %rax, %xmm3

 # movsd 8939(%rip),%xmm11 # da70 <_IO_stdin_used+0x10>
    mov $0x4000000000000000, %rax
    movq %rax, %xmm11

 pxor %xmm4,%xmm4
loop1: #b789
 xor %edx,%edx
 pxor %xmm9,%xmm9
 pxor %xmm8,%xmm8
loop2: #b795
 cvtsi2sd %edx,%xmm0
 movaps %xmm7,%xmm14
    mov $0x4000000000000000, %rax
    movq %rax, %xmm11
 mulsd %xmm11,%xmm0
 xor %ecx,%ecx
 subsd %xmm0,%xmm14
 movaps %xmm14,%xmm13
 mulsd %xmm14,%xmm13
 sqrtsd %xmm13,%xmm12
loop3: #b7b7
 cvtsi2sd %ecx,%xmm3
 movq %xmm14, %r8 # movsd %xmm14,(%rsp)
 movaps %xmm6,%xmm15
    mov $0x4000000000000000, %rax
    movq %rax, %xmm11
 mulsd %xmm11,%xmm3
 movaps %xmm13,%xmm0
 inc %ecx
 subsd %xmm3,%xmm15
 # movsd 8899(%rip),%xmm3 # daa0 <_IO_stdin_used+0x40>
    mov $0x3ff0000000000000, %rax
    movq %rax, %xmm3

 movq %xmm15, %r9 # movsd %xmm15,0x8(%rsp)
 movaps %xmm15,%xmm1
 mulsd %xmm15,%xmm1
 addsd %xmm1,%xmm0
 and %r13, %r8 # andl $0x7fffffff,0x4(%rsp)
 sqrtsd %xmm0,%xmm2
 movaps %xmm2,%xmm0
 mulsd %xmm2,%xmm0
 divsd %xmm0,%xmm3
 and %r13, %r9 # andl $0x7fffffff,0xc(%rsp)
 sqrtsd %xmm1,%xmm0
 divsd %xmm2,%xmm0
 mulsd %xmm3,%xmm0
 mulsd %xmm14,%xmm0
 movaps %xmm0,%xmm1

    # divsd (%rsp),%xmm1
    movq %r8, %xmm11
    divsd %xmm11, %xmm1

 movq %xmm14, %r8 # movsd %xmm14,(%rsp)
 and %r13, %r8 # andl $0x7fffffff,0x4(%rsp)
 addsd %xmm1,%xmm9
 movaps %xmm12,%xmm1
 divsd %xmm2,%xmm1
 mulsd %xmm1,%xmm3
 movaps %xmm0,%xmm1

 # divsd (%rsp),%xmm1
    movq %r8, %xmm11
    divsd %xmm11, %xmm1

 #movq %xmm14, %r8 # movsd %xmm14,(%rsp)
 mulsd %xmm15,%xmm3
 movaps %xmm3,%xmm2

 #divsd 0x8(%rsp),%xmm2
    movq %r9, %xmm11
    divsd %xmm11, %xmm2

 movq %xmm15, %r9 # movsd %xmm15,0x8(%rsp)
 and %r13, %r8 # andl $0x7fffffff,0x4(%rsp)
 addsd %xmm2,%xmm8
 movaps %xmm3,%xmm2
 and %r13, %r9 # andl $0x7fffffff,0xc(%rsp)

 # divsd 0x8(%rsp),%xmm2
 movq %r9, %xmm11
    divsd %xmm11, %xmm2

    movq %xmm15, %r9 # movsd %xmm15,0x8(%rsp)
 addsd %xmm1,%xmm9
 movaps %xmm0,%xmm1

 # divsd (%rsp),%xmm1
    movq %r8, %xmm11
    divsd %xmm11, %xmm1

 movq %xmm14, %r8 # movsd %xmm14,(%rsp)
 and %r13, %r9 # andl $0x7fffffff,0xc(%rsp)
 addsd %xmm2,%xmm8
 movaps %xmm3,%xmm2

 # divsd 0x8(%rsp),%xmm2
    movq %r9, %xmm11
    divsd %xmm11, %xmm2

 movq %xmm15, %r9 # movsd %xmm15,0x8(%rsp)
 and %r13, %r8 # andl $0x7fffffff,0x4(%rsp)
 addsd %xmm1,%xmm9
 movaps %xmm0,%xmm1

 # divsd (%rsp),%xmm1
    movq %r8, %xmm11
    divsd %xmm11, %xmm1

 movq %xmm14, %r8 # movsd %xmm14,(%rsp)
 and %r13, %r9 # andl $0x7fffffff,0xc(%rsp)

 addsd %xmm2,%xmm8
 movaps %xmm3,%xmm2
 # divsd 0x8(%rsp),%xmm2
    movq %r9, %xmm11
    divsd %xmm11, %xmm2

 movq %xmm15, %r9 # movsd %xmm15,0x8(%rsp)
 and %r13, %r8 # andl $0x7fffffff,0x4(%rsp)
 addsd %xmm1,%xmm9
 movaps %xmm0,%xmm1

 # divsd (%rsp),%xmm1
    movq %r8, %xmm11
    divsd %xmm11, %xmm1

 movq %xmm14, %r8 # movsd %xmm14,(%rsp)
 and %r13, %r9 # andl $0x7fffffff,0xc(%rsp)
 addsd %xmm2,%xmm8
 movaps %xmm3,%xmm2

 # divsd 0x8(%rsp),%xmm2
    movq %r9, %xmm11
    divsd %xmm11, %xmm2

 movq %xmm15, %r9 # movsd %xmm15,0x8(%rsp)
 and %r13, %r8 # andl $0x7fffffff,0x4(%rsp)
 addsd %xmm1,%xmm9
 movaps %xmm0,%xmm1

 # divsd (%rsp),%xmm1
    movq %r8, %xmm11
    divsd %xmm11, %xmm1

 movq %xmm14, %r8 # movsd %xmm14,(%rsp)
 and %r13, %r9 # andl $0x7fffffff,0xc(%rsp)

 addsd %xmm2,%xmm8
 movaps %xmm3,%xmm2

 # divsd 0x8(%rsp),%xmm2
    movq %r9, %xmm11
    divsd %xmm11, %xmm2

 movq %xmm15, %r9 # movsd %xmm15,0x8(%rsp)
 and %r13, %r8 # andl $0x7fffffff,0x4(%rsp)

    addsd %xmm1,%xmm9
 movaps %xmm0,%xmm1

 # divsd (%rsp),%xmm1
    movq %r8, %xmm11
    divsd %xmm11, %xmm1

    movq %xmm14, %r8 # movsd %xmm14,(%rsp)
 and %r13, %r9 # andl $0x7fffffff,0xc(%rsp)
 addsd %xmm2,%xmm8
 movaps %xmm3,%xmm2

 # divsd 0x8(%rsp),%xmm2
    movq %r9, %xmm11
    divsd %xmm11, %xmm2

 movq %xmm15, %r9 # movsd %xmm15,0x8(%rsp)
 and %r13, %r8 # andl $0x7fffffff,0x4(%rsp)
 addsd %xmm1,%xmm9
 movaps %xmm0,%xmm1

 # divsd (%rsp),%xmm1
    movq %r8, %xmm11
    divsd %xmm11, %xmm1

    movq %xmm14, %r8 # movsd %xmm14,(%rsp)
 and %r13, %r9 # andl $0x7fffffff,0xc(%rsp)
 addsd %xmm2,%xmm8
 movaps %xmm3,%xmm2

 # divsd 0x8(%rsp),%xmm2
    movq %r9, %xmm11
    divsd %xmm11, %xmm2

 movq %xmm15, %r9 # movsd %xmm15,0x8(%rsp)
 and %r13, %r8 # andl $0x7fffffff,0x4(%rsp)
 addsd %xmm1,%xmm9
 movaps %xmm0,%xmm1

 # divsd (%rsp),%xmm1
    movq %r8, %xmm11
    divsd %xmm11, %xmm1

 movq %xmm14, %r8 # movsd %xmm14,(%rsp)
 and %r13, %r9 # andl $0x7fffffff,0xc(%rsp)
 addsd %xmm2,%xmm8
 movaps %xmm3,%xmm2

 # divsd 0x8(%rsp),%xmm2
    movq %r9, %xmm11
    divsd %xmm11, %xmm2

 movq %xmm15, %r9 # movsd %xmm15,0x8(%rsp)
 and %r13, %r8 # andl $0x7fffffff,0x4(%rsp)

    # divsd (%rsp),%xmm0
    movq %r8, %xmm11
    divsd %xmm11, %xmm0

    and %r13, %r9 # andl $0x7fffffff,0xc(%rsp)

 #divsd 0x8(%rsp),%xmm3
    movq %r9, %xmm11
    divsd %xmm11, %xmm3

 addsd %xmm1,%xmm9
 addsd %xmm2,%xmm8
 addsd %xmm0,%xmm9
 addsd %xmm3,%xmm8
 cmp $0xa,%ecx
 jb loop3 # b7b7 <main+0xf7>
 inc %edx
 cmp $0xa,%edx
 jb loop2 # b795 <main+0xd5>

 # movsd 8245(%rip),%xmm0 # da90 <_IO_stdin_used+0x30>
    mov $0x3fe0000000000000, %rax
    movq %rax, %xmm0

 # movsd 8229(%rip),%xmm1 # da88 <_IO_stdin_used+0x28>
    mov $0x3fe0000000000000, %rax
    movq %rax, %xmm1

 # movsd 8213(%rip),%xmm2 # da80 <_IO_stdin_used+0x20>
    mov $0x3f747ae147ae147b, %rax
    movq %rax, %xmm2

 # movsd 8197(%rip),%xmm3 # da78 <_IO_stdin_used+0x18>
    mov $0x3f847ae147ae147b, %rax
    movq %rax, %xmm3

 mulsd %xmm3,%xmm9
 divsd %xmm3,%xmm9
 mulsd %xmm3,%xmm8
 divsd %xmm3,%xmm8
 addsd %xmm5,%xmm9
 addsd %xmm9,%xmm5
 mulsd %xmm2,%xmm5
 mulsd %xmm10,%xmm9
 addsd %xmm4,%xmm8
 addsd %xmm5,%xmm7
 addsd %xmm8,%xmm4
 mulsd %xmm2,%xmm4
 mulsd %xmm10,%xmm8
 addsd %xmm0,%xmm9
 addsd %xmm4,%xmm6
 addsd %xmm0,%xmm8
 inc %r10
 cmp $100, %r10
 cvttsd2si %xmm9,%edx
 cvtsi2sd %edx,%xmm5
 mulsd %xmm1,%xmm5
 cvttsd2si %xmm8,%ecx
 cvtsi2sd %ecx,%xmm4
 mulsd %xmm1,%xmm4
 jb loop1 # b789 <main+0xc9>

 # ucomisd 8058(%rip),%xmm7 # da68 <_IO_stdin_used+0x8>
    mov $0x4022000000000000, %rax
    movq %rax, %xmm11
    ucomisd %xmm11, %xmm7

 jp print_sdc # baf2 <main+0x432>
 je skip2 # bb13 <main+0x453>

print_sdc: #baf2
 mov $0x402d34,%edi
 xor %eax,%eax
 # callq b5a8 <fprintf@plt+0x8>
    # Print SDC message here
# 450 "../lattice/lattice_64bit_hacked.S"
skip2: #bb13
 # ucomisd 8013(%rip),%xmm6 # da68 <_IO_stdin_used+0x8>
    mov $0x4022000000000000, %rax
    movq %rax, %xmm11
    ucomisd %xmm11, %xmm6

 jne print_sdc # baf2 <main+0x432>
 jp print_sdc # af2 <main+0x432>

    ## here we know we have the correct results. Do inner loop
inc_loop: #bafe
 inc %r12d
 cmp $1,%r12d

 jb loop_inner # b742 <main+0x82>

 mov $0x402d28,%edi
 xor %eax,%eax
 # callq b5a8 <fprintf@plt+0x8>


    ######## print correct message ############
# 513 "../lattice/lattice_64bit_hacked.S"
    inc %r15d
    cmp $0x0fffffff, %r15d
 jb loop_outer # b707 <main+0x47>

end:
# 551 "../lattice/lattice_64bit_hacked.S"
end_loop:
    nop
    jmp end_loop
