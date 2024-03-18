-- myuart
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY myuart IS
    PORT (
        din : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        busy : OUT STD_LOGIC;
        wen : IN STD_LOGIC;
        sout : OUT STD_LOGIC;
        clr : IN STD_LOGIC;
        clk : IN STD_LOGIC);
END myuart;




ARCHITECTURE rtl OF myuart IS
    SIGNAL countsup1, countsup2, sout_temp, busy_temp : STD_LOGIC;
    SIGNAL ctr1, ctr2 : unsigned(7 DOWNTO 0);
    SIGNAL din_temp : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    PROCESS (clk, wen, countsup2)BEGIN
        IF countsup2 = '1' THEN
            din_temp <= "00000000";
        ELSIF rising_edge(clk) THEN
            IF wen = '1' THEN
                din_temp <= din;
            END IF;
        END IF;
    END PROCESS;
    --counter 1
    PROCESS (clk, countsup2, countsup1, clr)BEGIN
        IF countsup2 = '1' OR countsup1 = '1' OR clr = '1' THEN
            ctr1 <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            ctr1 <= ctr1 + 1;
        END IF;
    END PROCESS;




    PROCESS (clk) BEGIN
        IF rising_edge(clk) THEN
            IF ctr1 = 8 THEN
                countsup1 <= '1';
            ELSE
                countsup1 <= '0';
            END IF;
        END IF;
    END PROCESS;




    --counter 2
    PROCESS (clk, wen, countsup1, clr)BEGIN
        IF clr = '1' THEN
            ctr2 <= to_unsigned(10, 8);
        ELSIF wen = '1' THEN
            ctr2 <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            CASE countsup1 IS
                WHEN '0' =>
                    ctr2 <= ctr2 + 0;
                WHEN OTHERS =>
                    ctr2 <= ctr2 + 1;
            END CASE;
        END IF;
    END PROCESS;
    countsup2 <= '1' WHEN (ctr2 = 10) ELSE '0';




    --sout processes
    PROCESS (ctr2)BEGIN
        IF ctr2 = 0 THEN
            sout_temp <= '0';
        ELSIF ctr2 = 9 OR ctr2 = 10 THEN
            sout_temp <= '1';
        ELSIF ctr2 < 9 THEN
            sout_temp <= din_temp(to_integer(ctr2) - 1);
        END IF;
    END PROCESS;




    PROCESS (clk, clr) BEGIN
        IF clr = '1' THEN
            sout <= '1';
        ELSIF rising_edge(clk) THEN
            sout <= sout_temp;
        END IF;
    END PROCESS;




    --busy processes
    PROCESS (clk, clr)BEGIN
        IF clr = '1' THEN
            busy <= '0';
        ELSIF rising_edge(clk) THEN
            busy <= NOT countsup2;
        END IF;
    END PROCESS;




END rtl;