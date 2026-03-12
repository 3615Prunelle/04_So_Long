# Public Makefile (l'original a été backup)
# Si soucis de compil pour l'éval, make sure que l'ordi sur lequel a été cloné mon repo ait ces libs :
# sudo apt install build-essential libx11-dev libglfw3-dev libglfw3 xorg-dev
# Bien penser à changer path des textures avant eval
NAME = so_long

CC = cc

CFLAGS = -Wall -Wextra -Werror -g  -I. -I ./get_next_line -I ./MLX42/include/MLX42 -I ./libft
LFLAGS = -L ./get_next_line -L ./MLX42/build -L ./libft -lmlx42 -lgetnextline -lglfw -lft #-lglfw goes with mlx42

SRCS = 	./sources/so_long_main_build.c \
		./sources/so_long_graphics.c \
		./sources/so_long_checkers.c \
		./sources/so_long_path_check.c \
		./sources/so_long_misc.c \
		./sources/so_long_handler_bonus.c \
		./sources/so_long_free_functions.c

# Toutes les libs utilisées pour ce projet
MLX42_LIB = ./MLX42/build/libmlx42.a
LIBFT_LIB = ./libft/libft.a
GNL_LIB = ./get_next_line/libgetnextline.a

OBJS = $(SRCS:.c=.o)

all: $(NAME)

# libft fetch/build
$(LIBFT_LIB):
	@if [ ! -d "./libft" ]; then \
		echo "Cloning Libft ..." && \
		git clone https://github.com/3615Prunelle/01_Libft.git libft && \
		echo "Building Libft ..." && \
		cd ./libft && make ; \
	fi

# GNL fetch/build
$(GNL_LIB):
	@if [ ! -d "./get_next_line" ]; then \
		echo "Cloning Get_Next_Line ..." && \
		git clone https://github.com/3615Prunelle/03_Get_Next_Line.git get_next_line && \
		echo "Building Get_Next_Line ..." && \
		cd ./get_next_line && make ; \
	fi

$(NAME): $(MLX42_LIB) $(LIBFT_LIB) $(GNL_LIB) $(OBJS)
	$(CC) $(OBJS) $(LFLAGS) -o $(NAME)

# Dependency of MLX42 to create the .o, otherwise MLX header is not found during compilation
# Trick CMakeLists.txt pour éviter soucis de timestamp / relinks
%.o: %.c ./MLX42/CMakeLists.txt
	$(CC) $(CFLAGS) -c $< -o $@

# Règle pour cloner ET compiler MLX42
$(MLX42_LIB): ./MLX42
		echo "Building MLX42..." && \
		cd ./MLX42 && cmake -B build && cmake --build build -j4 \

# Règle pour cloner MLX42 si le dossier n'existe pas
./MLX42:
		echo "Cloning MLX42..." && \
		git clone https://github.com/codam-coding-college/MLX42.git \

# CMakeLists.txt est créé automatiquement quand MLX42 est cloné
./MLX42/CMakeLists.txt: ./MLX42

clean:
	rm -f $(OBJS)

fclean: clean
	rm -f $(NAME)
	$(MAKE) -C ./libft fclean
	$(MAKE) -C ./get_next_line fclean
	rm -rf ./MLX42
	rm -rf ./libft
	rm -rf ./get_next_line

re: fclean all

.PHONY: all clean fclean re
