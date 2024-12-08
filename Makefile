PROJECT_NAME = app

PRECC = bear -- ccache

CFLAGS = \
	-O3 -std=c11 -Wall

SRC = \
	src/*.c

DIRS = \
	-Iinclude

LIBS = \

.DEFAULT_GOAL := linux

.PHONY: linux
linux:
	mkdir -p build/linux
	$(PRECC) zig cc --target=x86_64-linux-gnu -Wl,-rpath=. $(CFLAGS) -o build/linux/$(PROJECT_NAME).elf $(SRC) $(DIRS) -Lvendor/linux $(LIBS)

	make run_linux

.PHONY: run_linux
run_linux:
	LD_LIBRARY_PATH=build/linux:$$LD_LIBRARY_PATH ./build/linux/$(PROJECT_NAME).elf

.PHONY: windows
windows:
	mkdir -p build/windows
	$(PRECC) zig cc --target=x86_64-windows-gnu $(CFLAGS) -o build/windows/$(PROJECT_NAME).exe $(SRC) $(DIRS) -Lvendor/windows $(LIBS)

.PHONY: wasm
wasm:
	mkdir -p build/wasm
	$(PRECC) emcc $(CFLAGS) -s WASM=2 -s ALLOW_MEMORY_GROWTH=1 -s ASSERTIONS=0 -o build/wasm/$(PROJECT_NAME).js $(SRC) $(DIRS) -Lvendor/wasm $(LIBS)

	cp web/* build/wasm -rf

	make run_wasm

.PHONY: run_wasm
run_wasm:
	python -m http.server -d build/wasm
