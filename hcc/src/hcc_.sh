test -f ~/etc/csv.sh && . ~/etc/csv.sh

X_EMACS=emacs

T_DIR=/cache/incoming/hcc


d_ln0 () {
    : ${d_dir:=$T_DIR/Uploaded\ Data}

    cd bak
    
    cat "$d_dir/lsoa.lst" | ( IFS=":"; while read i j; do ln -sf "$d_dir/$j" "$i"; done; )
}

d_2csv () {
    test $# -ge 1 || return 1
    local e_cmd=$1

    # local t_file=$(mktemp)
    # f_tpush $t_file

    case $e_cmd in
	weather0)
	    sed -e 's/Provisional,$//g' | sed -e 's/\*//g' -e 's/---//g' -e 's/,$//g' 
	    ;;

	weather)
	    awk '{ for (i=1; i<=NF; i++) printf("%s,", $i); printf("\n") }' 
	    ;;
	
	defects)
	    ## This has .0 on the end of a couple of fields.
	    awk -F, 'BEGIN { OFS="," } NR > 1 { gsub(/\.0$/, "", $2); gsub(/""/, "", $6); gsub(/.0/, "", $6) }
{ print }'
	    ;;
	
	*)
	    cat $1
	    ;;
    esac
}

d_prp () {
    test $# -ge 1 || return 1

    case $1 in
	all)
            echo ${S_PRS[@]}
            ;;
	[0-9])
            echo ${S_PRS[$1]}
            ;;
    esac
}

d_rpart () {
    test $# -ge 1 || return 1

    : ${d_file:=xroadsc}
    : ${d_dir:=results}

    local e_cmd=$1
    shift
    
    case $e_cmd in
	archive)
	    test -d ${d_dir} || mkdir ${d_dir}

	    local ttag="$(date +%Y-%m-%d-%H%M)"
	    local rtag=$RANDOM
	    local tfile1=${d_dir}/$d_file-${ttag}-${rtag}.zip

	    $nodo zip $tfile1 *-*-0??.tiff *-*-0??.txt

	    $nodo rm -f *-*-0??.tiff *-*-0??.txt
	    ;;

	one)
	    local cls0="$1"
	    rm -f ${d_file}-${cls0}.dat
            make -f model.mk ${nodo:+"-n"} TARGET=$d_file CLS0="$cls0" all 
	    ;;

	all0)
	    $FUNCNAME one cwy2-poi-weather
	    $FUNCNAME one cwy2-lsoa-poi
	    $FUNCNAME archive
	    ;;

	all1)
	    $FUNCNAME one cwy0
	    $FUNCNAME one cwy2-fworks-bworks
	    $FUNCNAME one cwy3-fworks-bworks
	    $FUNCNAME one cwy2-fworks-bworks-weather
	    $FUNCNAME one cwy3-fworks-bworks-weather
	    $FUNCNAME archive
	    ;;

	enq)
	    $FUNCNAME one cwy0
	    $FUNCNAME one enq1
	    $FUNCNAME one enq2
	    $FUNCNAME one cwy0-enq2
	    $FUNCNAME archive
	    ;;
	
	all)
	    $FUNCNAME one cwy0
	    $FUNCNAME one cwy2-fworks
	    $FUNCNAME one cwy3-fworks
	    $FUNCNAME one cwy2-fworks-weather
	    $FUNCNAME one cwy3-fworks-weather
	    $FUNCNAME archive
            ;;

	batch)
	    test -n "$d_service" || return
	    for i in out/xsamples?.csv
	    do
		make -B ${nodo:+"-n"} -f model.mk S_FILE=$i all-local0
		$FUNCNAME $d_service
	    done
	    ;;

    esac
}

d_br8 () {
     test $# -ge 1 || return 1

    : ${d_file:=xroadsc}

    local e_cmd=$1
    shift
    
    case $e_cmd in
	one)
	    local ttag="$(date +%Y-%m-%d-%H%M)"
	    local tfile=$(basename $(filebase $1))
	    local lfile=${tfile}-smote.log

	    make -f model.mk -B ${nodo:+"-n"} TARGET=$d_file S_FILE=$1 all-local8 2>&1 | tee $lfile
	    $nodo zip ${tfile}-${ttag} ${d_file}*-ml-*.jpeg $lfile ${d_file}-8.dat
	    ;;

	all)
	    for i in $(ls -d out/xsamples*.csv | egrep -v 6 | tac)
	    do
		$FUNCNAME one $i
	    done
	    ;;
    esac

   
}

d_clean () {
     test $# -ge 1 || return 1

    : ${d_file:=xroadsc}

    local e_cmd=$1
    shift
    
    case $e_cmd in
	hcc3|hcc4|hcc5)
	    ls ${e_cmd}-*.zip | egrep -v $(m_ mr ${e_cmd}*.zip) | xargs $nodo rm
	    ;;
	hcc)
	    for i in 3 4 5
	    do
		$FUNCNAME hcc${i}
	    done 2> /dev/null
	    ;;
    esac
}

