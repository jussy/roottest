# This is a template for all makefile.

#Set the list of files to be delete by clean:
CLEAN_TARGETS += $(ALL_LIBRARIES) *.log set_problem.root dict* set_problem

#Set the list of target to make while testing
TEST_TARGETS += setLong64Test

# adjust the location of Rules.mk as needed.
ifeq ($(strip $(ROOTTEST_HOME)),)
	export ROOTTEST_HOME := $(shell expr $(PWD) : '\(.*/roottest/\)')
endif

include $(ROOTTEST_HOME)/scripts/Rules.mk


setLong64Test.log: set_problem_cxx.$(DllSuf) runSetProblem.C
	$(CMDECHO) $(CALLROOTEXE) -b -l -q runSetProblem.C > setLong64Test.log

setLong64Test: setLong64Test.log setLong64Test.ref
	$(CMDECHO) diff -b setLong64Test.log setLong64Test.ref

mytest:
	$(CMDECHO) echo mytest > /dev/null

testWithFailure:
ifeq ($(FAIL),)
	$(WarnFailTest)
endif


