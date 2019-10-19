#!/usr/bin/gawk -f

# BEGIN { FPAT = "([^,]+)|(\"[^\"]+\")" }
BEGIN { FPAT = "([^,]*)|(\"[^\"]*\")"; OFS="," }

NR == 1 { printf("%s\t%s\n", "id", $(x0) ) >> d_file; print; next }
{ printf("%d\t%s\n", $1, $(x0)) >> d_file }
{ $(x0)=""; print }

