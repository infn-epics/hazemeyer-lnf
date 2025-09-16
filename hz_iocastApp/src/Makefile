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

hz_iocastSupport_LIBS += $(EPICS_BASE_IOC_LIBS)

# Auto-generate a header file containing a version string.
# Version comes from the VCS if available, else date+time.
GENVERSION = hz_iocastVersion.h
# Macro name
GENVERSIONMACRO = hz_iocastVERSION

# Build the IOC application
PROD_IOC = hz_iocast

# hz.dbd will be created and installed
DBD += hz_iocast.dbd

# hz.dbd will include these files:
hz_iocast_DBD += base.dbd
hz_iocast_DBD += modbusSupport.dbd
hz_iocast_DBD += asyn.dbd
hz_iocast_DBD += drvAsynIPPort.dbd
hz_iocast_SRCS += hz_iocast_registerRecordDeviceDriver.cpp

# Build the main IOC entry point where needed
hz_iocast_SRCS_DEFAULT += hz_iocastMain.cpp
hz_iocast_SRCS_vxWorks += -nil-

# Link in the code from our support library
hz_iocast_LIBS += asyn
hz_iocast_LIBS += modbus
# To build SNL programs, SNCSEQ must be defined
# in the <top>/configure/RELEASE file

# Link QSRV (pvAccess Server) if available
ifdef EPICS_QSRV_MAJOR_VERSION
    hz_iocast_LIBS += qsrv
    hz_iocast_LIBS += $(EPICS_BASE_PVA_CORE_LIBS)
    hz_iocast_DBD += PVAServerRegister.dbd
    hz_iocast_DBD += qsrv.dbd
endif

# Finally link IOC to the EPICS Base libraries
hz_iocast_LIBS += $(EPICS_BASE_IOC_LIBS)

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD EXTRA GNUMAKE RULES BELOW HERE

# Explicit dependency needed for generated header file
devhzVersion$(DEP): $(COMMON_DIR)/$(GENVERSION)
