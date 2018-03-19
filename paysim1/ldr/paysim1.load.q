/ 2018.03.19T17:17:57.944 peppy weaves
/ q paysim1.load.q FILE [-bl|bulkload] [-bs|bulksave] [-js|justsym] [-exit] [-savedb SAVEDB] [-saveptn SAVEPTN] [-savename SAVENAME] 
/ q paysim1.load.q FILE
/ q paysim1.load.q
/ q paysim1.load.q -help
FILE:LOADFILE:`$":../cache/in/paysim1.csv"
o:.Q.opt .z.x;if[count .Q.x;FILE:hsym`${x[where"\\"=x]:"/";x}first .Q.x]
if[`help in key o;-1"usage: q paysim1.load.q [FILE(default:../cache/in/paysim1.csv)] [-help] [-bl|bulkload] [-bs|bulksave] [-js|justsym] [-savedb SAVEDB] [-saveptn SAVEPTN] [-savename SAVENAME] [-af|asfile] [-exit]\n";exit 1]
SAVEDB:`:csvdb
SAVEPTN:`
if[`savedb in key o;if[count first o[`savedb];SAVEDB:hsym`$first o[`savedb]]]
if[`saveptn in key o;if[count first o[`saveptn];SAVEPTN:`$first o[`saveptn]]]
NOHEADER:0b
DELIM:","
\z 1 / D date format 0 => mm/dd/yyyy or 1 => dd/mm/yyyy (yyyy.mm.dd is always ok)
LOADNAME:`paysim1
SAVENAME:`paysim1
LOADFMTS:"ISFSFFSFFBB"
LOADHDRS:`step0`type0`amount`sname`sbal0`sbal1`dname`dbal0`dbal1`frd0`frd1
if[`savename in key o;if[count first o[`savename];SAVENAME:`$first o[`savename]]]
SAVEPATH:{` sv((`. `SAVEDB`SAVEPTN`SAVENAME)except`),`}
LOADDEFN:{(LOADFMTS;$[NOHEADER;DELIM;enlist DELIM])}
POSTLOADEACH:{x}
POSTLOADALL:{x}
POSTSAVEALL:{x}
LOAD:{[file] POSTLOADALL POSTLOADEACH$[NOHEADER;flip LOADHDRS!LOADDEFN[]0:;LOADHDRS xcol LOADDEFN[]0:]file}
LOAD10:{[file] LOAD(file;0;1+last(11-NOHEADER)#where 0xa=read1(file;0;20000))} / just load first 10 records
JUSTSYMFMTS:" S S  S    "
JUSTSYMHDRS:`type0`sname`dname
JUSTSYMDEFN:{(JUSTSYMFMTS;$[NOHEADER;DELIM;enlist DELIM])}
CHUNKSIZE:25000000
DATA:()
k)fs2:{[f;s]((-7!s)>){[f;s;x]i:1+last@&0xa=r:1:(s;x;CHUNKSIZE);f@`\:i#r;x+i}[f;s]/0j}
BULKLOAD:{[file] fs2[{`DATA insert POSTLOADEACH$[NOHEADER or count DATA;flip LOADHDRS!(LOADFMTS;DELIM)0:x;LOADHDRS xcol LOADDEFN[]0: x]}file];count DATA::POSTLOADALL DATA}
PRESAVEEACH:{x}
SAVE:{(r:SAVEPATH[])set PRESAVEEACH .Q.en[`. `SAVEDB] x;POSTSAVEALL r;r}
BULKSAVE:{[file] .tmp.bsc:0;fs2[{.[SAVEPATH[];();,;]PRESAVEEACH t:.Q.en[`. `SAVEDB]POSTLOADEACH$[NOHEADER or .tmp.bsc;flip LOADHDRS!(LOADFMTS;DELIM)0:x;LOADHDRS xcol LOADDEFN[]0: x];.tmp.bsc+:count t}]file;POSTSAVEALL SAVEPATH[];.tmp.bsc}
JUSTSYM:{[file] .tmp.jsc:0;fs2[{.tmp.jsc+:count .Q.en[`. `SAVEDB]POSTLOADEACH$[NOHEADER or .tmp.jsc;flip JUSTSYMHDRS!(JUSTSYMFMTS;DELIM)0:x;JUSTSYMHDRS xcol JUSTSYMDEFN[]0: x]}]file;.tmp.jsc}
if[any`js`justsym in key o;-1(string`second$.z.t)," saving `sym for <",(1_string FILE),"> to directory ",1_string SAVEDB;.tmp.st:.z.t;.tmp.rc:JUSTSYM FILE;.tmp.et:.z.t;.tmp.fs:hcount FILE;-1(string`second$.z.t)," done (",(string .tmp.rc)," records; ",(string floor .tmp.rc%1e-3*`int$.tmp.et-.tmp.st)," records/sec; ",(string floor 0.5+.tmp.fs%1e3*`int$.tmp.et-.tmp.st)," MB/sec)"]
if[any`bs`bulksave in key o;-1(string`second$.z.t)," saving <",(1_string FILE),"> to directory ",1_string` sv(SAVEDB,SAVEPTN,SAVENAME)except`;.tmp.st:.z.t;.tmp.rc:BULKSAVE FILE;.tmp.et:.z.t;.tmp.fs:hcount FILE;-1(string`second$.z.t)," done (",(string .tmp.rc)," records; ",(string floor .tmp.rc%1e-3*`int$.tmp.et-.tmp.st)," records/sec; ",(string floor 0.5+.tmp.fs%1e3*`int$.tmp.et-.tmp.st)," MB/sec)"]
if[any`af`asfile in key o;-1(string`second$.z.t)," saving <",(1_string FILE),"> to file "; DATA: LOAD FILE; value ":" sv string (SAVENAME;`DATA); save `$tname: "/" sv string (SAVEDB;SAVENAME) ]
if[any`bl`bulkload in key o;-1(string`second$.z.t)," loading <",(1_string FILE),"> to variable DATA";.tmp.st:.z.t;BULKLOAD FILE;.tmp.et:.z.t;.tmp.rc:count DATA;.tmp.fs:hcount FILE;-1(string`second$.z.t)," done (",(string .tmp.rc)," records; ",(string floor .tmp.rc%1e-3*`int$.tmp.et-.tmp.st)," records/sec; ",(string floor 0.5+.tmp.fs%1e3*`int$.tmp.et-.tmp.st)," MB/sec)"]
if[`exit in key o;exit 0]
/ DATA:(); BULKLOAD LOADFILE / incremental load all to DATA
/ BULKSAVE LOADFILE / incremental save all to SAVEDB[/SAVEPTN]
/ DATA:LOAD10 LOADFILE / only load the first 10 rows
/ DATA:LOAD LOADFILE / load all in one go
/ SAVE LOAD LOADFILE / save all in one go to SAVEDB[/SAVEPTN]
