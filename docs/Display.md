
# Entity: Display 
- **File**: Display.vhd

## Diagram
![Diagram](Display.svg "Diagram")
## Ports

| Port name         | Direction | Type                          | Description                                     |
| ----------------- | --------- | ----------------------------- | ----------------------------------------------- |
| clk               | in        | STD_LOGIC                     | System clock input                              |
| reset             | in        | STD_LOGIC                     | Reset signal input                              |
| flagDoneReceiving | in        | STD_LOGIC                     | Flag indicating that all data has been received |
| data              | in        | STD_LOGIC_VECTOR (0 to 111)   | Input data vector (112 bits)                    |
| vgaRed            | out       | STD_LOGIC_VECTOR (3 downto 0) | 4-bit red output for VGA                        |
| vgaGreen          | out       | STD_LOGIC_VECTOR (3 downto 0) | 4-bit green output for VGA                      |
| vgaBlue           | out       | STD_LOGIC_VECTOR (3 downto 0) | 4-bit blue output for VGA                       |
| Hsync             | out       | STD_LOGIC                     | Horizontal synchronization signal for VGA       |
| Vsync             | out       | STD_LOGIC                     | Vertical synchronization signal for VGA         |

## Signals

| Name                | Type                        | Description                                                              |
| ------------------- | --------------------------- | ------------------------------------------------------------------------ |
| Clock_Out           | STD_LOGIC                   | Internal signal for the divided clock                                    |
| Video_Out           | STD_LOGIC                   | Internal signal indicating active video region                           |
| h                   | integer range 0 to 800      | Internal signal for horizontal pixel counter (0 to 799)                  |
| v                   | integer range 0 to 525      | Internal signal for vertical line counter (0 to 524)                     |
| displayTextout1     | string (1 to 16)            | Internal signal to hold the first text line                              |
| displayTextout2     | string (1 to 32)            | Internal signal to hold the second text line (not directly used)         |
| intermediateData1   | STD_LOGIC_vector (0 to 127) | Internal signals for intermediate data (not directly used)               |
| intermediateData2   | STD_LOGIC_vector (0 to 127) | Internal signals for intermediate data (not directly used)               |
| test                | STD_LOGIC_vector (0 to 127) | Internal test signal (not directly used)                                 |
| Received_Data       | STD_LOGIC_VECTOR (0 to 127) | Internal signal to hold received data (not directly used)                |
| d1                  | std_logic                   | Internal signals to indicate if a pixel belongs to a text character      |
| d2                  | std_logic                   | Internal signals to indicate if a pixel belongs to a text character      |
| d3                  | std_logic                   | Internal signals to indicate if a pixel belongs to a text character      |
| d4                  | std_logic                   | Internal signals to indicate if a pixel belongs to a text character      |
| flagDoneConverting1 | std_logic                   | Internal flag indicating ASCII to alpha conversion is done               |
| x1                  | integer range -256 to 640   | Internal signal for the horizontal position of the first text            |
| x2                  | integer range -256 to 640   | Internal signal for the horizontal position of the second text           |
| x3                  | integer range -256 to 640   | Internal signal for the horizontal position of the third text (not used) |
| x4                  | integer range -256 to 640   |                                                                          |

## Processes
- HL_Position: ( Clock_Out, reset, flagDoneConverting1 )
- VL_Position: ( Clock_Out, reset, h, flagDoneConverting1 )
- HL_Sync: ( Clock_Out, reset, h, flagDoneConverting1 )
- VL_Sync: ( Clock_Out, reset, v, flagDoneConverting1 )
- Display: ( Clock_Out, reset, h, v, flagDoneConverting1 )
- unnamed: ( Video_Out, flagDoneConverting1, flagDoneReceiving, d1, d2, d3, d4 )

## Instantiations

- CD: Clock_Divider
- ascii: ASCII_to_Alpha
- textElement1: work.Pixel_On_Text
- textElement2: work.Pixel_On_Text
