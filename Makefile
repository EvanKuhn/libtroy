INC_DIR = include
SRC_DIR = src
OBJ_DIR = obj
LIB_DIR = lib
EXT_DIR = ext
BIN_DIR = bin

C_UTILS_PROJ_DIR = ext/c-utils
LIBYAML_PROJ_DIR = ext/libyaml
LIBYAML_LIB_FILE = $(LIBYAML_PROJ_DIR)/src/.libs/libyaml.a
LIBTROY_LIB_FILE = $(LIB_DIR)/libtroy.a

INC_FLAGS = -Iinclude -I$(C_UTILS_PROJ_DIR)/include -I$(LIBYAML_PROJ_DIR)/include
CC=clang-3.8
CFLAGS=-Wall -std=gnu99 $(INC_FLAGS)


HEADERS = $(shell find $(INC_DIR) -name '*.h')
SOURCES = $(shell find $(SRC_DIR) -maxdepth 1 -name '*.c')
OBJECTS = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SOURCES))
UNIT_TEST_HEADERS = $(shell find test/ -name '*.h')


all: lib/libtroy.a bin/unit_tests utilities

utilities: bin/troy_print_yaml_events

#-------------------------------------------------------------------------------
# libyaml
#-------------------------------------------------------------------------------

.PHONY: libyaml
libyaml: $(LIBYAML_LIB_FILE)

$(LIBYAML_LIB_FILE):
	cd $(LIBYAML_PROJ_DIR) && ./bootstrap && ./configure && make

#-------------------------------------------------------------------------------
# libtroy
#-------------------------------------------------------------------------------

.PHONY: bootstrap
bootstrap:
	cp ext/c-utils/include/* $(INC_DIR)
	cp ext/c-utils/src/* $(SRC_DIR)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c bootstrap libyaml
	$(CC) $(CFLAGS) -c $< -o $@ $(INC_FLAGS)

.PHONY: libtroy
libtroy: $(LIBTROY_LIB_FILE)

$(LIBTROY_LIB_FILE): $(OBJECTS)
	ar rcs $@ $(OBJECTS)

#-------------------------------------------------------------------------------
# utilities
#-------------------------------------------------------------------------------

bin/troy_print_yaml_events: src/utilities/troy_print_yaml_events.c libyaml
	$(CC) $(CFLAGS) -o $@ $< $(LIBYAML_LIB_FILE)

#-------------------------------------------------------------------------------
# Tests
#-------------------------------------------------------------------------------

bin/unit_tests: test/unit_tests.c $(UNIT_TEST_HEADERS) $(HEADERS) $(LIBTROY_LIB_FILE)
	$(CC) $(CFLAGS) -o $@ $< $(SOURCES) $(LIBYAML_LIB_FILE) $(LIBTROY_LIB_FILE)

test: bin/unit_tests
	./bin/unit_tests -c

#-------------------------------------------------------------------------------
# Clean / other
#-------------------------------------------------------------------------------

.PHONY: clean
clean:
	rm -fv $(BIN_DIR)/*
	rm -fv $(LIB_DIR)/*
	rm -fv $(OBJ_DIR)/*
