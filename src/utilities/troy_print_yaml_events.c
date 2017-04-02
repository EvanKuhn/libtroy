#include "yaml.h"
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

// Print usage info
void usage()
{
  puts("troy_print_yaml_events");
  puts("    This utility parses a YAML file and prints all parsing events.");
  puts("    Useful for debugging purposes.");
  puts("");
  puts("usage: troy_print_yaml_events <filename>");
}

// Process events. Return 0 on success, 1 on error.
int process_yaml_events(yaml_parser_t* parser)
{
  yaml_event_t event;

  while (true) {
    // Get the next event
    if (!yaml_parser_parse(parser, &event)) {
      fprintf(stderr, "Parser error %d\n", parser->error);
      return 1;
    }

    switch(event.type) {
      case YAML_NO_EVENT:
        break;

      case YAML_STREAM_START_EVENT:
        printf("event: YAML_STREAM_START_EVENT\n");
        break;

      case YAML_STREAM_END_EVENT:
        printf("event: YAML_STREAM_END_EVENT\n");
        return 0;
        break;

      case YAML_DOCUMENT_START_EVENT:
        printf("event: YAML_DOCUMENT_START_EVENT\n");
        break;

      case YAML_DOCUMENT_END_EVENT:
        printf("event: YAML_DOCUMENT_END_EVENT\n");
        break;

      case YAML_ALIAS_EVENT:
        printf("event: YAML_ALIAS_EVENT\n");
        break;

      case YAML_SCALAR_EVENT:
        printf("event: YAML_SCALAR_EVENT (value = '%s')\n", (char*)event.data.scalar.value);
        break;

      case YAML_SEQUENCE_START_EVENT:
        printf("event: YAML_SEQUENCE_START_EVENT\n");

      case YAML_SEQUENCE_END_EVENT:
        printf("event: YAML_SEQUENCE_END_EVENT\n");
        break;

      case YAML_MAPPING_START_EVENT:
        printf("event: YAML_MAPPING_START_EVENT\n");
        break;

      case YAML_MAPPING_END_EVENT:
        printf("event: YAML_MAPPING_END_EVENT\n");
        break;
    }

    // Delete the event after processing
    yaml_event_delete(&event);
  }
}

// Parse the YAML file and print events. Return 0 on success, 1 on error.
int parse_file(char* filepath)
{
  int retval = 1;
  FILE* fh = NULL;
  bool parser_initialized = false;
  yaml_parser_t parser;

  // Open file for reading
  fh = fopen(filepath, "r");
  if(fh == NULL) {
    fputs("Failed to open file!\n", stderr);
    goto cleanup;
  }

  // Initialize parser
  if(!yaml_parser_initialize(&parser)) {
    fputs("Failed to initialize parser!\n", stderr);
    goto cleanup;
  }
  parser_initialized = true;

  // Parse the yaml file
  yaml_parser_set_input_file(&parser, fh);
  retval = process_yaml_events(&parser);

  // Clean up and return
cleanup:
  if (parser_initialized)
    yaml_parser_delete(&parser);
  if (fh)
    fclose(fh);
  return retval;
}

int main(int argc, char** argv)
{
  if (argc < 2) {
    usage();
    return 0;
  }
  return parse_file(argv[1]);
}
