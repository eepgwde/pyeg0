test -f ~/etc/csv.sh && . ~/etc/csv.sh

X_EMACS=emacs

T_DIR=/cache/incoming/tickdata

d_xfld1 () {
  local terr0=${3:=1}
  awk -F, -v idx=$1 -v fdx=$2 -v errlvl=$terr0 'NR ==idx { tag=$(fdx);
  split(tag, x, "/")
  printf("%04d%02d%02d\n", x[3], x[1], x[2])
  exit(0) }' 
  # END { exit(errlvl) }'
}

d_2csv () {
  test $# -ge 1 || return 1
  local e_cmd=$1
  shift

  # local t_file=$(mktemp)
  # f_tpush $t_file

  case $e_cmd in
    splits0)
	    awk -F, '$2 ~ /^[0-9\/]+$/ { print $2 }' $d_file | sort -u
      ;;

	  re0)
      sed -e 's,/,\\\/,g' -e 's|^|/.*,|g' -e 's|$|,.*\/|g'
	    ;;

	  csplit)
      : ${d_dir:=$(dirname $1)}
      local tfile=$(basename $1)
      tfile=${tfile%.*}
      local args0="$(cat $2)"
      echo $2 > $verbose
      echo $args0 > $verbose

	    $nodo csplit -b "_%02d.csv" -f $d_dir/$tfile $1 $args0

	    ;;

    bundle)
      # local tfile=$(mktemp)
      # f_tpush $tfile
      local x0
      : ${d_service:=".csv1"}

      for i in $*
      do
        x0=${i%.*}${d_service}
        cat $d_file $i > $x0
        echo $x0 $(cat $i | d_xfld1 2 2 0)
      done

      ;;

	  defects)
	    ## This has .0 on the end of a couple of fields.
	    awk -F, 'BEGIN { OFS="," } NR > 1 { gsub(/\.0$/, "", $2); gsub(/""/, "", $6); gsub(/.0/, "", $6) }
{ print }'
	    ;;

	  luton1)
	    awk -F, 'BEGIN { OFS="," } 
NF > 11 { tag=""; for (i=11; i<= NF; i++) tag=tag""$i; gsub("[ ]+", " ", tag);
  $11=tag; for (i=12; i<= NF; i++) $i="" }
{ print; next }
'
	    ;;
	  
	  luton)
	    recode l1..ascii | dos2unix | $FUNCNAME luton1 | sed 's/",[,]*$/"/g' 
	    ;;
	  
	  works1)
	    recode l1..ascii | dos2unix 
	    ;;
	  
	  dfctcwy)
	    recode -f u8..ascii | dos2unix 
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

d_hcc () {
  test $# -ge 1 || return 1

  local e_cmd=$1
  shift
  
  case $e_cmd in
	  preds)
	    for i in $(echo $* | xargs -n1 | sort | xargs)
	    do
		    awk -vifile=$i -F, '{ print ifile, $1, $6, $7, $9 }' $i
	    done 
	    ;;
	  models0)
	    local t_file=$(mktemp)
	    f_tpush $t_file

	    ## Do some result post-processing
	    egrep '(start:|Deviance|R\^2|Family:|Link [a-z]+:)' -H $* | dos2unix | awk -F: 'BEGIN { ORS=","; OFS="," } 

function strip(p) {
   gsub(/^[ ]+/, "", p);
   gsub(/[ ]+$/, "", p);
   return p
}

$0 ~ /:start:/ {
  ORS=","
  tag=$1; gsub(/\.Rout$/, "", tag); gsub(/-/, ",", tag); print tag;

  ORS="-"
  OFS=""
  printf("\""); 
  for (i=3; i<=NF; i++) { gsub(/[ ]/, "", $i); gsub(/[,]/, " ", $i); print $i; }
  printf("\","); 
}

$2 ~ /Family/ { ORS=","; print strip($3); }
$2 ~ /Link function/ { ORS=","; print strip($3); }

$2 ~ /^R-sq/ { ORS=","; split($2, x0, " ", seps); for (x in x0) print x0[x]; }

$2 ~ /^R\^2/ { 
  ORS=","
  OFS=","
  for (i=2; i<=NF; i++) { gsub(/[ ]/, "", $i); gsub(/;/, ",", $i); print $i; }
  printf("\n")
}' 

	    # $2 ~ /^Family/ { ORS=","; OFS=","; print $1; printf(",");  }
	    ;;
	  models1)
	    $FUNCNAME models0 | sed -e 's/=,//g' -e 's/,,$//g' -e 's/%//g'
	    ;;

    # 1 gams
    # 2 enq1s
    # 3 repudns
    # 4 "ps-enq1s ps-mm1 ps-tmin ps-tmax ps-dtmax ps-mm1-"
    # 5 R-sq.(adj)
    # 6 0.938
    # 7 Deviance
    # 8 explained
    # 9 95.9
    # 10 R^2
    # 11 0.9384421
    # 12 GCV
    # 13 452.5728
    # 14 AIC
    # 15 512.3689
    # 16 BIC
    # 17 555.3303

	  
	  models)
	    echo "family,input,output,fmla,R-sq,Deviance,R^2,GCV,AIC,BIC"
	    $FUNCNAME models1 | cut --delimiter=',' -f 1,2,3,4,6,9,11,13,15,17,-1
	    ;;
  esac
}    

