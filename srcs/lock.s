%include "ft_shield.inc"

section .bss
	lockfd resw 2

section .data
	LOCK_FILE dq "ft_shield.lock", 0
	LOCK_ERROR dq "daemon already running", 10
	LOCK_ERROR_LEN equ $ - LOCK_ERROR

section .text
	global create_lock
	global existing_lock

create_lock:
	mov word[lockfd], 0
.open_file:
	mov rax, SYS_OPEN
	mov rdi, LOCK_FILE
	mov rsi, O_CREAT
	mov rdx, 0644
	syscall
	cmp rax, 0
	jl .err_open
	mov [lockfd], rax
.lock_file:
	mov rdi, [lockfd]
	mov rsi, LOCK_EX
	mov rax, SYS_FLOCK
	syscall
	cmp rax, 0
	jne .err_lock
	close_file [lockfd]
	ret
.err_open:
	exit EXIT_FAILURE
.err_lock:
	close_file [lockfd]
	exit EXIT_FAILURE

existing_lock:
	mov rax, SYS_ACCESS
	mov rdi, LOCK_FILE
	mov rsi, F_OK
	syscall
	cmp rax, 0
	je .err_lock_exist
	ret
.err_lock_exist:
	print STD_ERR, LOCK_ERROR, LOCK_ERROR_LEN
	exit EXIT_FAILURE