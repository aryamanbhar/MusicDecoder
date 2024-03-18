--mcdecoder
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;




ENTITY mcdecoder IS
    PORT (
        din : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        valid : IN STD_LOGIC;
        clr : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        dvalid : OUT STD_LOGIC;
        error : OUT STD_LOGIC);
END mcdecoder;




ARCHITECTURE Behavioral OF mcdecoder IS
    TYPE state_type IS (St_RESET, St_ERROR, LISTENING,
                  B1, B2, B3,
                  E1, E2, E3,
                  L1, L2, L3, L4, L5, L6);
    SIGNAL state, next_state : state_type := St_RESET;
    SIGNAL temp_dout : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL temp_dvalid, temp_error : STD_LOGIC;
BEGIN
    sync_process : PROCESS (clk, clr)
    BEGIN
        IF clr = '1' THEN
            -- Your code here
            state <= St_RESET;
            dvalid <= '0';
        ELSIF rising_edge(clk) THEN
            -- Put your code here
            state <= next_state;
            dout <= temp_dout;
            dvalid <= temp_dvalid;
        END IF;
    END PROCESS;




    --next state logic
    state_logic : PROCESS (state, din, valid)
    BEGIN
        -- Complete the following:
        next_state <= state;
        IF valid = '1' THEN
            CASE (state) IS
                WHEN St_RESET =>
                    IF din = "000" THEN
                        next_state <= B1;
                    ELSE
                        next_state <= St_ERROR;
                    END IF;
                WHEN B1 =>
                    IF din = "111" THEN
                        next_state <= B2;
                    ELSE
                        next_state <= St_ERROR;
                    END IF;
                WHEN B2 =>
                    IF din = "000" THEN
                        next_state <= B3;
                    ELSE
                        next_state <= St_ERROR;
                    END IF;
                WHEN B3 =>
                    IF din = "111" THEN
                        next_state <= LISTENING;
                    ELSE
                        next_state <= St_ERROR;
                    END IF;
                WHEN LISTENING =>
                    CASE din IS
                        WHEN "111" =>
                            next_state <= E1;
                        WHEN "001" =>
                            next_state <= L1;
                        WHEN "010" =>
                            next_state <= L2;
                        WHEN "011" =>
                            next_state <= L3;
                        WHEN "100" =>
                            next_state <= L4;
                        WHEN "101" =>
                            next_state <= L5;
                        WHEN "110" =>
                            next_state <= L6;
                        WHEN OTHERS =>
                            next_state <= St_ERROR;
                    END CASE;
                WHEN L1 =>
                    CASE din IS
                        WHEN "010" =>
                            next_state <= LISTENING;
                        WHEN "011" =>
                            next_state <= LISTENING;
                        WHEN "100" =>
                            next_state <= LISTENING;
                        WHEN "101" =>
                            next_state <= LISTENING;
                        WHEN "110" =>
                            next_state <= LISTENING;
                        WHEN OTHERS =>
                            next_state <= St_ERROR;
                    END CASE;
                WHEN L2 =>
                    CASE din IS
                        WHEN "001" =>
                            next_state <= LISTENING;
                        WHEN "011" =>
                            next_state <= LISTENING;
                        WHEN "100" =>
                            next_state <= LISTENING;
                        WHEN "101" =>
                            next_state <= LISTENING;
                        WHEN "110" =>
                            next_state <= LISTENING;
                        WHEN OTHERS =>
                            next_state <= St_ERROR;
                    END CASE;
                WHEN L3 =>
                    CASE din IS
                        WHEN "001" =>
                            next_state <= LISTENING;
                        WHEN "010" =>
                            next_state <= LISTENING;
                        WHEN "100" =>
                            next_state <= LISTENING;
                        WHEN "101" =>
                            next_state <= LISTENING;
                        WHEN "110" =>
                            next_state <= LISTENING;
                        WHEN OTHERS =>
                            next_state <= St_ERROR;
                    END CASE;
                WHEN L4 =>
                    CASE din IS
                        WHEN "001" =>
                            next_state <= LISTENING;
                        WHEN "010" =>
                            next_state <= LISTENING;
                        WHEN "011" =>
                            next_state <= LISTENING;
                        WHEN "101" =>
                            next_state <= LISTENING;
                        WHEN "110" =>
                            next_state <= LISTENING;
                        WHEN OTHERS =>
                            next_state <= St_ERROR;
                    END CASE;
                WHEN L5 =>
                    CASE din IS
                        WHEN "001" =>
                            next_state <= LISTENING;
                        WHEN "010" =>
                            next_state <= LISTENING;
                        WHEN "011" =>
                            next_state <= LISTENING;
                        WHEN "100" =>
                            next_state <= LISTENING;
                        WHEN "110" =>
                            next_state <= LISTENING;
                        WHEN OTHERS =>
                            next_state <= St_ERROR;
                    END CASE;
                WHEN L6 =>
                    CASE din IS
                        WHEN "001" =>
                            next_state <= LISTENING;
                        WHEN "010" =>
                            next_state <= LISTENING;
                        WHEN "011" =>
                            next_state <= LISTENING;
                        WHEN "100" =>
                            next_state <= LISTENING;
                        WHEN "101" =>
                            next_state <= LISTENING;
                        WHEN OTHERS =>
                            next_state <= St_ERROR;
                    END CASE;
                WHEN E1 =>
                    CASE din IS
                        WHEN "000" =>
                            next_state <= E2;
                        WHEN OTHERS =>
                            next_state <= St_ERROR;
                    END CASE;
                WHEN E2 =>
                    CASE din IS
                        WHEN "111" =>
                            next_state <= E3;
                        WHEN OTHERS =>
                            next_state <= St_ERROR;
                    END CASE;
                WHEN E3 =>
                    CASE din IS
                        WHEN "000" =>
                            next_state <= St_RESET;
                        WHEN OTHERS =>
                            next_state <= St_ERROR;
                    END CASE;
                WHEN St_ERROR =>
                    next_state <= St_RESET;
                WHEN OTHERS =>
                    next_state <= St_ERROR;
            END CASE;
        END IF;
    END PROCESS;




    --Output logic
    output_logic : PROCESS (state, din, valid)
    BEGIN
        IF valid = '1' THEN
            CASE state IS
                WHEN L1 =>
                    CASE din IS
                        WHEN "010" =>
                            temp_dout <= "01000010";
                            temp_dvalid <= '1';
                        WHEN "011" =>
                            temp_dout <= "01000100";
                            temp_dvalid <= '1';
                        WHEN "100" =>
                            temp_dout <= "01001000";
                            temp_dvalid <= '1';
                        WHEN "101" =>
                            temp_dout <= "01001100";
                            temp_dvalid <= '1';
                        WHEN "110" =>
                            temp_dout <= "01010010";
                            temp_dvalid <= '1';
                        WHEN OTHERS =>
                    END CASE;
                WHEN L2 =>
                    CASE din IS
                        WHEN "001" =>
                            temp_dout <= "01000001";
                            temp_dvalid <= '1';
                        WHEN "011" =>
                            temp_dout <= "01000111";
                            temp_dvalid <= '1';
                        WHEN "100" =>
                            temp_dout <= "01001011";
                            temp_dvalid <= '1';
                        WHEN "101" =>
                            temp_dout <= "01010001";
                            temp_dvalid <= '1';
                        WHEN "110" =>
                            temp_dout <= "01010110";
                            temp_dvalid <= '1';
                        WHEN OTHERS =>
                    END CASE;
                WHEN L3 =>
                    CASE din IS
                        WHEN "001" =>
                            temp_dout <= "01000011";
                            temp_dvalid <= '1';
                        WHEN "010" =>
                            temp_dout <= "01000110";
                            temp_dvalid <= '1';
                        WHEN "100" =>
                            temp_dout <= "01010000";
                            temp_dvalid <= '1';
                        WHEN "101" =>
                            temp_dout <= "01010101";
                            temp_dvalid <= '1';
                        WHEN "110" =>
                            temp_dout <= "01011010";
                            temp_dvalid <= '1';
                        WHEN OTHERS =>
                    END CASE;
                WHEN L4 =>
                    CASE din IS
                        WHEN "001" =>
                            temp_dout <= "01000101";
                            temp_dvalid <= '1';
                        WHEN "010" =>
                            temp_dout <= "01001010";
                            temp_dvalid <= '1';
                        WHEN "011" =>
                            temp_dout <= "01001111";
                            temp_dvalid <= '1';
                        WHEN "101" =>
                            temp_dout <= "01011001";
                            temp_dvalid <= '1';
                        WHEN "110" =>
                            temp_dout <= "00101110";
                            temp_dvalid <= '1';
                        WHEN OTHERS =>
                    END CASE;
                WHEN L5 =>
                    CASE din IS
                        WHEN "001" =>
                            temp_dout <= "01001001";
                            temp_dvalid <= '1';
                        WHEN "010" =>
                            temp_dout <= "01001110";
                            temp_dvalid <= '1';
                        WHEN "011" =>
                            temp_dout <= "01010100";
                            temp_dvalid <= '1';
                        WHEN "100" =>
                            temp_dout <= "01011000";
                            temp_dvalid <= '1';
                        WHEN "110" =>
                            temp_dout <= "00111111";
                            temp_dvalid <= '1';
                        WHEN OTHERS =>
                    END CASE;
                WHEN L6 =>
                    CASE din IS
                        WHEN "001" =>
                            temp_dout <= "01001101";
                            temp_dvalid <= '1';
                        WHEN "010" =>
                            temp_dout <= "01010011";
                            temp_dvalid <= '1';
                        WHEN "011" =>
                            temp_dout <= "01010111";
                            temp_dvalid <= '1';
                        WHEN "100" =>
                            temp_dout <= "00100001";
                            temp_dvalid <= '1';
                        WHEN "101" =>
                            temp_dout <= "00100000";
                            temp_dvalid <= '1';
                        WHEN OTHERS =>
                    END CASE;
                WHEN St_ERROR =>
                    error <= '1';
                WHEN LISTENING =>
                    temp_dvalid <= '0';
                WHEN OTHERS =>
                    --                temp_dout<="00000000";
                    error <= '0';
                    temp_dvalid <= '0';
            END CASE;
        ELSE
            temp_dvalid <= '0';
            error <= '0';
        END IF;
    END PROCESS;
END Behavioral;