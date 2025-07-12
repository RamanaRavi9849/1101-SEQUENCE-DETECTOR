`timescale 1ns / 1ps
//
//==============================================
// 1101 Sequence Detector - Mealy (Overlapping)
//==============================================

module seq_dectector(
clk, rst, in, out);
  input clk, rst, in;
  output reg out;
  reg [1:0] state, next_st;

  parameter s0 = 2'b00, s1 = 2'b01, s2 = 2'b10, s3 = 2'b11;

  always @(posedge clk or negedge rst) begin
    if (!rst)
      state <= s0;
    else
      state <= next_st;
  end

  always @(*) begin
    out = 0;
    case (state)
      s0: next_st = in ? s1 : s0;
      s1: next_st = in ? s1 : s2;
      s2: next_st = in ? s3 : s0;
      s3: begin
        next_st = in ? s1 : s2;
        out = in ? 1 : 0;
      end
      default: next_st = s0;
    endcase
  end
endmodule


// 1101 Sequence Detector - Mealy (Non-Overlapping)

module seq_det_mealy_no_overlap (clk, rst, in, out);
  input clk, rst, in;
  output reg out;
  reg [1:0] state, next_st;

  parameter s0 = 2'b00, s1 = 2'b01, s2 = 2'b10, s3 = 2'b11;

  always @(posedge clk or negedge rst) begin
    if (!rst)
      state <= s0;
    else
      state <= next_st;
  end

  always @(*) begin
    out = 0;
    case (state)
      s0: next_st = in ? s1 : s0;
      s1: next_st = in ? s1 : s2;
      s2: next_st = in ? s3 : s0;
      s3: begin
        if (in) begin
          out = 1;
          next_st = s0;
        end else begin
          next_st = s2;
        end
      end
      default: next_st = s0;
    endcase
  end
endmodule


// 1101 Sequence Detector - Moore (Overlapping)

module seq_det_moore_overlap (clk, rst, in, out);
  input clk, rst, in;
  output reg out;
  reg [2:0] state, next_st;

  parameter s0 = 3'b000, s1 = 3'b001, s2 = 3'b010, s3 = 3'b011, s4 = 3'b100;

  always @(posedge clk or negedge rst) begin
    if (!rst)
      state <= s0;
    else
      state <= next_st;
  end

  always @(*) begin
    case (state)
      s0: next_st = in ? s1 : s0;
      s1: next_st = in ? s1 : s2;
      s2: next_st = in ? s3 : s0;
      s3: next_st = in ? s4 : s2;
      s4: next_st = in ? s1 : s2; // Overlapping transition
      default: next_st = s0;
    endcase
  end

  always @(*) begin
    out = (state == s4);
  end
endmodule


// 1101 Sequence Detector - Moore (Non-Overlapping)

module seq_det_moore_no_overlap (clk, rst, in, out);
  input clk, rst, in;
  output reg out;
  reg [2:0] state, next_st;

  parameter s0 = 3'b000, s1 = 3'b001, s2 = 3'b010, s3 = 3'b011, s4 = 3'b100;

  always @(posedge clk or negedge rst) begin
    if (!rst)
      state <= s0;
    else
      state <= next_st;
  end

  always @(*) begin
    case (state)
      s0: next_st = in ? s1 : s0;
      s1: next_st = in ? s1 : s2;
      s2: next_st = in ? s3 : s0;
      s3: next_st = in ? s4 : s2;
      s4: next_st = s0; // Reset after detection (no overlap)
      default: next_st = s0;
    endcase
  end

  always @(*) begin
    out = (state == s4);
  end



    
endmodule
