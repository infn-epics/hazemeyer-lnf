#!../../bin/linux-x86_64/hz_iocast

< envPaths

## Register all support components
dbLoadDatabase "../../dbd/hz_iocast.dbd"
hz_iocast_registerRecordDeviceDriver(pdbbase)


# TCP Connection - Hezemeyer:
drvAsynIPPortConfigure("Hazemeyer_Asyn", "192.168.0.108:502", 0, 0, 1) 
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



## Read holding registers (0-37 - in according to Hazemeyer exchange_table.pdf)
# drvModbusAsynConfigure(portName, linkType, slave, functionCode, startAddress, count, timeoutMsec, writeDelayMsec, name)
drvModbusAsynConfigure("Hazemeyer_001_RAO", "Hazemeyer_Asyn", 1, 3, 0, 37, 0, 200, "HAZEMEYER")

## Write holding registers (0-7 - in according to Hazemeyer exchange_table.pdf)    
# drvModbusAsynConfigure(portName, linkType, slave, functionCode, startAddress, count, timeoutMsec, writeDelayMsec, name)
drvModbusAsynConfigure("Hazemeyer_001_WAO", "Hazemeyer_Asyn", 1, 6, 0, 7, 0, 500, "HAZEMEYER")


# https://millenia.cars.aps.anl.gov/software/epics/modbusDoc.html#Overview_of_Modbus



# Load database
dbLoadRecords("../../db/hz_iocast.db", "P=PS:LAB:,R=PS1,PORT=Hazemeyer_001_RAO, WPORT=Hazemeyer_001_WAO ,TIMEOUT=1000")

# Oppure usa il file di sostituzione
# dbLoadTemplate("db/PowerSupply.substitutions")

# Inizializza la IOC
iocInit


# Enable Hazemeyer_Asyn (TCP/IP port) trace


#asynSetTraceIOMask  "Hazemeyer_001_RAO", 0, 4 
#asynSetTraceMask    "Hazemeyer_001_RAO", 0, 9

asynSetTraceIOMask  "Hazemeyer_001_WAO", 0, 4 
asynSetTraceMask    "Hazemeyer_001_WAO", 0, 9




