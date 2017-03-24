#pragma once

#include <stdbool.h>
#include "c-utils/hash.h"

// Node data types
typedef enum troy_node_type {
  TROY_NODE_TYPE_UNDEF = 0,  // No type yet specified
  TROY_NODE_TYPE_INT,        // Integer
  TROY_NODE_TYPE_FLT,        // Floating point
  TROY_NODE_TYPE_STR,        // String
  TROY_NODE_TYPE_SEQ,        // Sequence
  TROY_NODE_TYPE_MAP         // Map (string to node)
} troy_node_type_t;

// Forward declare the node struct so it can refer to itself internallys
struct troy_node_s;
typedef struct troy_node_s troy_node_t;

// The node struct has a type and a value of that type
struct troy_node_s {
  troy_node_t* parent;
  troy_node_type_t type;

  union {
    // Scalar value types
    int     intval;
    double  fltval;
    char*   strval;

    // Map of (string,troy_node_t) pairs
    hash_t* map;

    // Sequence of nodes
    struct {
      troy_node_t** items;
      size_t length;
    } seq;

  } data;
};

// Parse a yaml document and get the root node
troy_node_t* troy_parse_file(char* filepath);

// Free a node and all internal data. Will free all child nodes.
void troy_node_delete(troy_node_t* node);

// Check node types
bool troy_node_is_undef(troy_node_t* node);
bool troy_node_is_int  (troy_node_t* node);
bool troy_node_is_flt  (troy_node_t* node);
bool troy_node_is_str  (troy_node_t* node);
bool troy_node_is_seq  (troy_node_t* node);
bool troy_node_is_map  (troy_node_t* node);

// Get child nodes
troy_node_t* troy_seq_at(troy_node_t* node, int index);
troy_node_t* troy_map_find(troy_node_t* node, char* key);

// Get node values
char*  troy_node_get_str(troy_node_t* node);
int    troy_node_get_int(troy_node_t* node);
double troy_node_get_flt(troy_node_t* node);

// Utilities
char* troy_node_type_to_string(troy_node_type_t type);
