-- ALU
-- Author: Eng. Youssef Nasser
-- Lab: Lab 1/2 - VHDL
-- Issued to: Egypt Make Electronics

---------------------------------
-- A testbench for a ALU with TEXT_IO Method
---------------------------------

--===========================--
--IEEE libraries
--===========================--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_bit.ALL;
USE std.textio.ALL; -- Standard logic 1164 package for boolean and std.textio package for file I/O
use ieee.std_logic_textio.all; -- Package for converting std_logic_vector to text and vice versa
library work;
USE WORK.pack_a.ALL; -- Using custom package pack_a

--===========================--
--Entity Declaration
--===========================--
ENTITY TEXT_IO_testbench IS
END ENTITY TEXT_IO_testbench;

--===========================--
--Architecture Declaration
--===========================--

ARCHITECTURE TEXT_IO OF TEXT_IO_testbench IS 

--===========================--
--COMPONENT Declaration
--===========================--

   COMPONENT alu IS
        PORT ( op: IN op_type;
            a, b : IN signed (3 DOWNTO 0);
            c : OUT signed (3 DOWNTO 0)); 
   END COMPONENT alu;

-- Instantiating the alu entity from the work library
FOR dut: alu USE ENTITY WORK.alu(behv);

--===========================--    
--Signals
--===========================--
SIGNAL op:  op_type;
SIGNAL a , b , c : signed (3 DOWNTO 0); -- inputs / outputs
-- signed number from -8 to +7
BEGIN 

--===========================--
--Component Instantiation
--===========================--
  
   dut: alu PORT MAP(op, a, b , c);
   
   My_Process: PROCESS IS
   
    FILE vectors_f: text OPEN READ_MODE IS  "alu_test_vectors.txt"; -- Open test vectors file for reading
    FILE results_f: text OPEN WRITE_MODE IS "alu_test_results.txt"; -- Open test results file for writing
    
    VARIABLE stimuli_l: line;
    VARIABLE res_l: line;
    VARIABLE op_file : STRING(1 TO 3);
    VARIABLE a_file, b_file , c_file: integer;
    VARIABLE pause: time;
    VARIABLE message: string (1 TO 23);
   
   BEGIN
    op <= add;  -- Initialize op signal to "add"
    a <= "0000"; -- Initialize a signal to binary 0000
    b <= "0000"; -- Initialize b signal to binary 0000
    
    WAIT FOR 15 ns;  -- Wait for 15 nanoseconds before starting the simulation
    
    -- Loop through test vectors file
    WHILE NOT endfile(vectors_f) LOOP
      READLINE (vectors_f, stimuli_l); -- Read a line from test vectors file
      READ (stimuli_l, op_file);       -- Read operation (add, sub, mul, div)
      READ (stimuli_l, a_file);        -- Read input a
      READ (stimuli_l, b_file);        -- Read input b
      READ (stimuli_l, pause);         -- Read pause time
      READ (stimuli_l, c_file);        -- Read expected output c
      READ (stimuli_l, message);       -- Read error message
      
      -- Convert operation string to enumeration value
      CASE op_file IS
        WHEN "add" =>  --If op_file is equal to "add", the signal op is assigned the value add
          op <= add;
        WHEN "sub" =>
          op <= sub;
        WHEN "mul" =>
          op <= mul;
        WHEN "div" =>
          op <= div;
        WHEN OTHERS =>
          op <= add;  -- Default to add if the input is not recognized
      END CASE;
      
      -- Convert integer inputs to signed data types
      a <= to_signed(a_file, a'length);
      b <= to_signed(b_file, b'length);
          
      WAIT FOR pause; -- Wait for the specified pause time
      
      -- Writing simulation results to the results file
      WRITE (res_l, string'("Time is now "));
      WRITE (res_l, NOW);  -- Current simulation time
      
      WRITE (res_l, string'(". a = ")); 			
      WRITE (res_l, a_file);
      
      WRITE (res_l, string'(", b = ")); 
      WRITE (res_l, b_file);
      
      WRITE (res_l, string'(", op = ")); 
      WRITE (res_l, op_file);
      
      WRITE (res_l, string'(", Expected c = ")); 
      WRITE (res_l, c_file);
      
      WRITE (res_l, string'(", Actual c = ")); 
      WRITE (res_l, to_integer (c)); 
      
      -- Check if actual output c matches expected c
      IF (c /= c_file) THEN
          WRITE (res_l, string'(". Test failed! Error message:"));
          WRITE (res_l, message);
      ELSE
          WRITE (res_l, string'(". Test passed."));
      END IF;
      
      WRITELINE (results_f, res_l);  -- Write the result line to the results file     
    END LOOP;
    
    WAIT;  -- Stop simulation run
  END PROCESS My_Process;
END ARCHITECTURE TEXT_IO;
