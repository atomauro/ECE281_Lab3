----------------------------------------------------------------------------------
-- Company: USAFA/DFEC
-- Engineer: Ian Goodbody
-- 
-- Create Date:    02:06:26 03/17/2014 
-- Design Name: 		Lab 3
-- Module Name:    PrimeElevatorController - Behavioral 
-- Description: 	 Controlls the elevator though 8 floors from a binary signal giving the floor
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DiffInputElevatorController is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  go: in STD_LOGIC;
           target : in  STD_LOGIC_Vector (3 downto 0);
           floor : out  STD_LOGIC_VECTOR (7 downto 0));
end DiffInputElevatorController;

architecture Behavioral of DiffInputElevatorController is

--Below you create a new variable type! You also define what values that 
--variable type can take on. Now you can assign a signal as 
--"floor_state_type" the same way you'd assign a signal as std_logic 

--Edit floor states so there are 8 options, they will be made prime later in the output phase
type floor_state_type is (floor1, floor2, floor3, floor4, floor5, floor6, floor7, floor8);

--Here you create a variable "floor_state" that can take on the values
--defined above. Neat-o!
signal floor_state, target_state : floor_state_type := floor1;
signal stop, up_down: STD_LOGIC;

begin
---------------------------------------------
--Below you will code your next-state process
---------------------------------------------

--Parse binary input into a state
target_state <= 	floor1 when (target = "0001") else
						floor2 when (target = "0010") else
						floor3 when (target = "0011") else
						floor4 when (target = "0100") else
						floor5 when (target = "0101") else
						floor6 when (target = "0110") else
						floor7 when (target = "0111") else
						floor8 when (target = "1000") else
						floor1;


--This line will set up a process that is sensitive to the clock
floor_state_machine: process(clk) -- No reset signal in sensitivity list therefore the reset is syncronyous 
begin
	--clk'event and clk='1' is VHDL-speak for a rising edge
	if clk'event and clk='1' then
		
		--Define up_down and stop parameters based on the inputs
		if (target_state = floor_state) then
			stop <= '1';
		else
			stop <= '0';
			--Brute force to determine if The elevator must stop or go up or down
			case floor_state is
			when floor1 =>
				up_down <= '1';
			when floor2 =>
				if target_state = floor1 then
					up_down <= '0';
				else
					up_down <= '1';
				end if;
			when floor3 =>
				if (target_state = floor1 or target_state = floor2) then
					up_down <= '0';
				else
					up_down <= '1';
				end if;
			when floor4 =>
				if (target_state = floor1 or target_state = floor2 or target_state = floor3) then
					up_down <= '0';
				else
					up_down <= '1';
				end if;
			when floor5 =>
				if (target_state = floor1 or target_state = floor2 or target_state = floor3 or target_state = floor4) then
					up_down <= '0';
				else
					up_down <= '1';
				end if;
			when floor6 =>
				if (target_state = floor1 or target_state = floor2 or target_state = floor3 or target_state = floor4 or target_state = floor5) then
					up_down <= '0';
				else
					up_down <= '1';
				end if;
			when floor7 =>
				if (target_state = floor1 or target_state = floor2 or target_state = floor3 or target_state = floor4 or target_state = floor5 or target_state = floor6)then
					up_down <= '0';
				else
					up_down <= '1';
				end if;
			when floor8 =>
				if (target_state = floor1 or target_state = floor2 or target_state = floor3 or target_state = floor4 or target_state = floor5 or target_state = floor6 or target_state = floor7) then
					up_down <= '0';
				else
					up_down <= '1';
				end if;
			when others =>
				up_down <= '0';
			end case;
		 end if;

		--reset is active high and will return the elevator to floor1
		--Question: is reset synchronous or asynchronous?
		if reset='1' then
			floor_state <= floor1;
		--now we will code our next-state logic
		else
			if (stop = '0') then 
			case floor_state is
				--when our current state is floor1
				when floor1 =>
					--if up_down is set to "go up" and stop is set to 
					--"don't stop" which floor do we want to go to?
					if (up_down='1' and stop='0') then 
						--floor2 right?? This makes sense!
						floor_state <= floor2;
					--otherwise we're going to stay at floor1
					else
						floor_state <= floor1;
					end if;
					
				--when our current state is floor2
				when floor2 => 
					--if up_down is set to "go up" and stop is set to 
					--"don't stop" which floor do we want to go to?
					if (up_down='1' and stop='0') then 
						floor_state <= floor3; 			
					--if up_down is set to "go down" and stop is set to 
					--"don't stop" which floor do we want to go to?
					elsif (up_down='0' and stop='0') then 
						floor_state <= floor1;
					--otherwise we're going to stay at floor2
					else
						floor_state <= floor2;
					end if;
					
				when floor3 =>
					--Moving down and not stopping
					if (up_down = '0' and stop = '0') then 
						-- Move down to floor 2
						floor_state <= floor2;
					--Moving up and not stopping
					elsif (up_down = '1' and stop = '0') then
						--Move to floor 4
						floor_state <= floor4;	
					--no matter what if it is stopped
					else
						floor_state <= floor3;
					end if;
					
				--When the current state is floor 4
				when floor4 =>
					--Moving down and not stopping
					if (up_down = '0' and stop = '0') then 
						-- Move down a floor
						floor_state <= floor3;
					--Moving up and not stoping
					elsif (up_down = '1' and stop = '0') then
						--Move up a floor
						floor_state <= floor5;	
					--no matter what if it is stopped
					else
						floor_state <= floor4;
					end if;
					
				when floor5 =>
					--Moving down and not stopping
					if (up_down = '0' and stop = '0') then 
						-- Move down a floor
						floor_state <= floor4;
					--Moving up and not stoping
					elsif (up_down = '1' and stop = '0') then
						--Move up a floor
						floor_state <= floor6;	
					--no matter what if it is stopped
					else
						floor_state <= floor5;
					end if;
					
				when floor6 =>
					--Moving down and not stopping
					if (up_down = '0' and stop = '0') then 
						-- Move down a floor
						floor_state <= floor5;
					--Moving up and not stoping
					elsif (up_down = '1' and stop = '0') then
						--Move up a floor
						floor_state <= floor7;	
					--no matter what if it is stopped
					else
						floor_state <= floor6;
					end if;
					
				when floor7 =>
					--Moving down and not stopping
					if (up_down = '0' and stop = '0') then 
						-- Move down a floor
						floor_state <= floor6;
					--Moving up and not stoping
					elsif (up_down = '1' and stop = '0') then
						--Move up a floor
						floor_state <= floor8;	
					--no matter what if it is stopped
					else
						floor_state <= floor7;
					end if;
					
				when floor8 =>
					--The only moving condition is going down and not stopped
					if (up_down = '0' and stop = '0') then 
						--Move down to floor 7
						floor_state <= floor7;
					--For any other case stay at the same floor
					else 
						floor_state <= floor8;
					end if;
				
				--This line accounts for phantom states
				when others =>
					floor_state <= floor1;
			end case;
			else
				floor_state <= floor_state;
			end if;
		end if;
	end if;
end process;


floor <= "00000001" when (floor_state = floor1) else --1
			"00000010" when (floor_state = floor2) else --2
			"00000011" when (floor_state = floor3) else --3
			"00000100" when (floor_state = floor4) else --4
			"00000101" when (floor_state = floor5) else --5
			"00000110" when (floor_state = floor6) else --6
			"00000111" when (floor_state = floor7) else --7
			"00001000" when (floor_state = floor8) else --8
			"00001001"; --otherwise reset output to floor 1 or primue 2

end Behavioral;

