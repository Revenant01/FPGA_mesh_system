
# Entity: control_unit 
- **File**: control_unit.vhd

## Diagram
![Diagram](control_unit.svg "Diagram")
## Description

Entity Declaration

## Generics

| Generic name | Type             | Value | Description         |
| ------------ | ---------------- | ----- | ------------------- |
| DATA_WIDTH   | INTEGER          | 128   | Width of data buses |
| entity_x     | STD_LOGIC_VECTOR | x"02" | Expected X address  |
| entity_y     | STD_LOGIC_VECTOR | x"01" | Expected Y address  |

## Ports

| Port name      | Direction | Type                                      | Description                      |
| -------------- | --------- | ----------------------------------------- | -------------------------------- |
| clk            | in        | STD_LOGIC                                 | System clock                     |
| reset          | in        | STD_LOGIC                                 | Asynchronous reset               |
| ps2_data       | in        | STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0) | Input data from PS2 device       |
| ps2_vld        | in        | STD_LOGIC                                 | PS2 data valid signal            |
| vga_data       | out       | STD_LOGIC_VECTOR(112 DOWNTO 0)            | Output to VGA display            |
| vga_done       | in        | STD_LOGIC                                 | VGA processing done              |
| uart_tx_data   | out       | STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0) | Data to be transmitted over UART |
| uart_tx_enable | out       | STD_LOGIC                                 | UART transmit enable             |
| uart_tx_done   | in        | STD_LOGIC                                 | UART transmission completed      |
| uart_rx_data   | in        | STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0) | Data received via UART           |
| uart_rx_done   | in        | STD_LOGIC                                 | UART reception completed         |

## Signals

| Name          | Type       | Description              |
| ------------- | ---------- | ------------------------ |
| current_state | state_type |                          |
| next_state    | state_type |                          |
| fsm_idle      | STD_LOGIC  | FSM control signals      |
| fsm_ps2       | STD_LOGIC  | FSM control signals      |
| fsm_rx        | STD_LOGIC  | FSM control signals      |
| fsm_tx        | STD_LOGIC  | FSM control signals      |
| fsm_dec       | STD_LOGIC  | FSM control signals      |
| fsm_vga       | STD_LOGIC  | FSM control signals      |
| dst_matched   | STD_LOGIC  | Destination match signal |

## Enums


### *state_type*
 FSM States
| Name | Description |
| ---- | ----------- |
| IDLE |             |
| PS2  |             |
| RX   |             |
| DEC  |             |
| TX   |             |
| VGA  |             |


## Processes
- unnamed: ( clk, reset )
  - **Description**
  Sequential process for state transition
- unnamed: ( fsm_dec )
  - **Description**
  Destination address checking logic
- unnamed: ( current_state, ps2_vld, uart_rx_done, uart_tx_done, dst_matched, vga_done )
  - **Description**
  Combinational process to determine next state
- unnamed: ( current_state )
  - **Description**
  FSM output signal logic based on current state
