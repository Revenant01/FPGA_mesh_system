library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Display is
  Port ( clk : in STD_LOGIC;                 --! System clock input
         reset : in STD_LOGIC;               --! Reset signal input
         flagDoneReceiving : in STD_LOGIC;   --! Flag indicating that all data has been received
         data : in STD_LOGIC_VECTOR (0 to 111); --! Input data vector (112 bits)
         vgaRed : out STD_LOGIC_VECTOR (3 downto 0);   --! 4-bit red output for VGA
         vgaGreen : out STD_LOGIC_VECTOR (3 downto 0); --! 4-bit green output for VGA
         vgaBlue : out STD_LOGIC_VECTOR (3 downto 0);  --! 4-bit blue output for VGA
         Hsync : out STD_LOGIC;               --! Horizontal synchronization signal for VGA
         Vsync : out STD_LOGIC                --! Vertical synchronization signal for VGA
        );
end Display;

architecture Behavioral of Display is

component ASCII_to_Alpha is
  Port ( data_in : in STD_LOGIC_VECTOR (0 to 127); --! Input data vector (128 bits)
         flagDoneDecryption : in STD_LOGIC;        --! Flag indicating decryption is complete
         flagDoneConverting : out STD_LOGIC;       --! Flag indicating ASCII to alpha conversion is complete
         data_out : out string (1 to 16) := (others => NUL) --! Output string (16 characters)
        );
end component;

component Clock_Divider is
port ( clk,reset: in std_logic; --! Input clock and reset signals
       clock_out: out std_logic  --! Output divided clock signal
     );
end component;



signal Clock_Out : STD_LOGIC;                      --! Internal signal for the divided clock
signal Video_Out : STD_LOGIC := '0';               --! Internal signal indicating active video region
signal h : integer range 0 to 800 := 0;           --! Internal signal for horizontal pixel counter (0 to 799)
signal v : integer range 0 to 525 := 0;           --! Internal signal for vertical line counter (0 to 524)
signal displayTextout1: string (1 to 16) := (others => NUL); --! Internal signal to hold the first text line
signal displayTextout2: string (1 to 32) := (others => NUL); --! Internal signal to hold the second text line (not directly used)
signal intermediateData1, intermediateData2: STD_LOGIC_vector (0 to 127); --! Internal signals for intermediate data (not directly used)
signal test: STD_LOGIC_vector (0 to 127) := (others => '0'); --! Internal test signal (not directly used)
signal Received_Data : STD_LOGIC_VECTOR (0 to 127) := (others => '0'); --! Internal signal to hold received data (not directly used)


-- results
signal d1, d2, d3, d4 : std_logic := '0'; --! Internal signals to indicate if a pixel belongs to a text character
--signal flagDoneReceiving : std_logic := '1';
--signal flagDoneDecryption : std_logic := '1';
signal flagDoneConverting1  : std_logic := '0'; --! Internal flag indicating ASCII to alpha conversion is done

signal x1 : integer range -256 to 640 := 200; --! Internal signal for the horizontal position of the first text
signal x2 : integer range -256 to 640 := 230; --! Internal signal for the horizontal position of the second text
signal x3 : integer range -256 to 640 := 200; --! Internal signal for the horizontal position of the third text (not used)
signal x4 : integer range -256 to 640 := 180; --! Internal signal for the horizontal position of the fourth text (not used)

begin

-- Instantiate the Clock Divider component
CD : Clock_Divider
  port map (
    clk => clk,
    reset => reset,
    clock_out => Clock_Out
  );

--RX1 : Receiver port map (clk, Rx, flagDoneReceiving, Received_Data);

--Decrypt : Decryption port map (Received_Data, flagDoneReceiving, flagDoneDecryption, intermediateData1);

-- Instantiate the ASCII to Alpha converter component
ascii : ASCII_to_Alpha
  port map (
    data_in => data & (others => '0'), -- Pad the input data to 128 bits
    flagDoneDecryption => flagDoneReceiving,
    flagDoneConverting => flagDoneConverting1,
    data_out => displayTextout1
  );

--DE : displayEncrypted port map (Received_Data, flagDoneReceiving,flagDoneConverting2, displayTextout2);


-- Instantiate the first text display element
textElement1: entity work.Pixel_On_Text
  generic map (
    textLength => 15
  )
  port map(
    clk => Clock_Out,
    displayText => "The Message is:",
    position => (x1, 220),
    horzCoord => h,
    vertCoord => v,
    pixel => d1
  );

-- Instantiate the second text display element
textElement2: entity work.Pixel_On_Text
  generic map (
    textLength => 14
  )
  port map(
    clk => Clock_Out,
    displayText => displayTextout1,
    position => (x2, 240),
    horzCoord => h,
    vertCoord => v,
    pixel => d2
  );



