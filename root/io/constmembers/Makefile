TEST_TARGETS = FileInfoTest
CLEAN_TARGETS = dict.* dictold.*

ifeq ($(strip $(ROOTTEST_HOME)),)
	export ROOTTEST_HOME := $(shell expr $(PWD) : '\(.*/roottest/\)')
endif

include $(ROOTTEST_HOME)/scripts/Rules.mk

#test:
#	$(CMDECHO)echo $(PWD) has a failing test FileInfoTest


ifeq ($(FAIL),)
FileInfoTest:
	$(WarnFailTest)	
else
FileInfoTest: dict.o dictold.o
endif

dict.cxx: TFileInfo.h LinkDef.h $(ROOTCINT)
	$(CMDECHO)rootcint -f dict.cxx -c TFileInfo.h LinkDef.h

dictold.cxx: old.h TFileInfo.h oldLinkDef.h $(ROOTCINT)
	$(CMDECHO)rootcint -f dictold.cxx -c old.h TFileInfo.h oldLinkDef.h



