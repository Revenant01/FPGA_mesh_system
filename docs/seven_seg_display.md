
# Entity: seven_seg_display 
- **File**: seven_seg_display.vhd

## Diagram
![Diagram](seven_seg_display.svg "Diagram")
## Ports

| Port name | Direction | Type                           | Description                |
| --------- | --------- | ------------------------------ | -------------------------- |
| clk       | in        | STD_LOGIC                      | Clock input                |
| ready     | in        | STD_LOGIC                      | Ready signal input         |
| state     | in        | STD_LOGIC_VECTOR(127 DOWNTO 0) | 128-bit state input        |
| seg       | out       | STD_LOGIC_VECTOR(6 DOWNTO 0)   | 7-bit segment output       |
| an        | out       | STD_LOGIC_VECTOR(1 DOWNTO 0)   | 2-bit anode output         |
| an2       | out       | STD_LOGIC_VECTOR(1 DOWNTO 0)   | Another 2-bit anode output |

## Signals

| Name        | Type                         | Description                                      |
| ----------- | ---------------------------- | ------------------------------------------------ |
| counter     | INTEGER                      | Counter to select the 8-bit chunk from the state |
| clk_in      | STD_LOGIC                    | Output clock signal from the clock divider       |
| output      | STD_LOGIC_VECTOR(7 DOWNTO 0) | 8-bit output selected from the state             |
| LED_IN      | STD_LOGIC_VECTOR(3 DOWNTO 0) | Input to the segment decoder and its nibbles     |
| most_sig_4  | STD_LOGIC_VECTOR(3 DOWNTO 0) | Input to the segment decoder and its nibbles     |
| least_sig_4 | STD_LOGIC_VECTOR(3 DOWNTO 0) | Input to the segment decoder and its nibbles     |
| anode_ref   | STD_LOGIC_VECTOR(1 DOWNTO 0) |                                                  |

## Processes
- unnamed: ( clk_in )
- unnamed: ( LED_IN )
- unnamed: ( anode_ref )

## Instantiations

- clkDiv: clockDivider
  -  Always drive an2 high (both anodes inactive for this output)