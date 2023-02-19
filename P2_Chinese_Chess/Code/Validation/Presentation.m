classdef Presentation < matlab.uitest.TestCase

    properties
        timekeeper
        board
    end

    methods(TestClassSetup)
        function Init(~)
            close all force;
            clear;
            clc;
            addpath("imgs/");
            addpath("Model/");
            addpath("ViewModel/");
            addpath("View/")
            addpath("recordings/");
        end
    end

    methods(TestMethodSetup)
        function createFigure(testcase)
            close all force;
            testcase.timekeeper=ChessTimer;
            testcase.board=ChessBoard(testcase.timekeeper);
        end
    end

    methods(TestMethodTeardown)
        function closeFigure(testcase)
            if ~isempty(timerfind)
                stop(timerfind);
                delete(timerfind);
            end
            close all force;
            clear;
            clc;
        end
    end

    methods(Test)
        function case1(testcase)

            %HumanHuman Mode(1)
            pause(15);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

            %Normal Move
            %red move pao 8-8->5-8
            pause(10);
            testcase.press(testcase.board.Red.Game.pos_8_8);
            pause(2);
            testcase.press(testcase.board.Red.Game.pos_5_8);
            testcase.verifyEqual(testcase.board.Content(8,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,8),int16(13));
            %black move ma 8-10->7-8
            pause(2);
            testcase.press(testcase.board.Black.Game.pos_8_10);
            pause(2);
            testcase.press(testcase.board.Black.Game.pos_7_8);
            testcase.verifyEqual(testcase.board.Content(2,1),int16(0));
            testcase.verifyEqual(testcase.board.Content(3,3),int16(4));
           
            %Regret
            %black regret cancel
            pause(2);
            testcase.press(testcase.board.Black.Game.RegretRequest);
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmMessage.Text),"您确定要悔棋吗");  
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmConfirm.Text),"确定"); 
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmCancel.Text),"取消"); 
            pause(2);
            testcase.press(testcase.board.Black.Game.ConfirmCancel);

            %Normal Move
            %red move bing 5-7->5-6 
            pause(2);
            testcase.press(testcase.board.Red.Game.pos_5_7);
            pause(2);
            testcase.press(testcase.board.Red.Game.pos_5_6);
            testcase.verifyEqual(testcase.board.Content(5,7),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,6),int16(14));

            %Regret
            %red regret confirm
            %reject by black
            pause(2);
            testcase.press(testcase.board.Red.Game.RegretRequest);
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"您确定要悔棋吗");  
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmConfirm.Text),"确定"); 
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmCancel.Text),"取消"); 
            pause(2);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmMessage.Text),"对方提出了悔棋");  
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmConfirm.Text),"同意"); 
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmCancel.Text),"拒绝"); 
            pause(2);
            testcase.press(testcase.board.Black.Game.ConfirmCancel);
            pause(2);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);

            %Normal Move
            %Black move pao 2-8->5-8
            pause(2);
            testcase.press(testcase.board.Black.Game.pos_2_8);
            pause(2);
            testcase.press(testcase.board.Black.Game.pos_5_8);
            testcase.verifyEqual(testcase.board.Content(8,3),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,3),int16(6));

            %Regret
            %black regret confirm
            %accept by red
            pause(2);
            testcase.press(testcase.board.Black.Game.RegretRequest);
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmMessage.Text),"您确定要悔棋吗");  
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmConfirm.Text),"确定"); 
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmCancel.Text),"取消"); 
            pause(2);
            testcase.press(testcase.board.Black.Game.ConfirmConfirm);
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"对方提出了悔棋");  
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmConfirm.Text),"同意"); 
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmCancel.Text),"拒绝");
            pause(2);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            pause(2);
            testcase.press(testcase.board.Black.Game.ConfirmConfirm);

            %Draw
            %red draw cancel
            pause(2);
            testcase.press(testcase.board.Red.Game.DrawRequest);
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"您确定要求和吗");  
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmConfirm.Text),"确定"); 
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmCancel.Text),"取消"); 
            pause(2);
            testcase.press(testcase.board.Red.Game.ConfirmCancel);

            %Normal Move
            %black move bing 3-7->3-6
            pause(2);
            testcase.press(testcase.board.Black.Game.pos_3_7);
            pause(2);
            testcase.press(testcase.board.Black.Game.pos_3_6);
            testcase.verifyEqual(testcase.board.Content(7,4),int16(0));
            testcase.verifyEqual(testcase.board.Content(7,5),int16(7));

            %Draw
            %black draw confirm
            %reject by red
            pause(2);
            testcase.press(testcase.board.Black.Game.DrawRequest);
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmMessage.Text),"您确定要求和吗");  
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmConfirm.Text),"确定"); 
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmCancel.Text),"取消"); 
            pause(2);
            testcase.press(testcase.board.Black.Game.ConfirmConfirm);
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"对方提出了求和");  
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmConfirm.Text),"同意"); 
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmCancel.Text),"拒绝"); 
            pause(2);
            testcase.press(testcase.board.Red.Game.ConfirmCancel);
            pause(2);
            testcase.press(testcase.board.Black.Game.ConfirmConfirm);

            %Normal Move
            %red move ma 2-10->3-8 
            pause(2);
            testcase.press(testcase.board.Red.Game.pos_2_10);
            pause(2);
            testcase.press(testcase.board.Red.Game.pos_3_8);
            testcase.verifyEqual(testcase.board.Content(2,10),int16(0));
            testcase.verifyEqual(testcase.board.Content(3,8),int16(11));

            %Draw
            %red draw confirm
            %reject by black
            pause(2);
            testcase.press(testcase.board.Red.Game.DrawRequest);
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"您确定要求和吗");  
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmConfirm.Text),"确定"); 
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmCancel.Text),"取消"); 
            pause(2);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmMessage.Text),"对方提出了求和");  
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmConfirm.Text),"同意"); 
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmCancel.Text),"拒绝"); 
            pause(2);
            testcase.press(testcase.board.Black.Game.ConfirmConfirm);
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmMessage.Text),"平局");
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"平局");
            pause(2);
            testcase.press(testcase.board.Black.Game.ConfirmConfirm);
            pause(2);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            pause(2);


            %HumanHuman Mode(2)
            pause(2);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

            %Normal Move
            %red move pao 8-8->5-8 
            pause(5);
            testcase.press(testcase.board.Red.Game.pos_8_8);
            pause(2);
            testcase.press(testcase.board.Red.Game.pos_5_8);
            testcase.verifyEqual(testcase.board.Content(8,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,8),int16(13));

            %Normal Move
            %black move bing 3-7->3-6
            pause(2);
            testcase.press(testcase.board.Black.Game.pos_3_7);
            pause(2);
            testcase.press(testcase.board.Black.Game.pos_3_6);
            testcase.verifyEqual(testcase.board.Content(7,4),int16(0));
            testcase.verifyEqual(testcase.board.Content(7,5),int16(7));

            %black surrendar canceled
            pause(2);
            testcase.press(testcase.board.Black.Game.DefeatRequest);
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmMessage.Text),"您确定要认输吗");  
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmConfirm.Text),"确定"); 
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmCancel.Text),"取消"); 
            pause(2);
            testcase.press(testcase.board.Black.Game.ConfirmCancel);
            
            %red surrender success
            pause(2);
            testcase.press(testcase.board.Red.Game.DefeatRequest);
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"您确定要认输吗");  
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmConfirm.Text),"确定"); 
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmCancel.Text),"取消"); 
            pause(2);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"您已认输");
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmMessage.Text),"对方已认输");
            pause(2);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            pause(2);
            testcase.press(testcase.board.Black.Game.ConfirmConfirm);
            pause(2);


            %HumanHuman Mode(3)
            pause(2);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

            %Normal Move
            %red move pao 8-8->5-8 
            pause(5);
            testcase.press(testcase.board.Red.Game.pos_8_8);
            pause(2);
            testcase.press(testcase.board.Red.Game.pos_5_8);
            testcase.verifyEqual(testcase.board.Content(8,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,8),int16(13));

            %Normal Move
            %black move bing 3-7->3-6
            pause(2);
            testcase.press(testcase.board.Black.Game.pos_3_7);
            pause(2);
            testcase.press(testcase.board.Black.Game.pos_3_6);
            testcase.verifyEqual(testcase.board.Content(7,4),int16(0));
            testcase.verifyEqual(testcase.board.Content(7,5),int16(7));

            %Normal Move
            %red move pao 5-8->5-4 
            pause(2);
            testcase.press(testcase.board.Red.Game.pos_5_8);
            pause(2);
            testcase.press(testcase.board.Red.Game.pos_5_4);
            testcase.verifyEqual(testcase.board.Content(5,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,4),int16(13));

            %Normal Move
            %black move shi 6-10->5-9
            pause(2);
            testcase.press(testcase.board.Black.Game.pos_6_10);
            pause(2);
            testcase.press(testcase.board.Black.Game.pos_5_9);
            testcase.verifyEqual(testcase.board.Content(4,1),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,2),int16(2));

            %Normal Move
            %red move pao 5-4->5-1 
            pause(2);
            testcase.press(testcase.board.Red.Game.pos_5_4);
            pause(2);
            testcase.press(testcase.board.Red.Game.pos_5_1);
            testcase.verifyEqual(testcase.board.Content(5,4),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,1),int16(13));
            
            %Red victory
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"胜利"); 
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmMessage.Text),"失败"); 
            pause(2);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            pause(2);
            testcase.press(testcase.board.Black.Game.ConfirmConfirm);
            pause(2);
            

            % LogPlayer(1)
            pause(2);
            testcase.press(testcase.board.Start.StartPageUI.PlayRecButton);
            % faster
            pause(15);
            testcase.press(testcase.board.log.player.fastforward);
            pause(10);
            %exit
            testcase.press(testcase.board.log.player.exit);
            pause(2);
        end
    end
end
