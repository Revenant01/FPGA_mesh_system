-- Pixel_On_Text determines if the current pixel is on text
-- param:
--   textlength, use to init the string
-- input:
--   VGA clock(the clk you used to update VGA)
--   display text
--   top left corner of the text box
--   current X and Y position
-- output:
--   a bit that represent whether is the pixel in text

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- note this line.The package is compiled to this directory by default.
-- so don't forget to include this directory.
library work;
-- this line also is must.This includes the particular package into your program.
use work.commonPak.all;

entity Pixel_On_Text is
  generic(
    -- needed for init displayText, the default value 11 is just a random number
    textLength: integer := 11 --! Generic parameter to define the maximum length of the display text
  );
  port (
    clk: in std_logic;                                       --! Input clock signal
    displayText: in string (1 to textLength) := (others => NUL); --! Input string to be displayed
    -- top left corner of the text
    position: in point_2d := (0, 0);                          --! Input coordinate for the top-left corner of the text box
    -- current pixel postion
    horzCoord: in integer;                                   --! Input horizontal coordinate of the current pixel
    vertCoord: in integer;                                   --! Input vertical coordinate of the current pixel

    pixel: out std_logic := '0'                              --! Output signal indicating if the current pixel is part of the text
  );

end Pixel_On_Text;

architecture Behavioral of Pixel_On_Text is

  signal fontAddress: integer;                               --! Signal to store the address for the font ROM
  -- A row of bit in a charactor, we check if our current (x,y) is 1 in char row
  signal charBitInRow: std_logic_vector(FONT_WIDTH-1 downto 0) := (others => '0'); --! Signal to hold the bit pattern of the current font row
  -- char in ASCII code
  signal charCode:integer := 0;                              --! Signal to store the ASCII code of the current character
  -- the position(column) of a charactor in the given text
  signal charPosition:integer := 0;                          --! Signal to store the horizontal position of the current character in the text
  -- the bit position(column) in a charactor
  signal bitPosition:integer := 0;                           --! Signal to store the horizontal bit position within the current character

begin
  -- Calculate the character position in the text based on the current horizontal coordinate and the text's starting X-coordinate
  charPosition <= (horzCoord - position.x)/FONT_WIDTH + 1;
  -- Calculate the bit position within the current character based on the current horizontal coordinate and the character's starting X-coordinate
  bitPosition <= (horzCoord - position.x) mod FONT_WIDTH;
  -- Get the ASCII code of the character at the calculated position in the displayText string
  charCode <= character'pos(displayText(charPosition));
  -- Calculate the address in the font ROM for the current character and row
  -- Each character in the font ROM occupies FONT_HEIGHT (typically 16) consecutive addresses
  -- (vertCoord - position.y) determines the current row within the character
  fontAddress <= charCode*FONT_HEIGHT+(vertCoord - position.y);


  -- Instantiate the Font ROM entity to get the bit pattern for the current character row
  fontRom: entity work.Font_Rom
  port map(
    clk => clk,
    addr => fontAddress,
    fontRow => charBitInRow
  );

  -- Process to determine if the current pixel should be on (part of the text)
  pixelOn: process(clk)
    variable inXRange: boolean := false; --! Variable to track if the current pixel's X-coordinate is within the text boundaries
    variable inYRange: boolean := false; --! Variable to track if the current pixel's Y-coordinate is within the text boundaries
  begin
    if rising_edge(clk) then
      -- Reset the output pixel value and range flags on each clock cycle
      inXRange := false;
      inYRange := false;
      pixel <= '0';

      -- Check if the current pixel's horizontal coordinate is within the bounds of the displayed text
      if horzCoord >= position.x and horzCoord < position.x + (FONT_WIDTH * textlength) then
        inXRange := true;
      end if;

      -- Check if the current pixel's vertical coordinate is within the bounds of the displayed text
      if vertCoord >= position.y and vertCoord < position.y + FONT_HEIGHT then
        inYRange := true;
      end if;

      -- If the current pixel is within both the horizontal and vertical bounds of the text
      if inXRange and inYRange then
        -- Check if the corresponding bit in the current font row is '1'
        -- FONT_WIDTH-1-bitPosition: Access the correct bit in the std_logic_vector, considering the bit order in the font ROM
        if charBitInRow(FONT_WIDTH-1-bitPosition) = '1' then
          pixel <= '1'; -- If the bit is '1', the pixel should be on
        end if;
      end if;

    end if;
  end process;


end Behavioral;