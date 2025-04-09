library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Keyboard is
  Port ( clk : in STD_LOGIC;             --! System clock input
         ps2_clk : in STD_LOGIC;         --! Clock signal from the PS/2 keyboard
         ps2_data : in STD_LOGIC;        --! Data signal from the PS/2 keyboard
         flag_receive : out STD_LOGIC;    --! Flag indicating that new data has been received
         data_out: out STD_LOGIC_vector(0 to 127) --! 128-bit output to store received data
        );
end Keyboard;

architecture Behavioral of Keyboard is

COMPONENT ps2_keyboard_to_ascii IS
  GENERIC(
    clk_freq                  : INTEGER := 100_000_000; --! System clock frequency in Hz
    ps2_debounce_counter_size : INTEGER := 9         --! Size of the debounce counter for PS/2 signals
  );
  PORT(
    clk       : IN  STD_LOGIC;                       --! System clock input
    ps2_clk   : IN  STD_LOGIC;                       --! Clock signal from PS2 keyboard
    ps2_data  : IN  STD_LOGIC;                       --! Data signal from PS2 keyboard
    ascii_new : OUT STD_LOGIC;                       --! Output flag indicating a new ASCII value is available
    ascii_code : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)    --! 7-bit ASCII value output
  );
END COMPONENT;

component SEG7_TEST is
  Port ( clk : in STD_LOGIC;
         reset : in STD_LOGIC;
         data : in STD_LOGIC_vector(0 to 127);
         go:in std_logic;
         an : out STD_LOGIC_vector(3 downto 0);
         seg : out STD_LOGIC_vector(0 to 6));
end component;


signal ascii_new:std_logic;                       --! Signal indicating a new ASCII code from the PS/2 decoder
signal ascii_code :  STD_LOGIC_VECTOR(0 to 6);    --! Signal to store the 7-bit ASCII code
signal data :STD_LOGIC_VECTOR(0 to 127):=(others=>'0'); --! Signal to store the received ASCII characters
signal flag_matrix_done:std_logic:='0';           --! Flag indicating that the matrix operation is done (currently not used)
signal reset :std_logic:='0';                      --! Reset signal (currently not used)

begin

-- Instantiate the PS/2 keyboard to ASCII converter component
Keyboard : ps2_keyboard_to_ascii
  port map (
    clk => clk,
    ps2_clk => ps2_clk,
    ps2_data => ps2_data,
    ascii_new => ascii_new,
    ascii_code => ascii_code
  );
--seg7 : SEG7_TEST port map (clk,reset,data, flag_matrix_done,an,seg); --to be comented

-- Assign the internal 'data' signal to the output port 'data_out'
data_out <= data;

-- Process to capture the received ASCII characters into the 'data' signal
process(ascii_new)
  variable counter: integer range 0 to 16:=0; --! Counter to track the number of received characters
begin
  if rising_edge(ascii_new) then --! Trigger on the rising edge of the 'ascii_new' flag
    if counter<16 then --! Store up to 16 characters
      if counter=0 then --! For the first character received
        data(8*counter to 8*counter+7) <= '0' & ascii_code; --! Store the 7-bit ASCII code with a leading '0'
        flag_receive <= '1'; --! Set the receive flag high
      elsif counter = 15 then --! For the 16th character received
        flag_receive <= '0'; --! Set the receive flag low after receiving 16 characters
        data(8*counter to 8*counter+7) <= '0' & ascii_code; --! Store the 7-bit ASCII code with a leading '0'
      else --! For characters 2 to 15
        data(8*counter to 8*counter+7) <= '0' & ascii_code; --! Store the 7-bit ASCII code with a leading '0'
      end if;
      counter:=counter+1; --! Increment the character counter
    end if;
    if counter=16 then --! After receiving 16 characters
      flag_matrix_done <= '1' after 100 us; --! Set the matrix done flag (currently with a delay)
      flag_receive <= '0'; --! Ensure the receive flag is low
      counter:=0; --! Reset the counter for the next set of characters
    end if;
  end if;
end process;

end Behavioral;