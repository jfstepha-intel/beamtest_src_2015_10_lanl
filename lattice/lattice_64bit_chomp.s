.text
    .global main
main:
	xor    %rbx,%rbx
	xor    %eax,%eax
	mov    $0x1,%eax
	cpuid  
	shr    $0x18,%ebx
	xor    %rcx,%rcx
	add    %rbx,%rcx
	shl    $0x19,%rcx
	add    $0x7,%rcx
	nop    
	loop   b704 <main+0x44>
	movsd  9049(%rip),%xmm5        # da68 <_IO_stdin_used+0x8>
	movsd  9049(%rip),%xmm4        # da70 <_IO_stdin_used+0x10>
	movsd  9049(%rip),%xmm3        # da78 <_IO_stdin_used+0x18>
	movsd  9049(%rip),%xmm2        # da80 <_IO_stdin_used+0x20>
	xor    %r12d,%r12d
	movsd  9046(%rip),%xmm1        # da88 <_IO_stdin_used+0x28>
	movsd  9046(%rip),%xmm0        # da90 <_IO_stdin_used+0x30>
	movsd  9046(%rip),%xmm6        # da98 <_IO_stdin_used+0x38>
	movsd  8990(%rip),%xmm7        # da68 <_IO_stdin_used+0x8>
	movaps %xmm7,%xmm6
	movsd  9026(%rip),%xmm10        # da98 <_IO_stdin_used+0x38>
	movsd  9010(%rip),%xmm0        # da90 <_IO_stdin_used+0x30>
	xor    %eax,%eax
	pxor   %xmm5,%xmm5
	movsd  8988(%rip),%xmm1        # da88 <_IO_stdin_used+0x28>
	movsd  8972(%rip),%xmm2        # da80 <_IO_stdin_used+0x20>
	movsd  8956(%rip),%xmm3        # da78 <_IO_stdin_used+0x18>
	movsd  8939(%rip),%xmm11        # da70 <_IO_stdin_used+0x10>
	pxor   %xmm4,%xmm4
	xor    %edx,%edx
	pxor   %xmm9,%xmm9
	pxor   %xmm8,%xmm8
	cvtsi2sd %edx,%xmm0
	movaps %xmm7,%xmm14
	mulsd  %xmm11,%xmm0
	xor    %ecx,%ecx
	subsd  %xmm0,%xmm14
	movaps %xmm14,%xmm13
	mulsd  %xmm14,%xmm13
	sqrtsd %xmm13,%xmm12
	cvtsi2sd %ecx,%xmm3
	movsd  %xmm14,(%rsp)
	movaps %xmm6,%xmm15
	mulsd  %xmm11,%xmm3
	movaps %xmm13,%xmm0
	inc    %ecx
	subsd  %xmm3,%xmm15
	movsd  8899(%rip),%xmm3        # daa0 <_IO_stdin_used+0x40>
	movsd  %xmm15,0x8(%rsp)
	movaps %xmm15,%xmm1
	mulsd  %xmm15,%xmm1
	addsd  %xmm1,%xmm0
	andl   $0x7fffffff,0x4(%rsp)
	sqrtsd %xmm0,%xmm2
	movaps %xmm2,%xmm0
	mulsd  %xmm2,%xmm0
	divsd  %xmm0,%xmm3
	andl   $0x7fffffff,0xc(%rsp)
	sqrtsd %xmm1,%xmm0
	divsd  %xmm2,%xmm0
	mulsd  %xmm3,%xmm0
	mulsd  %xmm14,%xmm0
	movaps %xmm0,%xmm1
	divsd  (%rsp),%xmm1
	movsd  %xmm14,(%rsp)
	andl   $0x7fffffff,0x4(%rsp)
	addsd  %xmm1,%xmm9
	movaps %xmm12,%xmm1
	divsd  %xmm2,%xmm1
	mulsd  %xmm1,%xmm3
	movaps %xmm0,%xmm1
	divsd  (%rsp),%xmm1
	movsd  %xmm14,(%rsp)
	mulsd  %xmm15,%xmm3
	movaps %xmm3,%xmm2
	divsd  0x8(%rsp),%xmm2
	movsd  %xmm15,0x8(%rsp)
	andl   $0x7fffffff,0x4(%rsp)
	addsd  %xmm2,%xmm8
	movaps %xmm3,%xmm2
	andl   $0x7fffffff,0xc(%rsp)
	divsd  0x8(%rsp),%xmm2
	movsd  %xmm15,0x8(%rsp)
	addsd  %xmm1,%xmm9
	movaps %xmm0,%xmm1
	divsd  (%rsp),%xmm1
	movsd  %xmm14,(%rsp)
	andl   $0x7fffffff,0xc(%rsp)
	addsd  %xmm2,%xmm8
	movaps %xmm3,%xmm2
	divsd  0x8(%rsp),%xmm2
	movsd  %xmm15,0x8(%rsp)
	andl   $0x7fffffff,0x4(%rsp)
	addsd  %xmm1,%xmm9
	movaps %xmm0,%xmm1
	divsd  (%rsp),%xmm1
	movsd  %xmm14,(%rsp)
	andl   $0x7fffffff,0xc(%rsp)
	addsd  %xmm2,%xmm8
	movaps %xmm3,%xmm2
	divsd  0x8(%rsp),%xmm2
	movsd  %xmm15,0x8(%rsp)
	andl   $0x7fffffff,0x4(%rsp)
	addsd  %xmm1,%xmm9
	movaps %xmm0,%xmm1
	divsd  (%rsp),%xmm1
	movsd  %xmm14,(%rsp)
	andl   $0x7fffffff,0xc(%rsp)
	addsd  %xmm2,%xmm8
	movaps %xmm3,%xmm2
	divsd  0x8(%rsp),%xmm2
	movsd  %xmm15,0x8(%rsp)
	andl   $0x7fffffff,0x4(%rsp)
	addsd  %xmm1,%xmm9
	movaps %xmm0,%xmm1
	divsd  (%rsp),%xmm1
	movsd  %xmm14,(%rsp)
	andl   $0x7fffffff,0xc(%rsp)
	addsd  %xmm2,%xmm8
	movaps %xmm3,%xmm2
	divsd  0x8(%rsp),%xmm2
	movsd  %xmm15,0x8(%rsp)
	andl   $0x7fffffff,0x4(%rsp)
	addsd  %xmm1,%xmm9
	movaps %xmm0,%xmm1
	divsd  (%rsp),%xmm1
	movsd  %xmm14,(%rsp)
	andl   $0x7fffffff,0xc(%rsp)
	addsd  %xmm2,%xmm8
	movaps %xmm3,%xmm2
	divsd  0x8(%rsp),%xmm2
	movsd  %xmm15,0x8(%rsp)
	andl   $0x7fffffff,0x4(%rsp)
	addsd  %xmm1,%xmm9
	movaps %xmm0,%xmm1
	divsd  (%rsp),%xmm1
	movsd  %xmm14,(%rsp)
	andl   $0x7fffffff,0xc(%rsp)
	addsd  %xmm2,%xmm8
	movaps %xmm3,%xmm2
	divsd  0x8(%rsp),%xmm2
	movsd  %xmm15,0x8(%rsp)
	andl   $0x7fffffff,0x4(%rsp)
	addsd  %xmm1,%xmm9
	movaps %xmm0,%xmm1
	divsd  (%rsp),%xmm1
	movsd  %xmm14,(%rsp)
	andl   $0x7fffffff,0xc(%rsp)
	addsd  %xmm2,%xmm8
	movaps %xmm3,%xmm2
	divsd  0x8(%rsp),%xmm2
	movsd  %xmm15,0x8(%rsp)
	andl   $0x7fffffff,0x4(%rsp)
	divsd  (%rsp),%xmm0
	andl   $0x7fffffff,0xc(%rsp)
	divsd  0x8(%rsp),%xmm3
	addsd  %xmm1,%xmm9
	addsd  %xmm2,%xmm8
	addsd  %xmm0,%xmm9
	addsd  %xmm3,%xmm8
	cmp    $0xa,%ecx
	jb     b7b7 <main+0xf7>
	inc    %edx
	cmp    $0xa,%edx
	jb     b795 <main+0xd5>
	movsd  8245(%rip),%xmm0        # da90 <_IO_stdin_used+0x30>
	movsd  8229(%rip),%xmm1        # da88 <_IO_stdin_used+0x28>
	movsd  8213(%rip),%xmm2        # da80 <_IO_stdin_used+0x20>
	movsd  8197(%rip),%xmm3        # da78 <_IO_stdin_used+0x18>
	mulsd  %xmm3,%xmm9
	divsd  %xmm3,%xmm9
	mulsd  %xmm3,%xmm8
	divsd  %xmm3,%xmm8
	addsd  %xmm5,%xmm9
	addsd  %xmm9,%xmm5
	mulsd  %xmm2,%xmm5
	mulsd  %xmm10,%xmm9
	addsd  %xmm4,%xmm8
	addsd  %xmm5,%xmm7
	addsd  %xmm8,%xmm4
	mulsd  %xmm2,%xmm4
	mulsd  %xmm10,%xmm8
	addsd  %xmm0,%xmm9
	addsd  %xmm4,%xmm6
	addsd  %xmm0,%xmm8
	inc    %eax
	cmp    $0x3e8,%eax
	cvttsd2si %xmm9,%edx
	cvtsi2sd %edx,%xmm5
	mulsd  %xmm1,%xmm5
	cvttsd2si %xmm8,%ecx
	cvtsi2sd %ecx,%xmm4
	mulsd  %xmm1,%xmm4
	jb     b789 <main+0xc9>
	ucomisd 8058(%rip),%xmm7        # da68 <_IO_stdin_used+0x8>
	jp     baf2 <main+0x432>
	je     bb13 <main+0x453>
	mov    $0x402d34,%edi
	xor    %eax,%eax
	callq  b5a8 <fprintf@plt+0x8>
	inc    %r12d
	cmp    $0x186a0,%r12d
	jb     b742 <main+0x82>
	jmpq   b707 <main+0x47>
	ucomisd 8013(%rip),%xmm6        # da68 <_IO_stdin_used+0x8>
	jne    baf2 <main+0x432>
	jp     baf2 <main+0x432>
	mov    $0x402d28,%edi
	xor    %eax,%eax
	callq  b5a8 <fprintf@plt+0x8>
	jmp    bafe <main+0x43e>
	xchg   %ax,%ax

