
# Entity: uart_txj 
- **File**: uart_txj.vhd

## Diagram
![Diagram](uart_txj.svg "Diagram")
## Description

UART transmitter entity declaration

## Ports

| Port name | Direction | Type                           | Description                            |
| --------- | --------- | ------------------------------ | -------------------------------------- |
| Clock     | in        | STD_LOGIC                      | System clock                           |
| Reset     | in        | STD_LOGIC                      | Asynchronous reset (currently unused)  |
| Enable    | in        | STD_LOGIC                      | Enable signal for data transmission    |
| DATA_BIT  | in        | STD_LOGIC_VECTOR(127 DOWNTO 0) | Data to transmit (ASCII value for 'X') |
| Txd       | out       | STD_LOGIC                      | UART serial output                     |
| send_done | out       | STD_LOGIC                      | Transmission complete signal           |

## Signals

| Name        | Type                   | Description                |
| ----------- | ---------------------- | -------------------------- |
| baud_clock  | STD_LOGIC              | Clock for baud rate timing |
| bit_counter | INTEGER RANGE 0 TO 129 |                            |

## Constants

| Name       | Type    | Value     | Description                        |
| ---------- | ------- | --------- | ---------------------------------- |
| BAUD_RATE  | INTEGER | 9600      | Constants for baud rate generation |
| CLOCK_FREQ | INTEGER | 100000000 | 100 MHz input clock                |

## Processes
- unnamed: ( Clock )
  - **Description**
  Baud rate clock generation process
- unnamed: ( baud_clock )
  - **Description**
  UART data transmission process triggered on baud clock edge
