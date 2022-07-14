	.file	"lab2.c"
	.section	.text.unlikely,"ax",@progbits
.LCOLDB4:
	.text
.LHOTB4:
	.p2align 4,,15
	.globl	LeibnizFormula
	.type	LeibnizFormula, @function
LeibnizFormula:
.LFB47:
	.cfi_startproc
	testq	%rdi, %rdi
	jle	.L6
	movsd	.LC1(%rip), %xmm3
	xorl	%eax, %eax
	pxor	%xmm0, %xmm0
	movapd	%xmm3, %xmm2
	movapd	%xmm3, %xmm4
	movsd	.LC2(%rip), %xmm5
	.p2align 4,,10
	.p2align 3
.L3:
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	addq	$1, %rax
	cmpq	%rax, %rdi
	addsd	%xmm1, %xmm1
	addsd	%xmm3, %xmm1
	divsd	%xmm1, %xmm2
	addsd	%xmm2, %xmm0
	je	.L10
	testb	$1, %al
	movapd	%xmm4, %xmm2
	je	.L3
	movapd	%xmm5, %xmm2
	jmp	.L3
	.p2align 4,,10
	.p2align 3
.L10:
	mulsd	.LC3(%rip), %xmm0
	ret
.L6:
	pxor	%xmm0, %xmm0
	ret
	.cfi_endproc
.LFE47:
	.size	LeibnizFormula, .-LeibnizFormula
	.section	.text.unlikely
.LCOLDE4:
	.text
.LHOTE4:
	.section	.text.unlikely
.LCOLDB5:
	.text
.LHOTB5:
	.p2align 4,,15
	.globl	fromCharToInt
	.type	fromCharToInt, @function
fromCharToInt:
.LFB48:
	.cfi_startproc
	movsbl	%dil, %eax
	subl	$48, %eax
	ret
	.cfi_endproc
.LFE48:
	.size	fromCharToInt, .-fromCharToInt
	.section	.text.unlikely
.LCOLDE5:
	.text
.LHOTE5:
	.section	.text.unlikely
.LCOLDB6:
	.text
.LHOTB6:
	.p2align 4,,15
	.globl	getN
	.type	getN, @function
getN:
.LFB49:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx // %rdi = %rbx = argv
	call	strlen // %eax = lengthN
	testl	%eax, %eax
	jle	.L15 // even - %eax = 0, less - старший бит %eax = 1; видимо проверка условия for, либо проверка на то, что длина строки не равна 0
	movl	%eax, %esi // %esi = LengthN
	xorl	%ecx, %ecx
	xorl	%eax, %eax // %eax = %ecx = 0 в %eax будет лежать значение переменной N
	.p2align 4,,10
	.p2align 3
.L14:
	leaq	(%rax,%rax,4), %rcx
	movsbl	(%rbx,%rdx), %eax
	addq	$1, %rdx
	subl	$48, %eax
	cmpl	%edx, %esi
	cltq
	leaq	(%rax,%rcx,2), %rax
	jg	.L14
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
.L15:
	.cfi_restore_state
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE49:
	.size	getN, .-getN
	.section	.text.unlikely
.LCOLDE6:
	.text
.LHOTE6:
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC7:
	.string	"%f\n"
	.section	.text.unlikely
.LCOLDB8:
	.text
.LHOTB8:
	.p2align 4,,15
	.globl	printAnswer
	.type	printAnswer, @function
printAnswer:
.LFB50:
	.cfi_startproc
	movl	$.LC7, %esi
	movl	$1, %edi
	movl	$1, %eax
	jmp	__printf_chk
	.cfi_endproc
.LFE50:
	.size	printAnswer, .-printAnswer
	.section	.text.unlikely
.LCOLDE8:
	.text
.LHOTE8:
	.section	.text.unlikely
.LCOLDB9:
	.section	.text.startup,"ax",@progbits
.LHOTB9:
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB51:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	8(%rsi), %rdi // не стал сохранять argv и argv, сохранил только argv[1]
	call	getN
	testq	%rax, %rax
	pxor	%xmm0, %xmm0
	jle	.L20 // если N <= 0
	movsd	.LC1(%rip), %xmm3
	xorl	%edx, %edx
	pxor	%xmm0, %xmm0
	movapd	%xmm3, %xmm2
	movsd	.LC2(%rip), %xmm4
	movapd	%xmm3, %xmm5
	.p2align 4,,10
	.p2align 3
.L21:
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rdx, %xmm1
	addq	$1, %rdx
	cmpq	%rdx, %rax
	addsd	%xmm1, %xmm1
	addsd	%xmm3, %xmm1
	divsd	%xmm1, %xmm2
	addsd	%xmm2, %xmm0
	je	.L20
	testb	$1, %dl
	movapd	%xmm4, %xmm2
	jne	.L21
	movapd	%xmm5, %xmm2
	jmp	.L21
	.p2align 4,,10
	.p2align 3
.L20:
	mulsd	.LC3(%rip), %xmm0
	movl	$.LC7, %esi
	movl	$1, %edi
	movl	$1, %eax
	call	__printf_chk
	xorl	%eax, %eax
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE51:
	.size	main, .-main
	.section	.text.unlikely
.LCOLDE9:
	.section	.text.startup
.LHOTE9:
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC1:
	.long	0
	.long	1072693248
	.align 8
.LC2:
	.long	0
	.long	-1074790400
	.align 8
.LC3:
	.long	0
	.long	1074790400
	.ident	"GCC: (Ubuntu 5.5.0-12ubuntu1~16.04) 5.5.0 20171010"
	.section	.note.GNU-stack,"",@progbits
