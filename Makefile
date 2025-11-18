NAME = ft_shield

ASM = nasm
ASM_FLAGS = -f elf64 -g

SOURCES = srcs/start.s \
	srcs/ft_shield.s \
	srcs/lock.s \
	srcs/syscall.s \

OBJECTS = ${SOURCES:.s=.o}

ENTRY = _start
LINKER = ld
LINK_FLAGS = -m elf_x86_64

all: ${NAME}

%.o: %.s
	${ASM} ${ASM_FLAGS} $< -o $@

${NAME}: ${OBJECTS}
	${LINKER} ${LINK_FLAGS} -e ${ENTRY} -o ${NAME} ${OBJECTS}

clean:
	rm -f ${OBJECTS}

fclean: clean
	rm -f ${NAME}

re: fclean all

.PHONY: all clean fclean re
