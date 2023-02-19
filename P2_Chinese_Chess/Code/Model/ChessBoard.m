classdef ChessBoard < handle

    properties (Access = public)
        Content             int16
        Mode                int16
        Start               StartViewModel
        Black               UIViewModel
        Red                 UIViewModel
        Turn                logical             % False for Red, True for Black
        Timekeeper          ChessTimer
        Deadline            int64
        TimeoutGuard        timer
        log                 LogKeeper
        prevCont            int16               % last operation
        closeAll            int16               % 2 for both windows opened, 0 for all closed
        WebListener         timer
        server              tcpserver.internal.TCPServer
        client              tcpclient
    end
    
    methods (Access = public)

        function obj = ChessBoard(Timekeeper)
            obj.Content = zeros(9, 10);
            obj.Start = StartViewModel(obj);
            obj.Turn = false;
            obj.Timekeeper = Timekeeper;
            obj.Deadline = 10000000;
            obj.TimeoutGuard = timer("Period", 0.5, "TimerFcn", @(~,~) obj.CheckTimeoutFunc,"ExecutionMode", "fixedRate");
            obj.TimeoutGuard.start;
        end
        
        function StartGame(obj, mode, target)
            switch mode
                case "HumanHuman"
                    Init(obj, 2, 0);
                case "OnlineHost"
                    Init(obj, 3, target);
                case "OnlineClient"
                    Init(obj, 4, target);
                case "PlayRec"
                    Init(obj, 1, target);
            end
        end

        function UpdateBoards(obj)
            switch obj.Mode
                case 2
                    obj.Red.Update(obj.Content);
                    obj.Black.Update(obj.Content);
                case 3
                    obj.Red.Update(obj.Content);
                case 4
                    obj.Black.Update(obj.Content);
            end
        end

        function result = move(obj, x, y, newX, newY, direction)
            % In remote client cases
            if obj.Mode == 4
                obj.send(["Move", x, y, newX, newY]);
                return
            end

            result = 0;
            % 0. Check whether its your turn to move
            if ((direction == "Black") && ~obj.Turn) || ((direction == "Red") && obj.Turn)
                return
            end
            % 1. Make sure start position and end position is valid
            type = obj.Content(x, y);
            if (type >= 8 && direction == "Black") || (0 < type && type <= 7 && direction == "Red")
                return
            end
            % 2. Find all valid position
            enableMatrix = GenerateRange(obj.Content, x, y);
            % 3. Check whether the position is valid
            if ~enableMatrix(newX, newY)
                return
            end
            
            % 3.5 Remembers last board
            obj.prevCont = obj.Content;

            % 4. Move chess in model
            obj.Content(newX, newY) = obj.Content(x, y);
            obj.Content(x, y) = 0;
            % 5. Render the chessboard
            obj.UpdateBoards();
            result = 1;
            % 6. Change the turn
            obj.Turn = ~obj.Turn;
            % 7. Check win or lose
            switch(Judge(obj.Content))
                case 0
                    obj.log.writeLog("move", direction, x, y, newX, newY, 20 - (obj.Deadline - obj.Timekeeper.getTime));
                case 1
                    obj.log.writeLog("move", direction, x, y, newX, newY, 20 - (obj.Deadline - obj.Timekeeper.getTime));
                    obj.log.writeLog("result", "Red", 0, 0, 0, 0, 0);
                    switch obj.Mode
                        case 2
                            obj.Black.lose(2);
                            obj.Red.win(2);
                        case 3
                            obj.send(["Lose", 0, 0, 0, 0]);
                            obj.Red.win(2);
                    end
                case 2
                    obj.log.writeLog("move", direction, x, y, newX, newY, 20 - (obj.Deadline - obj.Timekeeper.getTime));
                    obj.log.writeLog("result", "Black", 0, 0, 0, 0, 0);
                    switch obj.Mode
                        case 2
                            obj.Black.win(2);
                            obj.Red.lose(2);
                        case 3
                            obj.send(["Win", 0, 0, 0, 0]);
                            obj.Red.lose(2);
                    end
            end
            % 8. Update the time limit
            obj.UpdateTime(20);
            % In remote host cases
            if obj.Mode == 3
                obj.send(["Move", x, y, newX, newY]);
            end
        end

        function admitDefeat(obj, direction)
            switch direction
                case "Red"
                    obj.log.writeLog("surrender", "Red", 0, 0, 0, 0, 0);
                    if obj.Mode == 3
                        obj.send(["Surrender", 0, 0, 0, 0]);
                    else
                        obj.Black.win(1);
                    end
                case "Black"
                    obj.log.writeLog("surrender", "Black", 0, 0, 0, 0, 0);
                    if obj.Mode == 4
                        obj.send(["Surrender", 0, 0, 0, 0]);
                    else
                        obj.Red.win(1);
                    end
            end
        end

        function requestDraw(obj, direction)
            % In remote cases
            if obj.Mode ~= 2
                obj.send(["ReqDraw", 0, 0, 0, 0])
                return
            end
            switch direction
                case "Red"
                    obj.Black.request(1);
                case "Black"
                    obj.Red.request(1);
            end
        end

        function requestUndo(obj, direction)
            % In remote cases
            if obj.Mode ~= 2
                obj.send(["ReqUndo", 0, 0, 0, 0])
                return
            end
            switch direction
                case "Red"
                    obj.Black.request(2);
                case "Black"
                    obj.Red.request(2);
            end
        end

        function replyRequest(obj, direction, agree, event)
            if agree
                switch direction
                    case "Black"
                        obj.log.writeLog(event, "Red", 0, 0, 0, 0, 0);              % Direction is reversed
                    case "Red"
                        obj.log.writeLog(event, "Black", 0, 0, 0, 0);
                end
            end
            if event == "regret" & agree
                obj.Content = obj.prevCont;
                obj.UpdateBoards;
                obj.Turn = ~obj.Turn;
                obj.UpdateTime(20);
            end
            % In remote cases
            if obj.Mode ~= 2
                if event == "regret" & agree
                    obj.send(["AccUndo", 0, 0, 0, 0]);
                elseif event == "regret" & ~agree
                    obj.send(["DenyUndo", 0, 0, 0, 0]);
                elseif event == "draw" & agree
                    obj.send(["AccDraw", 0, 0, 0, 0]);
                elseif event == "draw" & ~agree
                    obj.send(["DenyUndo", 0, 0, 0, 0]);
                end
                return
            end
            % Local
            switch direction
                case "Red"
                    obj.Black.sendFeedback(agree);
                case "Black"
                    obj.Red.sendFeedback(agree);
            end
        end

        function EndGame(obj, direction)
            switch direction
                case "Black"
                    delete(obj.Black);
                case "Red"
                    delete(obj.Red);
            end
            obj.closeAll = obj.closeAll - 1;
            if obj.closeAll == 0
                obj.Content = zeros(9, 10);
                obj.Start = StartViewModel(obj);
                obj.Deadline = 10000000;
                stop(obj.TimeoutGuard);
                delete(obj.TimeoutGuard);
                obj.TimeoutGuard = timer("Period", 0.5, "TimerFcn", @(~,~) obj.CheckTimeoutFunc,"ExecutionMode", "fixedRate");
                obj.TimeoutGuard.start;
            end
        end
    
        function EndLog(obj)
            delete(obj.log);
            obj.Content = zeros(9, 10);
            obj.Start = StartViewModel(obj);
            obj.Deadline = 10000000;
            stop(obj.TimeoutGuard);
            delete(obj.TimeoutGuard);
            obj.TimeoutGuard = timer("Period", 0.5, "TimerFcn", @(~,~) obj.CheckTimeoutFunc,"ExecutionMode", "fixedRate");
            obj.TimeoutGuard.start;
        end
        
        function result = canReg(obj)
            result = obj.log.canReg;
        end
    end

    methods (Access = private)

        function Init(obj, mode, target)
            obj.Content = [[5 4 3 2 1 2 3 4 5];
                    [0 0 0 0 0 0 0 0 0];
                    [0 6 0 0 0 0 0 6 0];
                    [7 0 7 0 7 0 7 0 7];
                    [0 0 0 0 0 0 0 0 0];
                    [0 0 0 0 0 0 0 0 0];
                    [14 0 14 0 14 0 14 0 14];
                    [0 13 0 0 0 0 0 13 0];
                    [0 0 0 0 0 0 0 0 0];
                    [12 11 10 9 8 9 10 11 12];]';
            obj.prevCont = zeros(10, 9);
            obj.Mode = mode;
            switch mode
                case 1
                    % Play rec
                    obj.log = LogKeeper(obj, "r", target);
                case 2
                    % Human-Human
                    obj.closeAll = 2;
                    obj.Turn = false;
                    obj.Black = UIViewModel("Black", obj);
                    obj.Black.InitGame(obj.Timekeeper);
                    obj.Red = UIViewModel("Red", obj);
                    obj.Red.InitGame(obj.Timekeeper);
                    obj.log = LogKeeper(obj, "w", 0);
                    obj.UpdateBoards();
                    obj.UpdateTime(20);
                case 3
                    % OnlineHost
                    obj.closeAll = 1;
                    obj.Turn = false;
                    obj.server = tcpserver(61199);
                    waitUntil = obj.Timekeeper.getTime + 30;
                    while obj.Timekeeper.getTime < waitUntil
                        pause(0.2);
                        if obj.server.Connected
                            obj.Start.CloseUI;
                            obj.Red = UIViewModel("Red", obj);
                            obj.Red.InitGame(obj.Timekeeper);
                            obj.log = LogKeeper(obj, "w", 0);
                            obj.WebListener = timer("Period", 0.25, "TimerFcn", @(~,~) obj.listenAsHost, "ExecutionMode", "fixedRate");
                            obj.WebListener.start;
                            return
                        end
                    end
                    delete(obj.server);
                    obj.Start.NoConnection;
                case 4
                    % OnlineClient
                    try
                        obj.client = tcpclient(target, 61199, "Timeout", 3600, "ConnectTimeout", 5);
                    catch
                        obj.Start.NoConnection;
                        return
                    end
                    pause(1);
                    obj.closeAll = 1;
                    obj.Turn = false;
                    obj.Start.CloseUI;
                    obj.Black = UIViewModel("Black", obj);
                    obj.Black.InitGame(obj.Timekeeper);
                    obj.log = LogKeeper(obj, "w", 0);
                    obj.WebListener = timer("Period", 0.25, "TimerFcn", @(~,~) obj.listenAsClient, "ExecutionMode", "fixedRate");
                    obj.WebListener.start;
                    obj.send(["Start", 0, 0, 0, 0]);
            end

        end

        function UpdateTime(obj, time)
            if (obj.Turn)
                switch obj.Mode
                    case 2
                        obj.Black.UpdateDDL(obj.Timekeeper.getTime + time);
                        obj.Red.UpdateDDL(100000000);
                    case 3
                        obj.Red.UpdateDDL(100000000);
                    case 4
                        obj.Black.UpdateDDL(obj.Timekeeper.getTime + time);
                end
            else
                switch obj.Mode
                    case 2
                        obj.Black.UpdateDDL(100000000);
                        obj.Red.UpdateDDL(obj.Timekeeper.getTime + time);
                    case 3
                        obj.Red.UpdateDDL(obj.Timekeeper.getTime + time);
                    case 4
                        obj.Black.UpdateDDL(100000000);
                end

            end
            obj.Deadline = obj.Timekeeper.getTime + time;
        end
        
        function CheckTimeoutFunc(obj)
            if (obj.Deadline < obj.Timekeeper.getTime)
                if (obj.Turn)
                    % Black loses
                    obj.log.writeLog("result", "Red", 0, 0, 0, 0, 0);
                    switch obj.Mode
                        case 2
                            obj.Black.lose(2);
                            obj.Red.win(2);
                        case 3
                            obj.send(["Lose", 0, 0, 0, 0]);
                            obj.Red.win(2);
                        case 4
                            obj.Black.lose(2);
                            obj.send(["Win", 0, 0, 0, 0]);
                    end
                else
                    % Red loses
                    obj.log.writeLog("result", "Black", 0, 0, 0, 0, 0);
                    obj.Red.lose(2);
                    obj.Black.win(2);
                    switch obj.Mode
                        case 2
                            obj.Red.lose(2);
                            obj.Black.win(2);
                        case 3
                            obj.Red.lose(2);
                            obj.send(["Win", 0, 0, 0, 0]);
                        case 4
                            obj.send(["Lose", 0, 0, 0, 0]);
                            obj.Black.win(2);
                    end
                end
            end
        end
        
        % Below are online playing functions
        function RemoteMove(obj, x, y, newX, newY)

            % This function is called only if in "Client" mode

            % 1. Remembers last board
            obj.prevCont = obj.Content;
            % 2. Move chess in model
            obj.Content(newX, newY) = obj.Content(x, y);
            obj.Content(x, y) = 0;
            % 3. Render the chessboard
            obj.Black.Update(obj.Content);
            % 4. Change the turn
            obj.Turn = ~obj.Turn;
            % 5. Log
            obj.log.writeLog("move", 0, x, y, newX, newY, 20 - (obj.Deadline - obj.Timekeeper.getTime));
            % 6. Update the time limit
            obj.UpdateTime(20);
        end

        function listenAsClient(obj)
            if obj.client.NumBytesAvailable == 0
                return
            else
                result = obj.client.readline;
            end
            % process (concatenated, so split)
            result = split(result, "-");
            switch result(1)
                case "Init"
                    obj.Black.Update(obj.Content);
                case "Move"
                    obj.RemoteMove(str2double(result(2)), str2double(result(3)), str2double(result(4)), str2double(result(5)));
                case "ReqDraw"
                    obj.Black.request(1);
                case "ReqUndo"
                    obj.Black.request(2);
                case "Surrender"
                    obj.log.writeLog("surrender", "Red", 0, 0, 0, 0, 0);
                    obj.Black.win(1);
                    obj.Disconnect;
                case "AccDraw"
                    obj.Black.sendFeedback(true);
                    obj.log.writeLog("draw", "Black", 0, 0, 0, 0, 0);
                    obj.Disconnect;
                case "AccUndo"
                    obj.Black.sendFeedback(true);
                    obj.log.writeLog("regret", "Black", 0, 0, 0, 0, 0);
                    obj.Content = obj.prevCont;
                    obj.UpdateBoards;
                    obj.Turn = ~obj.Turn;
                    obj.UpdateTime(20);
                case "DenyDraw"
                    obj.Black.sendFeedback(false);
                case "DenyUndo"
                    obj.Black.sendFeedback(false);
                case "Win"
                    obj.log.writeLog("result", "Black", 0, 0, 0, 0, 0);
                    obj.Black.win(2);
                    obj.Disconnect;
                case "Lose"
                    obj.log.writeLog("result", "Red", 0, 0, 0, 0, 0);
                    obj.Black.lose(2);
                    obj.Disconnect;
            end
        end

        function listenAsHost(obj)
            if ~obj.server.Connected
                obj.Disconnect;
                return
            end
            if obj.server.NumBytesAvailable == 0
                return
            else
                result = obj.server.readline;
            end
            % process (concatenated, so split)
            result = split(result, "-");
            switch result(1)
                case "Start"
                    obj.Red.Update(obj.Content);
                    obj.send(["Init", 0, 0, 0, 0]);
                case "Move"
                    obj.move(str2double(result(2)), str2double(result(3)), str2double(result(4)), str2double(result(5)), "Black");
                case "ReqDraw"
                    obj.Red.request(1);
                case "ReqUndo"
                    obj.Red.request(2);
                case "Surrender"
                    obj.log.writeLog("surrender", "Black", 0, 0, 0, 0, 0);
                    obj.Red.win(1);
                case "AccDraw"
                    obj.Red.sendFeedback(true);
                    obj.log.writeLog("draw", "Red", 0, 0, 0, 0, 0);
                case "AccUndo"
                    obj.Red.sendFeedback(true);
                    obj.log.writeLog("regret", "Red", 0, 0, 0, 0, 0);
                    obj.Content = obj.prevCont;
                    obj.UpdateBoards;
                    obj.Turn = ~obj.Turn;
                    obj.UpdateTime(20);
                case "DenyDraw"
                    obj.Red.sendFeedback(false);
                case "DenyUndo"
                    obj.Red.sendFeedback(false);
            end
        end

        function send(obj, msg)
            switch obj.Mode
                case 3          % Host
                    writeline(obj.server, join(msg, "-"));
                case 4          % Client
                    writeline(obj.client, join(msg, "-"));
            end
        end

        function Disconnect(obj)
            switch obj.Mode
                case 3          % Host
                    delete(obj.server);
                    obj.Red.Disconnect;
                case 4          % Client
                    delete(obj.client);
                    obj.Black.Disconnect;
            end
        end
    end
        
end

