TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS BELOW HERE

# Use typed rset structure (see 3.16.1 release notes)
USR_CPPFLAGS += -DUSE_TYPED_RSET

# Build an IOC support library
# LIBRARY_IOC += hzSupport

# Link locally-provided code into the support library,
# rather than directly into the IOC application, that
# causes problems on Windows DLL builds
#hzSupport_SRCS += dbSubExample.c
#hzSupport_SRCS += devhzVersion.c
#hzSupport_SRCS += hzHello.c
#hzSupport_SRCS += initTrace.c

hzSupport_LIBS += $(EPICS_BASE_IOC_LIBS)

# Auto-generate a header file containing a version string.
# Version comes from the VCS if available, else date+time.
GENVERSION = hzVersion.h
# Macro name
GENVERSIONMACRO = hzVERSION

# Build the IOC application
PROD_IOC = hz

# hz.dbd will be created and installed
DBD += hz.dbd

# hz.dbd will include these files:
hz_DBD += base.dbd
hz_DBD += modbusSupport.dbd
hz_DBD += asyn.dbd
hz_DBD += drvAsynIPPort.dbd
hz_SRCS += hz_registerRecordDeviceDriver.cpp

# Build the main IOC entry point where needed
hz_SRCS_DEFAULT += hzMain.cpp
hz_SRCS_vxWorks += -nil-

# Link in the code from our support library
hz_LIBS += asyn
hz_LIBS += modbus
# To build SNL programs, SNCSEQ must be defined
# in the <top>/configure/RELEASE file

# Link QSRV (pvAccess Server) if available
ifdef EPICS_QSRV_MAJOR_VERSION
    hz_LIBS += qsrv
    hz_LIBS += $(EPICS_BASE_PVA_CORE_LIBS)
    hz_DBD += PVAServerRegister.dbd
    hz_DBD += qsrv.dbd
endif

# Finally link IOC to the EPICS Base libraries
hz_LIBS += $(EPICS_BASE_IOC_LIBS)

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD EXTRA GNUMAKE RULES BELOW HERE

# Explicit dependency needed for generated header file
devhzVersion$(DEP): $(COMMON_DIR)/$(GENVERSION)
