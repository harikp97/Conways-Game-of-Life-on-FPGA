library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY SYNC IS
PORT(
CLK: IN STD_LOGIC;
HSYNC, VSYNC: OUT STD_LOGIC;
R,G,B: OUT STD_LOGIC
);
END SYNC;

ARCHITECTURE MAIN OF SYNC IS 
SIGNAL RGB:STD_LOGIC;
SIGNAL HPOS: INTEGER RANGE 0 TO 1056:=0;
SIGNAL VPOS: INTEGER RANGE 0 TO 628:=0;    --  1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20                                       
--Pentadecathlon 
SIGNAL MATRIX: Bit_vector(0 to 399):="0000000000000000000001000000000000000000001000000000000000001110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
-- pulsar :                           0000000000000000000000000000000000000000000011100011100000000000000000000000000000100001010000100000001000010100001000000010000101000010000012000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000												  		
-- glider :                           0000000000000000000001000000000000000000001000000000000000001110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000                                                                                                                                                                     
-- blinker :                          0000000000000000000000000000000000000000001110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000                                                                                     
-- toad :                             0000000000000000000000000000000000000000000111000000000000000011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000


BEGIN 
PROCESS (CLK)
variable counter :INTEGER:=0;
variable i: INTEGER:=0;						--Loop variable
variable m: INTEGER:=0;
variable j: INTEGER:=0;						--Stores number of live neighbours for each cell
variable k: INTEGER:=0;	
variable y: INTEGER:=0;		
BEGIN
IF(CLK'EVENT AND CLK='1')THEN				
	counter:=counter+1;
	IF (counter=100000000) THEN        	--Updating the matrix grid after 100000000 clock periods
		for i in 0 to 399 loop				--Iterating through all cells in grid and checking status of neighbours
			k:=i-20;								--Neighbouring cell to the top of current cell
			IF(k<0) THEN
			k:=k+400;
			END IF;							
			IF (MATRIX(k)='1') THEN
			j:=j+1;
			END IF;
			
			k:=k-1;								--Neighbouring cell to the top left of current cell
			IF(k mod 20=19) THEN
			k:=k+20;
			END IF;
			IF (MATRIX(k)='1') THEN
			j:=j+1;
			END IF;
			
			k:=i-20;								--Neighbouring cell to the top right of current cell
			IF(k<0) THEN
			k:=k+400;
			END IF;
			k:=k+1;
			IF(k mod 20=0) THEN
			k:=k-20;
			END IF;
			IF (MATRIX(k)='1') THEN
			j:=j+1;
			END IF;
			
			k:=i;									--Neighbouring cell to the left of current cell
			IF(k mod 20=0) THEN
			k:=k+20;
			END IF;
			k:=k-1;
			IF (MATRIX(k)='1') THEN
			j:=j+1;
			END IF;
			
			k:=i;									--Neighbouring cell to the right of current cell
			IF((k mod 20=19))THEN
			k:=k-20;
			END IF;
			k:=k+1;
			IF (MATRIX(k)='1') THEN
			j:=j+1;
			END IF;
			
			k:=i+20;								--Neighbouring cell to the bottom of current cell						
			IF(k>399) THEN
			k:=k-400;
			END IF;
			IF (MATRIX(k)='1') THEN
			j:=j+1;
			END IF;
			
			k:=k-1;								--Neighbouring cell to the bottom left of current cell
			IF(k mod 20=19) THEN
			k:=k+20;
			END IF;
			IF (MATRIX(k)='1') THEN
			j:=j+1;
			END IF;
			
			k:=i+20;								--Neighbouring cell to the bottom right of current cell
			IF(k>399) THEN
			k:=k-400;
			END IF;
			k:=k+1;
			IF(k mod 20=0) THEN
			k:=k-20;
			END IF;
			IF (MATRIX(k)='1') THEN
			j:=j+1;
			END IF;
			
			--Updating matrix elements
			
			IF((MATRIX(i)='1')AND((j=2)OR(j=3))) THEN  
			--Live in next iteration if alive in present and number of neighbouring cells which are live is 2 or 3
			MATRIX(i)<='1';
			j:=0;
			ELSIF((MATRIX(i)='0')AND(j=3))THEN
			--Live in next iteration if dead in present and number of neighbouring cells which are live is 3
			MATRIX(i)<='1';
			j:=0;
			ELSE
			--Otherwise dead in next iteration
			MATRIX(i)<='0';
			j:=0;
			END IF;
			END LOOP;
			counter:=0;
	END IF;
	

	IF((HPOS>0 AND HPOS<256) OR (VPOS>0 AND VPOS<28))THEN  --FRONT PORCH + SYNC PULSE + BACK PORCH
						R<='0';
						G<='0';
						B<='0';
			ELSIF( (HPOS>255) AND (VPOS>27) AND ((((HPOS-255)-40*((HPOS-255)/40))<4) OR (((VPOS-27)-30*((VPOS-27)/30))<4)) ) THEN
						-- GRID BORDERS IN WHITE
						R<='1';
						G<='1';
						B<='1';
			ELSE
					y:=(HPOS-255)/40;		--Extracting array index of MATRIX based on HPOS value
					k:=(VPOS-27)/30;
					m:=k*20+y;
					IF(MATRIX(m)='1') THEN
					R<='1';
					G<='0';
					B<='0';
					ELSE
					R<='0';
					G<='0';
					B<='0';
				END IF;
			END IF;
	
	IF(HPOS<1056) THEN						--Increment HPOS until end of line
		HPOS<=HPOS+1;
		ELSE
		HPOS<=0;
			IF(VPOS<628) THEN					--Increment VPOS until end of frame
				VPOS<=VPOS+1;
			ELSE
				VPOS<=0;
			END IF;
	END IF; 
		
	IF(HPOS>40 AND HPOS<168)THEN			--SYNC PULSE
	   HSYNC<='0';
	ELSE
	   HSYNC<='1';
	END IF;
   IF(VPOS>1 AND VPOS<5)THEN				--SYNC PULSE
	   VSYNC<='0';
	ELSE
	   VSYNC<='1';
	END IF;	
END IF;
END PROCESS;
END MAIN;
