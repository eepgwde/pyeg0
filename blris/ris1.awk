BEGIN { FS = "\n"; RS = "\n\n" }

NF > 0 {
    for (i=1; i<=NF; i++) {
        split($i, x, " - ", seps);
        if (x[1] ~ /ER/) { print $i; print ""; continue }
        if (x[1] !~ /AU/) { print $i; continue }

        if (x[1] ~ /AU/) {
            split(x[2], y, "|");
            for (idx in y) {
                tag=y[idx]
                printf("AU - %s\n", tag)
            }
        }
    }
}


