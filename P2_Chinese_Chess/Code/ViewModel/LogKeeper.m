classdef LogKeeper < handle
    
    properties (Access = public)
        FileName        string
        player          LogPlayer
        matrix          string
        pointer         int64
        mode            % "r" / "w"
        ended           logical
        Main            ChessBoard
    end

    methods (Access = public)

        function obj = LogKeeper(model, mode, filename)
            obj.Main = model;
            obj.FileName = "";
            obj.matrix = zeros(1, 4);
            obj.pointer = 1;
            obj.mode = mode;
            obj.ended = false;
            switch mode
                case "r"
                    obj.setReadLog(filename);
                    obj.player = LogPlayer(obj);
                case "w"
            end
        end

        function setReadLog(obj, file)
            obj.FileName = file;
            obj.pointer = 1;
            obj.mode = "r";
            obj.matrix = readmatrix(file, "FileType", "text", "OutputType","string");
        end

        function result = nextLine(obj)
            if obj.pointer > size(obj.matrix, 1)
                result = ["0" "0" "0" "0" "0"];
                return
            end
            result = obj.matrix(obj.pointer, :);
            obj.pointer = obj.pointer + 1;
        end

        function writeLog(obj, type, direction, x, y, newX, newY, time)
            switch (type)
                case "regret"
                    obj.matrix(obj.pointer, 1) = type;
                    obj.matrix(obj.pointer, 2) = direction;
                    obj.matrix(obj.pointer, 3:5) = 0;
                case "draw"
                    obj.matrix(obj.pointer, 1) = type;
                    obj.matrix(obj.pointer, 2) = direction;
                    obj.matrix(obj.pointer, 3:5) = 0;
                    obj.saveLog;
                case "surrender"
                    obj.matrix(obj.pointer, 1) = type;
                    obj.matrix(obj.pointer, 2) = direction;
                    obj.matrix(obj.pointer, 3:5) = 0;
                    obj.saveLog;
                case "result"
                    obj.matrix(obj.pointer, 1) = type;
                    obj.matrix(obj.pointer, 2) = direction;
                    obj.matrix(obj.pointer, 3:5) = 0;
                    obj.saveLog;
                case "move"
                    obj.matrix(obj.pointer, 1) = x;
                    obj.matrix(obj.pointer, 2) = y;
                    obj.matrix(obj.pointer, 3) = newX;
                    obj.matrix(obj.pointer, 4) = newY;
                    obj.matrix(obj.pointer, 5) = time;
            end
            obj.pointer = obj.pointer + 1;
        end
    
        function saveLog(obj)
            if ~obj.ended
                if obj.pointer > 2
                   obj.matrix(1:end-1, 5) = obj.matrix(2:end, 5);
                end
                obj.ended = true;
                obj.FileName = "./recordings/" + string(datetime('now', 'Format','yyyy-MMMM-d-eeee-HH-mm-ss')) + ".rec";
                obj.pointer = 1;
                obj.mode = "w";
                
                writematrix(obj.matrix, obj.FileName, "FileType", "text");
            end
        end

        function Finish(obj)
            obj.Main.EndLog;
        end
    
        function result = canReg(obj)
            result = true;
            if obj.pointer == 1
                result = false;
            elseif obj.matrix(obj.pointer - 1, 1) == "regret"
                result = false;
            end
        end
    end

end

