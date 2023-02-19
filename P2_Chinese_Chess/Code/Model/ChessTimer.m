classdef ChessTimer < handle
    
    properties
        main            timer
        time            int64
    end
    
    methods (Access = public)

        function obj = ChessTimer()
            obj.main = timer;
            obj.main.StartDelay = 0;
            obj.main.Period = 1;
            obj.main.ExecutionMode = 'fixedRate';
            obj.main.TimerFcn = @(~,~) obj.tick;
            obj.main.BusyMode = 'queue';
            obj.time = 0;
            obj.main.start;
            return
        end

        function value = getTime(obj)
            value = obj.time;
        end

    end

    methods (Access = private)
        
        function tick(obj)
            obj.time = obj.time + 1;
        end

    end
end