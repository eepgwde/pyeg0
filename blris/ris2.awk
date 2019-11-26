BEGIN { FS = "\n"; RS = "\n\n" }

NF > 0 {
    for (i=1; i<=NF; i++) {
        split($i, x, " - ", seps);
        if (x[1] ~ /ER/) { print $i; print ""; continue }
        if (x[1] !~ /A2/) { print $i; continue }

        if (x[1] ~ /A2/) {
            split(x[2], y, "|");
            for (idx in y) {
                tag=y[idx]
                sub(/author/, "", tag)
                sub(/[0-9][0-9][0-9][0-9]/, "", tag)
                gsub(/[\- ]+$/, "", tag)
                printf("A2 - %s\n", tag)
            }
        }
    }
}