----------------------------------------------------------------------------------------
-- Process 1: Horizontal Position Counter
----------------------------------------------------------------------------------------
HL_Position : process (Clock_Out, reset, flagDoneConverting1)
begin
  if (flagDoneConverting1 = '1') then --! Enable process only after conversion is done
    if (reset = '1') then
      h <= 0; --! Reset horizontal counter
    elsif (rising_edge(Clock_Out)) then
      if (h = 799) then
        h <= 0; --! Wrap around at the end of the horizontal line
      else
        h <= h + 1; --! Increment horizontal counter
      end if;
    end if;
  end if;
end process;

----------------------------------------------------------------------------------------
-- Process 2: Vertical Position Counter
----------------------------------------------------------------------------------------
VL_Position : process (Clock_Out, reset, h, flagDoneConverting1)
begin
  if (flagDoneConverting1 = '1') then --! Enable process only after conversion is done
    if (reset = '1') then
      v <= 0; --! Reset vertical counter
    elsif (rising_edge(Clock_Out)) then
      if (h = 799) then --! Increment vertical counter at the end of each horizontal line
        if (v = 524) then
          v <= 0; --! Wrap around at the end of the vertical frame
          x2 <= x2 + 1; --! Increment horizontal position of the second text
          if (x2 = 640) then x2 <= -128; end if; --! Wrap around horizontal position
        else
          v <= v + 1; --! Increment vertical counter
        end if;
      end if;
    end if;
  end if;
end process;

----------------------------------------------------------------------------------------
-- Process 3: Horizontal Synchronization Signal Generation
----------------------------------------------------------------------------------------
HL_Sync : process (Clock_Out, reset, h, flagDoneConverting1)
begin
  if (flagDoneConverting1 = '1') then --! Enable process only after conversion is done
    if (reset = '1') then
      Hsync <= '1'; --! Initialize Hsync high
    elsif (rising_edge(Clock_Out)) then
      if (h > 655 and h < 752) then --! Generate Hsync pulse
        Hsync <= '0';
      else
        Hsync <= '1';
      end if;
    end if;
  end if;
end process;

----------------------------------------------------------------------------------------
-- Process 4: Vertical Synchronization Signal Generation
----------------------------------------------------------------------------------------
VL_Sync : process (Clock_Out, reset, v, flagDoneConverting1)
begin
  if (flagDoneConverting1 = '1') then --! Enable process only after conversion is done
    if (reset = '1') then
      Vsync <= '1'; --! Initialize Vsync high
    elsif (rising_edge(Clock_Out)) then
      if (v > 489 and v < 492) then --! Generate Vsync pulse
        Vsync <= '0';
      else
        Vsync <= '1';
      end if;
    end if;
  end if;
end process;

----------------------------------------------------------------------------------------
-- Process 5: Video Output Enable Signal
----------------------------------------------------------------------------------------
Display : process (Clock_Out, reset, h, v, flagDoneConverting1)
begin
  if (flagDoneConverting1 = '1') then --! Enable process only after conversion is done
    if (reset = '1') then
      Video_Out <= '0'; --! Initialize video output disabled
    elsif (rising_edge(Clock_Out)) then
      if (v < 480 and h < 640) then --! Active video region (standard 640x480)
        Video_Out <= '1';
      else
        Video_Out <= '0';
      end if;
    end if;
  end if;
end process;

----------------------------------------------------------------------------------------
-- Process 6: VGA Color Output Generation
----------------------------------------------------------------------------------------
process (Video_Out, flagDoneConverting1, flagDoneReceiving, d1, d2, d3, d4)
begin
if (flagDoneReceiving = '1') then --! Enable color output only after receiving data
  if (flagDoneConverting1 = '1') then --! Enable color output only after conversion
    if (Video_Out = '1') then --! Output colors only in the active video region
      if (d1 = '1') then --! If the current pixel belongs to the first text
        vgaRed <= "1111";
        vgaBlue <= "0000";
        vgaGreen <= "0000";
      elsif (d2 = '1') then --! If the current pixel belongs to the second text
        vgaRed <= "1111";
        vgaBlue <= "1111";
        vgaGreen <= "1111";
      elsif (d3 = '1') then --! If the current pixel belongs to the third text (not used)
        vgaRed <= "1111";
        vgaBlue <= "0000";
        vgaGreen <= "0000";
      elsif (d4 = '1') then --! If the current pixel belongs to the fourth text (not used)
        vgaRed <= "1111";
        vgaBlue <= "1111";
        vgaGreen <= "1111";
      else --! Background color
        vgaRed <= "0000";
        vgaBlue <= "0000";
        vgaGreen <= "0000";
      end if;
    else --! Black color in the non-active video regions (sync pulses, borders)
      vgaRed <= "0000";
      vgaBlue <= "0000";
      vgaGreen <= "0000";
    end if;
  else --! Default black if conversion is not done
    vgaRed <= "0000";
    vgaBlue <= "0000";
    vgaGreen <= "0000";
  end if;
else --! Default black if data is not received
  vgaRed <= "0000";
  vgaBlue <= "0000";
  vgaGreen <= "0000";
end if;
end process;


end Behavioral;