-- symb_det
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY symb_det IS
    PORT (
        clk : IN STD_LOGIC;
        clr : IN STD_LOGIC;
        adc_data : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        symbol_valid : OUT STD_LOGIC;
        symbol_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END symb_det;
ARCHITECTURE Behavioral OF symb_det IS
    SIGNAL countsup1, crossed, start_count, silent, start_scanning, toggle, countsup3 : STD_LOGIC;
    SIGNAL ctr1, ctr2, ctr2_temp, ctr3 : unsigned(12 DOWNTO 0);
    SIGNAL val, next_val : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL symb_out_temp : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL symb_valid_temp : STD_LOGIC;
    SIGNAL adc_data_temp : STD_LOGIC_VECTOR(11 DOWNTO 0);
BEGIN
    adc_data_temp <= adc_data - "100000000000";
    --Processes for checking whether ADC data is big enough to start the circuit (A.K.A. The setup)
    
    --Checks if adc_data pass a certain threshold
    PROCESS (adc_data)BEGIN
        IF unsigned(adc_data_temp) > 4 THEN
            start_scanning <= '1';
        ELSE
            start_scanning <= '0';
        END IF;
    END PROCESS;
    toggle <= start_scanning AND silent;


    --TFF for when adc_data does become big
    PROCESS (toggle, clk, clr)BEGIN
        IF clr = '1' THEN
            silent <= '1';
        ELSIF rising_edge(clk) THEN
            IF toggle = '1' THEN
                silent <= NOT silent;
            END IF;
        END IF;
    END PROCESS;


    --counter1 processes
    --The counter
    PROCESS (clk, silent, countsup1)BEGIN
        IF silent = '1' OR countsup1 = '1' THEN
            ctr1 <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            ctr1 <= ctr1 + 1;
        END IF;
    END PROCESS;


    --countsup1
    PROCESS (ctr1, clk)BEGIN
        IF rising_edge(clk) THEN
            IF ctr1 = 6000 THEN
                countsup1 <= '1';
            ELSE
                countsup1 <= '0';
            END IF;
        END IF;
    END PROCESS;


    --crossing processes
    --Delay line
    PROCESS (clk, adc_data_temp)BEGIN
        IF rising_edge(clk) THEN
            val <= next_val;
            next_val <= adc_data_temp;
        END IF;
    END PROCESS;


    --cross checking
    crossed <= '1' WHEN(val(11) = '0' AND next_val(11) = '1') ELSE
        '0';


    --ctr3 process
    PROCESS (clk, crossed, countsup3, countsup1, silent)BEGIN
        IF countsup1 = '1' OR silent = '1' THEN
            ctr3 <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF countsup3 = '0' AND crossed = '1' THEN
                ctr3 <= ctr3 + 1;
            ELSE
                ctr3 <= ctr3 + 0;
            END IF;
        END IF;
    END PROCESS;


    countsup3 <= '1' WHEN(ctr3 > 1) ELSE
        '0';
    start_count <= '1' WHEN(ctr3 = 1) ELSE
        '0';


    --ctr2 processes
    --ctr2 process
    PROCESS (clk, countsup1, silent, start_count)BEGIN
        IF (countsup1 = '1' OR silent = '1') THEN
            ctr2 <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF start_count = '1' THEN
                ctr2 <= ctr2 + 1;
            ELSE
                ctr2 <= ctr2 + 0;
            END IF;
        END IF;
    END PROCESS;


    --ctr2_temp process (for output)
    PROCESS (clk)BEGIN
        IF rising_edge(clk) THEN
            ctr2_temp <= ctr2;
        END IF;
    END PROCESS;


    --output processes
    --symbol_out process
    PROCESS (ctr2_temp, countsup1)BEGIN
        IF countsup1 = '1' THEN
            IF ctr2_temp >= 165 AND ctr2 <= 203 THEN
                symb_out_temp <= "111";
            ELSIF ctr2_temp < 165 AND ctr2_temp >= 135 THEN
                symb_out_temp <= "110";
            ELSIF ctr2_temp < 135 AND ctr2_temp >= 111 THEN
                symb_out_temp <= "101";
            ELSIF ctr2_temp < 111 AND ctr2_temp >= 90 THEN
                symb_out_temp <= "100";
            ELSIF ctr2_temp < 90 AND ctr2_temp >= 76 THEN
                symb_out_temp <= "011";
            ELSIF ctr2_temp < 76 AND ctr2_temp >= 62 THEN
                symb_out_temp <= "010";
            ELSIF ctr2_temp < 62 AND ctr2_temp >= 51 THEN
                symb_out_temp <= "001";
            ELSIF ctr2_temp < 51 AND ctr2_temp >= 41 THEN
                symb_out_temp <= "000";
            END IF;
        END IF;
    END PROCESS;


    PROCESS (symb_out_temp, clk, silent)BEGIN
        IF silent = '1' THEN
            symbol_out <= "000";
        ELSIF rising_edge(clk) THEN
            IF countsup1 = '1' THEN
                symbol_out <= symb_out_temp;
            END IF;
        END IF;
    END PROCESS;


    --symbol_valid processes
    PROCESS (countsup1, clk, silent)BEGIN
        IF silent = '1' THEN
            symbol_valid <= '0';
        ELSIF rising_edge(clk) THEN
            symbol_valid <= countsup1;
        END IF;
    END PROCESS;
END Behavioral;
