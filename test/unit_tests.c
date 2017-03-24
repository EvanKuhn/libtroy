#include "nu_unit.h"

nu_init();

int main(int argc, char **argv) {
  // Parse command-line options accepted by nu_unit
  nu_parse_cmdline(argc, argv);

  // Run test suites
  //nu_run_suite(test_suite__something);

  // Print results and return
  nu_print_summary();
  nu_exit();
}
