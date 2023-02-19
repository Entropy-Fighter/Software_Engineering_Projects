% This file is the file used for Integration test
% It test 5 whole complete game,each complete game is a combination of unit
% test and functional test.
% The 5 cases numbered from 1 to 5.Case 1 and 
% case 2 test normally ended game,which means one player
% eated the other player's "将" and wined.
% Case 3 and case 4 is ended because of one player "认输",so the other player
% automatically win.
% Case 5 is ended with a draw,because one player has agreed the other
% player's draw request.

% if there is any error or warning,please run
%             addpath("imgs/");
%             addpath("Model/");
%             addpath("ViewModel/");
%             addpath("View/")
%             addpath("recordings/");
% in "命令行窗口" first,and then run the code
classdef IntegrationTest < matlab.uitest.TestCase

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
            
 
        end
%           TestResult - 属性:
% 
%           Name: 'IntegrationTest/case1'
%         Passed: 1
%         Failed: 0
%     Incomplete: 0
%       Duration: 37.1580
%        Details: [1×1 struct]
% 
% 总计:
%    1 Passed, 0 Failed, 0 Incomplete.
%    37.158 秒测试时间。

        function case2(testcase)
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

            %Invalid move,left
            %red move bing 5-7->4-7
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_7);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_4_7);
            testcase.verifyEqual(testcase.board.Content(5,7),int16(14));
            testcase.verifyEqual(testcase.board.Content(4,7),int16(0));
            %Invalid move,right
            %red move bing 5-7->6-7
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_7);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_6_7);
            testcase.verifyEqual(testcase.board.Content(5,7),int16(14));
            testcase.verifyEqual(testcase.board.Content(6,7),int16(0));
            %Invalid move,back
            %red move bing 5-7->5-8
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_7);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_8);
            testcase.verifyEqual(testcase.board.Content(5,7),int16(14));
            testcase.verifyEqual(testcase.board.Content(5,8),int16(0));
            %Valid move,forward
            %red move bing 5-7->5-6
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_7);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_6);
            testcase.verifyEqual(testcase.board.Content(5,7),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,6),int16(14));
            
            %Invalid move,left
            %black move bing 5-7->4-7
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_7);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_4_7);
            testcase.verifyEqual(testcase.board.Content(5,4),int16(7));
            testcase.verifyEqual(testcase.board.Content(6,4),int16(0));
            %Invalid move,right
            %black move bing 5-7->6-7
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_7);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_6_7);
            testcase.verifyEqual(testcase.board.Content(5,4),int16(7));
            testcase.verifyEqual(testcase.board.Content(4,4),int16(0));

            %Invalid move,back
            %black move bing 5-7->5-8
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_7);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_8);
            testcase.verifyEqual(testcase.board.Content(5,4),int16(7));
            testcase.verifyEqual(testcase.board.Content(5,3),int16(0));


            %Valid move,forward
            %black move bing 5-7->5-6
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_7);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_6);
            testcase.verifyEqual(testcase.board.Content(5,4),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,5),int16(7));
            %Valid move
            %red move pao 8-8->8-1
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_1);
            testcase.verifyEqual(testcase.board.Content(8,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(8,1),int16(13));

            %Valid move
            %black move pao 8-8->8-1
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_8_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_8_1);
            testcase.verifyEqual(testcase.board.Content(2,3),int16(0));
            testcase.verifyEqual(testcase.board.Content(2,10),int16(6));

            %Valid move
            %red move pao 8-1->6-1
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_1);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_6_1);
            testcase.verifyEqual(testcase.board.Content(8,1),int16(0));
            testcase.verifyEqual(testcase.board.Content(6,1),int16(13));

            %Valid move
            %black move pao 8-1->6-1
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_8_1);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_6_1);
            testcase.verifyEqual(testcase.board.Content(2,10),int16(0));
            testcase.verifyEqual(testcase.board.Content(4,10),int16(6));

            %Valid move
            %red move pao 6-1->9-1
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_6_1);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_9_1);
            testcase.verifyEqual(testcase.board.Content(6,1),int16(0));
            testcase.verifyEqual(testcase.board.Content(9,1),int16(13));

            %Valid move
            %black move pao 6-1->9-1
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_6_1);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_9_1);
            testcase.verifyEqual(testcase.board.Content(4,10),int16(0));
            testcase.verifyEqual(testcase.board.Content(1,10),int16(6));

            %Valid move
            %red move pao 9-1->5-1
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_9_1);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_1);
            testcase.verifyEqual(testcase.board.Content(9,1),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,1),int16(13));

            %Red victory
            testcase.verifyEqual(string(testcase.board.Red.Game.ConfirmMessage.Text),"胜利"); 
            testcase.verifyEqual(string(testcase.board.Black.Game.ConfirmMessage.Text),"失败"); 
            pause(2);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            pause(2);
            testcase.press(testcase.board.Black.Game.ConfirmConfirm);
            pause(2);

        end
