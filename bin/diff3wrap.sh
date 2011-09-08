#!/bin/sh

# Configure your favorite diff3/merge program here.
DIFF3="/usr/bin/vimdiff"

# Subversion provides the paths we need as the ninth, tenth, and eleventh 
# parameters.
MINE=${9}
OLDER=${10}
YOURS=${11}

# Call the merge command (change the following line to make sense for
# your merge program).
$DIFF3 $OLDER $MINE $YOURS

# After performing the merge, this script needs to print the contents
# of the merged file to stdout.  Do that in whatever way you see fit.
# Return an errorcode of 0 on successful merge, 1 if unresolved conflicts
# remain in the result.  Any other errorcode will be treated as fatal.

