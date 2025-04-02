	.file	"main.c"
	.text
	.globl	calculateRoot
	.type	calculateRoot, @function
calculateRoot:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -36(%rbp) ; number
	movl	$0, -24(%rbp) ; result
	movl	-36(%rbp), %eax
	movl	%eax, -20(%rbp); remainder = number
	movl	$15, -16(%rbp); i = 15
	jmp	.L2 ; jump to for
.L4: ; for body
	movl	-16(%rbp), %eax 
	movl	$1, %edx
	movl	%eax, %ecx
	sall	%cl, %edx ; bit shift by i positions
	movl	%edx, %eax
	movl	%eax, -12(%rbp)
	movl	-24(%rbp), %eax
	orl	-12(%rbp), %eax ; result xor bit
	movl	%eax, -8(%rbp)
	movl	-16(%rbp), %eax
	addl	$1, %eax ; i + 1
	movl	-24(%rbp), %edx
	movl	%eax, %ecx
	sall	%cl, %edx ; result << (i + 1)
	movl	-16(%rbp), %eax
	addl	%eax, %eax ; i << 1
	movl	$1, %esi
	movl	%eax, %ecx
	sall	%cl, %esi ; 1 << (i << 1)
	movl	%esi, %eax
	addl	%edx, %eax ; (i + 1)) + (1 << (i << 1))
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	cmpl	%eax, -20(%rbp) ; if
	jb	.L3
	movl	-8(%rbp), %eax ; if body
	movl	%eax, -24(%rbp); result = tmp
	movl	-4(%rbp), %eax
	subl	%eax, -20(%rbp); remainder -= delta
.L3:
	subl	$1, -16(%rbp) ; i--
.L2: ; for
	cmpl	$0, -16(%rbp) ; i >= 0
	jns	.L4 ; jump to for body
	movl	-24(%rbp), %eax ; result
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	calculateRoot, .-calculateRoot
	.section	.rodata ; data
.LC0:
	.string	"\320\222\320\262\320\265\320\264\320\270\321\202\320\265 \321\207\320\270\321\201\320\273\320\276: "
.LC1:
	.string	"%u"
.LC2:
	.string	"%u\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT ; print first message
	leaq	-16(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT ; read from user
	movl	-16(%rbp), %eax
	movl	%eax, %edi
	call	calculateRoot; call func
	movl	%eax, -12(%rbp)
	movl	-12(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT ; print result
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L8
	call	__stack_chk_fail@PLT
.L8:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident	"GCC: (GNU) 14.2.1 20250207"
	.section	.note.GNU-stack,"",@progbits
