section .text
	global ft_strcmp

ft_strcmp:
    push r15
	XOR rax, rax
	XOR r15, r15
.loop:
	MOV al, [rdi + r15]
	SUB al, [rsi + r15]
	CMP al, 0
	JNE .return
	CMP [rdi + r15], byte 0
	JZ .return
	CMP [rsi + r15], byte 0
	JZ .return
	INC r15
	JMP .loop
.return:
	MOVSX rax, al
    pop r15
	RET