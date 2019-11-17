

// Language: Verilog-2001

`timescale 1 ns / 1 ps

/*
 * Synchronizes an active-high asynchronous reset signal to a given clock by
 * using a pipeline of N registers.
 */
module sync_reset #(
    parameter N=2 // depth of synchronizer
)(
    input wire clk,
    input wire rst,
    output wire sync_reset_out
);

reg [N-1:0] sync_reg = {N{1'b1}};

assign sync_reset_out = sync_reg[N-1];

always @(posedge clk or posedge rst) begin
    if (rst)
        sync_reg <= {N{1'b1}};
    else
        sync_reg <= {sync_reg[N-2:0], 1'b0};
end

endmodule
