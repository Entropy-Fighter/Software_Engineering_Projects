classdef UIViewModel < handle
    
    properties (Access = public)
        Direction               % Red / Black
        Game                    GameBoard
        Main                    ChessBoard
        Timekeeper              ChessTimer
    end
    
    methods (Access = public)
        function obj = UIViewModel(Dir, main)
            obj.Direction = Dir;
            obj.Main = main;
        end

        function InitGame(obj, Timekeeper)
            obj.Timekeeper = Timekeeper;
            obj.Game = GameBoard(obj.Direction, obj);
        end

        function Update(obj, content)
            obj.Game.UpdateBoard(content);
        end

        function UpdateDDL(obj, time)
            obj.Game.deadline = time;
        end

        function time = getTime(obj)
            time = obj.Timekeeper.getTime;
        end
        
        function RequestDefeat(obj)
            obj.Main.admitDefeat(obj.Direction);
            obj.Game.lose(1);       % admit defeat
        end

        function RequestUndo(obj)
            obj.Main.requestUndo(obj.Direction);
        end

        function RequestDraw(obj)
            obj.Main.requestDraw(obj.Direction);
        end

        function win(obj, type)
            if type == 1        % opponent admit defeat
                obj.Game.win(1);
            elseif type == 2    % Judged victory
                obj.Game.win(2);
            end
        end

        function lose(obj, type)
            if type == 1        % admit defeat
                obj.Game.lose(1);
            elseif type == 2    % Judged defeat
                obj.Game.lose(2);
            end
        end

        function request(obj, type) 
            if type == 1            % Draw
                obj.Game.notify(200);
            elseif type == 2        % regret
                obj.Game.notify(202);
            end
        end

        function reply(obj, agree, event)
            obj.Main.replyRequest(obj.Direction, agree, event);
        end

        function sendFeedback(obj, agree)
            obj.Game.feedback(agree)
        end

        function move(obj, x, y, newX, newY, direction)
            obj.Main.move(x, y, newX, newY, direction);
        end

        function EndGame(obj)
            obj.Main.EndGame(obj.Direction);
        end

        function Disconnect(obj)
            obj.Game.notify(400);
        end

        function result = canReg(obj)
            result = obj.Main.canReg;
        end
    end

end

