`timescale 1ns/1ps
`include "isa_defines.vh"

module multicycle_control(

    input wire clk,
    input wire reset,

    input wire [15:0] instruction,

    output reg pc_write,
    output reg ir_write,

    output reg A_en,
    output reg B_en,

    output reg ALUOut_en,
    output reg MDR_en,

    output reg reg_write,
    output reg mem_write,
    output reg flag_write

);