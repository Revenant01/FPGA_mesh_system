----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2023 10:57:47 AM
-- Design Name: 
-- Module Name: ASCII_to_Alpha - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ASCII_to_Alpha is
    Port ( data_in : in STD_LOGIC_VECTOR (0 to 127);
           flagDoneDecryption : in STD_LOGIC;
           flagDoneConverting : out STD_LOGIC;
           data_out : out string (1 to 16) := (others => NUL));
end ASCII_to_Alpha;

architecture Behavioral of ASCII_to_Alpha is

begin

process (flagDoneDecryption)
begin
    if (flagDoneDecryption = '1') then
    for i in 1 to 16 loop
        case data_in(8*(i-1) to 8*(i-1)+7) is
            when x"61" => data_out (i) <= 'a';
            when x"62" => data_out (i) <= 'b';
            when x"63" => data_out (i) <= 'c';
            when x"64" => data_out (i) <= 'd';
            when x"65" => data_out (i) <= 'e';
            when x"66" => data_out (i) <= 'f';
            when x"67" => data_out (i) <= 'g';
            when x"68" => data_out (i) <= 'h';
            when x"69" => data_out (i) <= 'i';
            when x"6A" => data_out (i) <= 'j';
            when x"6B" => data_out (i) <= 'k';
            when x"6C" => data_out (i) <= 'l';
            when x"6D" => data_out (i) <= 'm';
            when x"6E" => data_out (i) <= 'n';
            when x"6F" => data_out (i) <= 'o';
            when x"70" => data_out (i) <= 'p';
            when x"71" => data_out (i) <= 'q';
            when x"72" => data_out (i) <= 'r';
            when x"73" => data_out (i) <= 's';
            when x"74" => data_out (i) <= 't';
            when x"75" => data_out (i) <= 'u';
            when x"76" => data_out (i) <= 'v';
            when x"77" => data_out (i) <= 'w';
            when x"78" => data_out (i) <= 'x';
            when x"79" => data_out (i) <= 'y';
            when x"7A" => data_out (i) <= 'z';
            
            when x"20" => data_out (i) <= ' ';
            when x"2E" => data_out (i) <= '.';
            
            when x"41" => data_out (i) <= 'A';
            when x"42" => data_out (i) <= 'B';
            when x"43" => data_out (i) <= 'C';
            when x"44" => data_out (i) <= 'D';
            when x"45" => data_out (i) <= 'E';
            when x"46" => data_out (i) <= 'F';
            when x"47" => data_out (i) <= 'G';
            when x"48" => data_out (i) <= 'H';
            when x"49" => data_out (i) <= 'I';
            when x"4A" => data_out (i) <= 'J';
            when x"4B" => data_out (i) <= 'K';
            when x"4C" => data_out (i) <= 'L';
            when x"4D" => data_out (i) <= 'M';
            when x"4E" => data_out (i) <= 'N';
            when x"4F" => data_out (i) <= 'O';
            when x"50" => data_out (i) <= 'P';
            when x"51" => data_out (i) <= 'Q';
            when x"52" => data_out (i) <= 'R';
            when x"53" => data_out (i) <= 'S';
            when x"54" => data_out (i) <= 'T';
            when x"55" => data_out (i) <= 'U';
            when x"56" => data_out (i) <= 'V';
            when x"57" => data_out (i) <= 'W';
            when x"58" => data_out (i) <= 'X';
            when x"59" => data_out (i) <= 'Y';
            when x"5A" => data_out (i) <= 'Z';
            
            when x"30" => data_out (i) <= '0';
            when x"31" => data_out (i) <= '1';
            when x"32" => data_out (i) <= '2';
            when x"33" => data_out (i) <= '3';
            when x"34" => data_out (i) <= '4';
            when x"35" => data_out (i) <= '5';
            when x"36" => data_out (i) <= '6';
            when x"37" => data_out (i) <= '7';
            when x"38" => data_out (i) <= '8';
            when x"39" => data_out (i) <= '9';
            
            when others => data_out (i) <= ' ';
            
          end case;
    end loop;
    flagDoneConverting <= '1';
    end if;
end process;

end Behavioral;
