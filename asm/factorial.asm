; build with: nasm factorial.asm -g -o factorial.o -f elf64 -l factorial.lst
; and then:   ld -e _start -o factorial factorial.o
; syscalls reference: https://syscalls.kernelgrok.com/

section .text
global _start		; must be declared for linker (ld)


; convert sting to number. string at ds:rsi, output to rax
atoi:
	xor		rax, rax	; zero rax
	xor		rbx, rbx	; zero rbx
	mov		rcx, 10		; base 10

.next_digit:
	mov		bl, [rsi]	; put the next character in bl
	cmp		bl, 0		; do we have null terminator?
	jz		.exit_atoi	; if so, exit
	sub		bl, '0'		; subtract the character '0'
	js		.exit_atoi	; bail if less than zero
	cmp		bl, cl		; compare to 10
	jge		.exit_atoi	; bail if greater than 9
	mul     rcx			; multiply rax by 10
	add	    rax, rbx	; add next digit
	inc	    rsi			; move to the next digit
	jmp		.next_digit	; and repeat

.exit_atoi:
	ret



; convert rax to string to rdi size in rcx
itoa:
    mov     rsi, rsp    ; copy the stack pointer to rsi
	mov		rbx, 10		; base 10
	cmp		rax, 0		; compare rax to zero
    mov     r8, 0       ; we'll get back to this
	jge		.itoaloop	; skip if positive
	neg		rax			; negate
    mov     r8, 1       ; make a note

.itoaloop:
	xor		rdx, rdx	; zero rdx
	div		rbx			; divide rax by 10, remainder in rdx
	add		dl, '0'		; add '0' to the remainder
    dec     rsi         ; make room for the next char
	mov     byte [rsi], dl	; "push" the next char
	test	rax, rax	; test rax
	jnz		.itoaloop	; if there's something left continue

    test    r8, r8      ; check if r8 is set
    jz      .copyout    ; if it isnt then we're done
    mov     dl, '-'     ; we need to add a minus sign
    dec     rsi         ; make room for the next char
	mov     byte [rsi], dl	; "push" the next char

.copyout:
    mov     rcx, rsp    ; rsi is length smaller than rsp
    sub     rcx, rsi    ; rcx now contains the length
    mov     rbx, rcx    ; save rcx
    rep movsb           ; copy the string to rdi

    mov     rcx, rbx    ; restore rcx
	ret



; factorials rax
factorial:
    test    rax, rax    ; test for special case where rax = 0
    mov     rcx, rax    ; rcx will be our counter
    mov     rax, 1      ; reset rax to 1
    jz      .return
.again:
    mul     rcx         ; multiply rax with rcx
    loop    .again      ; decrease rcx and go again

.return:
    ret



; entrypoint
_start:

	pop		rcx			; get argc
	cmp		rcx, 2		; check how many parameters
	jl		printusage	; print usage if no args
	add		rsp, 8		; skip argv[0]
	pop		rsi			; pop argv[1] -> rsi
	call	atoi		; convert to number -> rax

    call    factorial   ; factorial rax

	mov		rdi, buffer	; rdi points to buffer
	call	itoa		; convert rax to string at buffer

    mov     byte [rdi+rcx], 0ah ; add newline on the end
    inc     rcx         ; increase the length to accomodate
	mov		rsi, buffer ; rsi points to buffer
    mov     rdx, rcx    ; count to rdx
	jmp writef

printusage:
	mov		rsi, usage	; write the usage buffer
	mov		rdx, usage_len ; how many bytes to write

writef:
	mov		rax, 1		; syscall: sys_write
	mov		rdi, 1		; 1 = stdout
	syscall

exit:
	mov		rax, 60		; syscall: sys_exit
	syscall



section .data

buffer		times 30 db 0				; temporary buffer
usage		db 'Usage: factorial n',0ah	; message
usage_len	equ $ - usage				; length of usage