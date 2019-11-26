BEGIN { FS = "\n"; RS = "\n\n" }

NF > 0 { print "";
    idx=-1;
    for (i=1; i<=NF; i++) {
        split($i, x, " - ", seps);
        if (x[1] ~ /^TY/) {
            idx=i
            break
        }
    }

    print $idx;
    for (i=1; i<=NF; i++)
        if (i!=idx) print $i;
}


