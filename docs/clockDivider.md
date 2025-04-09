
# Entity: clockDivider 
- **File**: clockDivider.vhd

## Diagram
![Diagram](clockDivider.svg "Diagram")
## Ports

| Port name | Direction | Type                         | Description |
| --------- | --------- | ---------------------------- | ----------- |
| clk       | in        | STD_LOGIC                    |             |
| clock_out | out       | STD_LOGIC                    |             |
| an_ref    | out       | STD_LOGIC_VECTOR(1 DOWNTO 0) |             |

## Signals

| Name  | Type                          | Description |
| ----- | ----------------------------- | ----------- |
| count | STD_LOGIC_VECTOR(31 DOWNTO 0) |             |
| tmp   | STD_LOGIC                     |             |

## Processes
- unnamed: ( clk )
