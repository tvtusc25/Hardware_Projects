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
-- CREATED		"Mon Sep 26 13:48:46 2022"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY extension IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		enable :  IN  STD_LOGIC;
		f :  OUT  STD_LOGIC
	);
END extension;

ARCHITECTURE bdf_type OF extension IS 

COMPONENT counter
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 q : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	q :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_14 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_15 :  STD_LOGIC;


BEGIN 



SYNTHESIZED_WIRE_4 <= SYNTHESIZED_WIRE_0 AND q(1) AND q(0);


b2v_inst0 : counter
PORT MAP(clk => clk,
		 reset => reset,
		 enable => enable,
		 q => q);


SYNTHESIZED_WIRE_0 <= NOT(q(3));



SYNTHESIZED_WIRE_14 <= NOT(q(4));



SYNTHESIZED_WIRE_15 <= NOT(q(1));



SYNTHESIZED_WIRE_9 <= SYNTHESIZED_WIRE_1 AND SYNTHESIZED_WIRE_2 AND SYNTHESIZED_WIRE_3 AND q(1);


SYNTHESIZED_WIRE_1 <= NOT(q(4));



SYNTHESIZED_WIRE_3 <= NOT(q(2));



SYNTHESIZED_WIRE_2 <= NOT(q(3));



f <= SYNTHESIZED_WIRE_4 OR SYNTHESIZED_WIRE_5 OR SYNTHESIZED_WIRE_6 OR SYNTHESIZED_WIRE_7 OR SYNTHESIZED_WIRE_8 OR SYNTHESIZED_WIRE_9;


SYNTHESIZED_WIRE_6 <= q(4) AND q(3) AND q(2) AND q(0);


SYNTHESIZED_WIRE_5 <= q(4) AND SYNTHESIZED_WIRE_10 AND SYNTHESIZED_WIRE_11 AND q(0);


SYNTHESIZED_WIRE_10 <= NOT(q(3));



SYNTHESIZED_WIRE_11 <= NOT(q(2));



SYNTHESIZED_WIRE_7 <= SYNTHESIZED_WIRE_12 AND SYNTHESIZED_WIRE_13 AND q(1) AND q(0);


SYNTHESIZED_WIRE_12 <= NOT(q(4));



SYNTHESIZED_WIRE_13 <= NOT(q(2));



SYNTHESIZED_WIRE_8 <= SYNTHESIZED_WIRE_14 AND q(2) AND SYNTHESIZED_WIRE_15 AND q(0);


END bdf_type;