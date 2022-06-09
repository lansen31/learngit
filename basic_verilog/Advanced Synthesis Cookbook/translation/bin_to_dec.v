// Copyright 2007 Altera Corporation. All rights reserved.  
// Altera products are protected under numerous U.S. and foreign patents, 
// maskwork rights, copyrights and other intellectual property laws.  
//
// This reference design file, and your use thereof, is subject to and governed
// by the terms and conditions of the applicable Altera Reference Design 
// License Agreement (either as signed by you or found at www.altera.com).  By
// using this reference design file, you indicate your acceptance of such terms
// and conditions between you and Altera Corporation.  In the event that you do
// not agree with such terms and conditions, you may not use the reference 
// design file and please promptly destroy any copies you have made.
//
// This reference design file is being provided on an "as-is" basis and as an 
// accommodation and therefore all warranties, representations or guarantees of 
// any kind (whether express, implied or statutory) including, without 
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Altera expressly does not recommend, suggest or 
// require that this reference design file be used in combination with any 
// other product not provided by Altera.
/////////////////////////////////////////////////////////////////////////////

// baeckler - 08-29-2006
// 32 bit binary to binary coded decimal (BCD)

module bin_to_dec (ins,out);

input [31:0] ins;
output [10*4-1:0] out;

	// dispose of powers 1 and 2 in the low bits of the next three compressors
	// - the odd / even of the sum is only controlled by bit 0, so the lowest
	// bit is gnd when un-tampered

    // powers : 4 8 16 32 64 128 
    wire [63:0] p2_dig_0_bit_0 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] p2_dig_0_bit_1 = 64'b1000110001100011000110001100011000110001100011000110001100011000;
    wire [63:0] p2_dig_0_bit_2 = 64'b0010100101001010010100101001010010100101001010010100101001010010;
    wire [63:0] p2_dig_0_bit_3 = 64'b0100001000010000100001000010000100001000010000100001000010000100;
    wire [63:0] p2_dig_1_bit_0 = 64'b1000110001100011000110001100011000110001100011000110001100011000;
    wire [63:0] p2_dig_1_bit_1 = 64'b0000111110000000000111110000011111000000000011111000001111100000;
    wire [63:0] p2_dig_1_bit_2 = 64'b1111000000000000000111111111100000000000000011111111110000000000;
    wire [63:0] p2_dig_1_bit_3 = 64'b0000000000000011111000000000000000000001111100000000000000000000;
    wire [63:0] p2_dig_2_bit_0 = 64'b0000000000000011111111111111111111111110000000000000000000000000;
    wire [63:0] p2_dig_2_bit_1 = 64'b1111111111111100000000000000000000000000000000000000000000000000;
    wire [63:0] p2_dig_2_bit_2 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] p2_dig_2_bit_3 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [5:0] p2_ins = {ins[7],ins[6],ins[5],ins[4],ins[3],ins[2]};

    wire [11:0] p2_outs = {
        p2_dig_2_bit_3[p2_ins],p2_dig_2_bit_2[p2_ins],p2_dig_2_bit_1[p2_ins],p2_dig_2_bit_0[p2_ins],
        p2_dig_1_bit_3[p2_ins],p2_dig_1_bit_2[p2_ins],p2_dig_1_bit_1[p2_ins],p2_dig_1_bit_0[p2_ins],
        p2_dig_0_bit_3[p2_ins],p2_dig_0_bit_2[p2_ins],p2_dig_0_bit_1[p2_ins],ins[0]
    };

    // powers : 256 512 1024 2048 4096 8192 
    wire [63:0] p8_dig_0_bit_0 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] p8_dig_0_bit_1 = 64'b0110001100011000110001100011000110001100011000110001100011000110;
    wire [63:0] p8_dig_0_bit_2 = 64'b0010100101001010010100101001010010100101001010010100101001010010;
    wire [63:0] p8_dig_0_bit_3 = 64'b1000010000100001000010000100001000010000100001000010000100001000;
    wire [63:0] p8_dig_1_bit_0 = 64'b0110001100011000110001100011000110001100011000110001100011000110;
    wire [63:0] p8_dig_1_bit_1 = 64'b1101000101100000111100000110100010110000011110000011010001011000;
    wire [63:0] p8_dig_1_bit_2 = 64'b0101010000101010010101010010101000010101001010101001010100001010;
    wire [63:0] p8_dig_1_bit_3 = 64'b0000001010000001000000101000000101000000100000010100000010100000;
    wire [63:0] p8_dig_2_bit_0 = 64'b1001101100110010011001001100110110011001001100100110011011001100;
    wire [63:0] p8_dig_2_bit_1 = 64'b0011000100010001010101010101010001000100011001100010001010101010;
    wire [63:0] p8_dig_2_bit_2 = 64'b0010001000100010011001100110011001100110010001000100010011001100;
    wire [63:0] p8_dig_2_bit_3 = 64'b0100010001000100000000001000100010001000100010001000100000000000;
    wire [63:0] p8_dig_3_bit_0 = 64'b0111100001111000011110001111000011110000111100001111000011110000;
    wire [63:0] p8_dig_3_bit_1 = 64'b1000000001111111100000000000000011111111000000001111111100000000;
    wire [63:0] p8_dig_3_bit_2 = 64'b1111111110000000000000000000000011111111111111110000000000000000;
    wire [63:0] p8_dig_3_bit_3 = 64'b0000000000000000000000001111111100000000000000000000000000000000;
    wire [63:0] p8_dig_4_bit_0 = 64'b1111111111111111111111110000000000000000000000000000000000000000;
    wire [63:0] p8_dig_4_bit_1 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] p8_dig_4_bit_2 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] p8_dig_4_bit_3 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [5:0] p8_ins = {ins[13],ins[12],ins[11],ins[10],ins[9],ins[8]};

    wire [19:0] p8_outs = {
        p8_dig_4_bit_3[p8_ins],p8_dig_4_bit_2[p8_ins],p8_dig_4_bit_1[p8_ins],p8_dig_4_bit_0[p8_ins],
        p8_dig_3_bit_3[p8_ins],p8_dig_3_bit_2[p8_ins],p8_dig_3_bit_1[p8_ins],p8_dig_3_bit_0[p8_ins],
        p8_dig_2_bit_3[p8_ins],p8_dig_2_bit_2[p8_ins],p8_dig_2_bit_1[p8_ins],p8_dig_2_bit_0[p8_ins],
        p8_dig_1_bit_3[p8_ins],p8_dig_1_bit_2[p8_ins],p8_dig_1_bit_1[p8_ins],p8_dig_1_bit_0[p8_ins],
        p8_dig_0_bit_3[p8_ins],p8_dig_0_bit_2[p8_ins],p8_dig_0_bit_1[p8_ins],ins[1]
    };

    // powers : 16384 32768 65536 131072 262144 524288 
    wire [63:0] p14_dig_0_bit_0 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] p14_dig_0_bit_1 = 64'b1000110001100011000110001100011000110001100011000110001100011000;
    wire [63:0] p14_dig_0_bit_2 = 64'b0010100101001010010100101001010010100101001010010100101001010010;
    wire [63:0] p14_dig_0_bit_3 = 64'b0100001000010000100001000010000100001000010000100001000010000100;
    wire [63:0] p14_dig_1_bit_0 = 64'b1000110001100011000110001100011000110001100011000110001100011000;
    wire [63:0] p14_dig_1_bit_1 = 64'b0010010011010001010001011001001001101000101000101100100100110100;
    wire [63:0] p14_dig_1_bit_2 = 64'b0001110000110000110000111000111000011000011000011100011100001100;
    wire [63:0] p14_dig_1_bit_3 = 64'b1000001000001000001100000100000100000100000110000010000010000010;
    wire [63:0] p14_dig_2_bit_0 = 64'b1000000111111000000011111100000011111100000001111110000001111110;
    wire [63:0] p14_dig_2_bit_1 = 64'b0000110001100100011000110010001100011011000110001101100011000110;
    wire [63:0] p14_dig_2_bit_2 = 64'b0010100101001001010010100100101001010010010100101001001010010100;
    wire [63:0] p14_dig_2_bit_3 = 64'b0100001000010010000100001001000010000100100001000010010000100000;
    wire [63:0] p14_dig_3_bit_0 = 64'b0111001110011100011000110001110011100111000110001100011100111000;
    wire [63:0] p14_dig_3_bit_1 = 64'b1001101100000011011000000110110010001001100100010011011000000110;
    wire [63:0] p14_dig_3_bit_2 = 64'b0100100101001001001010010010010110100100101101001001001010010010;
    wire [63:0] p14_dig_3_bit_3 = 64'b0010000000100100000001001001000000010010000000100100000001001000;
    wire [63:0] p14_dig_4_bit_0 = 64'b1110011100011100111000111000110001110001100011100011000111000110;
    wire [63:0] p14_dig_4_bit_1 = 64'b1000101000101000101100101100100100100100110100110100010100010100;
    wire [63:0] p14_dig_4_bit_2 = 64'b0000110000110000110000110000111000111000111000111000011000011000;
    wire [63:0] p14_dig_4_bit_3 = 64'b0011000001000001000001000001000001000001000001000001100001100000;
    wire [63:0] p14_dig_5_bit_0 = 64'b0011111110000001111110000001111110000001111110000001111110000000;
    wire [63:0] p14_dig_5_bit_1 = 64'b0000000000000001111111111110000000000001111111111110000000000000;
    wire [63:0] p14_dig_5_bit_2 = 64'b0000000000000001111111111111111111111110000000000000000000000000;
    wire [63:0] p14_dig_5_bit_3 = 64'b0011111111111110000000000000000000000000000000000000000000000000;
    wire [63:0] p14_dig_6_bit_0 = 64'b1100000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] p14_dig_6_bit_1 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] p14_dig_6_bit_2 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] p14_dig_6_bit_3 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [5:0] p14_ins = {ins[19],ins[18],ins[17],ins[16],ins[15],ins[14]};

    wire [27:0] p14_outs = {
        p14_dig_6_bit_3[p14_ins],p14_dig_6_bit_2[p14_ins],p14_dig_6_bit_1[p14_ins],p14_dig_6_bit_0[p14_ins],
        p14_dig_5_bit_3[p14_ins],p14_dig_5_bit_2[p14_ins],p14_dig_5_bit_1[p14_ins],p14_dig_5_bit_0[p14_ins],
        p14_dig_4_bit_3[p14_ins],p14_dig_4_bit_2[p14_ins],p14_dig_4_bit_1[p14_ins],p14_dig_4_bit_0[p14_ins],
        p14_dig_3_bit_3[p14_ins],p14_dig_3_bit_2[p14_ins],p14_dig_3_bit_1[p14_ins],p14_dig_3_bit_0[p14_ins],
        p14_dig_2_bit_3[p14_ins],p14_dig_2_bit_2[p14_ins],p14_dig_2_bit_1[p14_ins],p14_dig_2_bit_0[p14_ins],
        p14_dig_1_bit_3[p14_ins],p14_dig_1_bit_2[p14_ins],p14_dig_1_bit_1[p14_ins],p14_dig_1_bit_0[p14_ins],
        p14_dig_0_bit_3[p14_ins],p14_dig_0_bit_2[p14_ins],p14_dig_0_bit_1[p14_ins],ins[1]
    };

    // powers : 1048576 2097152 4194304 8388608 16777216 33554432 
    wire [63:0] p20_dig_0_bit_0 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] p20_dig_0_bit_1 = 64'b0110001100011000110001100011000110001100011000110001100011000110;
    wire [63:0] p20_dig_0_bit_2 = 64'b0010100101001010010100101001010010100101001010010100101001010010;
    wire [63:0] p20_dig_0_bit_3 = 64'b1000010000100001000010000100001000010000100001000010000100001000;
    wire [63:0] p20_dig_1_bit_0 = 64'b0110001100011000110001100011000110001100011000110001100011000110;
    wire [63:0] p20_dig_1_bit_1 = 64'b0011001000101010101010001001100100010101010101000100110010001010;
    wire [63:0] p20_dig_1_bit_2 = 64'b0001000100011001100110011000100010001100110011001100010001000110;
    wire [63:0] p20_dig_1_bit_3 = 64'b1000100010000000010001000100010001000000001000100010001000100000;
    wire [63:0] p20_dig_2_bit_0 = 64'b0111100001111000001111000011110000111100000111100001111000011110;
    wire [63:0] p20_dig_2_bit_1 = 64'b1100000110001011000110100011000001100000110001111000110100011000;
    wire [63:0] p20_dig_2_bit_2 = 64'b0101010010100001010010101001010100101010010100101010010101001010;
    wire [63:0] p20_dig_2_bit_3 = 64'b0000101000010100001000000100000010000101000010000001000000100000;
    wire [63:0] p20_dig_3_bit_0 = 64'b0110110011011001101100110110011011001001100100110010011001001100;
    wire [63:0] p20_dig_3_bit_1 = 64'b0010010001001000100100010010001001000100100010010001001000100100;
    wire [63:0] p20_dig_3_bit_2 = 64'b0001110000111000011100001110000111000011100001110000111000011100;
    wire [63:0] p20_dig_3_bit_3 = 64'b0000001000000100000010000001000000100000010000001000000100000010;
    wire [63:0] p20_dig_4_bit_0 = 64'b0101010010101001010100101010010101001010100101010010101001010100;
    wire [63:0] p20_dig_4_bit_1 = 64'b1010101111111101010100000000000000010101011111111010101000000000;
    wire [63:0] p20_dig_4_bit_2 = 64'b1010101010101000000001010101010101010101010101010000000010101010;
    wire [63:0] p20_dig_4_bit_3 = 64'b0000000000000010101010101010000000000000000000000101010101010100;
    wire [63:0] p20_dig_5_bit_0 = 64'b0011001100110011001100110011100110011001100110011001100110011000;
    wire [63:0] p20_dig_5_bit_1 = 64'b0000001111000011110000000011111000011110000000011110000111100000;
    wire [63:0] p20_dig_5_bit_2 = 64'b0000001111111100000000000011111111100000000000011111111000000000;
    wire [63:0] p20_dig_5_bit_3 = 64'b0011110000000000000000111100000000000000000111100000000000000000;
    wire [63:0] p20_dig_6_bit_0 = 64'b0110101010101010101010010101010101010101010010101010101010101010;
    wire [63:0] p20_dig_6_bit_1 = 64'b1011000011001100001100100001100110000110011000110011000011001100;
    wire [63:0] p20_dig_6_bit_2 = 64'b1100000011110000001111000001111000000111100000111100000011110000;
    wire [63:0] p20_dig_6_bit_3 = 64'b0000001100000000110000000110000000011000000011000000001100000000;
    wire [63:0] p20_dig_7_bit_0 = 64'b0000001111111111000000000111111111100000000011111111110000000000;
    wire [63:0] p20_dig_7_bit_1 = 64'b1111110000000000000000000111111111111111111100000000000000000000;
    wire [63:0] p20_dig_7_bit_2 = 64'b1111111111111111111111111000000000000000000000000000000000000000;
    wire [63:0] p20_dig_7_bit_3 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [5:0] p20_ins = {ins[25],ins[24],ins[23],ins[22],ins[21],ins[20]};

    wire [31:0] p20_outs = {
        p20_dig_7_bit_3[p20_ins],p20_dig_7_bit_2[p20_ins],p20_dig_7_bit_1[p20_ins],p20_dig_7_bit_0[p20_ins],
        p20_dig_6_bit_3[p20_ins],p20_dig_6_bit_2[p20_ins],p20_dig_6_bit_1[p20_ins],p20_dig_6_bit_0[p20_ins],
        p20_dig_5_bit_3[p20_ins],p20_dig_5_bit_2[p20_ins],p20_dig_5_bit_1[p20_ins],p20_dig_5_bit_0[p20_ins],
        p20_dig_4_bit_3[p20_ins],p20_dig_4_bit_2[p20_ins],p20_dig_4_bit_1[p20_ins],p20_dig_4_bit_0[p20_ins],
        p20_dig_3_bit_3[p20_ins],p20_dig_3_bit_2[p20_ins],p20_dig_3_bit_1[p20_ins],p20_dig_3_bit_0[p20_ins],
        p20_dig_2_bit_3[p20_ins],p20_dig_2_bit_2[p20_ins],p20_dig_2_bit_1[p20_ins],p20_dig_2_bit_0[p20_ins],
        p20_dig_1_bit_3[p20_ins],p20_dig_1_bit_2[p20_ins],p20_dig_1_bit_1[p20_ins],p20_dig_1_bit_0[p20_ins],
        p20_dig_0_bit_3[p20_ins],p20_dig_0_bit_2[p20_ins],p20_dig_0_bit_1[p20_ins],p20_dig_0_bit_0[p20_ins]
    } ;

    // powers : 67108864 134217728 268435456 536870912 1073741824 2147483648 
    wire [63:0] p26_dig_0_bit_0 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] p26_dig_0_bit_1 = 64'b1000110001100011000110001100011000110001100011000110001100011000;
    wire [63:0] p26_dig_0_bit_2 = 64'b0010100101001010010100101001010010100101001010010100101001010010;
    wire [63:0] p26_dig_0_bit_3 = 64'b0100001000010000100001000010000100001000010000100001000010000100;
    wire [63:0] p26_dig_1_bit_0 = 64'b1000110001100011000110001100011000110001100011000110001100011000;
    wire [63:0] p26_dig_1_bit_1 = 64'b1100100010011011000000110110010001001101100000011011001000100110;
    wire [63:0] p26_dig_1_bit_2 = 64'b0101101001001001010010010010110100100100101001001001011010010010;
    wire [63:0] p26_dig_1_bit_3 = 64'b0000000100100000001001001000000010010000000100100100000001001000;
    wire [63:0] p26_dig_2_bit_0 = 64'b0110110110110010010010010011011011011001001001001001101101101100;
    wire [63:0] p26_dig_2_bit_1 = 64'b0010001101100110110001001000110110001011000100100011011000100100;
    wire [63:0] p26_dig_2_bit_2 = 64'b1110000011100001110000111000001110000111000011100000111000011100;
    wire [63:0] p26_dig_2_bit_3 = 64'b0001100000010000001000000110000001000000100000011000000100000010;
    wire [63:0] p26_dig_3_bit_0 = 64'b0101001010100101010010101011010101101010110101010010101001010100;
    wire [63:0] p26_dig_3_bit_1 = 64'b0000100110001100110001100110001100100001101100001001100011001100;
    wire [63:0] p26_dig_3_bit_2 = 64'b0000011110000011110000011110000011100000011100000111100000111100;
    wire [63:0] p26_dig_3_bit_3 = 64'b1100000001100000001000000001000000011000000011000000011000000010;
    wire [63:0] p26_dig_4_bit_0 = 64'b1001010101001010101101010101101010101101010101101010101101010100;
    wire [63:0] p26_dig_4_bit_1 = 64'b0001100001110011000001100110000011001110000110001100001110011000;
    wire [63:0] p26_dig_4_bit_2 = 64'b1110000001111100000001111000000011110000000111110000001111100000;
    wire [63:0] p26_dig_4_bit_3 = 64'b0000000110000000001110000000001100000000011000000000110000000000;
    wire [63:0] p26_dig_5_bit_0 = 64'b0101010010101010100101010101011010101010110101010101101010101010;
    wire [63:0] p26_dig_5_bit_1 = 64'b0110011000110011000110011000010011000011011000011001000011001100;
    wire [63:0] p26_dig_5_bit_2 = 64'b0111100000111100000111100000011100000011100000011110000011110000;
    wire [63:0] p26_dig_5_bit_3 = 64'b1000000011000000001000000001100000001100000001100000001100000000;
    wire [63:0] p26_dig_6_bit_0 = 64'b1010101001010101011010101011010101011010101011010101011010101010;
    wire [63:0] p26_dig_6_bit_1 = 64'b1011010001101000010100001010000101100010110101011010001101000010;
    wire [63:0] p26_dig_6_bit_2 = 64'b1001001000100100110010011001001100100110010011001001000100100110;
    wire [63:0] p26_dig_6_bit_3 = 64'b0000100100010010001001000000100000010000001000000100100010010000;
    wire [63:0] p26_dig_7_bit_0 = 64'b0010110110100100101101101101001001011011010010010110110100100100;
    wire [63:0] p26_dig_7_bit_1 = 64'b1101001001001001000000000000000000010010010010010110110110110110;
    wire [63:0] p26_dig_7_bit_2 = 64'b0100100100100100100100100100100100110110110110110010010010010010;
    wire [63:0] p26_dig_7_bit_3 = 64'b0010010010010010010010010010010010000000000000000000000000000000;
    wire [63:0] p26_dig_8_bit_0 = 64'b0100100100100100100100100100100100100100100100100100100100100100;
    wire [63:0] p26_dig_8_bit_1 = 64'b1000000111000111000000111000111000000111000111000000111000111000;
    wire [63:0] p26_dig_8_bit_2 = 64'b0000000111111000000000111111000000000111111000000000111111000000;
    wire [63:0] p26_dig_8_bit_3 = 64'b0000111000000000000111000000000000111000000000000111000000000000;
    wire [63:0] p26_dig_9_bit_0 = 64'b0000111111111111111000000000000000111111111111111000000000000000;
    wire [63:0] p26_dig_9_bit_1 = 64'b0000111111111111111111111111111111000000000000000000000000000000;
    wire [63:0] p26_dig_9_bit_2 = 64'b1111000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] p26_dig_9_bit_3 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [5:0] p26_ins = {ins[31],ins[30],ins[29],ins[28],ins[27],ins[26]};

    wire [39:0] p26_outs = {
        p26_dig_9_bit_3[p26_ins],p26_dig_9_bit_2[p26_ins],p26_dig_9_bit_1[p26_ins],p26_dig_9_bit_0[p26_ins],
        p26_dig_8_bit_3[p26_ins],p26_dig_8_bit_2[p26_ins],p26_dig_8_bit_1[p26_ins],p26_dig_8_bit_0[p26_ins],
        p26_dig_7_bit_3[p26_ins],p26_dig_7_bit_2[p26_ins],p26_dig_7_bit_1[p26_ins],p26_dig_7_bit_0[p26_ins],
        p26_dig_6_bit_3[p26_ins],p26_dig_6_bit_2[p26_ins],p26_dig_6_bit_1[p26_ins],p26_dig_6_bit_0[p26_ins],
        p26_dig_5_bit_3[p26_ins],p26_dig_5_bit_2[p26_ins],p26_dig_5_bit_1[p26_ins],p26_dig_5_bit_0[p26_ins],
        p26_dig_4_bit_3[p26_ins],p26_dig_4_bit_2[p26_ins],p26_dig_4_bit_1[p26_ins],p26_dig_4_bit_0[p26_ins],
        p26_dig_3_bit_3[p26_ins],p26_dig_3_bit_2[p26_ins],p26_dig_3_bit_1[p26_ins],p26_dig_3_bit_0[p26_ins],
        p26_dig_2_bit_3[p26_ins],p26_dig_2_bit_2[p26_ins],p26_dig_2_bit_1[p26_ins],p26_dig_2_bit_0[p26_ins],
        p26_dig_1_bit_3[p26_ins],p26_dig_1_bit_2[p26_ins],p26_dig_1_bit_1[p26_ins],p26_dig_1_bit_0[p26_ins],
        p26_dig_0_bit_3[p26_ins],p26_dig_0_bit_2[p26_ins],p26_dig_0_bit_1[p26_ins],p26_dig_0_bit_0[p26_ins]
    } ;

	wire [19:0] add0_sum;
	bcd_add_chain add0 (.ina({8'b0,p2_outs}),.inb(p8_outs),.sum(add0_sum));
		defparam add0 .DEC_DIGITS = 5;

	wire [27:0] add1_sum;
	bcd_add_chain add1 (.ina({8'b0,add0_sum}),.inb(p14_outs),.sum(add1_sum));
		defparam add1 .DEC_DIGITS = 7;

    wire [39:0] add2_sum;
	bcd_add_chain add2 (.ina({8'b0,p20_outs}),.inb(p26_outs),.sum(add2_sum));
		defparam add2 .DEC_DIGITS = 10;

	wire [39:0] add3_sum;
	bcd_add_chain add3 (.ina({12'b0,add1_sum}),.inb(add2_sum),.sum(add3_sum));
		defparam add3 .DEC_DIGITS = 10;

	assign out = add3_sum;

endmodule



