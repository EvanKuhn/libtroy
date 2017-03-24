LIBYAML_PROJ_DIR = ext/libyaml
C_UTILS_PROJ_DIR = ext/c-utils

INC_FLAGS = -Iinclude -I$(C_UTILS_PROJ_DIR)/include  -I$(LIBYAML_PROJ_DIR)/include
CC=gcc
CFLAGS=-std=gnu99

SOURCES = $(shell find src -name '*.c')
HEADERS = $(shell find include -name '*.h')
UNIT_TEST_HEADERS = $(shell find test/ -name '*.h')


all: lib/libtroy.a bin/unit_tests

$(LIBYAML_PROJ_DIR)/src/.libs/libyaml.a:
	cd $(LIBYAML_PROJ_DIR) && ./bootstrap && ./configure && make

lib/libtroy.a: $(SOURCES) $(HEADERS)
	touch lib/libtroy.a # TODO

bin/unit_tests: test/unit_tests.c $(UNIT_TEST_HEADERS) $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) -o $@ $< $(SOURCES)

test: bin/unit_tests
	./bin/unit_tests -c

.PHONY: clean
clean:
	rm -f bin/*
