local_clean = Event$(ExeSuf) libEvent.$(DllSuf) *.o EventDict.cxx EventDict.h *~ *.log *.$(ObjSuf) $(ALL_LIBRARIES)

CLEAN_TARGETS += $(local_clean)
TEST_TARGETS += bigeventTest

ifeq ($(strip $(ROOTTEST_HOME)),)
	export ROOTTEST_HOME := $(shell expr $(PWD) : '\(.*/roottest/\)')
endif

include $(ROOTTEST_HOME)/scripts/Rules.mk
include $(ROOTTEST_HOME)/scripts/Event.mk

#.SUFFIXES: .cxx .o .so

CXXOPT:=-Z7
LDOPT:=-debug

#all: bigeventTest

bigeventTest: ./Event$(ExeSuf) ./libEvent.$(DllSuf)
	$(CMDECHO)./Event 10 1 1 1 > Event.write.log
	$(CMDECHO)./Event 10 1 1 20 > Event.read.log


