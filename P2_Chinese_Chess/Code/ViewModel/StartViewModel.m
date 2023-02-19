classdef StartViewModel < handle
    
    properties (Access = public)
        StartPageUI                     StartPage
        Main                            ChessBoard
    end
    
    methods (Access = public)
        function obj = StartViewModel(main)
            obj.Main = main;
            obj.StartPageUI = StartPage(obj);
        end

        function HumanHuman(obj)
            obj.Main.StartGame("HumanHuman", 0);
        end

        function PlayRec(obj, filename)
            obj.Main.StartGame("PlayRec", filename);
        end

        function Online(obj, type, ip)
            switch type
                case "Host"
                    obj.Main.StartGame("OnlineHost", ip);
                case "Client"
                    obj.Main.StartGame("OnlineClient", ip);
            end
        end

        function NoConnection(obj)
            obj.StartPageUI.noConnection;
        end

        function CloseUI(obj)
            close(obj.StartPageUI.UIFigure);
        end
    end
end

