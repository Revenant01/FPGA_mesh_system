
# Entity: Keyboard 
- **File**: Keyboard.vhd

## Diagram
![Diagram](Keyboard.svg "Diagram")
## Ports

| Port name    | Direction | Type                       | Description                                     |
| ------------ | --------- | -------------------------- | ----------------------------------------------- |
| clk          | in        | STD_LOGIC                  | System clock input                              |
| ps2_clk      | in        | STD_LOGIC                  | Clock signal from the PS/2 keyboard             |
| ps2_data     | in        | STD_LOGIC                  | Data signal from the PS/2 keyboard              |
| flag_receive | out       | STD_LOGIC                  | Flag indicating that new data has been received |
| data_out     | out       | STD_LOGIC_vector(0 to 127) | 128-bit output to store received data           |

## Signals

| Name             | Type                       | Description                                                            |
| ---------------- | -------------------------- | ---------------------------------------------------------------------- |
| ascii_new        | std_logic                  | Signal indicating a new ASCII code from the PS/2 decoder               |
| ascii_code       | STD_LOGIC_VECTOR(0 to 6)   | Signal to store the 7-bit ASCII code                                   |
| data             | STD_LOGIC_VECTOR(0 to 127) | Signal to store the received ASCII characters                          |
| flag_matrix_done | std_logic                  | Flag indicating that the matrix operation is done (currently not used) |
| reset            | std_logic                  |                                                                        |

## Processes
- unnamed: ( ascii_new )

## Instantiations

- Keyboard: ps2_keyboard_to_ascii
