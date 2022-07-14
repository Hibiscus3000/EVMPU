	.file	"prog.cpp"
	.text
	.globl	_Z5func1PdS_
	.type	_Z5func1PdS_, @function
_Z5func1PdS_:
.LFB2:
	pushq	%rbp
.LCFI0:
	movq	%rsp, %rbp // пролог
.LCFI1:
	pushq	%rbx
	subq	$40, %rsp
.LCFI2:
	movq	%rdi, -40(%rbp) // -40(%rbp) = a
	movq	%rsi, -48(%rbp) // -48(%rbp) = b
	movl	$0, -20(%rbp) // -20(%rbp) = i = 0
.L3:
	cmpl	$49999999, -20(%rbp)
	jg	.L2
	movl	-20(%rbp), %eax // %eax = i
	cltq
	leaq	0(,%rax,8), %rdx // %rdx = 8 * i
	movq	-40(%rbp), %rax // %rax = a
	leaq	(%rdx,%rax), %rbx // %rbx = a + 8 * i
	call	rand // %xmm0 = случайное число
	pxor	%xmm0, %xmm0 // зануление %xmm0
	cvtsi2sd	%eax, %xmm0 // %xmm0 = c
	movsd	.LC0(%rip), %xmm1 // %xmm1 = const1 
	mulsd	%xmm1, %xmm0 // %xmm0 = const1 * r1
	movsd	.LC1(%rip), %xmm1 // %xmm1 = const2
	divsd	%xmm1, %xmm0 // %xmm0 = const1 * r1 / const2
	movsd	.LC2(%rip), %xmm1 // %xmm1 = const3
	subsd	%xmm1, %xmm0 // %xmm0 = const1 * r1 / const2 - const3
	movsd	%xmm0, (%rbx) // (%rbx) = a[i] = const1 * r1 / const2 - const3
	movl	-20(%rbp), %eax // %eax = i
	cltq
	leaq	0(,%rax,8), %rdx // %rdx = 8 * i
	movq	-48(%rbp), %rax // %rax = b
	leaq	(%rdx,%rax), %rbx // %rbx = b + 8 * i
	call	rand
	pxor	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0 // %xmm0 = b
	movsd	.LC0(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	.LC1(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	.LC2(%rip), %xmm1
	subsd	%xmm1, %xmm0
	movsd	%xmm0, (%rbx) // b[i] = const1 * r2 / const2 - const3
	addl	$1, -20(%rbp) // i++
	jmp	.L3
.L2:
	movl	$0, %eax
	addq	$40, %rsp
	popq	%rbx
	popq	%rbp
.LCFI3:
	ret
.LFE2:
	.size	_Z5func1PdS_, .-_Z5func1PdS_
	.globl	_Z5func2PdS_
	.type	_Z5func2PdS_, @function
_Z5func2PdS_:
.LFB3:
	pushq	%rbp
.LCFI4:
	movq	%rsp, %rbp
.LCFI5:
	subq	$48, %rsp // резервируем 48 байт
	movq	%rdi, -24(%rbp) // -24(%rbp) = a
	movq	%rsi, -32(%rbp) // -32(%rbp) = b
				// создание локальных копий указателей a и b
	pxor	%xmm0, %xmm0 // %xmm0 = 0
	movsd	%xmm0, -8(%rbp) // -8(%rbp) = %xmm0 = 0 = x 
	movl	$0, -12(%rbp) // -12(%rbp) = i = 0
.L7:
	cmpl	$49999999, -12(%rbp)
	jg	.L6 // -12(%rbp) = i > 4999999 (конец цикла for)
	movl	-12(%rbp), %eax // %eax = -12(%rbp) = i 
	cltq
	leaq	0(,%rax,8), %rdx // %rdx = 8 * %rax = -12(%rbp) * 8 = 8 * i
	movq	-24(%rbp), %rax // %rax = -24(%rbp) = a
	addq	%rdx, %rax // %rax = %rax + %rdx = a + 8 * -12(%rbp) = a+8*i
			      берем i-ый элемент массив
	movq	(%rax), %rax // %rax = a[i]
	movq	%rax, -40(%rbp) // -40(%rbp) = a[i]
	movsd	-40(%rbp), %xmm0 // %xmm0 = a[i]
	call	sin
	movapd	%xmm0, %xmm1 // xmm1 = sin(a[i])
	movsd	.LC4(%rip), %xmm0 
	mulsd	%xmm0, %xmm1
	movsd	%xmm1, -40(%rbp) // -40(%rbp) = sin(a[i]) * 
	movl	-12(%rbp), %eax // %eax = i
	cltq
	leaq	0(,%rax,8), %rdx // %rdx = 8*i
	movq	-32(%rbp), %rax // %rax = b
	addq	%rdx, %rax // %rax = 8*i + b
	movq	(%rax), %rax // %rax = b[i]
	movq	%rax, -48(%rbp) // -48(%rbp) = b[i]
	movsd	-48(%rbp), %xmm0 // %xmm0 = b[i]
	call	cos // %xmm0 = cos(b[i])
	mulsd	-40(%rbp), %xmm0 // %xmm0 = sin(a[i])*cos(b[i])
	movsd	-8(%rbp), %xmm1 // %xmm1 = x 
	addsd	%xmm1, %xmm0 // %xmm0 = x + sin(a[i])*cos(b[i])
	movsd	%xmm0, -8(%rbp) // x += sin(a[i])*cos(b[i]) 
	addl	$1, -12(%rbp) // i++
	jmp	.L7
.L6:
	movsd	-8(%rbp), %xmm0
	leave
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
.LFB4:
	pushq	%rbp
.LCFI7:
	movq	%rsp, %rbp // пролог
.LCFI8:
	subq	$48, %rsp // резервируем 48 байт под локальные
			     переменные в функции main
	pxor	%xmm0, %xmm0 // %xmm0 = 0
	movsd	%xmm0, -24(%rbp) // -24(%rbp) = 0
	movl	$400000000, %edi // 
	call	_Znam // выделение динамической памяти под массив
			 unsgined long, судя по всему указатель на массив
			 хранится в %rax
	movq	%rax, -16(%rbp) // -16(%rbp) = указатель на первый массив (a)
	movl	$400000000, %edi // !!!!
	call	_Znam // выделение динамической памяти ____|____
	movq	%rax, -8(%rbp) // -8(%rbp) = указатель на второй массив (b)
	movq	-8(%rbp), %rdx // %rdx = b
	movq	-16(%rbp), %rax// %rax = a
	movq	%rdx, %rsi // %rsi = b
	movq	%rax, %rdi // %rdi = a
	call	_Z5func1PdS_
	movq	-8(%rbp), %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, %rsi // %rsi = b
	movq	%rax, %rdi // %rdi = a
	call	_Z5func2PdS_
	movq	%xmm0, %rax // %rax = сумма произвед син и кос
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, -40(%rbp)
	movsd	-40(%rbp), %xmm0
	movl	$.LC5, %edi
	movl	$1, %eax
	call	printf
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	_ZdlPv
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	_ZdlPv
	movl	$0, %eax
	leave
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
