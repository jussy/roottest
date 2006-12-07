#!/bin/sh

Setup=yes
while test "x$1" != "x"; do
   case $1 in 
      "-v" ) verbose=x; shift ;;
      "-h" ) help=x; shift;;
      "-cintdlls") cintdlls=x; shift;;
      "-mail") mail=x; shift; mailto=$1; shift;;
      *) help=x; shift;;
   esac
done

if test "x$help" != "x"; then
    echo "$0 [options]"
    echo "Option:"
    echo "  -v : verbose"
    echo "  -cintdlls : also built the cintdlls"
    exit
fi

if [ "x$verbose" = "xx" ] ; then
   set -x
fi

MAKE=gmake
ROOT_MAKEFLAGS=
ROOTTEST_MAKEFLAGS=
CONFIGURE_OPTION=

ROOTMARKS=n/a
FITROOTMARKS=n/a

SHOW_TOP=yes
UPLOAD_LOCATION=flxi02:/afs/.fnal.gov/files/expwww/root/html/roottest/
export CVSROOT=:pserver:cvs@root.cern.ch:/user/cvs 

# The config is expected to set ROOTLOC,
# ROOTTESTLOC and any of the customization
# above (MAKE, etc.)
# and the method to acquire the `load`
host=`hostname -s`
dir=`dirname $0`
. $dir/run_roottest.$host.config

export ROOTBUILD=opt

echo "Running the nightly test on $host from $ROOTLOC"
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:.
export PATH

#echo The path is $PATH
#echo The library path is $LD_LIBRARY_PATH

error_handling() {
    cd $ROOTSYS
    write_summary
    upload_log summary.log

    echo "Found an error on \"$host\" ("`uname`") in $ROOTLOC"
    echo "Error: $2"
    echo "See full log file at http://www-root.fnal.gov/roottest/summary.shtml"

    if [ "x$mail" = "xx" ] ; then
	mail -s "root $OSNAME test" $mailto <<EOF
Failure while building root and roottest on $host ("`uname`") in $ROOTLOC
Error: $2
See full log file at http://www-root.fnal.gov/roottest/summary.shtml
EOF
    fi
    exit $1
}

upload_log() {    
    target_name=$2$1.$host
    scp $1 $UPLOAD_LOCATION/$target_name > scp.log 2>&1 
}

write_summary() {
   lline="<td style=\"width: 100px; text-align: center;\" >"
   rline="</td>"
         osline="$lline $OSNAME $rline"
        cvsline="$lline <a href="cvsupdate.log.$host">$cvsstatus</a>           $rline"
      gmakeline="$lline <a href="gmake.log.$host">$mainstatus</a></td>         $rline"
       testline="$lline <a href="test_gmake.log.$host">$teststatus</a>         $rline"
     stressline="$lline <a href="speedresult.log.$host">$teststatus</a>        $rline"
   roottestline="$lline <a href="roottest_gmake.log.$host">$rootteststatus</a> $rline"
   date=`date +"%b %d %Y"`
   dateline="$lline $date $rline"
   
   echo $osline       >  $ROOTSYS/summary.log
   echo $cvsline      >> $ROOTSYS/summary.log
   echo $gmakeline    >> $ROOTSYS/summary.log
   echo $testline     >> $ROOTSYS/summary.log
   echo $stressline   >> $ROOTSYS/summary.log
   echo $roottestline >> $ROOTSYS/summary.log
   echo $dateline     >> $ROOTSYS/summary.log
}

na="N/A"
success="Ok."
failure="Failed"
cvsstatus=$na
mainstatus=$na
teststatus=$na
rootteststatus=$na

mkdir -p $ROOTSYS
cd $ROOTSYS/..
locname=`basename $ROOTSYS`
cvs -z9 -q co -P -d $locname root > $locname/cvsupdate.log  2>&1
result=$?
if test $result != 0; then 
    cvsstatus=$failure
else
    cvsstatus=$success
fi
upload_log cvsupdate.log

cd $ROOTSYS

if test ! -e config.status ; then
    configure $CONFIGURE_OPTION > configure.log 2>&1
fi

$MAKE $ROOT_MAKEFLAGS  > gmake.log  2>&1 
result=$?
upload_log gmake.log
if test $result != 0; then 
   mainstatus=$failure
   error_handling $result "ROOT's gmake failed!  See log file at $ROOTSYS/gmake.log"
fi
mainstatus=$success

if [ "x$cintdlls" = "xx" ] ; then
   gmake cintdlls  >> gmake.log  2>&1 
fi

$MAKE map  >> gmake.log  2>&1 

upload_log gmake.log

cd test; $MAKE distclean > gmake.log
$MAKE >> gmake.log  2>&1 
result=$?

upload_log gmake.log test_
if test $result != 0; then
   teststatus=$failure
   error_handling $result "ROOT's test gmake failed!  See log file at $ROOTSYS/gmake.log"
fi
teststatus=$success

echo >> speedresult.log
date >> speedresult.log
echo Expected rootmarks: $ROOTMARKS | tee -a speedresult.log
./stress -b 30 | tail -4 | grep -v '\*\*\*' | tee -a speedresult.log
./stress -b 30 | tail -4 | grep -v '\*\*\*' | tee -a speedresult.log
echo
if test "x$SHOW_TOP" = "xyes"; then
   top n 1 b | head -14 | tail -11 | tee -a speedresult.log
fi
if test "x$$IDLE_COMMAND" != "x"; then
   idle=`eval $IDLE_COMMAND`
   echo "idle value: $idle" | tee -a speedresult.log
fi
echo
echo Expected fit rootmarks: $FITROOTMARKS
./stressFit | tail -5 | grep -v '\*\*\*' | grep -v 'Time at the' | tee -a speedresult.log
./stressFit | tail -5 | grep -v '\*\*\*' | grep -v 'Time at the' | tee -a speedresult.log
echo

upload_log speedresult.log

echo Going to roottest at: $ROOTTESTLOC

mkdir -p $ROOTTESTLOC
cd $ROOTTESTLOC/..
locname=`basename $ROOTTESTLOC`
cvs -z9 -q co -P -d $locname roottest > $locname/gmake.log 2>&1

cd $ROOTTESTLOC
$MAKE clean >> gmake.log 2>&1 
$MAKE -k >> gmake.log 2>&1 
result=$?
upload_log gmake.log roottest_

grep FAIL $PWD/gmake.log
tail $PWD/gmake.log

if test $result != 0; then
    rootteststatus=$failure
    error_handling $result "roottest's gmake failed!  See log file at $PWD/gmake.log"
fi
rootteststatus=$success

cd $ROOTSYS
write_summary
upload_log summary.log
