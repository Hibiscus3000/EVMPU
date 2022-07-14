	.file	"lab2.c" 
	.text // секция кода
	.globl	LeibnizFormula // глобальная область
	.type	LeibnizFormula, @function // 
LeibnizFormula:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6 // конец пролога
	movq	%rdi, -40(%rbp) // -40(%rbp) = N создание локальной переменной
	pxor	%xmm0, %xmm0 // %xmn0 = 0;
	movsd	%xmm0, -24(%rbp) // %xmn0 = 0; судя по всему там будет лежать Pi
	movq	$0, -8(%rbp) // -8(%rbp) = i = 0;
	jmp	.L2
.L5:
	movq	-8(%rbp), %rax // %rax = i;
	andl	$1, %eax // %eax = i % 2;
	testq	%rax, %rax // (i % 2) & (i % 2) - проверяем i на четность
	je	.L3
	movsd	.LC1(%rip), %xmm0
	movsd	%xmm0, -16(%rbp) // в -16(%rbp) должна быть положена -1
	jmp	.L4
.L3:
	movsd	.LC2(%rip), %xmm0 
	movsd	%xmm0, -16(%rbp) // В -16(%rbp) должна быть положена единица 
.L4:
	pxor	%xmm0, %xmm0 // %xmm0 = 0;
	cvtsi2sdq	-8(%rbp), %xmm0 // преобразование i в double
	addsd	%xmm0, %xmm0 // %xmm0 = i + i addsd - скалярное сложение double
	movsd	.LC2(%rip), %xmm1 // в %xmm1 лежит единица
	addsd	%xmm1, %xmm0 // %xmm0 = i + i + 1
	movsd	-16(%rbp), %xmm1 // в xmm1 лежит nextMember (либо 1, либо -1, в зависимости от четности члена)
	divsd	%xmm0, %xmm1 // divsd - скалярное деление double %xmm1 = nextMember\(2*i + 1)
	movapd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp) // в -16(%rbp) лежит "готовый" nextMember
	movsd	-24(%rbp), %xmm0 // %xmm0 = Pi;
	addsd	-16(%rbp), %xmm0 // %xmm += nextMember;
	movsd	%xmm0, -24(%rbp) // %xmm0 = Pi; (прибавили к Pi следующий член ряда) 
	addq	$1, -8(%rbp) // i++
.L2:
	movq	-8(%rbp), %rax // %rax = i;
	cmpq	-40(%rbp), %rax // сравнение N и i
	jl	.L5 // если i < N, то переходим на следующую итерацию цикла
	movsd	-24(%rbp), %xmm1 // %xmm1 = Pi;
	movsd	.LC3(%rip), %xmm0 // movsd перемещение скалярного double, должно быть %xmm0 = 4;
	mulsd	%xmm1, %xmm0 // %xmm0 = 4*Pi;
	movsd	%xmm0, -24(%rbp) // -24(%rbp) = Pi
	movsd	-24(%rbp), %xmm0 // %xmm0 = Pi;
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	LeibnizFormula, .-LeibnizFormula
	.globl	fromCharToInt
	.type	fromCharToInt, @function
fromCharToInt:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, %eax // в %al лежит argv[1][i], в %ah либо 1, либо 0, в зависимости от знака argv[1][i]
	movb	%al, -4(%rbp) // -4(%rbp) = argv[1][i] 
	movsbl	-4(%rbp), %eax // в %al лежит argv[1][i], в %ah либо 1, либо 0, в зависимости от знака argv[1][i] ****
	subl	$48, %eax // %eax = c - '0'
	popq	%rbp // эпилог
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	fromCharToInt, .-fromCharToInt
	.globl	getN
	.type	getN, @function
getN:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp) // создание локальной копии argv[1], она лежит в -24(%rbp)
	movq	-24(%rbp), %rax // в %rax лежит argv[1], хотя оно до этого там и лежало **
	movq	%rax, %rdi // в %rdi лежит argv[1], хотя оно до этого там и лежало  **
	call	strlen // в %eax лежит результат работы strlen
	movl	%eax, -12(%rbp) // то есть теперь в -12(%rbp) лежит результат работы strlen: -12(%rbp) = lengthN;
	movq	$0, -8(%rbp) // N = 0; также создание локальных переменных
	movl	$0, -16(%rbp) // i = 0; 
	jmp	.L10
