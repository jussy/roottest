#
# Set of macro passed to root.exe to tell the scripts to
# avoid features not yet implemented by cling.
#

CINT_VERSION := cling

CALLROOTEXE = root.exe

# Essential problems, must be fixed before the release.
# (incorrect behavior of C++ compliant code)
#CALLROOTEXE += -e "\#define ClingWorkAroundIncorrectTearDownOrder"
#CALLROOTEXE += -e "\#define ClingWorkAroundCallfuncAndConversion"
CALLROOTEXE += -e "\#define ClingWorkAroundCallfuncReturnInt"
CALLROOTEXE += -e "\#define ClingWorkAroundLackOfModule"
# Major features/issues
CALLROOTEXE += -e "\#define ClingWorkAroundDouble32inDefaultTmpltArg"
CALLROOTEXE += -e "\#define ClingWorkAroundMissingDynamicScope"
CALLROOTEXE += -e "\#define ClingWorkAroundMissingAutoLoadingForNamespaces"
CALLROOTEXE += -e "\#define ClingWorkAroundMissingAutoLoadingForTemplates"
#CALLROOTEXE += -e "\#define ClingWorkAroundMissingAutoLoading"
CALLROOTEXE += -e "\#define ClingWorkAroundJITandInline"
#CALLROOTEXE += -e "\#define ClingWorkAroundCallfuncAndVirtual"
#CALLROOTEXE += -e "\#define ClingWorkAroundCallfuncAndInline"
CALLROOTEXE += -e "\#define ClingWorkAroundScriptClassDef"
CALLROOTEXE += -e "\#define ClingWorkAroundMultipleInclude"
CALLROOTEXE += -e "\#define ClingWorkAroundCallfuncAndReturnByValue"
# Features needed for the tutorials
CALLROOTEXE += -e "\#define ClingWorkAroundMissingImplicitAuto"
# and See ClingReinstateRedeclarationAllowed
# Other missing features
CALLROOTEXE += -e "\#define ClingWorkAroundNoPrivateClassIO"
# Convenience features, would be nice to have.
CALLROOTEXE += -e "\#define ClingWorkAroundBrokenRecovery"
CALLROOTEXE += -e "\#define ClingWorkAroundMissingSmartInclude"
CALLROOTEXE += -e "\#define ClingWorkAroundBrokenUnnamedReturn"
CALLROOTEXE += -e "\#define ClingWorkAroundUnnamedDetection"
CALLROOTEXE += -e "\#define ClingWorkAroundUnnamedInclude"
CALLROOTEXE += -e "\#define ClingWorkAroundJITfullSymbolResolution"
CALLROOTEXE += -e "\#define ClingWorkAroundDeletedSourceFile"
CALLROOTEXE += -e "\#define ClingWorkAroundValuePrinterNotFullyQualified"
CALLROOTEXE += -e "\#define ClingWorkAroundNoDotNamespace"
CALLROOTEXE += -e "\#define ClingWorkAroundNoDotInclude"
CALLROOTEXE += -e "\#define ClingWorkAroundNoDotOptimization"
CALLROOTEXE += -e "\#define ClingWorkAroundUnnamedIncorrectFileLoc"
CALLROOTEXE += -e "\#define ClingWorkAroundTypeinfoToTypename"
# Most likely no longer supported.
# CALLROOTEXE += -e "\#define ClingReinstateRedeclarationAllowed"
# CALLROOTEXE += -e "\#define ClingReinstateImplicitDynamicCast"

# Not for 6.0
CALLROOTEXE += -e "\#define ClingWorkAroundMissingUnloading"

# Fixes used when building library via ACLiC
#CALLROOTEXEBUILD += -e "\#define ClingWorkAroundCallfuncAndInline"
#CALLROOTEXEBUILD += -e "\#define ClingWorkAroundCallfuncAndVirtual"
CALLROOTEXEBUILD += -e "\#define ClingWorkAroundJITandInline"
CALLROOTEXEBUILD += -e "\#define ClingWorkAroundCallfuncAndReturnByValue"
CALLROOTEXEBUILD += -e "\#define ClingWorkAroundNoPrivateClassIO"

