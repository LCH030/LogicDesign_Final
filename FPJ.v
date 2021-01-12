module FPJ(
output reg[7:0] DATA_R, 
output reg[7:0] DATA_G,
output reg[7:0] DATA_B,
output reg[2:0] COMM,
output reg enable,
output reg[3:0] life,
output reg[6:0] sevenScreen,
output reg [1:0] screenCOM,
output audio,
input CLK, LButton, RButton, LaserBeamButton, ResetButton,NormalButton,EasyButton,HardButton);
				 
	bit [2:0] x_count;
	reg [2:0] x_jet;
	reg [2:0] x_badjet;
	reg [2:0] x_badjet2;
	reg [3:0] score_one;
	reg [3:0] score_ten;
	reg[23:0]  counter4Hz;
   reg[23:0]  counter6MHz;
   reg[13:0]  count;
   reg[13:0]  origin;
   reg[4:0]  j;
   reg[7:0]  len;
   reg  audiof;
   reg  clk_6MHz;
   reg  clk_4Hz;
	reg  difficult;
	assign audio = audiof; // 控制開關
 

	divfreq1kHz F0(CLK, CLK_div1k); //畫面的HZ
	
	Hard Q1(CLK, CLK_Hard); //按鈕的HZ
	Normal F1(CLK, CLK_Normal); //按鈕的HZ
	Easy W1(CLK, CLK_Easy); //按鈕的HZ

	
	initial
		begin
			x_count = 3'b000;
			DATA_R = 8'b11111111;
			DATA_G = 8'b11111111;
			DATA_B = 8'b11111111;
			COMM = 3'b000;
			enable = 1;
			x_jet = 3'b011;
			x_badjet = 3;
			y_badjet = 8;
			score_one = 4'b0000;
			score_ten = 4'b0000;
			life = 4'b1111;
		end
	
	integer laserCD;
	integer LaserBeam;
	integer badjetCD;
	integer y_badjet = 9;
	integer BadNumRand = 0;
	integer IsTwoBad = 0;
	integer BadNum = 1;
	integer x_badrandom = 7;
	integer scorePoint = 0;
	integer BadBreak = 0;
	integer BadBreak2 = 0;
	integer score_enable = 0;
	integer isCrush = 0;
	integer isCrush2 = 0;
	integer lifeLeft = 0;
	integer minusLife = 0;
	integer alphaCount = 0;
	integer alphaCD = 0;

	
	
	//過關and失敗畫面
	logic [7:0] alpha[7:0] = 
	  '{8'b11111111,
		 8'b11111111,
		 8'b11111111,
		 8'b11111111,
		 8'b11111111,
		 8'b11111111,
		 8'b11111111,
		 8'b11111111};
	parameter logic [7:0] G[7:0] =
	  '{8'b11111111,
		 8'b10010001,
		 8'b01110110,
		 8'b01110110,
		 8'b01111110,
		 8'b01111110,
		 8'b10111101,
		 8'b11000011};
	parameter logic [7:0] A[7:0] =
	  '{8'b11111111,
		 8'b11000000,
		 8'b10110111,
		 8'b01110111,
		 8'b01110111,
		 8'b10110111,
		 8'b11000000,
		 8'b11111111};
	parameter logic [7:0] M[7:0] =
	  '{8'b11111111,
		 8'b00000000,
		 8'b10111111,
		 8'b11011111,
		 8'b11011111,
		 8'b10111111,
		 8'b00000000,
		 8'b11111111};
	parameter logic [7:0] E[7:0] =
	  '{8'b11111111,
		 8'b01101110,
		 8'b01101110,
		 8'b01101110,
		 8'b01101110,
		 8'b01101110,
		 8'b00000000,
		 8'b11111111};
	parameter logic [7:0] C[7:0] =
	  '{8'b11111111,
		 8'b10111101,
		 8'b01111110,
		 8'b01111110,
		 8'b01111110,
		 8'b01111110,
		 8'b10111101,
		 8'b11000011};
	parameter logic [7:0] L[7:0] =
	  '{8'b11111111,
		 8'b11111000,
		 8'b11111110,
		 8'b11111110,
		 8'b11111110,
		 8'b11111110,
		 8'b00000000,
		 8'b11111111};
	parameter logic [7:0] R[7:0] =
	  '{8'b11111111,
		 8'b11111110,
		 8'b10011101,
		 8'b01101011,
		 8'b01100111,
		 8'b01101111,
		 8'b00000000,
		 8'b11111111};
	parameter logic [7:0] O[7:0] =
	  '{8'b11000011,
		 8'b10111101,
		 8'b01111110,
		 8'b01111110,
		 8'b01111110,
		 8'b01111110,
		 8'b10111101,
		 8'b11000011};
	parameter logic [7:0] V[7:0] =
	  '{8'b11111111,
		 8'b00000011,
		 8'b11111101,
		 8'b11111110,
		 8'b11111110,
		 8'b11111101,
		 8'b00000011,
		 8'b11111111};
		 
	always@(posedge CLK)
		begin
			if(HardButton)
				difficult = CLK_Hard;
			else if(NormalButton)
				difficult = CLK_Normal;
			else if(EasyButton)
				difficult = CLK_Easy;
		end
	always @(posedge difficult) //操作
		begin 
			
			if(ResetButton)
			begin
				
				life = 4'b1111;
				score_one = 4'b0000;
				score_ten = 4'b0000;
				x_badjet = 3;
				y_badjet = 8;
				y_badjet = 9;
				BadNumRand = 0;
				IsTwoBad = 0;
				BadNum = 1;
				x_badrandom = 7;
				scorePoint = 0;
				BadBreak = 0;
				BadBreak2 = 0;
				isCrush = 0;
				isCrush2 = 0;
				lifeLeft = 0;
				minusLife = 0;
			end
			
			//左右方向鍵
			if(LButton && x_jet != 1)
				x_jet <= x_jet - 1;
			else if(RButton && x_jet != 6)
				x_jet <= x_jet + 1;
			
			//Laser Cool Down
			if(laserCD < 25)
			begin
				LaserBeam = 0;
				laserCD = laserCD + 1;
			end
			else if (LaserBeamButton == 0 && laserCD >= 3)
			begin
				laserCD = laserCD + 1;
			end
			else 
			begin
				laserCD = 0;
				if(LaserBeamButton)
					LaserBeam = 1;					
			end
			
			//random generate x bad jet
			x_badrandom = x_badrandom * (x_badrandom +1);
			BadNumRand = BadNumRand + 1;
			
			//Bad Jet fall
			if(badjetCD < 2)
			begin
				badjetCD = badjetCD + 1;
			end
			
			else
			begin
				badjetCD = 0;
				y_badjet = y_badjet - 1;
				if(y_badjet < 0)
				begin
					y_badjet = 8;
					x_badrandom = x_badrandom * (x_badrandom+1);
					IsTwoBad = BadNumRand % 2;
					x_badjet = (x_badrandom % 5) + 1;
					//隨機一次是否有兩個敵人
					if(IsTwoBad && (x_badjet == 1 || x_badjet == 2 || x_badjet == 5 || x_badjet == 6))
					begin
						BadNum = 2;
						x_badjet2 = (BadNumRand % 3) % 2 ;
						case (x_badjet)
							1 : x_badjet2 = x_badjet2 + 5;
							2 : x_badjet2 = 6;
							5 : x_badjet2 = 1;
							6 : x_badjet2 = x_badjet2 + 1;
						endcase
					end
					else
						BadNum = 1;
				end
				//扣血
				if((isCrush || isCrush2) && y_badjet == 0)
				begin
					life[lifeLeft] = 1'b0;
					lifeLeft = lifeLeft + 1;
				end
			end
			//攻擊1成功
			if((x_jet == x_badjet && LaserBeam) || (x_jet - 1 == x_badjet && LaserBeam) || (x_jet + 1 == x_badjet && LaserBeam))
			begin
				BadBreak = 1;
				scorePoint = 1;
				
			end
			else
			begin
				if(y_badjet == 8)
					BadBreak = 0;
					
			end
			//攻擊2成功
			if((x_jet == x_badjet2 && LaserBeam) || (x_jet - 1 == x_badjet2 && LaserBeam) || (x_jet + 1 == x_badjet2 && LaserBeam))
			begin
					BadBreak2 = 1;
					scorePoint = 1;
			end
			else 
			begin
				if(y_badjet == 8)
					BadBreak2 = 0;
			end
			
			
			
			//加分
			if(scorePoint == 1 || scorePoint == 1)
			begin
				if(score_one == 4'b1001)
				begin
						score_one = 4'b0000;
						score_ten = score_ten + 1'b1;
						scorePoint = 0;
				end
				else
					score_one = score_one + 1'b1;
					scorePoint = 0;
			end
			
			//判斷碰撞
			//情況一 頭對頭

			//bad jet1
			if((x_jet == x_badjet && y_badjet == 2)&& !BadBreak)
				isCrush = 1;
			//bad jet2
			if((x_jet == x_badjet2 && y_badjet == 2)&&!BadBreak2)
				isCrush2 = 1;
			//情況二 身對頭
			else if ((x_jet == x_badjet - 1 || x_jet == x_badjet + 1)&& y_badjet == 1 && !BadBreak )
				isCrush = 1;
			else if ((x_jet == x_badjet2 - 1 || x_jet == x_badjet2 + 1)&& y_badjet == 1 && !BadBreak2)
				isCrush2 = 1;
			//情況三 身對身
			else if ((x_jet == x_badjet - 2 || x_jet == x_badjet + 2) && y_badjet == 0 && !BadBreak)
				isCrush = 1;
			else if ((x_jet == x_badjet2 - 2 || x_jet == x_badjet2 + 2) && y_badjet == 0 && !BadBreak2)
				isCrush2 = 1;
			else if(y_badjet == 8)
			begin
				isCrush = 0;
				isCrush2 = 0;
			end
			
		end

		
		
	always @(posedge CLK_div1k) //畫面
		begin 
		
			if(ResetButton==1)
			begin
				x_count = 3'b000;
				DATA_R = 8'b11111111;
				DATA_G = 8'b11111111;
				DATA_B = 8'b11111111;
				COMM = 3'b000;
				enable = 1;
				score_enable = 0;
				alphaCount = 0;
				alphaCD = 0;
			end
			
			
			//畫面刷新
			if (x_count >= 7)
				x_count = 3'b000;
			else
				x_count = x_count + 1'b1;
			COMM = x_count;
			
			//通關畫面	
			if(score_one == 4'b0000 && score_ten == 4'b0001)
			begin
				DATA_B = 8'b11111111;
				DATA_R = 8'b11111111; 
				DATA_G = 8'b11111111; 
				if(alphaCD < 250)
					alphaCD = alphaCD + 1;
				else
				begin	
					alphaCD = 0;
					if(alphaCount==0)
						alpha = G;
					else if(alphaCount==1)
						alpha = A;
					else if(alphaCount==2)
						alpha = M;
					else if(alphaCount==3)
						alpha = E;
					else if(alphaCount==4)
						alpha = C;
					else if(alphaCount==5)
						alpha = L;
					else if(alphaCount==6)
						alpha = E;
					else if(alphaCount==7)
						alpha = A;
					else if(alphaCount==8)
						alpha = R;
					else 
						alphaCount = -1;
					alphaCount = alphaCount + 1;
				end
				DATA_G <= alpha[x_count];
				screenCOM = 2'b11;
			end
			
			// 失敗
			else if(life == 4'b0000)
			begin
				DATA_B = 8'b11111111;
				DATA_R = 8'b11111111; 
				DATA_G = 8'b11111111; 
				if(alphaCD < 250)
					alphaCD = alphaCD + 1;
				else
				begin	
					alphaCD = 0;
					if(alphaCount==0)
						alpha = G;
					else if(alphaCount==1)
						alpha = A;
					else if(alphaCount==2)
						alpha = M;
					else if(alphaCount==3)
						alpha = E;
					else if(alphaCount==4)
						alpha = O;
					else if(alphaCount==5)
						alpha = V;
					else if(alphaCount==6)
						alpha = E;
					else if(alphaCount==7)
						alpha = R;
					else
						alphaCount = -1;
					alphaCount = alphaCount + 1;
				end
				DATA_R <= alpha[x_count];
				screenCOM = 2'b11;
			end
			
			else
			begin //畫飛機
				if (x_count == x_jet || x_count == x_jet - 1 || x_count == x_jet +1)
				begin
					if(x_count == x_jet - 1 || x_count == x_jet + 1)	
					begin
						DATA_R[1:0] = 2'b10;
						DATA_B[1:0] = 2'b10;
					end
					else if(x_count == x_jet )
					begin			
						DATA_R[1:0] = 2'b00;
						DATA_B[1:0] = 2'b00;
					end
				end
				else
					begin
						DATA_R[1:0] = 2'b11;
						DATA_B[1:0] = 2'b11;
					end
				
				//draw LaserBeam
				if (LaserBeam && x_count == x_jet)
					begin
						DATA_R[7:2] = 6'b000000;
						DATA_G[7:2] = 6'b000000;
					end
				else 
				begin
					DATA_R[7:2] = 6'b111111;
					DATA_G[7:2] = 6'b111111;
				end
				
				//draw Bad Jet1
				if(BadNum == 1 || BadNum == 2)
				begin
					if(!((BadBreak) || (isCrush)))
					begin
						if (x_count == x_badjet || x_count == x_badjet - 1 || x_count == x_badjet + 1)
						begin
							if(x_count == x_badjet)
							begin
								DATA_R[y_badjet] = 1'b0;
								DATA_R[y_badjet-1] = 1'b0;
							end
							else if(x_count == x_badjet - 1 || x_count == x_badjet + 1)	
							begin
								DATA_R[y_badjet] = 1'b0;
								DATA_R[y_badjet-1] = 1'b1;
							end
							else
							begin
								DATA_R[y_badjet] = 1'b1;
								DATA_R[y_badjet-1] = 1'b1;
							end
						end
					end
				end
				//draw bad jet2
				if(BadNum == 2)
				begin
					if(!((BadBreak2) || (isCrush2)))
					begin
						if (x_count == x_badjet2 || x_count == x_badjet2 - 1 || x_count == x_badjet2 + 1)
						begin
							if(x_count == x_badjet2)
							begin
								DATA_R[y_badjet] = 1'b0;
								DATA_R[y_badjet-1] = 1'b0;
							end
							else if(x_count == x_badjet2 - 1 || x_count == x_badjet2 + 1)	
							begin
								DATA_R[y_badjet] = 1'b0;
								DATA_R[y_badjet-1] = 1'b1;
							end
							else
							begin
								DATA_R[y_badjet] = 1'b1;
								DATA_R[y_badjet-1] = 1'b1;
							end
						end
					end
				end
							
				//show score
				if(score_enable == 0)
					begin
						 score_enable = 1;
						 screenCOM = 2'b01;
					end
				else 
					begin
						 score_enable = 0;
						 screenCOM = 2'b10;
					end
				if(score_enable == 0)
				begin
					case(score_one)
						 4'b0000:sevenScreen[6:0]=7'b0000001;
						 4'b0001:sevenScreen[6:0]=7'b1001111;
						 4'b0010:sevenScreen[6:0]=7'b0010010;
						 4'b0011:sevenScreen[6:0]=7'b0000110;
						 4'b0100:sevenScreen[6:0]=7'b1001100;
						 4'b0101:sevenScreen[6:0]=7'b0100100;
						 4'b0110:sevenScreen[6:0]=7'b0100000;
						 4'b0111:sevenScreen[6:0]=7'b0001111;
						 4'b1000:sevenScreen[6:0]=7'b0000000;
						 4'b1001:sevenScreen[6:0]=7'b0000100;
					endcase
				end
				else
					begin
						case(score_ten)
						 4'b0000:sevenScreen[6:0]=7'b0000001;
						 4'b0001:sevenScreen[6:0]=7'b1001111;
						 4'b0010:sevenScreen[6:0]=7'b0010010;
						 4'b0011:sevenScreen[6:0]=7'b0000110;
						endcase
					end
			end
		end
		
		
		
always @ (posedge CLK) // 6MHz分頻
begin
    if(counter6MHz == 4)
    begin
        counter6MHz = 0;
        clk_6MHz = ~clk_6MHz;
    end
    else
    begin
        counter6MHz = counter6MHz+1;
    end
end

always @ (posedge CLK) // 4Hz分頻
begin
    if(counter4Hz == 6250000)
    begin
        counter4Hz = 0;
        clk_4Hz = ~clk_4Hz;
    end
    else
    begin
        counter4Hz = counter4Hz+1;
    end
end

always @ (posedge clk_6MHz)
begin
    if(count == 16383)
    begin
        count = origin;
        audiof = ~audiof;
    end
	 else if (j == 24)
	 begin
		audiof = 0;
		count = 0;
	 end

    else
        count = count+1;

end


 always @ (posedge clk_4Hz)
 begin
      case(j)
     'd1:origin='d4916;  //low
     'd2:origin='d6168;
     'd3:origin='d7281;  //7
     'd4:origin='d7791;
     'd5:origin='d8730; //2
     'd6:origin='d9565;
     'd7:origin='d10310;
     'd8:origin='d010647;  //middle
     'd9:origin='d011272;
     'd10:origin='d011831;
     'd11:origin='d012087;
     'd12:origin='d012556;
     'd13:origin='d012974;
     'd14:origin='d013346;
     'd15:origin='d13516;  //high
     'd16:origin='d13829;
     'd17:origin='d14108;
     'd18:origin='d11535;
     'd19:origin='d14470;
     'd20:origin='d14678;
     'd21:origin='d14864;
	  'd22:origin='d20000;
	  'd23:origin='d13100;
	  'd24:;
     default:origin='d011111;

     endcase             
 end
 
 always @(posedge clk_4Hz)  //樂譜
 begin
      if(len==43)
         len=0;
     else
         len=len+1;
     case(len)
     0:j=7;
	  1:j=7;
     2:j=24;
     3:j=7;
	  4:j=7;
     5:j=24;
     6:j=7;
	  7:j=4;
     8:j=24;     
	  9:j=9;
     10:j=7;
	  11:j=7;
	  12:j=4;
     13:j=24;
     14:j=9;	  
	  15:j=7;
     16:j=7;
	  17:j=11;
	  18:j=24;
	  19:j=24;
	  20:j=11;
	  21:j=24;
	  22:j=11;
	  23:j=11;
	  24:j=24;
	  25:j=11;
	  26:j=12;
	  27:j=24;
	  28:j=9;
	  29:j=7;
	  30:j=7;
	  31:j=4;
	  32:j=24;
	  33:j=9;
     34:j=7;
	  35:j=7;
	  36:j=24;
     37:j=24;
     38:j=24;
	  39:j=24;
endcase
                
end
endmodule




module divfreq1kHz(input CLK, output reg CLK_div1k); //除頻器 1kHz
	reg [15:0] Count;
	always @(posedge CLK)
		begin
			if(Count > 50000)
				begin
					Count <= 16'b0;
					CLK_div1k <= ~CLK_div1k;
				end
			else
				Count <= Count + 1'b1;
		end
endmodule

module Normal(input CLK, output reg CLK_div20); //除頻器 10Hz
	reg [25:0] Count;
	always @(posedge CLK)
		begin
			if(Count > 2500000)
				begin
					Count <= 26'b0;
					CLK_div20 <= ~CLK_div20;
				end
			else
				Count <= Count + 1'b1;
		end
endmodule
module Easy(input CLK, output reg CLK_div20); //除頻器 10Hz
	reg [25:0] Count;
	always @(posedge CLK)
		begin
			if(Count > 5000000)
				begin
					Count <= 26'b0;
					CLK_div20 <= ~CLK_div20;
				end
			else
				Count <= Count + 1'b1;
		end
endmodule
module Hard(input CLK, output reg CLK_div20); //除頻器 20Hz
	reg [25:0] Count;
	always @(posedge CLK)
		begin
			if(Count > 1250000)
				begin
					Count <= 26'b0;
					CLK_div20 <= ~CLK_div20;
				end
			else
				Count <= Count + 1'b1;
		end
endmodule


 
