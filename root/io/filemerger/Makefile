# This is a template for all makefiles.

#Set the list of files to be deleted by clean (Targets can also be specified).:
CLEAN_TARGETS += $(ALL_LIBRARIES) *.log *.clog merged*.root a_*.root b_*.root input*.root freidt_merge.root mfile*.root

# Set the list of target to make while testing.  By default, mytest is the
# only target added.  If the name of the target is changed in the rules then
# the name should be changed accordingly in this list.

TEST_TARGETS += notmergeable

# Search for Rules.mk in roottest/scripts
# Algorithm:  Find the current working directory and remove everything after
#  '*roottest/'.  Append the path for Rules.mk from within roottest, which 
#  should be 'scripts/Rules.mk'.  The roottest path is saved in the
#  ROOTTEST_HOME variable for use by the SUBDIRECTORIES variable and is 
#  exported to eliminate the overhead of findding the path again during 
#  recursive calls of gmake.
# Since all makefiles should be under roottest or one of its
#  subdirectories and all recursions of gmake are called by 
#    'cd [DIR]; gmake ...'
#  this algorithm should not fail in finding /roottest/ in the
#  current working directory.  
# Issues:  This algorithm will fail if a makefile is called from outside the 
#  roottest folder, as in executing 'gmake -f ~/roottest/Makefile' from 
#  the home directory.

ifeq ($(strip $(ROOTTEST_HOME)),)
	export ROOTTEST_HOME:=$(shell expr $(PWD) : '\(.*/roottest/\)')
endif

include $(ROOTTEST_HOME)/scripts/Rules.mk


# The name of this target should be changed according to the test being run.  Any name changes
#  should also be reflected in the TEST_TARGETS variable above.

mytest:
	$(CMDECHO) echo mytest > /dev/null


# Outputs a message if the FAIL variable is null

testWithFailure:
ifeq ($(FAIL),)
	$(WarnFailTest)
endif

# Remember that sometest.log can be made automatically from
#  from runsometest.C
# This target attempts to create a log file (which should be the output of running the test), and
#  compares its output with a prebuilt reference file.  The reference file should be copied from
#  the log files produced during what is considered a successful run of the test.  The testWithDiff
#  files should be renamed according to the test being run.
# By default the TestDiff variable is set to compare the .log and .ref files
# To run a diff and ignore whitespacing use $(TestDiffW)

testWithDiff: testWithDiff.log testWithDiff.ref
	$(TestDiff)

notmergeable.log:
	$(CMDECHO) hadd -f freidt_merge.root  freidt_CDMeson_0000.root freidt_CDMeson_0001.root > notmergeable.log 2>&1

notmergeable: notmergeable.log
	$(TestDiff)

ifneq ($(ClingWorkAroundMissingAutoLoading),)
execFileMerger.log: CALLROOTEXE += -e 'gSystem->Load("libTreePlayer");'
endif

mfile1.root mfile2.root mfile3.root mfile4.root: execMergeMulti

mfile1-4.root: execMergeMulti mfile1.root mfile2.root mfile3.root mfile4.root
	$(CMDECHO) ( hadd -f mfile1-2.root mfile1.root mfile2.root && hadd -f mfile3-4.root mfile3.root mfile4.root \
	     && hadd -f mfile1-4.root mfile1-2.root mfile3-4.root ) > mfile1-4.log 2>&1  \
	|| handleError.sh --log=mfile1-4.log --res=$$?

execTestMultiMerge.log: mfile1-4.root

