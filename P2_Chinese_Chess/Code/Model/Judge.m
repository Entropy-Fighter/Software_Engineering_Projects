function outputArg = Judge(ChessBoard)

    % 0 stands for not finished
    % 1 stands for Red winning
    % 2 stands for Black winning

    if isempty(find(ChessBoard == 1, 1))
        outputArg = 1;
        return;
    elseif isempty(find(ChessBoard == 8, 1))
        outputArg = 2;
        return;
    end

    [row1, col1] = find(ChessBoard >= 8);
    RedLose = true;
    for i=1:length(row1)
        RedLose = RedLose && isempty(find(GenerateRange(ChessBoard, row1(i), col1(i)) > 0, 1));
    end
    if RedLose
        outputArg = 2;
        return;
    end

    [row2, col2] = find(ChessBoard <= 7 & ChessBoard > 0);
    BlackLose = true;
    for i=1:length(row2)
        BlackLose = BlackLose && isempty(find(GenerateRange(ChessBoard, row2(i), col2(i)) > 0, 1));
    end
    if BlackLose
        outputArg = 1;
        return;
    end

    outputArg = 0;
    return;
end