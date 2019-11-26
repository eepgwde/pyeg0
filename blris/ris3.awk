BEGIN { FS = "\n"; RS = "\n\n" }

NF > 0 {
    state=0
    nA2=0
    nAU=0

    for (i=1; i<=NF; i++) {
        split($i, x, " - ", seps);
        if (x[1] ~ /A2/ && nA2 == 0) { state=state+1; nA2=1 }
        if (x[1] ~ /AU/ && nAU == 0) { state=state+2; nAU=1 }
    }

    if (state == 1) {
        for (i=1; i<=NF; i++) {
            split($i, x, " - ", seps);
            if (x[1] ~ /ER/) { print $i; print ""; continue }
            if (x[1] ~ /A2/) { sub(/A2/, "AU", $i); print $i; continue }
            print $i
        }
    }

    if (state == 3) {
        for (i=1; i<=NF; i++) {
            split($i, x, " - ", seps);
            if (x[1] ~ /ER/) { print $i; print ""; continue }
            if (x[1] ~ /A2/) { continue }
            print $i
        }
    }
}


