# Hazemeyer Serial Power Supply EPICS Driver

This EPICS database provides a complete interface for controlling Hazemeyer power supplies via Modbus TCP/RTU communication.

## Overview

The database implements:
- Current and voltage setpoints with automatic scaling
- Real-time readbacks of output values
- State machine for power supply control
- Fault monitoring and status reporting
- Automatic ramp start functionality

## Database Structure

### Control Records

| Record Name | Type | Description | Units |
|-------------|------|-------------|-------|
| `$(P):$(R):CURRENT_SP` | ao | Current setpoint | A |
| `$(P):$(R):SLEWRATE_SP` | ao | Current ramp rate | A/s |
| `$(P):$(R):STATE_SP` | mbbo | Power supply state control | - |

### Readback Records

| Record Name | Type | Description | Units |
|-------------|------|-------------|-------|
| `$(P):$(R):CURRENT_RB` | calc | Actual output current | A |
| `$(P):$(R):VOLTAGE_RB` | calc | Actual output voltage | V |
| `$(P):$(R):EARTH_CURRENT_RB` | ai | Earth leakage current | A |
| `$(P):$(R):SET_CURRENT_RB` | ai | Commanded current readback | A |
| `$(P):$(R):STATE_RB` | mbbi | Power supply state | - |

### Status Records

| Record Name | Type | Description |
|-------------|------|-------------|
| `$(P):$(R):OPERATIONAL` | bi | Operational status (ON/OFF) |
| `$(P):$(R):ALL_FAULT` | bi | Fault condition (OK/FAULT) |

## State Machine

The power supply supports the following states:

| State | Value | Description |
|-------|-------|-------------|
| OFF | 0 | Power supply disabled |
| ON | 1 | Normal operation, output enabled |
| STANDBY | 2 | Ready but output disabled |
| RESET | 3 | Reset command (transient) |
| INTERLOCK | 4 | Safety interlock active |
| ERROR | 5 | Fault condition |

## Modbus Mapping

### Write Registers (Port: $(WPORT))

| Address | Function | Raw Record | Description |
|---------|----------|------------|-------------|
| 0 | Command | `RAW_STATE_SP` | Control register |
| 2 | Current SP | `RAW_CURRENT_SP` | Current setpoint (0-32767) |
| 3 | Slew Rate | `RAW_SLEWRATE_SP` | Ramp rate (0-32767) |

### Read Registers (Port: $(PORT))

| Address | Function | Raw Record | Description |
|---------|----------|------------|-------------|
| 6 | Status 1 | `RAW_STATE_RB` | Status bits register 1 |
| 7 | Current RB | `RAW_CURRENT_RB` | Output current (0-32767) |
| 8 | Voltage RB | `RAW_VOLTAGE_RB` | Output voltage (0-32767) |
| 9 | Earth Current | `EARTH_CURRENT_RB` | Earth leakage current |
| 10 | Set Current RB | `SET_CURRENT_RB` | Commanded current |
| 11 | Status 2 | `RAW_STATE2_RB` | Status bits register 2 |

## Scaling

Raw Modbus values (0-32767) are automatically scaled to engineering units:

- **Current**: `(raw_value / 32767) * IMAX`
- **Voltage**: `(raw_value / 32767) * VMAX`

## Macros

When loading the database, define these macros:

| Macro | Description | Example |
|-------|-------------|---------|
| `P` | Device prefix | `HZ:PS01` |
| `R` | Record suffix | `:` |
| `PORT` | Asyn port for reads | `HZ_READ` |
| `WPORT` | Asyn port for writes | `HZ_WRITE` |
| `IMAX` | Maximum current (A) | `100` |
| `VMAX` | Maximum voltage (V) | `1000` |
| `TIMEOUT` | Communication timeout (ms) | `1000` |

## Usage Example

### IOC Startup Script

```bash
# Configure Modbus ports
drvAsynIPPortConfigure("HZ_TCP", "192.168.1.100:502")

# Configure Modbus read port
modbusInterposeConfig("HZ_READ", "HZ_TCP", 0, 1)
drvModbusAsynConfigure("HZ_READ", "HZ_READ", 1, 3, 0, 20, 0, 1000, "Hazemeyer")

# Configure Modbus write port  
modbusInterposeConfig("HZ_WRITE", "HZ_TCP", 0, 1)
drvModbusAsynConfigure("HZ_WRITE", "HZ_WRITE", 1, 6, 0, 10, 0, 1000, "Hazemeyer")

# Load database
dbLoadRecords("hz.db", "P=HZ:PS01,R=:,PORT=HZ_READ,WPORT=HZ_WRITE,IMAX=100,VMAX=1000,TIMEOUT=1000")
```

### Operation Sequence

1. **Initialize**: Power supply starts in OFF state
2. **Set Parameters**: Set current and slew rate setpoints
3. **Enable**: Set STATE_SP to "STANDBY" or "ON"
4. **Monitor**: Watch readbacks and status

### EPICS Client Commands

```bash
# Set current to 50A
caput HZ:PS01:CURRENT_SP 50

# Set slew rate to 10 A/s
caput HZ:PS01:SLEWRATE_SP 10

# Turn on power supply
caput HZ:PS01:STATE_SP 1

# Monitor output
caget HZ:PS01:CURRENT_RB
caget HZ:PS01:VOLTAGE_RB
caget HZ:PS01:STATE_RB
```

## Safety Features

- **Automatic Fault Detection**: Monitors fault status bits
- **State Interlocks**: Prevents operation in fault conditions  
- **Range Limiting**: Current setpoints limited by IMAX
- **Alarm Handling**: Fault conditions generate MAJOR alarms

## Troubleshooting

### Common Issues

1. **Communication Errors**
   - Check Modbus TCP connection
   - Verify port configuration
   - Check timeout values

2. **Scaling Problems**
   - Verify IMAX and VMAX macros
   - Check raw value ranges (0-32767)

3. **State Machine Issues**
   - Check fault status
   - Verify interlock conditions
   - Reset if necessary

### Debug Commands

```bash
# Check raw Modbus values
caget HZ:PS01:RAW_CURRENT_RB
caget HZ:PS01:RAW_STATE_RB

# Monitor fault status  
caget HZ:PS01:ALL_FAULT
caget HZ:PS01:OPERATIONAL

# Enable asyn debugging
asynSetTraceMask("HZ_READ", 0, 0x11)
asynSetTraceIOMask("HZ_READ", 0, 0x6)
```

## Version History

- **v1.0**: Initial implementation
- **v1.1**: Fixed duplicate records, improved scaling, added documentation

## Support

For technical support, contact the EPICS controls team or refer to the Hazemeyer power supply manual.