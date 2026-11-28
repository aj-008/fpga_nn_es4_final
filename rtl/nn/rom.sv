// WIDTH is width of widest value, we probably won't change (8 for w, 16 for b)
// DEPTH is number of weights or biases
module rom #(
    parameter int WIDTH = 8,
    parameter int DEPTH = 8320,
    parameter string FILE = "mem/w.mem"
) (
    input logic clk,
    input logic [$clog2(DEPTH)-1:0] addr,  // ceiling of log_2(N)
    output logic signed [WIDTH-1:0] data
);

  logic signed [WIDTH-1:0] mem[DEPTH];

  initial begin
    $readmemh(FILE, mem);
  end

  always_ff @(posedge clk) begin
    data <= mem[addr];
  end

endmodule
