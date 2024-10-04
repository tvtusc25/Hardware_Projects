-- Copyright (C) 1991-2012 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 32-bit"
-- VERSION		"Version 12.1 Build 177 11/07/2012 SJ Full Version"
-- CREATED		"Mon Sep 19 14:05:55 2022"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY prime IS 
	PORT
	(
		A :  IN  STD_LOGIC;
		B :  IN  STD_LOGIC;
		C :  IN  STD_LOGIC;
		D :  IN  STD_LOGIC;
		F :  OUT  STD_LOGIC
	);
END prime;

ARCHITECTURE bdf_type OF prime IS 

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;


BEGIN 



SYNTHESIZED_WIRE_5 <= SYNTHESIZED_WIRE_0 AND SYNTHESIZED_WIRE_1 AND C;


SYNTHESIZED_WIRE_8 <= SYNTHESIZED_WIRE_2 AND C AND D;


SYNTHESIZED_WIRE_1 <= NOT(B);



SYNTHESIZED_WIRE_2 <= NOT(A);



SYNTHESIZED_WIRE_3 <= NOT(B);



SYNTHESIZED_WIRE_4 <= NOT(C);



SYNTHESIZED_WIRE_6 <= SYNTHESIZED_WIRE_3 AND C AND D;


SYNTHESIZED_WIRE_7 <= B AND SYNTHESIZED_WIRE_4 AND D;


F <= SYNTHESIZED_WIRE_5 OR SYNTHESIZED_WIRE_6 OR SYNTHESIZED_WIRE_7 OR SYNTHESIZED_WIRE_8;


SYNTHESIZED_WIRE_0 <= NOT(A);



END bdf_type;