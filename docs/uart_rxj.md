
# Entity: uart_rxj 
- **File**: uart_rxj.vhd

## Diagram
![Diagram](uart_rxj.svg "Diagram")
## Description

UART receiver entity declaration

## Ports

| Port name     | Direction | Type                           | Description                           |
| ------------- | --------- | ------------------------------ | ------------------------------------- |
| Clock         | in        | STD_LOGIC                      | System clock                          |
| Reset         | in        | STD_LOGIC                      | Asynchronous reset (currently unused) |
| Rxd           | in        | STD_LOGIC                      | UART serial input                     |
| Received_Data | out       | STD_LOGIC_VECTOR(127 DOWNTO 0) | Parallel output data                  |
| receive_done  | out       | STD_LOGIC                      | Reception complete signal             |

## Signals

| Name          | Type                           | Description                                         |
| ------------- | ------------------------------ | --------------------------------------------------- |
| Baud_Clock    | STD_LOGIC                      | Clock for baud rate timing                          |
| bit_counter   | INTEGER RANGE 0 TO 129         | Counter for received bits (start + 128 data + stop) |
| received_byte | STD_LOGIC_VECTOR(127 DOWNTO 0) |                                                     |

## Constants

| Name       | Type    | Value     | Description                        |
| ---------- | ------- | --------- | ---------------------------------- |
| BAUD_RATE  | INTEGER | 9600      | Constants for baud rate generation |
| CLOCK_FREQ | INTEGER | 100000000 | 100 MHz input clock                |

## Processes
- unnamed: ( Clock )
  - **Description**
  Baud rate clock generation process (reset logic removed)
- unnamed: ( Baud_Clock )
  - **Description**
  Data reception process triggered on Baud_Clock edge
