module ble_ctrl(
	sys_clk,
	sys_rst_n,
	ble_rxd,
	rdata,
	rx_sig);

	//---Ports declearation: generated by Robei---
	input sys_clk;
	input sys_rst_n;
	input ble_rxd;
	output [7:0] rdata;
	output rx_sig;

	wire sys_clk;
	wire sys_rst_n;
	wire ble_rxd;
	reg [7:0] rdata;
	reg rx_sig;

	//----Code starts here: integrated by Robei-----
	
	
	parameter  CNT_BAUD9600    = 1735,
							CNT_BAUD19200 	= 867,
							CNT_BAUD38400 	= 433,
							CNT_BAUD57600 	= 288,
							CNT_BAUD115200 = 143;
		
		
		parameter	CNT_END_SEL = CNT_BAUD115200;
		
		//通过波特率时钟参数，生成波特率时钟信号
		reg baud_clk;
		reg [11:0] baud_cnt;
		
		always@(posedge sys_clk or negedge sys_rst_n)
			begin
				if(!sys_rst_n)
					begin
						baud_clk <= 1'b0;
						baud_cnt <= 12'd0;
					end
				else if (baud_cnt == CNT_END_SEL)
					begin
						baud_clk <= ~baud_clk;
						baud_cnt <= 12'd0;
					end
				else 
					begin
						baud_cnt <= baud_cnt + 1'b1;
					end
			end
		
	
		parameter 	IDLE 		    = 2'd0, //空闲状态
						    READY		= 2'd1, //起始位
						    RX_DATA 	= 2'd2, //数据帧
						    RX_FINISH 	= 2'd3; //停止位
		
		reg[1:0] 	state;  //存储状态信息
		reg [2:0]	rx_cnt;//存储接收到的数据位数信息
		reg [7:0]	rx_reg;//存储接收到的数据信息
			
		always@(posedge baud_clk or negedge sys_rst_n)
		begin
			if(!sys_rst_n)
				begin
					rdata <= 8'd0;
					rx_reg <= 8'd0;
					rx_cnt <= 3'd0;
					rx_sig <= 1'b0;
					state <= IDLE;
				end
			else
				case(state)
		
	
					IDLE:
						begin
							rdata <= 8'd0;
							rx_reg <= 8'd0;
							rx_sig <= 1'b0;
							rx_cnt <= 3'd0;
							state <= READY;
						end
		
					READY:
						begin
							rx_reg <= 8'd0;
							rx_sig <= 1'b0;
							rx_cnt <= 3'd0;
							if(!ble_rxd)
								state <= RX_DATA;
							else
								state <= READY;
						end
	
					RX_DATA:
						begin
							if(rx_cnt==7) 
								begin
									rx_reg[rx_cnt] <= ble_rxd;
									rx_sig <= 1'b1;
									state <= RX_FINISH;
								end
							else
								begin
									rx_reg[rx_cnt] <= ble_rxd;
									rx_cnt <= rx_cnt + 1'b1;
									state <= RX_DATA;
								end
						end
		
					RX_FINISH:
						begin
							rdata <= rx_reg;
							rx_sig <= 1'b1;
							if(ble_rxd)
								state <= READY;
							else
								state <= RX_FINISH;
						end
		
		
						default:
						begin
							rdata <= 8'd0;
							rx_reg <= 8'd0;
							rx_sig <= 1'b0;
							rx_cnt <= 3'd0;
							state <= IDLE;
						end
					endcase
			end
	
endmodule    //ble_ctrl

