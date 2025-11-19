NAME = ft_shield

ASM = nasm
ASM_FLAGS = -f elf64 -g
DEBUG_FLAGS = -F dwarf

SOURCES = srcs/start.s \
	srcs/ft_shield.s \
	srcs/lock.s \
	srcs/init_server.s \
	srcs/init_epoll.s \
	srcs/run_server.s

OBJECTS = ${SOURCES:.s=.o}

ENTRY = _start
LINKER = ld
LINK_FLAGS = -m elf_x86_64

INCLUDES = -I includes/
all: ${NAME}

%.o: %.s
	${ASM} ${ASM_FLAGS} ${INCLUDES} $< -o $@

${NAME}: ${OBJECTS}
	${LINKER} ${LINK_FLAGS} -e ${ENTRY} -o ${NAME} ${OBJECTS}

debug: ${NAME}

%.o: %.s
	${ASM} ${ASM_FLAGS} ${DEBUG_FLAGS} ${INCLUDES} $< -o $@

${NAME}: ${OBJECTS}
	${LINKER} ${LINK_FLAGS} -e ${ENTRY} -o ${NAME} ${OBJECTS}

clean:
	rm -f ${OBJECTS}

fclean: clean
	rm -f ${NAME}

re: fclean all

.PHONY: all debug clean fclean re
