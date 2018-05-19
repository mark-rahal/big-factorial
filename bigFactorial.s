@ Big Factorial.s
@ Calculates factorials up to 100
@ Mark Rahal

@ Define Raspberry Pi
        .cpu 	cortex-a53
	.fpu	neon-fp-armv8
	.syntax unified

@ data section
	.data
prompt: .asciz "Enter a number : "
integer: .asciz "%d"
newline: .asciz "\n"
@ program code
        .text
	.align 2
	.global main
	.type 	main, %function

main:
	push	{lr}

	ldr	r0, =prompt
	bl	printf

	mov	r0, #8
	bl	malloc
	mov	r3, r0 @address of the first node of result--> r3
	mov	r6, r3
	mov	r5, #1
	str	r5, [r3, #0] @ add 1 the first node of the list

	mov	r5, #2 @number we will multiply the the list by

	sub     sp, sp, #4
        ldr     r0, =integer
        mov     r1, sp
        bl      scanf
        ldr     r5, [sp]
        add     sp, sp, #4
        @sub     r1, r1, #1

mult:
	mov	r0, #8
	bl 	malloc
	mov	r4, r0 @address of the first node of temp--> r4
	mov	r1, r4 @copy address of temp to r1
	mov	r3, #1
	mov     r9, #0 @carry = 0

loop1:
	ldr	r7, [r6, #0]
	ldr	r8, [r6, #4]
	mul	r7, r7, r5
	add	r7, r7, r9 @ scalar * current digit + carry

	mov	r0, #10
	sdiv	r9, r7, r0 @ new carry
	mul	r10, r9, r0
	sub	r10, r7, r10 @ digit to be placed in list

	mov	r0, #8
	push	{r1}
	push	{r3}
	bl	malloc
	pop	{r3}
	pop	{r1}
	mov	r2, r0

	str	r2, [r1, #4]
	mov	r1, r2
	str	r10, [r1, #0]
	cmp	r3, #1
	beq	newFirstNode
	b	loop2

newFirstNode:
	mov	r4, r1
	mov	r3, #0

loop2:
	cmp	r8, #0
	beq	carryLoop
	ldr	r6, [r6, #4]
	b	loop1

carryLoop:
	cmp	r9, #0
	beq	mult3
	mov	r3, #10
	mov	r7, r9
	sdiv	r9, r7, r3
	mul	r10, r9, r3
	sub	r7, r7, r10
	push	{r1}
	mov	r0, #8
	bl	malloc
	pop	{r1}
	mov	r2, r0
	str	r2, [r1, #4]
	mov	r1, r2
	str	r7, [r1, #0]
	b	carryLoop
mult3:
	mov	r3, r4 @result = temp
	mov	r6, r3
	sub	r5, r5, #1

	cmp	r5, #0
	bne	mult
printLoop:
	ldr     r7, [r6, #0]
        ldr     r8, [r6, #4]

        ldr     r0, =integer
        mov     r1, r7
        bl      printf

	cmp	r8, #0
	beq	exit

        ldr     r6, [r6, #4]
        b       printLoop

exit:
	ldr	r0, =newline
	bl	printf

	pop	{pc}
	bx	lr

