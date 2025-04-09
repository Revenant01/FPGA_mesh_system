
# Entity: Pixel_On_Text 
- **File**: Pixel_On_Text.vhd

## Diagram
![Diagram](Pixel_On_Text.svg "Diagram")
## Generics

| Generic name | Type    | Value | Description                                                        |
| ------------ | ------- | ----- | ------------------------------------------------------------------ |
| textLength   | integer | 11    | Generic parameter to define the maximum length of the display text |

## Ports

| Port name   | Direction | Type                     | Description                                                       |
| ----------- | --------- | ------------------------ | ----------------------------------------------------------------- |
| clk         | in        | std_logic                | Input clock signal                                                |
| displayText | in        | string (1 to textLength) | Input string to be displayed                                      |
| position    | in        | point_2d                 | Input coordinate for the top-left corner of the text box          |
| horzCoord   | in        | integer                  | Input horizontal coordinate of the current pixel                  |
| vertCoord   | in        | integer                  | Input vertical coordinate of the current pixel                    |
| pixel       | out       | std_logic                | Output signal indicating if the current pixel is part of the text |

## Signals

| Name         | Type                                    | Description                                                                  |
| ------------ | --------------------------------------- | ---------------------------------------------------------------------------- |
| fontAddress  | integer                                 | Signal to store the address for the font ROM                                 |
| charBitInRow | std_logic_vector(FONT_WIDTH-1 downto 0) | Signal to hold the bit pattern of the current font row                       |
| charCode     | integer                                 | Signal to store the ASCII code of the current character                      |
| charPosition | integer                                 | Signal to store the horizontal position of the current character in the text |
| bitPosition  | integer                                 |                                                                              |

## Processes
- pixelOn: ( clk )

## Instantiations

- fontRom: work.Font_Rom
