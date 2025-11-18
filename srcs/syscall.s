section .data
    SYS_WRITE equ 1
    SYS_OPEN equ 2
    SYS_CLOSE equ 3
    SYS_ACCESS equ 21
    SYS_EXIT equ 60
    SYS_FLOCK equ 73
    SYS_GETUID equ 102

section .text
    global SYS_WRITE
    global SYS_OPEN
    global SYS_CLOSE
    global SYS_ACCESS
    global SYS_EXIT 
    global SYS_FLOCK 
    global SYS_GETUID