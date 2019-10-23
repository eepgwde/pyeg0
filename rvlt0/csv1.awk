#!/usr/bin/gawk -f

## weaves
# Specifically for the revolut challenge, extract the quoted text field named
# by the number x0 from the CSV input and write it to the file named by text string
# d_file.
# The header at record 1 is preserved.

# BEGIN { FPAT = "([^,]+)|(\"[^\"]+\")" }
BEGIN { FPAT = "([^,]*)|(\"[^\"]*\")"; OFS="," }

NR == 1 { printf("%s\t%s\n", "id", $(x0) ) >> d_file; print; next }
{ printf("%d\t%s\n", $1, $(x0)) >> d_file }
{ $(x0)=""; print }

