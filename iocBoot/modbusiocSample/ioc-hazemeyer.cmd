#!../../bin/linux-x86_64/hz

< envPaths

## Register all support components
dbLoadDatabase "../../dbd/hz.dbd"
hz_registerRecordDeviceDriver(pdbbase)


# TCP Connection - Hezemeyer:
drvAsynIPPortConfigure("Hazemeyer_Asyn", "192.168.0.107:502", 0, 0, 1) 
# https://millenia.cars.aps.anl.gov/software/epics/modbusDoc.html#Overview_of_Modbus

# open a channel used by Asyn

# Modbus configuration
# modbusInterposeConfig(portName, linkType, timeoutMsec, writeDelayMsec)
modbusInterposeConfig("Hazemeyer_Asyn", 0, 0, 0)
# https://millenia.cars.aps.anl.gov/software/epics/modbusDoc.html#Overview_of_Modbus

## Modbus Function Codes Documentation
# Access         Function Description           Function Code
# Bit access     Read Coils                     1
# Bit access     Read Discrete Inputs           2
# Bit access     Write Single Coil              5
# Bit access     Write Multiple Coils           15
# 16-bit word    Read Input Registers           4
# 16-bit word    Read Holding Registers         3
# 16-bit word    Write Single Register          6
# 16-bit word    Write Multiple Registers       16
# 16-bit word    Read/Write Multiple Registers  23


## Write holding registers
# drvModbusAsynConfigure("Hazemeyer_001_WAO", "Hazemeyer_Asyn", 1, 6, 0, 16, 0, 1000, "HAZEMEYER")

## Read holding registers
drvModbusAsynConfigure("Hazemeyer_001_RAO", "Hazemeyer_Asyn", 1, 3, 0, 37, 0, 1000, "HAZEMEYER")
# drvModbusAsynConfigure("Hazemeyer_001_Rbit", "Hazemeyer_Asyn",  1, 1, 0, 16, 0, 1000, "HAZEMEYER")
# https://millenia.cars.aps.anl.gov/software/epics/modbusDoc.html#Overview_of_Modbus




# Load database
dbLoadRecords("../../db/hz.db", "P=PS:LAB:,R=PS1:,PORT=Hazemeyer_001_RAO, WPORT=Hazemeyer_001_WAO , PORTbit=Hazemeyer_001_Rbit,TIMEOUT=1000")

# Oppure usa il file di sostituzione
# dbLoadTemplate("db/PowerSupply.substitutions")

# Inizializza la IOC
iocInit


# Enable Hazemeyer_Asyn (TCP/IP port) trace


# asynSetTraceIOMask  "Hazemeyer_001_RAO", 0, 4 
# asynSetTraceMask    "Hazemeyer_001_RAO", 0, 9




