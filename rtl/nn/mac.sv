module mac #(
    parameter int IN_WIDTH  = 8,
    parameter int ACC_WIDTH = 20
) (
    input logic clk,
    input logic en,
    input logic clr_acc,
    input logic [IN_WIDTH-1:0] a,  // activations are unsigned
    input logic signed [IN_WIDTH-1:0] b,  // weights are signed
    output logic signed [ACC_WIDTH-1:0] acc_out
);
  always_ff @(posedge clk) begin
    if (en) begin
      acc_out <= clr_acc ? $signed({1'b0, a}) * b : acc_out + ($signed({1'b0, a}) * b);
    end
  end
endmodule
