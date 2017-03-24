C_UTILS_PROJ_DIR = ext/c-utils
LIBYAML_PROJ_DIR = ext/libyaml
LIBYAML_LIB_FILE = $(LIBYAML_PROJ_DIR)/src/.libs/libyaml.a

INC_FLAGS = -Iinclude -I$(C_UTILS_PROJ_DIR)/include  -I$(LIBYAML_PROJ_DIR)/include
CC=clang-3.8
CFLAGS=-Wall -std=gnu99 $(INC_FLAGS)

SOURCES = $(shell find src -name '*.c') $(shell find ext/c-utils/src -name '*.c')
HEADERS = $(shell find include -name '*.h')
UNIT_TEST_HEADERS = $(shell find test/ -name '*.h')


all: lib/libtroy.a bin/unit_tests

$(LIBYAML_LIB_FILE):
	cd $(LIBYAML_PROJ_DIR) && ./bootstrap && ./configure && make

lib/libtroy.a: $(SOURCES) $(HEADERS) $(LIBYAML_LIB_FILE)
	touch lib/libtroy.a # TODO

bin/unit_tests: test/unit_tests.c $(UNIT_TEST_HEADERS) $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) -o $@ $< $(SOURCES) $(LIBYAML_LIB_FILE)

test: bin/unit_tests
	./bin/unit_tests -c

.PHONY: clean
clean:
	rm -fv bin/*
	rm -fv lib/*
