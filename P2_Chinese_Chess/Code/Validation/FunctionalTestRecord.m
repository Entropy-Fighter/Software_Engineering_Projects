% This file mainly test if the function of "观看回放" will work well.

% The test can only be partly automatic, the part of selecting recording
% file can only be done manually since it is contrlled by the operating
% system,instead of matlab.

%There are only 2 testcase,but actually we have manually test all of the
%testcase in Presentatin.m,UnitTestMove.m,UnitTestOption.m. So actually
%many testcase has been performed.

% the testcase is numbered according to calssification
% case 10x      record shoued without fast forward
% case 20x      record shoued with fast forward

% if there is any error or warning,please run
%             addpath("imgs/");
%             addpath("Model/");
%             addpath("ViewModel/");
%             addpath("View/")
%             addpath("recordings/");
% in "命令行窗口" first,and then run the code
classdef FunctionalTestRecord <matlab.uitest.TestCase
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
        function case101(testcase) % record shoued without fast forward
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.PlayRecButton);
            % faster
            testcase.press(testcase.board.log.player.fastforward);
            pause(60);
            %exit
            testcase.press(testcase.board.log.player.exit);
            pause(0.5);
            
        end

        function case201(testcase) % record shoued with fast forward
            pause(0.5);
            testcase.press(testcase.board.Start.StartPageUI.PlayRecButton);
            % faster
            testcase.press(testcase.board.log.player.fastforward);
            pause(20);
            %exit
            testcase.press(testcase.board.log.player.exit);
            pause(0.5);
        end
    end
end
