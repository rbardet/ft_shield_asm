section .data
    LOCK_FILE dq "ft_shield.lock", 0
    LOCK_ERROR dq "daemon already running", 10
    LOCK_ERROR_LEN equ $ - LOCK_ERROR
    O_CREAT equ 0100
    LOCK_EX equ 1
    F_OK equ 0

section .text
    global create_lock
    global existing_lock
    extern exit
    extern print_error
    extern SYS_OPEN
    extern SYS_FLOCK
    extern SYS_CLOSE
    extern SYS_ACCESS

create_lock:
    mov rax, SYS_OPEN
    mov rdi, LOCK_FILE
    mov rsi, O_CREAT
    mov rdx, 0644
    syscall
    cmp rax, 0
    jl .err_open
    mov rdi, rax
    mov rsi, LOCK_EX
    mov rax, SYS_FLOCK
    syscall
    cmp rax, 0
    jne .err_lock
    mov rax, SYS_CLOSE
    syscall
    xor rax, rax
    ret
.err_open:
    mov rax, 1
    call exit
    ret
.err_lock:
    mov rax, 2
    call exit
    ret

existing_lock:
    mov rax, SYS_ACCESS
    mov rdi, LOCK_FILE
    mov rsi, F_OK
    syscall
    cmp rax, 0
    je .err_lock_exist
    ret
.err_lock_exist:
    mov rsi, LOCK_ERROR
    mov rdx, LOCK_ERROR_LEN
    call print_error
    call exit