# variable to be used in Makefiles.
ClingWorkAroundLackOfModule = yes
ClingWorkAroundMissingImplicitAuto = yes
ClingWorkAroundMissingDynamicScope = yes
ClingWorkAroundMissingUnloading = yes
ClingWorkAroundDouble32inDefaultTmpltArg = yes
ClingWorkAroundCallfuncReturnInt = yes         # See http://savannah.cern.ch/bugs/?100652 
#ClingWorkAroundCallfuncAndConversion = yes     # See https://savannah.cern.ch/bugs/index.php?99517
ClingWorkAroundMissingAutoLoadingForNamespaces = yes # See: https://sft.its.cern.ch/jira/browse/ROOT-4779
ClingWorkAroundMissingAutoLoadingForTemplates = yes  # See: https://sft.its.cern.ch/jira/browse/ROOT-4786
#ClingWorkAroundMissingAutoLoading = yes        # See *also* the problem namespace and templates:
                                               #     https://sft.its.cern.ch/jira/browse/ROOT-4786
                                               #     https://sft.its.cern.ch/jira/browse/ROOT-4779
ClingWorkAroundJITfullSymbolResolution = yes   # See https://savannah.cern.ch/bugs/index.php?98898
ClingWorkAroundMissingSmartInclude = yes
ClingWorkAroundBrokenUnnamedReturn = yes       # See https://savannah.cern.ch/bugs/index.php?99032
ClingWorkAroundUnnamedIncorrectFileLoc = yes   # see https://savannah.cern.ch/bugs/index.php?99236
#ClingWorkAroundCallfuncAndInline = yes        # see https://savannah.cern.ch/bugs/index.php?98425
ClingWorkAroundCallfuncAndReturnByValue = yes  # See https://savannah.cern.ch/bugs/index.php?98317 and https://savannah.cern.ch/bugs/?98148
ClingWorkAroundDeletedSourceFile = yes         # See https://savannah.cern.ch/bugs/index.php?100082 
ClingWorkAroundUnnamedInclude = yes            # See https://savannah.cern.ch/bugs/index.php?99246
ClingWorkAroundBrokenRecovery = yes
ClingWorkAroundNoDotNamespace = yes            # See https://savannah.cern.ch/bugs/index.php?99288
ClingWorkAroundJITandInline = yes              # JIT does not instantiate inline even-though they are used (but not actually inlined)
ClingWorkAroundValuePrinterNotFullyQualified = yes # See https://savannah.cern.ch/bugs/index.php?99290
ClingWorkAroundNoDotInclude = yes              # See trello card about .include
ClingWorkAroundScriptClassDef = yes            # See https://savannah.cern.ch/bugs/index.php?99268
ClingWorkAroundMultipleInclude = yes           # File are included each time a module that contains them is 
                                               # loaded.  Should go away with the modules
ClingWorkAroundNoDotOptimization = yes         # See https://savannah.cern.ch/bugs/index.php?99339
ClingWorkAroundUnnamedDetection = yes          # See https://savannah.cern.ch/bugs/index.php?99341
#ClingWorkAroundIncorrectTearDownOrder = yes    # See https://savannah.cern.ch/bugs/index.php?99266
ClingWorkAroundNoPrivateClassIO = yes          # See https://savannah.cern.ch/bugs/index.php?99860 
#ClingWorkAroundCallfuncAndVirtual = yes        # See https://savannah.cern.ch/bugs/index.php?99910
# Most likely no longer supported.
# ClingReinstateRedeclarationAllowed = yes     # See https://savannah.cern.ch/bugs/index.php?99396 
# ClingReinstateImplicitDynamicCast = yes      # See https://savannah.cern.ch/bugs/index.php?99395
ClingWorkAroundTypeinfoToTypename = yes        # See https://sft.its.cern.ch/jira/browse/ROOT-186

ifneq ($(ClingReinstateRedeclarationAllowed)-$(ClingWorkAroundMissingImplicitAuto),yes-)
ClingWorkAroundSavePrimitive = yes             # stressGraphics use of SavePrimitive currently requires at least implicit auto and allowing redeclaration
endif

ifneq ($(ClingWorkAroundMissingAutoLoading),)
CALLROOTEXE += -e 'gSystem->Load("libTreePlayer"); gSystem->Load("libPhysics");'
endif
ifneq ($(ClingWorkAroundMissingAutoLoadingForNamespaces),)
CALLROOTEXE += -e 'gSystem->Load("libTreePlayer"); gSystem->Load("libPhysics");'
endif

PYROOT_EXTRAFLAGS = --fixcling
