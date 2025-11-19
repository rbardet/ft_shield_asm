%include "ft_shield.inc"

section .data

section .text
    global run_server

run_server:
    jmp run_server
    ret