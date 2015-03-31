/*
 * In The Name Of God
 * ========================================
 * [] File Name : cache.v
 *
 * [] Creation Date : 04-03-2015
 *
 * [] Last Modified : Tue, Mar 31, 2015  9:32:06 AM
 *
 * [] Created By : Parham Alvani (parham.alvani@gmail.com)
 * =======================================
*/
`timescale 1 ns/100 ps
module cache (enable, index, word, comp,
	write, tag_in, data_in, valid_in,
	rst, hit, dirty, tag_out,
	data_out, valid, ack);

	parameter N = 15;
	reg [0:3] counter;

	input enable;
	input [0:3] index;
	input [0:1] word;
	input comp;
	input write;
	input [0:4] tag_in;
	input [0:15] data_in;
	input valid_in;
	input rst;

	output reg hit;
	output reg dirty;
	output reg [0:4] tag_out;
	output reg [0:15] data_out;
	output reg valid;
	output reg ack;
		
	reg set_en [0:N];
	reg [0:1] set_word [0:N];
	reg set_cmp [0:N];
	reg set_wr [0:N];
	reg [0:4] set_tag_in [0:N];
	reg [0:15] set_in [0:N];
	reg set_valid_in [0:N];
	reg set_rst [0:N];

	wire set_hit [0:N];
	wire set_dirty_out [0:N];
	wire [0:4] set_tag_out [0:N];
	wire [0:15] set_out [0:N];
	wire set_valid_out [0:N];
	wire set_ack [0:N];

	generate
	genvar i;
	for (i = 0; i < N; i = i + 1) begin
		set set_ins(set_en[i], set_word[i], set_cmp[i], set_wr[i], set_rst[i],
			set_tag_in[i], set_in[i], set_valid_in[i], set_hit[i], set_dirty_out[i],
			set_tag_out[i], set_out[i], set_valid_out[i], set_ack[i]);
	end
	endgenerate
	
	always @ (enable) begin
		ack = 1'b0;
		if (enable) begin
			if (rst) begin
				for (counter = 0; counter < N; counter = counter + 1) begin
					set_en[counter] = 1'b1;
					set_rst[counter] = 1'b1;
					wait (set_ack[counter]) begin
						set_en[counter] = 1'b0;
						set_rst[counter] = 1'b0;
					end
				end
				ack = 1'b1;
			end else begin
				set_word[index] = word;
				set_cmp[index] = comp;
				set_wr[index] = write;
				set_tag_in[index] = tag_in;
				set_in[index] = data_in;
				set_valid_in[index] = valid_in;
				set_en[index] = 1'b1;
			
				wait (set_ack[index]) begin
					hit = set_hit[index];
					dirty = set_dirty_out[index];
					tag_out = set_tag_out[index];
					valid = set_valid_out[index];
					data_out = set_out[index];
				end

				ack = 1'b1;
			end
		end else begin
			set_en[index] = 1'b0;
		end
	end
endmodule
