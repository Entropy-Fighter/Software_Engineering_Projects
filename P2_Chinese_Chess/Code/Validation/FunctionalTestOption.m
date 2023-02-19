% This file mainly test if the three option,surrender,draw,regret can
% behave correctly.

% For simplicity, some testcase will only  cover one color(black or red)of the chess. The
% correctness is guaranteed since the black chess and red chess use the same code and behave
% exactly the same.

% the testcase is numbered according to calssification
% case 10x      surrender（投降）
% case 20x      draw（求和）
% case 30x      regret （悔棋）

% if there is any error or warning,please run
%             addpath("imgs/");
%             addpath("Model/");
%             addpath("ViewModel/");
%             addpath("View/")
%             addpath("recordings/");
% in "命令行窗口" first,and then run the code

classdef FunctionalTestOption <matlab.uitest.TestCase
    properties
        timekeeper  ChessTimer
        board       ChessBoard
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
        function case101(testcase)%取消投降+直接投降（在自己回合,不进行其他移动）
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

            %red surrendar canceled
            pause(0.5);
            testcase.press(testcase.board.Red.Game.DefeatRequest);
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"您确定要认输吗");  
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmConfirm.Text),"确定"); 
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmCancel.Text),"取消"); 
            pause(0.5);
            testcase.press(testcase.board.Red.Game.ConfirmCancel);
            
            %red surrender success
            pause(0.5);
            testcase.press(testcase.board.Red.Game.DefeatRequest);
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"您确定要认输吗");  
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmConfirm.Text),"确定"); 
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmCancel.Text),"取消"); 
            pause(0.5);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"您已认输");
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmMessage.Text),"对方已认输");
            pause(0.5);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.ConfirmConfirm);
            pause(0.5);
        end

        function case102(testcase)%在自己回合投降（已经进行过行棋）
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

            %Normal Move
            %red move pao 8-8->5-8 
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_8);
            testcase.verifyEqual(testcase.board.Content(8,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,8),int16(13));

            %Normal Move
            %black move bing 3-7->3-6
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_3_7);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_3_6);
            testcase.verifyEqual(testcase.board.Content(7,4),int16(0));
            testcase.verifyEqual(testcase.board.Content(7,5),int16(7));

            %red surrender success
            pause(0.5);
            testcase.press(testcase.board.Red.Game.DefeatRequest);
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"您确定要认输吗");  
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmConfirm.Text),"确定"); 
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmCancel.Text),"取消"); 
            pause(0.5);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"您已认输");
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmMessage.Text),"对方已认输");
            pause(0.5);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.ConfirmConfirm);
            pause(0.5);
        end

        function case103(testcase) %取消投降+直接投降（在对方回合,不进行其他移动）
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

            %red surrendar canceled
            pause(0.5);
            testcase.press(testcase.board.Black.Game.DefeatRequest);
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmMessage.Text),"您确定要认输吗");  
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmConfirm.Text),"确定"); 
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmCancel.Text),"取消"); 
            pause(0.5);
            testcase.press(testcase.board.Black.Game.ConfirmCancel);
            
            %red surrender success
            pause(0.5);
            testcase.press(testcase.board.Black.Game.DefeatRequest);
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmMessage.Text),"您确定要认输吗");  
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmConfirm.Text),"确定"); 
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmCancel.Text),"取消"); 
            pause(0.5);
            testcase.press(testcase.board.Black.Game.ConfirmConfirm);
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmMessage.Text),"您已认输");
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"对方已认输");
            pause(0.5);
            testcase.press(testcase.board.Black.Game.ConfirmConfirm);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            pause(0.5);
        end

        function case104(testcase)%在对方回合投降（已经进行过行棋）
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

            %Normal Move
            %red move pao 8-8->5-8 
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_8);
            testcase.verifyEqual(testcase.board.Content(8,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,8),int16(13));

            %red surrender success
            pause(0.5);
            testcase.press(testcase.board.Red.Game.DefeatRequest);
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"您确定要认输吗");  
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmConfirm.Text),"确定"); 
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmCancel.Text),"取消"); 
            pause(0.5);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"您已认输");
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmMessage.Text),"对方已认输");
            pause(0.5);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.ConfirmConfirm);
            pause(0.5);
        end

        function case201(testcase)%(在自己回合）取消求和+确认求和，求和被拒绝+确认求和，求和成功
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);
            
            %Normal Move
            %red move pao 8-8->5-8 
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_8);
            testcase.verifyEqual(testcase.board.Content(8,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,8),int16(13));

            %Normal Move
            %black move bing 3-7->3-6
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_3_7);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_3_6);
            testcase.verifyEqual(testcase.board.Content(7,4),int16(0));
            testcase.verifyEqual(testcase.board.Content(7,5),int16(7));
            %Draw
            %red draw cancel
            pause(0.5);
            testcase.press(testcase.board.Red.Game.DrawRequest);
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"您确定要求和吗");  
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmConfirm.Text),"确定"); 
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmCancel.Text),"取消"); 
            pause(0.5);
            testcase.press(testcase.board.Red.Game.ConfirmCancel);

            %Draw
            %black draw confirm
            %reject by red
            pause(0.5);
            testcase.press(testcase.board.Red.Game.DrawRequest);
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"您确定要求和吗");  
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmConfirm.Text),"确定"); 
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmCancel.Text),"取消"); 
            pause(0.5);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmMessage.Text),"对方提出了求和");  
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmConfirm.Text),"同意"); 
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmCancel.Text),"拒绝"); 
            pause(0.5);
            testcase.press(testcase.board.Black.Game.ConfirmCancel);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);

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
        end

        function case202(testcase) %(在对方回合）取消求和+确认求和，求和被拒绝+确认求和，求和成功
             pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);
            
            %Normal Move
            %red move pao 8-8->5-8 
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_8);
            testcase.verifyEqual(testcase.board.Content(8,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,8),int16(13));

            %Draw
            %red draw cancel
            pause(0.5);
            testcase.press(testcase.board.Red.Game.DrawRequest);
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"您确定要求和吗");  
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmConfirm.Text),"确定"); 
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmCancel.Text),"取消"); 
            pause(0.5);
            testcase.press(testcase.board.Red.Game.ConfirmCancel);

            %Draw
            %black draw confirm
            %reject by red
            pause(0.5);
            testcase.press(testcase.board.Red.Game.DrawRequest);
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"您确定要求和吗");  
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmConfirm.Text),"确定"); 
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmCancel.Text),"取消"); 
            pause(0.5);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmMessage.Text),"对方提出了求和");  
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmConfirm.Text),"同意"); 
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmCancel.Text),"拒绝"); 
            pause(0.5);
            testcase.press(testcase.board.Black.Game.ConfirmCancel);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);

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
        end

        function case301(testcase) %（在自己回合）取消悔棋+确认悔棋，对方拒绝+确认悔棋，对方同意

            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

            %Normal Move
            %red move pao 8-8->5-8
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_8);
            pause(2);
            testcase.press(testcase.board.Red.Game.pos_5_8);
            testcase.verifyEqual(testcase.board.Content(8,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,8),int16(13));
           
            %Regret
            %red regret cancel
            pause(2);
            testcase.press(testcase.board.Red.Game.RegretRequest);
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"您确定要悔棋吗");  
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmConfirm.Text),"确定"); 
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmCancel.Text),"取消"); 
            pause(2);
            testcase.press(testcase.board.Red.Game.ConfirmCancel);

            %black move ma 8-10->7-8
            pause(2);
            testcase.press(testcase.board.Black.Game.pos_8_10);
            pause(2);
            testcase.press(testcase.board.Black.Game.pos_7_8);
            testcase.verifyEqual(testcase.board.Content(2,1),int16(0));
            testcase.verifyEqual(testcase.board.Content(3,3),int16(4));

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

             %Normal Move
            %red move bing 1-7->1-6 
            pause(2);
            testcase.press(testcase.board.Red.Game.pos_1_7);
            pause(2);
            testcase.press(testcase.board.Red.Game.pos_1_6);
            testcase.verifyEqual(testcase.board.Content(1,7),int16(0));
            testcase.verifyEqual(testcase.board.Content(1,6),int16(14));

            %Regret
            %red regret confirm
            %accept by red
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
            testcase.press(testcase.board.Black.Game.ConfirmConfirm);
            pause(2);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);

            %red surrender success
            pause(0.5);
            testcase.press(testcase.board.Red.Game.DefeatRequest);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.ConfirmConfirm);
            pause(0.5);
        end

        function case302(testcase) %（在对方回合）悔棋按钮不可用
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

            %Normal Move
            %red move pao 8-8->5-8
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_8);
            pause(2);
            testcase.press(testcase.board.Red.Game.pos_5_8);
            testcase.verifyEqual(testcase.board.Content(8,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,8),int16(13));

            %Regret
            %black cannot regret,there will be no message box
            pause(2);
            testcase.press(testcase.board.Black.Game.RegretRequest); 
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmMessage.Visible),"off");
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmConfirm.Visible),"off");
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmCancel.Visible),"off");

            %red surrender success
            pause(0.5);
            testcase.press(testcase.board.Red.Game.DefeatRequest);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.ConfirmConfirm);
            pause(0.5);
        end

    end
end
