/*
 * In The Name Of God
 * ========================================
 * [] File Name : set_t.v
 *
 * [] Creation Date : 04-03-2015
 *
 * [] Last Modified : Wed 04 Mar 2015 10:53:23 AM IRST
 *
 * [] Created By : Parham Alvani (parham.alvani@gmail.com)
 * =======================================
*/
`timescale 1 ns/100 ps

module set_t;
	reg [0:15] data_in;
	reg [0:4] tag;
	reg enable;
	reg write;
	reg [0:1] word;
	reg cmp;

	wire [0:15] data_out;
	wire [0:4] tag_out;
	wire hit;
	wire dirty;
	wire valid;

	initial begin
		$dumpfile("set.vcd");
		$dumpvars(0, set_t);
		enable = 0;
		word = 2'b11;
		data_in = 16'b0000_1111_0000_1111;
		tag = 5'b11101;
		#5
		enable = 1;
		write = 1;
		cmp = 0;
		#5
		enable = 0;
		#5
		enable = 1;
		write = 0;
		cmp = 1;
		#10
		$stop;
	end

	set st(enable, word, cmp, write, tag, data_in, 1'b0, 1'b0, hit, dirty, tag_out, data_out, valid);
endmodule