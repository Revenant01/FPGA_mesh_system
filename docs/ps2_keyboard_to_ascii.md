
# Entity: ps2_keyboard_to_ascii 
- **File**: ps2_keyboard_to_ascii.vhd

## Diagram
![Diagram](ps2_keyboard_to_ascii.svg "Diagram")
## Generics

| Generic name              | Type    | Value       | Description |
| ------------------------- | ------- | ----------- | ----------- |
| clk_freq                  | INTEGER | 100_000_000 |             |
| ps2_debounce_counter_size | INTEGER | 9           |             |

## Ports

| Port name  | Direction | Type                         | Description |
| ---------- | --------- | ---------------------------- | ----------- |
| clk        | in        | STD_LOGIC                    |             |
| ps2_clk    | in        | STD_LOGIC                    |             |
| ps2_data   | in        | STD_LOGIC                    |             |
| ascii_new  | out       | STD_LOGIC                    |             |
| ascii_code | out       | STD_LOGIC_VECTOR(6 DOWNTO 0) |             |
