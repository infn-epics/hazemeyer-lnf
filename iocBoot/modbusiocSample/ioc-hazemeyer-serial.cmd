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

## Write holding registers slave 6
drvModbusAsynConfigure("HAZMEYER_GUN01_PORT_WAO", "Hazemeyer_Asyn", 6,    16, 4, 4, 0, 1000, "HAZEMEYER")

## Read holding registers
drvModbusAsynConfigure("HAZMEYER_GUN01_PORT_RAO", "Hazemeyer_Asyn", 6,    3, 4, 12, 0, 1000, "HAZEMEYER")

#Load database
dbLoadRecords("../../db/hz.db", "P=SPARC:MAG,R=HZ:GUNSOL01,PORT=HAZMEYER_GUN01_PORT_RAO, WPORT=HAZMEYER_GUN01_PORT_WAO ,IMAX=200,VMAX=110,TIMEOUT=2000")




## Write holding registers slave 7
# drvModbusAsynConfigure("HAZMEYER_AC1SOL01_PORT_WAO", "Hazemeyer_Asyn", 7,    16, 4, 4, 0, 1000, "HAZEMEYER")

# ## Read holding registers
# drvModbusAsynConfigure("HAZMEYER_AC1SOL01_PORT_RAO", "Hazemeyer_Asyn", 7,    3, 4, 12, 0, 1000, "HAZEMEYER")

# # Load database
# dbLoadRecords("../../db/hz.db", "P=SPARC:MAG,R=HZ:AC1SOL01,PORT=HAZMEYER_AC1SOL01_PORT_RAO, WPORT=HAZMEYER_AC1SOL01_PORT_WAO,IMAX=200,VMAX=110 ,TIMEOUT=2000")




# # Write holding registers slave 8
# drvModbusAsynConfigure("HAZMEYER_AC1SOL02_PORT_WAO", "Hazemeyer_Asyn", 8,    16, 4, 4, 0, 1000, "HAZEMEYER")

# # Read holding registers
# drvModbusAsynConfigure("HAZMEYER_AC1SOL02_PORT_RAO", "Hazemeyer_Asyn", 8,    3, 4, 12, 0, 1000, "HAZEMEYER")

# #Load database
# dbLoadRecords("../../db/hz.db", "P=SPARC:MAG,R=AC1SOL02,PORT=HZ:HAZMEYER_AC1SOL02_PORT_RAO, WPORT=HAZMEYER_AC1SOL02_PORT_WAO,IMAX=200,VMAX=110 ,TIMEOUT=2000")



# Inizializza la IOC
iocInit
epicsThreadSleep 1
dbl 

#dbgf PS:LAB:PS1:state_raw

#dbgf PS:LAB:PS1:current_raw_rb
#dbpf PS:LAB:PS1:cmd 1



