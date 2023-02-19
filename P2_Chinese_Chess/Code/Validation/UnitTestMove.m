% This file mainly test if the movement of the chess is valid and correct.  
% 
% the testcase is numbered according to calssification
% case 10x      兵
% case 20x      将
% case 30x      士
% case 40x      相
% case 50x      车
% case 60x      马
% case 70x      炮

% if there is any error or warning,please run
%             addpath("imgs/");
%             addpath("Model/");
%             addpath("ViewModel/");
%             addpath("View/")
%             addpath("recordings/");
% in "命令行窗口" first,and then run the code

classdef UnitTestMove <matlab.uitest.TestCase
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
            testcase.timekeeper=ChessTimer();
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
        %(x,y) in Red corresponding to (10,11)-(x,y) in black
        function case101(testcase) %兵过河之前的移动,可以向前，不能向左右后
            %HumanHuman Mode
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

        function case102(testcase) %兵过河之后的移动，可以向左右前，不能向后
            %HumanHuman Mode
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

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

            %Valid move,forward
            %red move bing 7-6->7-5
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_6);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_5);
            testcase.verifyEqual(testcase.board.Content(7,6),int16(0));
            testcase.verifyEqual(testcase.board.Content(7,5),int16(14));

            %Valid move,forward
            %black move bing 7-6->7-5
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_6);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_5);
            testcase.verifyEqual(testcase.board.Content(3,5),int16(0));
            testcase.verifyEqual(testcase.board.Content(3,6),int16(7));

            %Invalid move,back
            %red move bing 7-5->7-6
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_5);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_6);
            testcase.verifyEqual(testcase.board.Content(7,5),int16(14));
            testcase.verifyEqual(testcase.board.Content(7,6),int16(0));

            %Invalid move,back
            %black move bing 7-5->7-6
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_5);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_6);
            testcase.verifyEqual(testcase.board.Content(3,6),int16(7));
            testcase.verifyEqual(testcase.board.Content(3,5),int16(0));

            %Valid move,left
            %red move bing 7-5->6-5
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_5);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_6_5);
            testcase.verifyEqual(testcase.board.Content(7,5),int16(0));
            testcase.verifyEqual(testcase.board.Content(6,5),int16(14));

            %valid move,left
            %black move bing 7-5->6-5
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_5);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_6_5);
            testcase.verifyEqual(testcase.board.Content(3,6),int16(0));
            testcase.verifyEqual(testcase.board.Content(4,6),int16(7));

            %Valid move,right
            %red move bing 6-5->7-5
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_6_5);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_5);
            testcase.verifyEqual(testcase.board.Content(6,5),int16(0));
            testcase.verifyEqual(testcase.board.Content(7,5),int16(14));

            %valid move,right
            %black move bing 6-5->7-5
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_6_5);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_5);
            testcase.verifyEqual(testcase.board.Content(4,6),int16(0));
            testcase.verifyEqual(testcase.board.Content(3,6),int16(7));

            %Valid move,forward
            %red move bing 7-5->7-4
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_5);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_4);
            testcase.verifyEqual(testcase.board.Content(7,5),int16(0));
            testcase.verifyEqual(testcase.board.Content(7,4),int16(14));

            %valid move,forward
            %black move bing 7-5->7-4
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_5);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_4);
            testcase.verifyEqual(testcase.board.Content(3,6),int16(0));
            testcase.verifyEqual(testcase.board.Content(3,7),int16(7));

            
            
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

        function case201(testcase) %将在九宫格内移动
            %HumanHuman Mode
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

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

        function case202(testcase) %将不能移动到九宫格外
            %HumanHuman Mode
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

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

            %Valid move,forward
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

            %Invalid move,left
            %red move jiang 4-9->3-9
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_4_9);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_3_9);
            testcase.verifyEqual(testcase.board.Content(4,9),int16(8));
            testcase.verifyEqual(testcase.board.Content(3,9),int16(0));

            %Invalid move,left
            %black move jiang 4-9->3-9
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_4_9);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_3_9);
            testcase.verifyEqual(testcase.board.Content(6,2),int16(1));
            testcase.verifyEqual(testcase.board.Content(7,2),int16(0));

            %Valid move,right
            %red move jiang 4-9->5-9
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_4_9);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_9);
            testcase.verifyEqual(testcase.board.Content(4,9),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,9),int16(8));

            %Valid move,right
            %black move jiang 4-9->5-9
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_4_9);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_9);
            testcase.verifyEqual(testcase.board.Content(6,2),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,2),int16(1));

            %Valid move
            %red move jiang 5-9->5-8
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_9);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_8);
            testcase.verifyEqual(testcase.board.Content(5,9),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,8),int16(8));

            %Valid move
            %black move jiang 5-9->5-8
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_9);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_8);
            testcase.verifyEqual(testcase.board.Content(5,2),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,3),int16(1));

            %InValid move
            %red move jiang 5-8->5-7
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_7);
            testcase.verifyEqual(testcase.board.Content(5,8),int16(8));
            testcase.verifyEqual(testcase.board.Content(5,7),int16(0));

            %Valid move
            %black move jiang 5-8->5-7
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_7);
            testcase.verifyEqual(testcase.board.Content(5,3),int16(1));
            testcase.verifyEqual(testcase.board.Content(5,4),int16(0));

            %Valid move
            %red move jiang 5-8->5-9
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_9);
            testcase.verifyEqual(testcase.board.Content(5,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,9),int16(8));

            %Valid move
            %black move jiang 5-8->5-9
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_9);
            testcase.verifyEqual(testcase.board.Content(5,3),int16(0));
            testcase.verifyEqual(testcase.board.Content(5,2),int16(1));

            %Valid move
            %red move jiang 5-9->6-9
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_9);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_6_9);
            testcase.verifyEqual(testcase.board.Content(5,9),int16(0));
            testcase.verifyEqual(testcase.board.Content(6,9),int16(8));

            %Valid move
            %black move jiang 5-9->6-9
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_9);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_6_9);
            testcase.verifyEqual(testcase.board.Content(5,2),int16(0));
            testcase.verifyEqual(testcase.board.Content(4,2),int16(1));

            %InValid move
            %red move jiang 6-9->7-9
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_6_9);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_9);
            testcase.verifyEqual(testcase.board.Content(6,9),int16(8));
            testcase.verifyEqual(testcase.board.Content(7,9),int16(0));

            %InValid move
            %black move jiang 6-9->7-9
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_6_9);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_9);
            testcase.verifyEqual(testcase.board.Content(4,2),int16(1));
            testcase.verifyEqual(testcase.board.Content(3,2),int16(0));

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

        function case301(testcase) %士在九宫格内移动
            %HumanHuman Mode
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

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

        function case302(testcase) %士不能移动到九宫格外
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
            pause(0.5);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.ConfirmConfirm);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.ConfirmConfirm);
            pause(0.5);
        end

        function case401(testcase) %相在自己半场，没有相脚
            %HumanHuman Mode
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

        function case402(testcase) %相在自己半场，有相脚
            %HumanHuman Mode
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

            %Valid move
            %red move pao 8-8->8->9
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_9);
            testcase.verifyEqual(testcase.board.Content(8,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(8,9),int16(13));

            %Valid move
            %black move pao 8-8->8->9
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_8_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_8_9);
            testcase.verifyEqual(testcase.board.Content(2,3),int16(0));
            testcase.verifyEqual(testcase.board.Content(2,2),int16(6));

            %InValid move
            %red move xiang 7-10->9->8
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_10);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_9_8);
            testcase.verifyEqual(testcase.board.Content(7,10),int16(10));
            testcase.verifyEqual(testcase.board.Content(9,8),int16(0));

            %InValid move
            %black move xiang 7-10->9->8
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_10);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_9_8);
            testcase.verifyEqual(testcase.board.Content(3,1),int16(3));
            testcase.verifyEqual(testcase.board.Content(1,3),int16(0));

             %Valid move
            %red move pao 8-9->8->8
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_9);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_8);
            testcase.verifyEqual(testcase.board.Content(8,9),int16(0));
            testcase.verifyEqual(testcase.board.Content(8,8),int16(13));

            %Valid move
            %black move pao 8-9->8->8
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_8_9);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_8_8);
            testcase.verifyEqual(testcase.board.Content(2,2),int16(0));
            testcase.verifyEqual(testcase.board.Content(2,3),int16(6));

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
            %red move pao 8-8->8->7
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_7);
            testcase.verifyEqual(testcase.board.Content(8,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(8,7),int16(13));

            %Valid move
            %black move pao 8-8->8->7
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_8_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_8_7);
            testcase.verifyEqual(testcase.board.Content(2,3),int16(0));
            testcase.verifyEqual(testcase.board.Content(2,4),int16(6));

            %InValid move
            %red move xiang 9-8->7->6
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_9_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_6);
            testcase.verifyEqual(testcase.board.Content(9,8),int16(10));
            testcase.verifyEqual(testcase.board.Content(7,6),int16(0));

            %InValid move
            %black move xiang 9-8->7->6
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_9_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_6);
            testcase.verifyEqual(testcase.board.Content(1,3),int16(3));
            testcase.verifyEqual(testcase.board.Content(3,5),int16(0));

            %Valid move
            %red move pao 8-7->8->8
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_7);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_8);
            testcase.verifyEqual(testcase.board.Content(8,7),int16(0));
            testcase.verifyEqual(testcase.board.Content(8,8),int16(13));

            %Valid move
            %black move pao 8-7->8->8
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_8_7);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_8_8);
            testcase.verifyEqual(testcase.board.Content(2,4),int16(0));
            testcase.verifyEqual(testcase.board.Content(2,3),int16(6));

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

        function case403(testcase) %相不能过河到对面半场 
            %HumanHuman Mode
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

            %Valid move,forward
            %red move bing 1-7->1-6
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_1_7);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_1_6);
            testcase.verifyEqual(testcase.board.Content(1,7),int16(0));
            testcase.verifyEqual(testcase.board.Content(1,6),int16(14));

            %Valid move,forward
            %black move bing 1-7->1-6
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_1_7);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_1_6);
            testcase.verifyEqual(testcase.board.Content(9,4),int16(0));
            testcase.verifyEqual(testcase.board.Content(9,5),int16(7));

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

            %InValid move
            %red move xiang 7-6->9-4
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_6);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_9_4);
            testcase.verifyEqual(testcase.board.Content(7,6),int16(10));
            testcase.verifyEqual(testcase.board.Content(9,4),int16(0));

            %InValid move
            %black move xiang 7-6->9-4
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_6);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_9_4);
            testcase.verifyEqual(testcase.board.Content(3,5),int16(3));
            testcase.verifyEqual(testcase.board.Content(1,7),int16(0));

            %InValid move
            %red move xiang 7-6->5-4
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_6);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_5_4);
            testcase.verifyEqual(testcase.board.Content(7,6),int16(10));
            testcase.verifyEqual(testcase.board.Content(5,4),int16(0));

            %InValid move
            %black move xiang 7-6->5-4
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_6);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_5_4);
            testcase.verifyEqual(testcase.board.Content(3,5),int16(3));
            testcase.verifyEqual(testcase.board.Content(5,7),int16(0));

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

        function case501(testcase) %车没有其他子阻挡
            %HumanHuman Mode
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

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

        function case502(testcase) %车遇到友方棋子的阻挡
            %HumanHuman Mode
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

            %InValid move
            %red move ju 9->10->8-10
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_9_10);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_10);
            testcase.verifyEqual(testcase.board.Content(9,10),int16(12));
            testcase.verifyEqual(testcase.board.Content(8,10),int16(11));

            %Valid move
            %black move ju  9->10->8-10
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_9_10);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_8_10);
            testcase.verifyEqual(testcase.board.Content(1,1),int16(5));
            testcase.verifyEqual(testcase.board.Content(2,1),int16(4));

            %InValid move
            %red move ju 9->10->9-7
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_9_10);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_9_7);
            testcase.verifyEqual(testcase.board.Content(9,10),int16(12));
            testcase.verifyEqual(testcase.board.Content(9,7),int16(14));

            %Valid move
            %black move ju  9->10->9-7
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_9_10);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_9_7);
            testcase.verifyEqual(testcase.board.Content(1,1),int16(5));
            testcase.verifyEqual(testcase.board.Content(1,4),int16(7));

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

        function case503(testcase) %车遇到对方棋子的阻挡（吃子）
            %HumanHuman Mode
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

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
            %red move ju 6-9->6-1
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_6_9);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_6_1);
            testcase.verifyEqual(testcase.board.Content(6,9),int16(0));
            testcase.verifyEqual(testcase.board.Content(6,1),int16(12));

            %Valid move
            %black move ju 6-9->6-1
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_6_9);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_6_1);
            testcase.verifyEqual(testcase.board.Content(4,2),int16(0));
            testcase.verifyEqual(testcase.board.Content(4,10),int16(5));

            %Valid move
            %red move ju 6-1->7-1
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_6_1);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_1);
            testcase.verifyEqual(testcase.board.Content(6,1),int16(0));
            testcase.verifyEqual(testcase.board.Content(7,1),int16(12));

            %Valid move
            %black move ju 6-1->7-1
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_6_1);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_1);
            testcase.verifyEqual(testcase.board.Content(4,10),int16(0));
            testcase.verifyEqual(testcase.board.Content(3,10),int16(5));

            %Valid move
            %red move ju 7-1->7-4
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_1);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_4);
            testcase.verifyEqual(testcase.board.Content(7,1),int16(0));
            testcase.verifyEqual(testcase.board.Content(7,4),int16(12));

            %Valid move
            %black move ju 7-1->7-4
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_1);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_4);
            testcase.verifyEqual(testcase.board.Content(3,10),int16(0));
            testcase.verifyEqual(testcase.board.Content(3,7),int16(5));

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

        function case601(testcase) %马没有遇到马脚
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

        function case602(testcase) %马遇到马脚
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

            %InValid move
            %red move ma 7-8->9-9
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_9_9);
            testcase.verifyEqual(testcase.board.Content(7,8),int16(11));
            testcase.verifyEqual(testcase.board.Content(9,9),int16(0));

            %InValid move
            %black move ma 7-8->9-9
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_9_9);
            testcase.verifyEqual(testcase.board.Content(3,3),int16(4));
            testcase.verifyEqual(testcase.board.Content(1,2),int16(0));
            
            %InValid move
            %red move ma 7-8->9-7
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_9_7);
            testcase.verifyEqual(testcase.board.Content(7,8),int16(11));
            testcase.verifyEqual(testcase.board.Content(9,7),int16(14));

            %InValid move
            %black move ma 7-8->9-7
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_9_7);
            testcase.verifyEqual(testcase.board.Content(3,3),int16(4));
            testcase.verifyEqual(testcase.board.Content(1,4),int16(7));

            %InValid move
            %red move ma 7-8->8-6
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_6);
            testcase.verifyEqual(testcase.board.Content(7,8),int16(11));
            testcase.verifyEqual(testcase.board.Content(8,6),int16(0));

            %InValid move
            %black move ma 7-8->8-6
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_8_6);
            testcase.verifyEqual(testcase.board.Content(3,3),int16(4));
            testcase.verifyEqual(testcase.board.Content(2,5),int16(0));

            %InValid move
            %red move ma 7-8->6-6
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_7_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_6_6);
            testcase.verifyEqual(testcase.board.Content(7,8),int16(11));
            testcase.verifyEqual(testcase.board.Content(6,6),int16(0));

            %InValid move
            %black move ma 7-8->6-6
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_7_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_6_6);
            testcase.verifyEqual(testcase.board.Content(3,3),int16(4));
            testcase.verifyEqual(testcase.board.Content(4,5),int16(0));


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

        function case701(testcase) %炮的移动
            %HumanHuman Mode
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

            %Valid move
            %red move pao 8-8->4-8
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_4_8);
            testcase.verifyEqual(testcase.board.Content(8,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(4,8),int16(13));

            %Valid move
            %black move ju 8-8->4-8
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_8_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_4_8);
            testcase.verifyEqual(testcase.board.Content(2,3),int16(0));
            testcase.verifyEqual(testcase.board.Content(6,3),int16(6));

            %Valid move
            %red move pao 4-8->4-6
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_4_8);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_4_6);
            testcase.verifyEqual(testcase.board.Content(4,8),int16(0));
            testcase.verifyEqual(testcase.board.Content(4,6),int16(13));

            %Valid move
            %black move ju 4-8->4-6
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_4_8);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_4_6);
            testcase.verifyEqual(testcase.board.Content(6,3),int16(0));
            testcase.verifyEqual(testcase.board.Content(6,5),int16(6));

            %Valid move
            %red move pao 4-6->8-6
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_4_6);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_6);
            testcase.verifyEqual(testcase.board.Content(4,6),int16(0));
            testcase.verifyEqual(testcase.board.Content(8,6),int16(13));

            %Valid move
            %black move ju 4-6->8-6
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_4_6);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_8_6);
            testcase.verifyEqual(testcase.board.Content(6,5),int16(0));
            testcase.verifyEqual(testcase.board.Content(2,5),int16(6));

            %Valid move
            %red move pao 8-6->8-8
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_6);
            pause(0.5);
            testcase.press(testcase.board.Red.Game.pos_8_8);
            testcase.verifyEqual(testcase.board.Content(8,6),int16(0));
            testcase.verifyEqual(testcase.board.Content(8,8),int16(13));

            %Valid move
            %black move ju 8-6->8-8
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_8_6);
            pause(0.5);
            testcase.press(testcase.board.Black.Game.pos_8_8);
            testcase.verifyEqual(testcase.board.Content(2,5),int16(0));
            testcase.verifyEqual(testcase.board.Content(2,3),int16(6));

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

        function case702(testcase)  
            %HumanHuman Mode
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.HumanButton);

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