.L11:
	movl	-16(%rbp), %eax // %eax = i; 
	movslq	%eax, %rdx // %rdx = i;
	movq	-24(%rbp), %rax // %rax = argv[1];
	addq	%rdx, %rax // %rax = argv[1] + i;
	movzbl	(%rax), %eax // %eax = argv[1][i]
	movsbl	%al, %eax // в %al лежит argv[1][i], в %ah либо 1, либо 0, в зависимости от знака argv[1][i]
	movl	%eax, %edi
	call	fromCharToInt
	cltq // на данный момент в %rax лежит первая цифра числа N ???
	addq	%rax, -8(%rbp) /*
	movq	-8(%rbp), %rdx *****
	movq	%rdx, %rax */ // сохранили в %rdx, чтобы потом прибавить
	salq	$2, %rax // сдвигаем на 2 влево %rax = 4*N
	addq	%rdx, %rax // %rax = 4*N + N = 5*N
	addq	%rax, %rax // %rax = %rax + %rax = 10*N
	movq	%rax, -8(%rbp) // -8(%rbp) = 10*N
	addl	$1, -16(%rbp) // i++;
.L10:
	movl	-16(%rbp), %eax // %eax = i;
	cmpl	-12(%rbp), %eax // i (%eax) - lengthN (-12(%rbp))
	jl	.L11 // если lengthN > i переходм на следующую итерацию цикла 
	movq	-8(%rbp), %rax // %rax = N; (N посчитано)
	leave // movq %rbp, %rsp; popq %rbp
	.cfi_def_cfa 7, 8
	ret // возвращаемся в main
	.cfi_endproc
	
	
.LFE2:
	.size	getN, .-getN
	.section	.rodata
.LC4:
	.string	"%f\n"
	.text
	.globl	printAnswer
	.type	printAnswer, @function
	
	
	
	
printAnswer:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movsd	%xmm0, -8(%rbp) // -8(%rbp) = Pi;
	movq	-8(%rbp), %rax
	movq	%rax, -16(%rbp) // -16(%rbp) = Pi;
	movsd	-16(%rbp), %xmm0
	movl	$.LC4, %edi 
	movl	$1, %eax
	call	printf
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	printAnswer, .-printAnswer
	.globl	main
	.type	main, @function
	
	
	
main:
.LFB4:
	.cfi_startproc // задаёт начало процедуры и устанавливает начальный регистр и смещение для расчёта адреса CFA (Canonical Frame Address)
	pushq	%rbp // сохраняем указатель базы кадра стека в стеке, %esp-=4
	.cfi_def_cfa_offset 16 // обновляет смещение CFA, говоря, что оно стало равно 16 относительно заданного (директивой .cfi_startproc) регистра (%rsp)
	.cfi_offset 6, -16 // говорит, что теперь регистр 6 лежит по смещению -16 от CFA (таким образом была описана инструкция pushq %rbp).
	movq	%rsp, %rbp // кладем адрес вершины стека в указатель на базу кадра стека
	.cfi_def_cfa_register 6 // говорит, что теперь для расчёта адреса CFA используется регистр 6.
	
	
	
	subq	$48, %rsp 
	movl	%edi, -20(%rbp) // -20(%rbp) = argc; ??
	movq	%rsi, -32(%rbp)  // -32(%rbp) = argv; ??
	movq	-32(%rbp), %rax // %rax = argv = &argv[0]
	addq	$8, %rax // %rax += 8 = argv + 8 = &argv[1];
	movq	(%rax), %rax // %rax = argv[1] (т.е. N)
	movq	%rax, %rdi // %rdi = argv[1]
	call	getN // вызов подпрограммы getN
	movq	%rax, -16(%rbp) // -16(%rbp) = N;
	movq	-16(%rbp), %rax // %rax = N; ****
	movq	%rax, %rdi // %rdi = N;
	call	LeibnizFormula // вызов подпрограммы LeibnizFormula
	movq	%xmm0, %rax // %rax = Pi;
	movq	%rax, -8(%rbp) // -8(%rbp) = Pi;
	movq	-8(%rbp), %rax 
	movq	%rax, -40(%rbp) // -40(%rbp) = Pi создали копию для printAnswer??
	movsd	-40(%rbp), %xmm0
	call	printAnswer // вызов подпрограммы printAnswer
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC1:
	.long	0
	.long	-1074790400
	.align 8
.LC2:
	.long	0
	.long	1072693248
	.align 8
.LC3:
	.long	0
	.long	1074790400
	.ident	"GCC: (Ubuntu 5.5.0-12ubuntu1~16.04) 5.5.0 20171010"
	.section	.note.GNU-stack,"",@progbits
