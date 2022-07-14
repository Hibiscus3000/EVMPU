	.file	"prog.cpp"
	.text
	.globl	_Z5func1PdS_
	.type	_Z5func1PdS_, @function
_Z5func1PdS_:
.LCFI2:
        pushq   %rbx
	movq	$0, %r15
.L3:
	cmpq	$49999999, %r15
        jg .L2
	movq	%r13, %rax
	leaq	(%rax,%r15,8), %rbx
        call    rand
	pxor	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0
	movsd	.LC0(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	.LC1(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	.LC2(%rip), %xmm1
	subsd	%xmm1, %xmm0
	movsd	%xmm0, (%rbx)
	movq	%r14, %rax
	leaq	(%rax,%r15,8), %rbx
        call    rand
        pxor	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0
	movsd	.LC0(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	.LC1(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	.LC2(%rip), %xmm1
	subsd	%xmm1, %xmm0
	movsd	%xmm0, (%rbx)
	addq	$1, %r15
	jmp	.L3
.L2:
	movl	$0, %eax
        popq    %rbx
.LCFI3:
	ret
.LFE2:
	.size	_Z5func1PdS_, .-_Z5func1PdS_
	.globl	_Z5func2PdS_
	.type	_Z5func2PdS_, @function
_Z5func2PdS_:
.LCFI5:
        pxor    %xmm0, %xmm0
	movq	%xmm0, %r10
	movq	$0, %r15
.L7:
	cmpq	$49999999, %r15
	jg	.L6
	leaq	0(%r13,%r15,8), %rax
	movq	(%rax), %xmm0
	call	sin
	movapd	%xmm0, %xmm1
	movsd	.LC4(%rip), %xmm0
	mulsd	%xmm0, %xmm1
	movq	%xmm1, %r12
	leaq	0(%r14,%r15,8), %rax
	movq	(%rax), %xmm0
	call	cos
        movq    %r12, %xmm2
	mulsd	%xmm2, %xmm0
	movq	%r10, %xmm1
	addsd	%xmm1, %xmm0
	movq	%xmm0, %r10
	addq	$1, %r15
	jmp	.L7
.L6:
	movq  %r10, %xmm0
.LCFI6:
	ret
.LFE3:
	.size	_Z5func2PdS_, .-_Z5func2PdS_
	.section	.rodata
.LC5:
	.string	"\n\n result = %lf"
	.text
	.globl	main
	.type	main, @function
main:
.LCFI8:
	movl	$400000000, %edi
	call	_Znam
	movq	%rax, %r13 
	movl	$400000000, %edi
	call	_Znam
        movq	%rax, %r14
	call	_Z5func1PdS_
	call	_Z5func2PdS_
	movl	$.LC5, %edi
	movl	$1, %eax
	call	printf
	movq	%r14, %rdi
	call	_ZdlPv
	movq	%r13, %rdi
	call	_ZdlPv
	movl	$0, %eax
.LCFI9:
	ret
.LFE4:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC0:
	.long	0
	.long	1079574528
	.align 8
.LC1:
	.long	4290772992
	.long	1105199103
	.align 8
.LC2:
	.long	0
	.long	1078525952
	.align 8
.LC4:
	.long	3100958126
	.long	1075678820
	.section	.eh_frame,"a",@progbits
.LEFDE1:
	.ident	"GCC: (Ubuntu 5.5.0-12ubuntu1~16.04) 5.5.0 20171010"
	.section	.note.GNU-stack,"",@progbits
