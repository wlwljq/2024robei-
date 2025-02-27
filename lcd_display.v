module lcd_display(
	lcd_pclk,
	rst_n,
	data1,
	data2,
	pixel_xpos,
	pixel_ypos,
	pixel_data);

	//---Ports declearation: generated by Robei---
	input lcd_pclk;
	input rst_n;
	input [7:0] data1;
	input [7:0] data2;
	input [10:0] pixel_xpos;
	input [10:0] pixel_ypos;
	output [23:0] pixel_data;

	wire lcd_pclk;
	wire rst_n;
	wire [7:0] data1;
	wire [7:0] data2;
	wire [10:0] pixel_xpos;
	wire [10:0] pixel_ypos;
	reg [23:0] pixel_data;

	//----Code starts here: integrated by Robei-----
	
	localparam PIC_X_START = 11'd1;      //图片起始点横坐标
	localparam PIC_Y_START = 11'd1;      //图片起始点纵坐标
	localparam PIC_WIDTH   = 11'd100;    //图片宽度
	localparam PIC_HEIGHT  = 11'd100;    //图片高度
	 //CICC3125                      
	localparam CHAR_X_START= 11'd1;      //字符起始点横坐标
	localparam CHAR_Y_START= 11'd150;    //字符起始点纵坐标
	localparam CHAR_WIDTH  = 11'd128;    //字符宽度,4个字符:32*4
	localparam CHAR_HEIGHT = 11'd32;     //字符高度
	//温度：
	localparam CHAR_X_START1= 11'd1;      //字符起始点横坐标
	localparam CHAR_Y_START1= 11'd250;    //字符起始点纵坐标
	localparam CHAR_WIDTH1  = 11'd96;    //字符宽度,3个字符:32*3
	localparam CHAR_HEIGHT1 = 11'd32;     //字符高度
	//湿度：
	localparam CHAR_X_START2= 11'd1;      //字符起始点横坐标
	localparam CHAR_Y_START2= 11'd330;    //字符起始点纵坐标
	localparam CHAR_WIDTH2  = 11'd96;    //字符宽度,3个字符:32*3
	localparam CHAR_HEIGHT2 = 11'd32;     //字符高度
	//数字
	localparam CHAR_POS_X_1  = 11'd200;  //第1行字符区域起始点横坐标
	localparam CHAR_POS_Y_1  = 11'd250;  //第1行字符区域起始点纵坐标
	localparam CHAR_POS_X_2  = 11'd200; //第2行字符区域起始点横坐标
	localparam CHAR_POS_Y_2  = 11'd330; //第2行字符区域起始点纵坐标
	localparam CHAR_WIDTH_1  = 11'd80; //第1行字符区域的宽度，第1行共10个字符(加空格)
	localparam CHAR_WIDTH_2  = 11'd80; //第2行字符区域的宽度，第2行共10个字符(加空格)
	localparam CHAR_HEIGHT3   = 11'd16; //单个字符的高度
	
	localparam CHAR_POS_X_3  = 11'd98;  //第1行字符区域起始点横坐标
	localparam CHAR_POS_Y_3  = 11'd250;  //第1行字符区域起始点纵坐标
	localparam CHAR_POS_X_4  = 11'd98; //第2行字符区域起始点横坐标
	localparam CHAR_POS_Y_4  = 11'd330; //第2行字符区域起始点纵坐标
	localparam CHAR_WIDTH_3  = 11'd160; //第1行字符区域的宽度，第1行共10个字符(加空格)
	localparam CHAR_WIDTH_4  = 11'd160; //第2行字符区域的宽度，第2行共10个字符(加空格)
	localparam CHAR_HEIGHT4   = 11'd32; //单个字符的高度
	                      
	localparam BACK_COLOR  = 24'hE0FFFF; //背景色，浅蓝色
	localparam CHAR_COLOR  = 24'hff0000; //字符颜色，红色
	
	//reg define
	reg   [127:0] char[31:0];  //字符数组
	reg   [95:0] char1[31:0];  //字符数组
	reg   [95:0] char2[31:0];  //字符数组
	reg   [127:0] char3[9:0];  //字符数组
	reg   [511:0] char4[9:0];  //字符数组
	reg   [13:0]  rom_addr  ;  //ROM地址
	
	
	
	//wire define   
	wire  [10:0]  x_cnt;       //横坐标计数器
	wire  [10:0]  y_cnt;       //纵坐标计数器
	wire  [10:0]  x_cnt1;       //横坐标计数器
	wire  [10:0]  y_cnt1;       //BACK_COLOR
	wire  [10:0]  x_cnt2;       //横坐标计数器
	wire  [10:0]  y_cnt2;       //纵坐标计数器
	wire          rom_rd_en ;  //ROM读使能信号
	wire  [23:0]  rom_rd_data ;//ROM数据
	
	wire [7:0]  data_1;
	wire [7:0]  data_2;
	
	assign  x_cnt = pixel_xpos - CHAR_X_START; //像素点相对于字符区域起始点水平坐标
	assign  y_cnt = pixel_ypos - CHAR_Y_START; //像素点相对于字符区域起始点垂直坐标
	assign  x_cnt1 = pixel_xpos - CHAR_X_START1; //像素点相对于字符区域起始点水平坐标
	assign  y_cnt1 = pixel_ypos - CHAR_Y_START1; //像素点相对于字符区域起始点垂直坐标
	assign  x_cnt2 = pixel_xpos - CHAR_X_START2; //像素点相对于字符区域起始点水平坐标
	assign  y_cnt2 = pixel_ypos - CHAR_Y_START2; //像素点相对于字符区域起始点垂直坐标
	
	assign  rom_rd_en = 1'b1;                  //读使能拉高，即一直读ROM数据
	
	assign data_1 = 8'b00110001;
	assign data_2 = 8'b00010011;
	
	//给字符数组赋值，显示汉字“CICL3125”，每个汉字大小为32*32
	always @(posedge lcd_pclk) begin
	    char[0 ]  <= 128'h00000000000000000000000000000000;
	    char[1 ]  <= 128'h00000000000000000000000000000000;
	    char[2 ]  <= 128'h00000000000000000000000000000000;
	    char[3 ]  <= 128'h00000000000000000000000000000000;
	    char[4 ]  <= 128'h00000000000000000000000000000000;
	    char[5 ]  <= 128'h00000000000000000000000000000000;
	    char[6 ]  <= 128'h03E01FF803E003E007C0008007E00FFC;
	    char[7 ]  <= 128'h061C0180061C061C1860018008380FFC;
	    char[8 ]  <= 128'h080C0180080C080C30301F8010181000;
	    char[9 ]  <= 128'h180601801806180630180180200C1000;
	    char[10]  <= 128'h300201803002300230180180200C1000;
	    char[11]  <= 128'h300201803002300230180180300C1000;
	    char[12]  <= 128'h300001803000300000180180300C1000;
	    char[13]  <= 128'h600001806000600000180180000C1000;
	    char[14]  <= 128'h600001806000600000300180001813E0;
	    char[15]  <= 128'h60000180600060000060018000181430;
	    char[16]  <= 128'h600001806000600003C0018000301818;
	    char[17]  <= 128'h60000180600060000070018000601008;
	    char[18]  <= 128'h60000180600060000018018000C0000C;
	    char[19]  <= 128'h6000018060006000000801800180000C;
	    char[20]  <= 128'h6000018060006000000C01800300000C;
	    char[21]  <= 128'h6000018060006000000C01800200000C;
	    char[22]  <= 128'h3002018030023002300C01800404300C;
	    char[23]  <= 128'h3002018030023002300C01800804300C;
	    char[24]  <= 128'h10040180100410043008018010042018;
	    char[25]  <= 128'h180801801808180830180180200C2018;
	    char[26]  <= 128'h0C1001800C100C10183003C03FF81830;
	    char[27]  <= 128'h03E01FF803E003E007C01FF83FF807C0;
	    char[28]  <= 128'h00000000000000000000000000000000;
	    char[29]  <= 128'h00000000000000000000000000000000;
	    char[30]  <= 128'h00000000000000000000000000000000;
	    char[31]  <= 128'h00000000000000000000000000000000;       
	end
	//给字符数组赋值，显示汉字"温度："，每个汉字大小为32*32
	always @(posedge lcd_pclk) begin
	    char1[0 ]  <= 96'h000000000000000000000000;
	    char1[1 ]  <= 96'h000000000000000000000000;
	    char1[2 ]  <= 96'h000000000001000000000000;
	    char1[3 ]  <= 96'h0C0800800000C00000000000;
	    char1[4 ]  <= 96'h060FFFC00000E01000000000;
	    char1[5 ]  <= 96'h030C00800400403800000000;
	    char1[6 ]  <= 96'h030C008007FFFFFC00000000;
	    char1[7 ]  <= 96'h002C00800604040000000000;
	    char1[8 ]  <= 96'h004C00800607070000000000;
	    char1[9 ]  <= 96'h004FFF800606060000000000;
	    char1[10]  <= 96'h004C00800606063000000000;
	    char1[11]  <= 96'h304C008007FFFFF800000000;
	    char1[12]  <= 96'h188C00800606060000000000;
	    char1[13]  <= 96'h0C8C00800606060000000000;
	    char1[14]  <= 96'h088FFF800606060000000000;
	    char1[15]  <= 96'h010C00800606060000000000;
	    char1[16]  <= 96'h010800000607FE0000000000;
	    char1[17]  <= 96'h010000000606060007000000;
	    char1[18]  <= 96'h03200020040001000F000000;
	    char1[19]  <= 96'h023FFFF0043FFF800F000000;
	    char1[20]  <= 96'h02318C600C04038007000000;
	    char1[21]  <= 96'h06318C600C02070000000000;
	    char1[22]  <= 96'h3E318C600C03060000000000;
	    char1[23]  <= 96'h0E318C6008010C0000000000;
	    char1[24]  <= 96'h0C318C600800D80000000000;
	    char1[25]  <= 96'h0C318C601800700007000000;
	    char1[26]  <= 96'h0C318C601000F8000F000000;
	    char1[27]  <= 96'h0C318C6010039E000F000000;
	    char1[28]  <= 96'h0C318C6C200E07F806000000;
	    char1[29]  <= 96'h0DFFFFFC207000F800000000;
	    char1[30]  <= 96'h000000004780001000000000;
	    char1[31]  <= 96'h000000000000000000000000;   
	end
	//给字符数组赋值，显示汉字“湿度：”，每个汉字大小为32*32
	always @(posedge lcd_pclk) begin
	    char2[0 ]  <= 96'h000000000000000000000000;
	    char2[1 ]  <= 96'h000000000000000000000000;
	    char2[2 ]  <= 96'h000000000001000000000000;
	    char2[3 ]  <= 96'h080800000000C00000000000;
	    char2[4 ]  <= 96'h060FFFE00000E01000000000;
	    char2[5 ]  <= 96'h070C00600400403800000000;
	    char2[6 ]  <= 96'h030C006007FFFFFC00000000;
	    char2[7 ]  <= 96'h030C00600604040000000000;
	    char2[8 ]  <= 96'h002C00600607070000000000;
	    char2[9 ]  <= 96'h004FFFE00606060000000000;
	    char2[10]  <= 96'h604C00600606063000000000;
	    char2[11]  <= 96'h304C006007FFFFF800000000;
	    char2[12]  <= 96'h1C8C00600606060000000000;
	    char2[13]  <= 96'h0C8C00600606060000000000;
	    char2[14]  <= 96'h0C8FFFE00606060000000000;
	    char2[15]  <= 96'h010C84600606060000000000;
	    char2[16]  <= 96'h0108C6000607FE0000000000;
	    char2[17]  <= 96'h0300C6000606060007000000;
	    char2[18]  <= 96'h0200C618040001000F000000;
	    char2[19]  <= 96'h0620C61C043FFF800F000000;
	    char2[20]  <= 96'h0610C6300C04038007000000;
	    char2[21]  <= 96'h7C18C6600C02070000000000;
	    char2[22]  <= 96'h0C0CC6400C03060000000000;
	    char2[23]  <= 96'h0C0CC68008010C0000000000;
	    char2[24]  <= 96'h0C0CC7000800D80000000000;
	    char2[25]  <= 96'h0C04C6001800700007000000;
	    char2[26]  <= 96'h1C00C6001000F8000F000000;
	    char2[27]  <= 96'h1C00C60010039E000F000000;
	    char2[28]  <= 96'h1C00C608200E07F806000000;
	    char2[29]  <= 96'h0CFFFFFC207000F800000000;
	    char2[30]  <= 96'h000000004780001000000000;
	    char2[31]  <= 96'h000000000000000000000000;    
	end
	//字符数组初始值,用于存储字模数据(由取模软件生成,单个数字字体大小:16*16)
	always @(posedge lcd_pclk ) begin
	    char3[0] <= 128'h00000018244242424242424224180000 ;  // "0"
	    char3[1] <= 128'h000000107010101010101010107C0000 ;  // "1"
	    char3[2] <= 128'h0000003C4242420404081020427E0000 ;  // "2"
	    char3[3] <= 128'h0000003C424204180402024244380000 ;  // "3"
	    char3[4] <= 128'h000000040C14242444447E04041E0000 ;  // "4"
	    char3[5] <= 128'h0000007E404040586402024244380000 ;  // "5"
	    char3[6] <= 128'h0000001C244040586442424224180000 ;  // "6"
	    char3[7] <= 128'h0000007E444408081010101010100000 ;  // "7"
	    char3[8] <= 128'h0000003C4242422418244242423C0000 ;  // "8"
	    char3[9] <= 128'h0000001824424242261A020224380000 ;  // "9"
	end
	always @(posedge lcd_pclk ) begin
	    char4[0] <= 512'h00000000000000000000000003C006200C30181818181808300C300C300C300C300C300C300C300C300C300C1808181818180C30062003C00000000000000000 ;  // "0"
	    char4[1] <= 512'h000000000000000000000000008001801F800180018001800180018001800180018001800180018001800180018001800180018003C01FF80000000000000000 ;  // "1"
	    char4[2] <= 512'h00000000000000000000000007E008381018200C200C300C300C000C001800180030006000C0018003000200040408041004200C3FF83FF80000000000000000 ;  // "2"
	    char4[3] <= 512'h00000000000000000000000007C018603030301830183018001800180030006003C0007000180008000C000C300C300C30083018183007C00000000000000000 ;  // "3"
	    char4[4] <= 512'h0000000000000000000000000060006000E000E0016001600260046004600860086010603060206040607FFC0060006000600060006003FC0000000000000000 ;  // "4"
	    char4[5] <= 512'h0000000000000000000000000FFC0FFC10001000100010001000100013E0143018181008000C000C000C000C300C300C20182018183007C00000000000000000 ;  // "5"
	    char4[6] <= 512'h00000000000000000000000001E006180C180818180010001000300033E0363038183808300C300C300C300C300C180C18080C180E3003E00000000000000000 ;  // "6"
	    char4[7] <= 512'h0000000000000000000000001FFC1FFC100830102010202000200040004000400080008001000100010001000300030003000300030003000000000000000000 ;  // "7"
	    char4[8] <= 512'h00000000000000000000000007E00C301818300C300C300C380C38081E180F2007C018F030783038601C600C600C600C600C3018183007C00000000000000000 ;  // "8"
	    char4[9] <= 512'h00000000000000000000000007C01820301030186008600C600C600C600C600C701C302C186C0F8C000C0018001800103030306030C00F800000000000000000 ;  // "9"
	end
	
	
	
	
	//为LCD不同显示区域绘制图片、字符和背景色
	always @(posedge lcd_pclk or negedge rst_n) begin
	    if (!rst_n)
	        pixel_data <= BACK_COLOR;
	//    else if( (pixel_xpos >= PIC_X_START) && (pixel_xpos < PIC_X_START + PIC_WIDTH) 
	//          && (pixel_ypos >= PIC_Y_START) && (pixel_ypos < PIC_Y_START + PIC_HEIGHT) )
	//        pixel_data <= rom_rd_data ;  //显示图片
	    else if((pixel_xpos >= CHAR_X_START) && (pixel_xpos < CHAR_X_START + CHAR_WIDTH)
	         && (pixel_ypos >= CHAR_Y_START) && (pixel_ypos < CHAR_Y_START + CHAR_HEIGHT)) begin
	        if(char[y_cnt][CHAR_WIDTH -1'b1 - x_cnt]) 
	            pixel_data <= CHAR_COLOR;    //显示字符
	        else
	            pixel_data <= BACK_COLOR;    //显示字符区域的背景色
	    end
	    else if((pixel_xpos >= CHAR_X_START1) && (pixel_xpos < CHAR_X_START1 + CHAR_WIDTH1)
	         && (pixel_ypos >= CHAR_Y_START1) && (pixel_ypos < CHAR_Y_START1 + CHAR_HEIGHT1)) begin
	        if(char1[y_cnt1][CHAR_WIDTH1 -1'b1 - x_cnt1]) 
	            pixel_data <= CHAR_COLOR;    //显示字符1
	        else
	            pixel_data <= BACK_COLOR;    //显示字符区域的背景色
	    end
	    else if((pixel_xpos >= CHAR_X_START2) && (pixel_xpos < CHAR_X_START2 + CHAR_WIDTH2)
	         && (pixel_ypos >= CHAR_Y_START2) && (pixel_ypos < CHAR_Y_START2 + CHAR_HEIGHT2)) begin
	        if(char2[y_cnt2][CHAR_WIDTH2 -1'b1 - x_cnt2]) 
	            pixel_data <= CHAR_COLOR;    //显示字符2
	        else
	            pixel_data <= BACK_COLOR;    //显示字符区域的背景色
	    end
	    
	    else if(     (pixel_xpos >= CHAR_POS_X_1)                    
	                  && (pixel_xpos <  CHAR_POS_X_1 + CHAR_WIDTH_1/10*1)
	                  && (pixel_ypos >= CHAR_POS_Y_1)                    
	                  && (pixel_ypos <  CHAR_POS_Y_1 + CHAR_HEIGHT3)  ) begin
	            if(char3 [data1[7:4]] [ (CHAR_HEIGHT3+CHAR_POS_Y_1 - pixel_ypos)*8 
	                          - ((pixel_xpos-CHAR_POS_X_1)%8) -1 ] )  
	                pixel_data <= CHAR_COLOR;         //显示字符为黑色
	            else
	                pixel_data <= BACK_COLOR;        //显示字符区域背景为白色
	        end
	    else if(     (pixel_xpos >= CHAR_POS_X_1 + CHAR_WIDTH_1/10*1) 
	                  && (pixel_xpos <  CHAR_POS_X_1 + CHAR_WIDTH_1/10*2)
	                  && (pixel_ypos >= CHAR_POS_Y_1)                    
	                  && (pixel_ypos <  CHAR_POS_Y_1 + CHAR_HEIGHT3)  ) begin
	            if(char3 [data1[3:0]] [ (CHAR_HEIGHT3+CHAR_POS_Y_1 - pixel_ypos)*8 
	                          - ((pixel_xpos-CHAR_POS_X_1)%8) -1 ] )  
	                pixel_data <= CHAR_COLOR;         //显示字符为黑色
	            else
	                pixel_data <= BACK_COLOR;        //显示字符区域背景为白色
	        end
	        
	    else if(     (pixel_xpos >= CHAR_POS_X_2) 
	                  && (pixel_xpos <  CHAR_POS_X_2 + CHAR_WIDTH_2/10*1)
	                  && (pixel_ypos >= CHAR_POS_Y_2)                    
	                  && (pixel_ypos <  CHAR_POS_Y_2 + CHAR_HEIGHT3)  ) begin
	            if(char3 [data2[7:4]] [ (CHAR_HEIGHT3+CHAR_POS_Y_2 - pixel_ypos)*8 
	                          - ((pixel_xpos-CHAR_POS_X_2)%8) -1 ] )  
	                pixel_data <= CHAR_COLOR;         //显示字符为黑色
	            else
	                pixel_data <= BACK_COLOR;        //显示字符区域背景为白色
	        end
	    else if(     (pixel_xpos >= CHAR_POS_X_2 + CHAR_WIDTH_2/10*1) 
	                  && (pixel_xpos <  CHAR_POS_X_2 + CHAR_WIDTH_2/10*2)
	                  && (pixel_ypos >= CHAR_POS_Y_2)                    
	                  && (pixel_ypos <  CHAR_POS_Y_2 + CHAR_HEIGHT3)  ) begin
	            if(char3 [data2[3:0]] [ (CHAR_HEIGHT3+CHAR_POS_Y_2 - pixel_ypos)*8 
	                          - ((pixel_xpos-CHAR_POS_X_2)%8) -1 ] )  
	                pixel_data <= CHAR_COLOR;         //显示字符为黑色
	            else
	                pixel_data <= BACK_COLOR;        //显示字符区域背景为白色
	        end
	        
	    else if(     (pixel_xpos >= CHAR_POS_X_3) 
	                  && (pixel_xpos <  CHAR_POS_X_3 + CHAR_WIDTH_3/10*1)
	                  && (pixel_ypos >= CHAR_POS_Y_3)                    
	                  && (pixel_ypos <  CHAR_POS_Y_3 + CHAR_HEIGHT4)  ) begin
	            if(char4 [data1[7:4]] [ (CHAR_HEIGHT4+CHAR_POS_Y_3 - pixel_ypos)*16 
	                          - ((pixel_xpos-CHAR_POS_X_3)%16) -1 ] )  
	                pixel_data <= CHAR_COLOR;         //显示字符为黑色
	            else
	                pixel_data <= BACK_COLOR;        //显示字符区域背景为白色
	        end
	    else if(     (pixel_xpos >= CHAR_POS_X_3 + CHAR_WIDTH_3/10*1) 
	                  && (pixel_xpos <  CHAR_POS_X_3 + CHAR_WIDTH_3/10*2)
	                  && (pixel_ypos >= CHAR_POS_Y_3)                    
	                  && (pixel_ypos <  CHAR_POS_Y_3 + CHAR_HEIGHT4)  ) begin
	            if(char4 [data1[3:0]] [ (CHAR_HEIGHT4+CHAR_POS_Y_3 - pixel_ypos)*16 
	                          - ((pixel_xpos-CHAR_POS_X_3)%16) -1 ] )  
	                pixel_data <= CHAR_COLOR;         //显示字符为黑色
	            else
	                pixel_data <= BACK_COLOR;        //显示字符区域背景为白色
	        end
	    else if(     (pixel_xpos >= CHAR_POS_X_4) 
	                  && (pixel_xpos <  CHAR_POS_X_4 + CHAR_WIDTH_4/10*1)
	                  && (pixel_ypos >= CHAR_POS_Y_4)                    
	                  && (pixel_ypos <  CHAR_POS_Y_4 + CHAR_HEIGHT4)  ) begin
	            if(char4 [data2[7:4]] [ (CHAR_HEIGHT4+CHAR_POS_Y_4 - pixel_ypos)*16 
	                          - ((pixel_xpos-CHAR_POS_X_4)%16) -1 ] )  
	                pixel_data <= CHAR_COLOR;         //显示字符为黑色
	            else
	                pixel_data <= BACK_COLOR;        //显示字符区域背景为白色
	        end
	    else if(     (pixel_xpos >= CHAR_POS_X_4 + CHAR_WIDTH_4/10*1) 
	                  && (pixel_xpos <  CHAR_POS_X_4 + CHAR_WIDTH_4/10*2)
	                  && (pixel_ypos >= CHAR_POS_Y_4)                    
	                  && (pixel_ypos <  CHAR_POS_Y_4 + CHAR_HEIGHT4)  ) begin
	            if(char4 [data2[3:0]] [ (CHAR_HEIGHT4+CHAR_POS_Y_4 - pixel_ypos)*16 
	                          - ((pixel_xpos-CHAR_POS_X_4)%16) -1 ] )  
	                pixel_data <= CHAR_COLOR;         //显示字符为黑色
	            else
	                pixel_data <= BACK_COLOR;        //显示字符区域背景为白色
	        end
	    else
	        pixel_data <= BACK_COLOR;        //屏幕背景色
	end
	
	//根据当前扫描点的横纵坐标为ROM地址赋值
	always @(posedge lcd_pclk or negedge rst_n) begin
	    if(!rst_n)
	        rom_addr <= 14'd0;
	    //当横纵坐标位于图片显示区域时,累加ROM地址    
	    else if((pixel_ypos >= PIC_Y_START) && (pixel_ypos < PIC_Y_START + PIC_HEIGHT) 
	        && (pixel_xpos >= PIC_X_START) && (pixel_xpos < PIC_X_START + PIC_WIDTH)) 
	        rom_addr <= rom_addr + 1'b1;
	    //当横纵坐标位于图片区域最后一个像素点时,ROM地址清零    
	    else if((pixel_ypos >= PIC_Y_START + PIC_HEIGHT))
	        rom_addr <= 14'd0;
	end
	
	
	
endmodule    //lcd_display

