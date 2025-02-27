module car_top(
	sys_clk,
	sys_rst_n,
	ble_rxd,
	encoder1_A,
	encoder1_B,
	encoder2_A,
	encoder2_B,
	encoder3_A,
	encoder3_B,
	encoder4_A,
	encoder4_B,
	pwm1,
	pwm2,
	pwm3,
	pwm4,
	pwm5,
	pwm6,
	motorA_1,
	motorA_2,
	motorB_1,
	motorB_2,
	motorC_1,
	motorC_2,
	motorD_1,
	motorD_2,
	led,
	dht11,
	lcd_hs,
	lcd_vs,
	lcd_rgb,
	lcd_bl,
	lcd_de,
	lcd_rst,
	lcd_clk);

	//---Ports declearation: generated by Robei---
	input sys_clk;
	input sys_rst_n;
	input ble_rxd;
	input encoder1_A;
	input encoder1_B;
	input encoder2_A;
	input encoder2_B;
	input encoder3_A;
	input encoder3_B;
	input encoder4_A;
	input encoder4_B;
	output pwm1;
	output pwm2;
	output pwm3;
	output pwm4;
	output pwm5;
	output pwm6;
	output motorA_1;
	output motorA_2;
	output motorB_1;
	output motorB_2;
	output motorC_1;
	output motorC_2;
	output motorD_1;
	output motorD_2;
	output [5:0] led;
	inout dht11;
	output lcd_hs;
	output lcd_vs;
	output [23:0] lcd_rgb;
	output lcd_bl;
	output lcd_de;
	output lcd_rst;
	output lcd_clk;

	wire sys_clk;
	wire sys_rst_n;
	wire ble_rxd;
	wire encoder1_A;
	wire encoder1_B;
	wire encoder2_A;
	wire encoder2_B;
	wire encoder3_A;
	wire encoder3_B;
	wire encoder4_A;
	wire encoder4_B;
	wire pwm1;
	wire pwm2;
	wire pwm3;
	wire pwm4;
	wire pwm5;
	wire pwm6;
	wire motorA_1;
	wire motorA_2;
	wire motorB_1;
	wire motorB_2;
	wire motorC_1;
	wire motorC_2;
	wire motorD_1;
	wire motorD_2;
	wire [5:0] led;
	wire dht11;
	wire lcd_hs;
	wire lcd_vs;
	wire [23:0] lcd_rgb;
	wire lcd_bl;
	wire lcd_de;
	wire lcd_rst;
	wire lcd_clk;
	wire ble_ctrl3_rx_sig;
	wire [7:0] ble_ctrl3_rdata;

	//----Code starts here: integrated by Robei-----
	
	
	
	
	//---Module instantiation---
	motor motor1(
		.sys_clk(sys_clk),
		.sys_rst_n(sys_rst_n),
		.rdata(ble_ctrl3_rdata),
		.rx_sig(ble_ctrl3_rx_sig),
		.encoder1_A(encoder1_A),
		.encoder1_B(encoder1_B),
		.encoder2_A(encoder2_A),
		.encoder2_B(encoder2_B),
		.encoder3_A(encoder3_A),
		.encoder3_B(encoder3_B),
		.encoder4_A(encoder4_A),
		.encoder4_B(encoder4_B),
		.motorA_1(motorA_1),
		.motorA_2(motorA_2),
		.motorB_1(motorB_1),
		.motorB_2(motorB_2),
		.motorC_1(motorC_1),
		.motorC_2(motorC_2),
		.motorD_1(motorD_1),
		.motorD_2(motorD_2),
		.led(led));

	arm arm2(
		.sys_clk(sys_clk),
		.sys_rst_n(sys_rst_n),
		.rdata(ble_ctrl3_rdata),
		.rx_sig(ble_ctrl3_rx_sig),
		.pwm1(pwm1),
		.pwm2(pwm2),
		.pwm3(pwm3),
		.pwm4(pwm4),
		.pwm5(pwm5),
		.pwm6(pwm6));

	ble_ctrl ble_ctrl3(
		.sys_clk(sys_clk),
		.sys_rst_n(sys_rst_n),
		.ble_rxd(ble_rxd),
		.rdata(ble_ctrl3_rdata),
		.rx_sig(ble_ctrl3_rx_sig));

	lcd_rgb_char lcd_rgb_char4(
		.sys_clk(sys_clk),
		.sys_rst_n(sys_rst_n),
		.lcd_hs(lcd_hs),
		.lcd_vs(lcd_vs),
		.lcd_de(lcd_de),
		.lcd_rgb(lcd_rgb),
		.lcd_bl(lcd_bl),
		.lcd_rst(lcd_rst),
		.lcd_clk(lcd_clk),
		.dht11(dht11));

endmodule    //car_top

