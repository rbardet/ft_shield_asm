%include "ft_shield.inc"

section .data
	LOGIN dq "rbardet-\n"
	LOGIN_LEN equ $ - LOGIN

section .text
	global _start
	extern ft_shield

_start:
	call ft_shield
	print STD_OUT, LOGIN, LOGIN_LEN
	exit EXIT_SUCCESS