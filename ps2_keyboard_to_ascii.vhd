LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ps2_keyboard_to_ascii IS
  GENERIC(
      clk_freq                  : INTEGER := 100_000_000;
      ps2_debounce_counter_size : INTEGER := 9);
  PORT(
      clk        : IN  STD_LOGIC;
      ps2_clk    : IN  STD_LOGIC;
      ps2_data   : IN  STD_LOGIC;
      ascii_new  : OUT STD_LOGIC;
      ascii_code : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END ps2_keyboard_to_ascii;

ARCHITECTURE behavior OF ps2_keyboard_to_ascii IS
  TYPE machine IS(ready, new_code, translate, output);
  SIGNAL state             : machine;
  SIGNAL ps2_code_new      : STD_LOGIC;
  SIGNAL ps2_code          : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL prev_ps2_code_new : STD_LOGIC := '1';
  SIGNAL break             : STD_LOGIC := '0';
  SIGNAL e0_code           : STD_LOGIC := '0';
  SIGNAL caps_lock         : STD_LOGIC := '0';
  SIGNAL control_r         : STD_LOGIC := '0';
  SIGNAL control_l         : STD_LOGIC := '0';
  SIGNAL shift_r           : STD_LOGIC := '0';
  SIGNAL shift_l           : STD_LOGIC := '0';
  SIGNAL ascii             : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"FF";

  COMPONENT ps2_keyboard IS
    GENERIC(
      clk_freq              : INTEGER;
      debounce_counter_size : INTEGER);
    PORT(
      clk          : IN  STD_LOGIC;
      ps2_clk      : IN  STD_LOGIC;
      ps2_data     : IN  STD_LOGIC;
      ps2_code_new : OUT STD_LOGIC;
      ps2_code     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
  END COMPONENT;

BEGIN

  ps2_keyboard_0:  ps2_keyboard
    GENERIC MAP(clk_freq => clk_freq, debounce_counter_size => ps2_debounce_counter_size)
    PORT MAP(clk => clk, ps2_clk => ps2_clk, ps2_data => ps2_data, ps2_code_new => ps2_code_new, ps2_code => ps2_code);

  PROCESS(clk)
  BEGIN
    IF(clk'EVENT AND clk = '1') THEN
      prev_ps2_code_new <= ps2_code_new;
      CASE state IS
      
        WHEN ready =>
          IF(prev_ps2_code_new = '0' AND ps2_code_new = '1') THEN
            ascii_new <= '0';
            state <= new_code;
          ELSE
            state <= ready;
          END IF;
          
        WHEN new_code =>
          IF(ps2_code = x"F0") THEN
            break <= '1';
            state <= ready;
          ELSIF(ps2_code = x"E0") THEN
            e0_code <= '1';
            state <= ready;
          ELSE
            ascii(7) <= '1';
            state <= translate;
          END IF;

        WHEN translate =>
            break <= '0';
            e0_code <= '0';
            
            CASE ps2_code IS
              WHEN x"58" =>
                IF(break = '0') THEN
                  caps_lock <= NOT caps_lock;
                END IF;
              WHEN x"14" =>
                IF(e0_code = '1') THEN
                  control_r <= NOT break;
                ELSE
                  control_l <= NOT break;
                END IF;
              WHEN x"12" =>
                shift_l <= NOT break;
              WHEN x"59" =>
                shift_r <= NOT break;
              WHEN OTHERS => NULL;
            END CASE;
        
            IF(control_l = '1' OR control_r = '1') THEN
              CASE ps2_code IS
                WHEN x"1E" => ascii <= x"00";
                WHEN x"1C" => ascii <= x"01";
                WHEN x"32" => ascii <= x"02";
                WHEN x"21" => ascii <= x"03";
                WHEN x"23" => ascii <= x"04";
                WHEN x"24" => ascii <= x"05";
                WHEN x"2B" => ascii <= x"06";
                WHEN x"34" => ascii <= x"07";
                WHEN x"33" => ascii <= x"08";
                WHEN x"43" => ascii <= x"09";
                WHEN x"3B" => ascii <= x"0A";
                WHEN x"42" => ascii <= x"0B";
                WHEN x"4B" => ascii <= x"0C";
                WHEN x"3A" => ascii <= x"0D";
                WHEN x"31" => ascii <= x"0E";
                WHEN x"44" => ascii <= x"0F";
                WHEN x"4D" => ascii <= x"10";
                WHEN x"15" => ascii <= x"11";
                WHEN x"2D" => ascii <= x"12";
                WHEN x"1B" => ascii <= x"13";
                WHEN x"2C" => ascii <= x"14";
                WHEN x"3C" => ascii <= x"15";
                WHEN x"2A" => ascii <= x"16";
                WHEN x"1D" => ascii <= x"17";
                WHEN x"22" => ascii <= x"18";
                WHEN x"35" => ascii <= x"19";
                WHEN x"1A" => ascii <= x"1A";
                WHEN x"54" => ascii <= x"1B";
                WHEN x"5D" => ascii <= x"1C";
                WHEN x"5B" => ascii <= x"1D";
                WHEN x"36" => ascii <= x"1E";
                WHEN x"4E" => ascii <= x"1F";
                WHEN x"4A" => ascii <= x"7F";
                WHEN OTHERS => NULL;
              END CASE;
            ELSE
              CASE ps2_code IS
                WHEN x"29" => ascii <= x"20";
                WHEN x"66" => ascii <= x"08";
                WHEN x"0D" => ascii <= x"09";
                WHEN x"5A" => ascii <= x"0D";
                WHEN x"76" => ascii <= x"1B";
                WHEN x"71" =>
                  IF(e0_code = '1') THEN
                    ascii <= x"7F";
                  END IF;
                WHEN OTHERS => NULL;
              END CASE;
              
              IF((shift_r = '0' AND shift_l = '0' AND caps_lock = '0') OR
                ((shift_r = '1' OR shift_l = '1') AND caps_lock = '1')) THEN
                CASE ps2_code IS
                  WHEN x"1C" => ascii <= x"61";
                  WHEN x"32" => ascii <= x"62";
                  WHEN x"21" => ascii <= x"63";
                  WHEN x"23" => ascii <= x"64";
                  WHEN x"24" => ascii <= x"65";
                  WHEN x"2B" => ascii <= x"66";
                  WHEN x"34" => ascii <= x"67";
                  WHEN x"33" => ascii <= x"68";
                  WHEN x"43" => ascii <= x"69";
                  WHEN x"3B" => ascii <= x"6A";
                  WHEN x"42" => ascii <= x"6B";
                  WHEN x"4B" => ascii <= x"6C";
                  WHEN x"3A" => ascii <= x"6D";
                  WHEN x"31" => ascii <= x"6E";
                  WHEN x"44" => ascii <= x"6F";
                  WHEN x"4D" => ascii <= x"70";
                  WHEN x"15" => ascii <= x"71";
                  WHEN x"2D" => ascii <= x"72";
                  WHEN x"1B" => ascii <= x"73";
                  WHEN x"2C" => ascii <= x"74";
                  WHEN x"3C" => ascii <= x"75";
                  WHEN x"2A" => ascii <= x"76";
                  WHEN x"1D" => ascii <= x"77";
                  WHEN x"22" => ascii <= x"78";
                  WHEN x"35" => ascii <= x"79";
                  WHEN x"1A" => ascii <= x"7A";
                  WHEN OTHERS => NULL;
                END CASE;
              ELSE
                CASE ps2_code IS
                  WHEN x"1C" => ascii <= x"41";
                  WHEN x"32" => ascii <= x"42";
                  WHEN x"21" => ascii <= x"43";
                  WHEN x"23" => ascii <= x"44";
                  WHEN x"24" => ascii <= x"45";
                  WHEN x"2B" => ascii <= x"46";
                  WHEN x"34" => ascii <= x"47";
                  WHEN x"33" => ascii <= x"48";
                  WHEN x"43" => ascii <= x"49";
                  WHEN x"3B" => ascii <= x"4A";
                  WHEN x"42" => ascii <= x"4B";
                  WHEN x"4B" => ascii <= x"4C";
                  WHEN x"3A" => ascii <= x"4D";
                  WHEN x"31" => ascii <= x"4E";
                  WHEN x"44" => ascii <= x"4F";
                  WHEN x"4D" => ascii <= x"50";
                  WHEN x"