%           TestResult - 属性:
% 
%           Name: 'IntegrationTest/case2'
%         Passed: 1
%         Failed: 0
%     Incomplete: 0
%       Duration: 35.4913
%        Details: [1×1 struct]
% 
% 总计:
%    1 Passed, 0 Failed, 0 Incomplete.
%    35.4913 秒测试时间。

        function case3(testcase)
            %HumanHuman Mode
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

            %Valid move,forward
            %red move bing 3-7->3-6
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_3_7);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_3_6);
            testcase.verifyEqual(testcase.board.Content(3,7),int16(0));
            testcase.verifyEqual(testcase.board.Content(3,6),int16(14));

            %Valid move,forward
            %black move bing 3-7->3-6
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_3_7);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_3_6);
            testcase.verifyEqual(testcase.board.Content(7,4),int16(0));
            testcase.verifyEqual(testcase.board.Content(7,5),int16(7));

            %Valid move,forward
            %red move bing 5-7->5-6
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_7);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_6);
            testcase.verifyEqual(testcase.board.Content(5,7),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,6),int16(14));

            %Valid move,forward
            %black move bing 5-7->5-6
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_7);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_6);
            testcase.verifyEqual(testcase.board.Content(5,4),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,5),int16(7));

            %Valid move,forward
            %red move bing 7-7->7-6
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_7);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_6);
            testcase.verifyEqual(testcase.board.Content(7,7),int16(0));
            testcase.verifyEqual(testcase.board.Content(7,6),int16(14));

            %Valid move,forward
            %black move bing 7-7->7-6
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_7);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_6);
            testcase.verifyEqual(testcase.board.Content(3,4),int16(0));
            testcase.verifyEqual(testcase.board.Content(3,5),int16(7));

            %InValid move
            %red move shi 4-10->3-9
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_4_10);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_3_9);
            testcase.verifyEqual(testcase.board.Content(4,10),int16(9));
            testcase.verifyEqual(testcase.board.Content(3,9),int16(0));

            %InValid move
            %black move shi 4-10->3-9
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_4_10);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_3_9);
            testcase.verifyEqual(testcase.board.Content(6,1),int16(2));
            testcase.verifyEqual(testcase.board.Content(7,2),int16(0));

            %Valid move
            %red move shi 4-10->5-9
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_4_10);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_9);
            testcase.verifyEqual(testcase.board.Content(4,10),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,9),int16(9));

            %Valid move
            %black move shi 4-10->5-9
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_4_10);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_9);
            testcase.verifyEqual(testcase.board.Content(6,1),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,2),int16(2));

            %Valid move
            %red move shi 5-9->4-8
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_9);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_4_8);
            testcase.verifyEqual(testcase.board.Content(5,9),int16(0));
            testcase.verifyEqual(testcase.board.Content(4,8),int16(9));

            %Valid move
            %black move shi 5-9->4-8
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_9);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_4_8);
            testcase.verifyEqual(testcase.board.Content(5,2),int16(0));
            testcase.verifyEqual(testcase.board.Content(6,3),int16(2));

            %Valid move
            %red move shi 4-8->3-7
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_4_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_3_7);
            testcase.verifyEqual(testcase.board.Content(4,8),int16(9));
            testcase.verifyEqual(testcase.board.Content(3,7),int16(0));

            %Valid move
            %black move shi 4-8->3-7
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_4_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_3_7);
            testcase.verifyEqual(testcase.board.Content(6,3),int16(2));
            testcase.verifyEqual(testcase.board.Content(7,4),int16(0));

            %Valid move
            %red move shi 4-8->5-7
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_4_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_7);
            testcase.verifyEqual(testcase.board.Content(4,8),int16(9));
            testcase.verifyEqual(testcase.board.Content(5,7),int16(0));

            %Valid move
            %black move shi 4-8->5-7
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_4_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_7);
            testcase.verifyEqual(testcase.board.Content(6,3),int16(2));
            testcase.verifyEqual(testcase.board.Content(5,4),int16(0));

            %Valid move
            %red move shi 4-8->5-9
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_4_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_9);
            testcase.verifyEqual(testcase.board.Content(4,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,9),int16(9));

            %Valid move
            %black move shi 4-8->5-9
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_4_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_9);
            testcase.verifyEqual(testcase.board.Content(6,3),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,2),int16(2));

            %Valid move
            %red move shi 5-9->6-8
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_9);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_6_8);
            testcase.verifyEqual(testcase.board.Content(5,9),int16(0));
            testcase.verifyEqual(testcase.board.Content(6,8),int16(9));

            %Valid move
            %black move shi 5-9->6-8
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_9);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_6_8);
            testcase.verifyEqual(testcase.board.Content(5,2),int16(0));
            testcase.verifyEqual(testcase.board.Content(4,3),int16(2));

            %InValid move
            %red move shi 6-8->7-7
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_6_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_7);
            testcase.verifyEqual(testcase.board.Content(6,8),int16(9));
            testcase.verifyEqual(testcase.board.Content(7,7),int16(0));

            %InValid move
            %black move shi 6-8->7-7
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_6_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_7);
            testcase.verifyEqual(testcase.board.Content(4,3),int16(2));
            testcase.verifyEqual(testcase.board.Content(3,4),int16(0));
            
            
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
%         ans = 
% 
%   TestResult - 属性:
% 
%           Name: 'IntegrationTest/case3'
%         Passed: 1
%         Failed: 0
%     Incomplete: 0
%       Duration: 46.0298
%        Details: [1×1 struct]
% 
% 总计:
%    1 Passed, 0 Failed, 0 Incomplete.
%    46.0298 秒测试时间。

        function case4(testcase)
            %HumanHuman Mode
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

            %Valid move
            %red move ma 8-10->7-8
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_10);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_8);
            testcase.verifyEqual(testcase.board.Content(8,10),int16(0));
            testcase.verifyEqual(testcase.board.Content(7,8),int16(11));

            %Valid move
            %black move ma 8-10->7-8
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_8_10);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_8);
            testcase.verifyEqual(testcase.board.Content(2,1),int16(0));
            testcase.verifyEqual(testcase.board.Content(3,3),int16(4));

            %Valid move
            %red move ma 7-8->5-9
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_9);
            testcase.verifyEqual(testcase.board.Content(7,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,9),int16(11));

            %Valid move
            %black move ma 7-8->5-9
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_9);
            testcase.verifyEqual(testcase.board.Content(3,3),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,2),int16(4));

            %Valid move
            %red move ma 5-9->4-7
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_9);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_4_7);
            testcase.verifyEqual(testcase.board.Content(5,9),int16(0));
            testcase.verifyEqual(testcase.board.Content(4,7),int16(11));

            %Valid move
            %black move ma 5-9->4-7
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_9);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_4_7);
            testcase.verifyEqual(testcase.board.Content(5,2),int16(0));
            testcase.verifyEqual(testcase.board.Content(6,4),int16(4));

            %Valid move,forward
            %red move jiang 5-10->5-9
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_10);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_9);
            testcase.verifyEqual(testcase.board.Content(5,10),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,9),int16(8));

            %Valid move,forward
            %black move jiang 5-10->5-9
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_10);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_9);
            testcase.verifyEqual(testcase.board.Content(5,1),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,2),int16(1));

            %Valid move,left
            %red move jiang 5-9->4-9
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_9);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_4_9);
            testcase.verifyEqual(testcase.board.Content(5,9),int16(0));
            testcase.verifyEqual(testcase.board.Content(4,9),int16(8));

            %Valid move,left
            %black move jiang 5-9->4-9
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_9);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_4_9);
            testcase.verifyEqual(testcase.board.Content(5,2),int16(0));
            testcase.verifyEqual(testcase.board.Content(6,2),int16(1));

            %Valid move,forward
            %red move jiang 4-9->4-8
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_4_9);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_4_8);
            testcase.verifyEqual(testcase.board.Content(4,9),int16(0));
            testcase.verifyEqual(testcase.board.Content(4,8),int16(8));

            %Valid move,forawrd
            %black move jiang 4-9->4-8
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_4_9);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_4_8);
            testcase.verifyEqual(testcase.board.Content(6,2),int16(0));
            testcase.verifyEqual(testcase.board.Content(6,3),int16(1));

            %Valid move,right
            %red move jiang 4-8->5-8
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_4_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_8);
            testcase.verifyEqual(testcase.board.Content(4,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,8),int16(8));

            %Valid move,right
            %black move jiang 4-8->5-8
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_4_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_8);
            testcase.verifyEqual(testcase.board.Content(6,3),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,3),int16(1));

            %Valid move,right
            %red move jiang 5-8->6-8
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_6_8);
            testcase.verifyEqual(testcase.board.Content(5,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(6,8),int16(8));

            %Valid move,right
            %black move jiang 5-8->6-8
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_6_8);
            testcase.verifyEqual(testcase.board.Content(5,3),int16(0));
            testcase.verifyEqual(testcase.board.Content(4,3),int16(1));

            %Valid move,right
            %red move jiang 6-8->6-9
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_6_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_6_9);
            testcase.verifyEqual(testcase.board.Content(6,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(6,9),int16(8));

            %Valid move,right
            %black move jiang 6-8->6-9
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_6_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_6_9);
            testcase.verifyEqual(testcase.board.Content(4,3),int16(0));
            testcase.verifyEqual(testcase.board.Content(4,2),int16(1));

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
%           TestResult - 属性:
% 
%           Name: 'IntegrationTest/case4'
%         Passed: 1
%         Failed: 0
%     Incomplete: 0
%       Duration: 44.6754
%        Details: [1×1 struct]
% 
% 总计:
%    1 Passed, 0 Failed, 0 Incomplete.
%    44.6754 秒测试时间。

        function case5(testcase)
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

            %Valid move
            %red move xiang 7-10->9->8
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_10);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_9_8);
            testcase.verifyEqual(testcase.board.Content(7,10),int16(0));
            testcase.verifyEqual(testcase.board.Content(9,8),int16(10));

            %Valid move
            %black move xiang 7-10->9->8
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_10);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_9_8);
            testcase.verifyEqual(testcase.board.Content(3,1),int16(0));
            testcase.verifyEqual(testcase.board.Content(1,3),int16(3));

            %Valid move
            %red move xiang 9-8->7->6
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_9_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_6);
            testcase.verifyEqual(testcase.board.Content(9,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(7,6),int16(10));

            %Valid move
            %black move xiang 9-8->7->6
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_9_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_6);
            testcase.verifyEqual(testcase.board.Content(1,3),int16(0));
            testcase.verifyEqual(testcase.board.Content(3,5),int16(3));

            %Valid move
            %red move xiang 7->6->5-8
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_6);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_8);
            testcase.verifyEqual(testcase.board.Content(7,6),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,8),int16(10));

            %Valid move
            %black move xiang 7->6->5-8
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_6);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_8);
            testcase.verifyEqual(testcase.board.Content(3,5),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,3),int16(3));

            %Valid move
            %red move ju 9->10->9-9
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_9_10);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_9_9);
            testcase.verifyEqual(testcase.board.Content(9,10),int16(0));
            testcase.verifyEqual(testcase.board.Content(9,9),int16(12));

            %Valid move
            %black move ju 9->10->9-9
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_9_10);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_9_9);
            testcase.verifyEqual(testcase.board.Content(1,1),int16(0));
            testcase.verifyEqual(testcase.board.Content(1,2),int16(5));

            %Valid move
            %red move ju 9->9->6-9
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_9_9);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_6_9);
            testcase.verifyEqual(testcase.board.Content(9,9),int16(0));
            testcase.verifyEqual(testcase.board.Content(6,9),int16(12));

            %Valid move
            %black move ju 9->9->6-9
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_9_9);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_6_9);
            testcase.verifyEqual(testcase.board.Content(1,2),int16(0));
            testcase.verifyEqual(testcase.board.Content(4,2),int16(5));


            %Valid move
            %red move ju 6->9->6-6
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_6_9);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_6_6);
            testcase.verifyEqual(testcase.board.Content(6,9),int16(0));
            testcase.verifyEqual(testcase.board.Content(6,6),int16(12));

            %Valid move
            %black move ju 6->9->6-6
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_6_9);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_6_6);
            testcase.verifyEqual(testcase.board.Content(4,2),int16(0));
            testcase.verifyEqual(testcase.board.Content(4,5),int16(5));

            %Valid move
            %red move ju 6->6->2-6
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_6_6);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_2_6);
            testcase.verifyEqual(testcase.board.Content(6,6),int16(0));
            testcase.verifyEqual(testcase.board.Content(2,6),int16(12));

            %Valid move
            %black move ju 6->6->2-6
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_6_6);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_2_6);
            testcase.verifyEqual(testcase.board.Content(4,5),int16(0));
            testcase.verifyEqual(testcase.board.Content(8,5),int16(5));

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

%          TestResult - 属性:
% 
%           Name: 'IntegrationTest/case5'
%         Passed: 1
%         Failed: 0
%     Incomplete: 0
%       Duration: 44.7853
%        Details: [1×1 struct]
% 
% 总计:
%    1 Passed, 0 Failed, 0 Incomplete.
%    44.7853 秒测试时间。
    end
end
