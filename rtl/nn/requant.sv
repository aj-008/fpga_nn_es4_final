module requant (
    input logic signed [19:0] acc,
    input logic signed [15:0] bias,
    input logic relu,
    output logic signed [15:0] y
);
  logic signed [19:0] t;
  always_comb begin
    t = ((acc + 64) >>> 7) + bias;
    if (!relu) y = t[15:0];
    else if (t < 0) y = '0;
    else if (t > 255) y = 16'd255;
    else y = t[15:0];
  end
endmodule

