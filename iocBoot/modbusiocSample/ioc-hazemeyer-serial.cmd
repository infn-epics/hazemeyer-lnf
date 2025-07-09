#!../../bin/linux-x86_64/hz

< envPaths

## Register all support components
dbLoadDatabase "../../dbd/hz.dbd"
hz_registerRecordDeviceDriver(pdbbase)


# TCP Connection - Hezemeyer:
drvAsynIPPortConfigure("Hazemeyer_Asyn", "192.168.197.102:4001", 0, 0, 1)
# open a channel used by Asyn

# Modbus configuration
# modbusInterposeConfig(portName, linkType, timeoutMsec, writeDelayMsec) linktype = 1 = RTU

modbusInterposeConfig("Hazemeyer_Asyn", 1, 2000, 1000)

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



## Write holding registers slave 6
drvModbusAsynConfigure("HAZMEYER_GUN01_PORT_WAO", "Hazemeyer_Asyn", 6,    6, 4, 12, 0, 1000, "HAZEMEYER")

## Read holding registers
drvModbusAsynConfigure("HAZMEYER_GUN01_PORT_RAO", "Hazemeyer_Asyn", 6,    3, 4, 12, 0, 1000, "HAZEMEYER")

# Load database
dbLoadRecords("../../db/hz.db", "P=SPARC:MAG,R=GUNSOL01,PORT=HAZMEYER_GUN01_PORT_RAO, WPORT=HAZMEYER_GUN01_PORT_WAO ,IMAX=200,VMAX=110,TIMEOUT=2000")




## Write holding registers slave 7
drvModbusAsynConfigure("HAZMEYER_AC1SOL01_PORT_WAO", "Hazemeyer_Asyn", 7,    6, 4, 12, 0, 1000, "HAZEMEYER")

## Read holding registers
drvModbusAsynConfigure("HAZMEYER_AC1SOL01_PORT_RAO", "Hazemeyer_Asyn", 7,    3, 4, 12, 0, 1000, "HAZEMEYER")

# Load database
dbLoadRecords("../../db/hz.db", "P=SPARC:MAG,R=AC1SOL01,PORT=HAZMEYER_AC1SOL01_PORT_RAO, WPORT=HAZMEYER_AC1SOL01_PORT_WAO,IMAX=200,VMAX=110 ,TIMEOUT=2000")




## Write holding registers slave 8
drvModbusAsynConfigure("HAZMEYER_AC1SOL02_PORT_WAO", "Hazemeyer_Asyn", 8,    6, 4, 12, 0, 1000, "HAZEMEYER")

## Read holding registers
drvModbusAsynConfigure("HAZMEYER_AC1SOL02_PORT_RAO", "Hazemeyer_Asyn", 8,    3, 4, 12, 0, 1000, "HAZEMEYER")

# Load database
dbLoadRecords("../../db/hz.db", "P=SPARC:MAG,R=AC1SOL02,PORT=HAZMEYER_AC1SOL02_PORT_RAO, WPORT=HAZMEYER_AC1SOL02_PORT_WAO,IMAX=200,VMAX=110 ,TIMEOUT=2000")

# Oppure usa il file di sostituzione
# dbLoadTemplate("db/PowerSupply.substitutions")

# Inizializza la IOC
iocInit
epicsThreadSleep 1
dbl 

dbgf PS:LAB:PS1:state_raw

dbgf PS:LAB:PS1:current_raw_rb
dbpf PS:LAB:PS1:cmd 1



