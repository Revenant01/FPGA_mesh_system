
# Entity: ps2_keyboard 
- **File**: ps2_keyboard.vhd

## Diagram
![Diagram](ps2_keyboard.svg "Diagram")
## Generics

| Generic name          | Type    | Value      | Description |
| --------------------- | ------- | ---------- | ----------- |
| clk_freq              | INTEGER | 50_000_000 |             |
| debounce_counter_size | INTEGER | 8          |             |

## Ports

| Port name    | Direction | Type                         | Description |
| ------------ | --------- | ---------------------------- | ----------- |
| clk          | in        | STD_LOGIC                    |             |
| ps2_clk      | in        | STD_LOGIC                    |             |
| ps2_data     | in        | STD_LOGIC                    |             |
| ps2_code_new | out       | STD_LOGIC                    |             |
| ps2_code     | out       | STD_LOGIC_VECTOR(7 DOWNTO 0) |             |

## Signals

| Name         | Type                               | Description |
| ------------ | ---------------------------------- | ----------- |
| sync_ffs     | STD_LOGIC_VECTOR(1 DOWNTO 0)       |             |
| ps2_clk_int  | STD_LOGIC                          |             |
| ps2_data_int | STD_LOGIC                          |             |
| ps2_word     | STD_LOGIC_VECTOR(10 DOWNTO 0)      |             |
| error        | STD_LOGIC                          |             |
| count_idle   | INTEGER RANGE 0 TO clk_freq/18_000 |             |

## Processes
- unnamed: ( clk )
- unnamed: ( ps2_clk_int )
- unnamed: ( clk )

## Instantiations

- debounce_ps2_clk: debounce
- debounce_ps2_data: debounce
