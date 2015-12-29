#!/bin/bash
# Wrapper for the AProVE tool.
# Non-termination preserving transformation from Java bytecode to inttrs.

HELP="USAGE: 
  $(basename $0) OPTIONS JAR

 -h, --help             print this help
 -o, --outputDir DIR    directory in which TRSs will be dumped (default '.')
 -t, --timeout SECONDS  timeout, in seconds (default 60)
 -p, --proof            print proof for steps from input to TRSs
 -g, --graph yes|no     export to Graph (default no)
 -s, --simplify yes|no  simplify resulting TRSs (default yes)
 -q, --qdp yes|no       if possible, produce a QDP (default yes), conflicts with other output
 -2, --t2 yes|no        export to T2 transition systems (default no), conflicts with other output
 -c, --clauses yes|no   export to HSF clauses (default no), conflicts with other output
 -a, --pushdown yes|no  export Pushdown automaton (default no), conflicts with other output
 -j, --json yes|no      export JSON (default no), conflicts with other output"

[ -z "$1" ] && echo -e "$HELP" && exit 1

java -ea -cp aprove.jar aprove.CommandLineInterface.JBCFrontendMain --qdp no "$@"

