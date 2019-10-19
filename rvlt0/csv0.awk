#!/usr/bin/gawk -f

# BEGIN { FPAT = "([^,]+)|(\"[^\"]+\")" }
BEGIN { FPAT = "([^,]*)|(\"[^\"]*\")" }

{ print $8 }
{ print NF }
