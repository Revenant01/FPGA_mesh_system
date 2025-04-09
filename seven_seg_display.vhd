LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY seven_seg_display IS
  PORT (
    clk : IN STD_LOGIC;                 --! Clock input
    ready : IN STD_LOGIC;               --! Ready signal input
    state : IN STD_LOGIC_VECTOR(127 DOWNTO 0); --! 128-bit state input
    seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);   --! 7-bit segment output
    an : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);    --! 2-bit anode output
    an2 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)   --! Another 2-bit anode output
  );
END seven_seg_display;

ARCHITECTURE Behavioral OF seven_seg_display IS
  -- Component declaration for the clock divider
  COMPONENT clockDivider IS
    PORT (
      clk : IN STD_LOGIC;
      clock_out : OUT STD_LOGIC;
      an_ref : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
  END COMPONENT;

  -- Signals declaration
  SIGNAL counter : INTEGER := 0;        --! Counter to select the 8-bit chunk from the state
  SIGNAL clk_in : STD_LOGIC;           --! Output clock signal from the clock divider
  SIGNAL output : STD_LOGIC_VECTOR(7 DOWNTO 0); --! 8-bit output selected from the state
  SIGNAL LED_IN, most_sig_4, least_sig_4 : STD_LOGIC_VECTOR(3 DOWNTO 0); --! Input to the segment decoder and its nibbles
  SIGNAL anode_ref : STD_LOGIC_VECTOR(1 DOWNTO 0); --! Anode reference signal from the clock divider
  --signal state: std_logic_vector(127 downto 0); --! Original state signal (commented out)

BEGIN
  an2 <= "11";                         --! Always drive an2 high (both anodes inactive for this output)

  -- Instantiate the clock divider component
  clkDiv : clockDivider
    PORT MAP (
      clk => clk,
      clock_out => clk_in,
      an_ref => anode_ref
    );

  -- Process to select 8 bits from the 'state' based on the counter
  PROCESS (clk_in)
  BEGIN
    IF (ready = '1') THEN              --! Execute only when the 'ready' signal is high
      IF (rising_edge(clk_in)) THEN   --! On the rising edge of the divided clock
        output <= state(127 - 8 * counter DOWNTO 120 - 8 * counter); --! Select 8 bits from 'state'
        most_sig_4 <= output(7 DOWNTO 4); --! Get the most significant 4 bits
        least_sig_4 <= output(3 DOWNTO 0); --! Get the least significant 4 bits
        counter <= counter + 1;         --! Increment the counter
        IF (counter = 16) THEN         --! Reset the counter after iterating through 16 bytes
          counter <= 0;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  -- Process to decode the 4-bit input 'LED_IN' to the 7-segment output 'seg'
  PROCESS (LED_IN)
  BEGIN
    CASE LED_IN IS
      WHEN "0000" => seg <= "0000001"; --! Display '0'
      WHEN "0001" => seg <= "1001111"; --! Display '1'
      WHEN "0010" => seg <= "0010010"; --! Display '2'
      WHEN "0011" => seg <= "0000110"; --! Display '3'
      WHEN "0100" => seg <= "1001100"; --! Display '4'
      WHEN "0101" => seg <= "0100100"; --! Display '5'
      WHEN "0110" => seg <= "0100000"; --! Display '6'
      WHEN "0111" => seg <= "0001111"; --! Display '7'
      WHEN "1000" => seg <= "0000000"; --! Display '8'
      WHEN "1001" => seg <= "0000100"; --! Display '9'
      WHEN "1010" => seg <= "0001000"; --! Display 'A'
      WHEN "1011" => seg <= "1100000"; --! Display 'B'
      WHEN "1100" => seg <= "1110010"; --! Display 'C'
      WHEN "1101" => seg <= "1000010"; --! Display 'D'
      WHEN "1110" => seg <= "0110000"; --! Display 'E'
      WHEN "1111" => seg <= "0111000"; --! Display 'F'
    END CASE;
  END PROCESS;

  -- Process to control the anodes and select which 4-bit nibble to display
  PROCESS (anode_ref)
  BEGIN
    CASE anode_ref IS
      WHEN "00" => an <= "01";        --! Activate the first anode
        LED_IN <= most_sig_4;       --! Display the most significant 4 bits
      WHEN "01" => an <= "10";        --! Activate the second anode
        LED_IN <= least_sig_4;      --! Display the least significant 4 bits
      WHEN "10" => an <= "01";        --! Activate the first anode (repeated for multiplexing)
        LED_IN <= most_sig_4;       --! Display the most significant 4 bits
      WHEN "11" => an <= "10";        --! Activate the second anode (repeated for multiplexing)
        LED_IN <= least_sig_4;      --! Display the least significant 4 bits
    END CASE;
  END PROCESS;
  --state<=x"1a2b55784c8e9b112307085a4c3b9d8e"; --! Example state value (commented out)
END Behavioral;