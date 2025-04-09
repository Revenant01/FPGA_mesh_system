
# Entity: uart_j 
- **File**: uart_j.vhd

## Diagram
![Diagram](uart_j.svg "Diagram")
## Description

UART top-level entity declaration

## Ports

| Port name | Direction | Type                           | Description            |
| --------- | --------- | ------------------------------ | ---------------------- |
| Clock     | in        | STD_LOGIC                      | System clock           |
| reset     | in        | STD_LOGIC                      | Asynchronous reset     |
| seg       | out       | STD_LOGIC_VECTOR(6 DOWNTO 0)   | Segment output         |
| an        | out       | STD_LOGIC_VECTOR(1 DOWNTO 0)   | Digit enable           |
| an2       | out       | STD_LOGIC_VECTOR(1 DOWNTO 0)   | Second digit enable    |
| Txd       | out       | STD_LOGIC                      | UART transmit data     |
| Tx_done   | out       | STD_LOGIC                      | Transmission done      |
| Tx_enable | in        | STD_LOGIC                      | Transmit enable        |
| Tx_data   | in        | STD_LOGIC_VECTOR(127 DOWNTO 0) | Data to be transmitted |
| Rxd       | in        | STD_LOGIC                      | UART receive data      |
| Rx_done   | out       | STD_LOGIC                      | Reception done         |
| Rx_data   | out       | STD_LOGIC_VECTOR(127 DOWNTO 0) | Received data output   |

## Signals

| Name             | Type                           | Description                  |
| ---------------- | ------------------------------ | ---------------------------- |
| ready            | STD_LOGIC                      | Ready signal for 7-segment   |
| decryptdone      | STD_LOGIC                      | Placeholder for decrypt done |
| i                | INTEGER                        | Counter variable             |
| flag             | STD_LOGIC                      | Condition flag               |
| intermediate     | STD_LOGIC_VECTOR(127 DOWNTO 0) | Temporary buffer for Rx      |
| decryptionoutput | STD_LOGIC_VECTOR(127 DOWNTO 0) | Placeholder for decryption   |
| Rx_done_tmp      | STD_LOGIC                      |                              |

## Processes
- unnamed: ( Clock )
  - **Description**
  Process to forward Rx_done_tmp to Rx_done
- unnamed: ( intermediate )
  - **Description**
  Process to assert flag based on input value

## Instantiations

- transmitter: uart_txj
  -  UART transmitter instantiation- receiver: uart_rxj
  -  UART receiver instantiation- seven_seg: seven_seg_display
  -  Seven-segment display controller instantiation