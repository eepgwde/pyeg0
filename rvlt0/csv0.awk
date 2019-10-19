#!/usr/bin/gawk -f

# BEGIN { FPAT = "([^,]+)|(\"[^\"]+\")" }
BEGIN { FPAT = "([^,]*)|(\"[^\"]*\")" }

{ print NF }
