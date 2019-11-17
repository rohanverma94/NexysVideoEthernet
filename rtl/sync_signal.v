

// Language: Verilog-2001

`timescale 1 ns / 1 ps

/*
 * Synchronizes an asyncronous signal to a given clock by using a pipeline of
 * two registers.
 */
module sync_signal #(
    parameter WIDTH=1, // width of the input and output signals
    parameter N=2 // depth of synchronizer
)(
    input wire clk,
    input wire [WIDTH-1:0] in,
    output wire [WIDTH-1:0] out
);

reg [WIDTH-1:0] sync_reg[N-1:0];

/*
 * The synchronized output is the last register in the pipeline.
 */
assign out = sync_reg[N-1];

integer k;

always @(posedge clk) begin
    sync_reg[0] <= in;
    for (k = 1; k < N; k = k + 1) begin
        sync_reg[k] <= sync_reg[k-1];
    end
end

endmodule
