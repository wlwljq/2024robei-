module motor_controller(
	sys_clk,
	sys_rst_n,
	control_n,
	motorout_1,
	motorout_2);

	//---Ports declearation: generated by Robei---
	input sys_clk;
	input sys_rst_n;
	input [15:0] control_n;
	output motorout_1;
	output motorout_2;

	wire sys_clk;
	wire sys_rst_n;
	wire [15:0] control_n;
	wire motorout_1;
	wire motorout_2;

	//----Code starts here: integrated by Robei-----
	
	
	reg motorout_1_r;
	reg motorout_2_r;
	reg [15:0]pwm_sel;
	
	wire pwm_out;
	
	wire signed [15:0] control;
	reg [15:0]pwm_sel_d;
	
	assign motorout_1=motorout_1_r;
	assign motorout_2=motorout_2_r;
	assign control=control_n-1000;
	
	
	always @(posedge sys_clk or negedge sys_rst_n) begin
		if(!sys_rst_n)begin
			motorout_1_r<= 1'b0;
			motorout_2_r<= 1'b0;
			pwm_sel <= 1'b0;
		end
		else if(control>0) begin
			motorout_1_r<=0;
			motorout_2_r<=pwm_out;
			pwm_sel<=control;
		end
		else if(control<0) begin
			motorout_1_r<=pwm_out;
			motorout_2_r<=0;
			pwm_sel<=-control;
		end
		else begin
			motorout_1_r<=0;
			motorout_2_r<=0;
			
		end
	
			
	end
	
	//---Module instantiation---
	pwm_10kHz pwm_10kHz1(
		.sys_clk(sys_clk),
		.sys_rst_n(sys_rst_n),
		.pwm_sel(pwm_sel),
		.pwm_out(pwm_out));

endmodule    //motor_controller

