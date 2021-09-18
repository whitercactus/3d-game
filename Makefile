UNAME_S = $(shell uname -s)

CC = clang++
CFLAGS = -std=c++17 -DSFML_STATIC -O3 -g -Wall -Wextra -Wpedantic -Wstrict-aliasing
CFLAGS += -Wno-pointer-arith -Wno-newline-eof -Wno-unused-parameter -Wno-gnu-statement-expression
CFLAGS += -Wno-gnu-compound-literal-initializer -Wno-gnu-zero-variadic-macro-arguments
CFLAGS += -Ideps/glfw/include -Ideps/glad/include -Ideps/glm -Ideps/SFML/include -Ideps/json
CFLAGS += -Ideps -Isrc -fbracket-depth=1024
LDFLAGS = deps/glfw/src/libglfw3.a deps/SFML/lib/*.dylib deps/glad/src/glad.o -lm

# GLFW required frameworks on OSX
ifeq ($(UNAME_S), Darwin)
	LDFLAGS += -framework OpenGL -framework IOKit -framework CoreVideo -framework Cocoa
endif

ifeq ($(UNAME_S), Linux)
	LDFLAGS += -ldl -lpthread
endif

SRC  = $(wildcard src/**/*.cpp) $(wildcard src/*.cpp) $(wildcard src/**/**/*.cpp) $(wildcard src/**/**/**/*.cpp)
OBJ  = $(SRC:.cpp=.o)
BIN = bin

.PHONY: all clean

all: dirs libs game

libs:
	cd deps/glfw && cmake . && make
	cd deps/glad && $(CC) -o src/glad.o -Iinclude -c src/glad.c

dirs:
	mkdir -p ./$(BIN)
	cd

run: all
	$(BIN)/game

game: $(OBJ)
	$(CC) -o $(BIN)/game $^ $(LDFLAGS)

%.o: %.cpp
	$(CC) -o $@ -c $< $(CFLAGS)

clean:
	rm -rf $(BIN) $(OBJ)
	clear
