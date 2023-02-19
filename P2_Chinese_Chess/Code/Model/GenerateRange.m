function outputArg = GenerateRange(ChessBoard, x, y)

    function result = checkBlack(x, y)
        result = 0;
        if ChessBoard(x, y) == 0 || ChessBoard(x, y) >= 8
            result = 1;
            outputArg(x, y) = 1;
        end
    end
    
    function result = checkRed(x, y)
        result = 0;
        if ChessBoard(x, y) <= 7
            result = 1;
            outputArg(x, y) = 1;
        end
    end

    function result = checkEmpty(x, y)
        result = ChessBoard(x, y) == 0;
    end

    function result = inRange(x ,y)
        result = x > 0 && y > 0 && x < 10 && y < 11;
    end

    function checkRangeBlack(x, y)
        if inRange(x, y)
            checkBlack(x, y);
        end
    end

    function checkRangeRed(x, y)
        if inRange(x, y)
            checkRed(x, y);
        end
    end

    outputArg = zeros(9, 10);
    switch ChessBoard(x, y)
        case 1
            switch 100 * x + y
                case 401
                    checkBlack(4, 2);
                    checkBlack(5, 1);
                case 402
                    checkBlack(4, 1);
                    checkBlack(5, 2);
                    checkBlack(4, 3);
                case 403
                    checkBlack(4, 2);
                    checkBlack(5, 3);
                case 501
                    checkBlack(4, 1);
                    checkBlack(5, 2);
                    checkBlack(6, 1);
                case 502
                    checkBlack(4, 2);
                    checkBlack(5, 1);
                    checkBlack(5, 3);
                    checkBlack(6, 2);
                case 503
                    checkBlack(5, 2);
                    checkBlack(4, 3);
                    checkBlack(6, 3);
                case 601
                    checkBlack(5, 1);
                    checkBlack(6, 2);
                case 602
                    checkBlack(6, 1);
                    checkBlack(5, 2);
                    checkBlack(6, 3);
                case 603
                    checkBlack(6, 2);
                    checkBlack(5, 3);
            end

        case 2
            switch 100 * x + y
                case 401
                    checkBlack(5, 2);
                case 601
                    checkBlack(5, 2);
                case 403
                    checkBlack(5, 2);
                case 603
                    checkBlack(5, 2);
                case 502
                    checkBlack(4, 1);
                    checkBlack(6, 1);
                    checkBlack(4, 3);
                    checkBlack(6, 3);
            end

        case 3
            if inRange(x - 1, y - 1) && checkEmpty(x - 1, y - 1)
                checkRangeBlack(x - 2, y - 2);
            end
            if inRange(x + 1, y - 1) && checkEmpty(x + 1, y - 1)
                checkRangeBlack(x + 2, y - 2);
            end
            if inRange(x - 1, y + 1) && checkEmpty(x - 1, y + 1)
                checkRangeBlack(x - 2, y + 2);
            end
            if inRange(x + 1, y + 1) && checkEmpty(x + 1, y + 1)
                checkRangeBlack(x + 2, y + 2);
            end
            outputArg(:, 6:10) = zeros(9, 5);

        case 4
            if inRange(x + 1, y) && checkEmpty(x + 1, y)
                checkRangeBlack(x + 2, y - 1);
                checkRangeBlack(x + 2, y + 1);
            end
            if inRange(x, y + 1) && checkEmpty(x, y + 1)
                checkRangeBlack(x + 1, y + 2);
                checkRangeBlack(x - 1, y + 2);
            end
            if inRange(x - 1, y) && checkEmpty(x - 1, y)
                checkRangeBlack(x - 2, y + 1);
                checkRangeBlack(x - 2, y - 1);
            end
            if inRange(x, y - 1) && checkEmpty(x, y - 1)
                checkRangeBlack(x - 1, y - 2);
                checkRangeBlack(x + 1, y - 2);
            end

        case 5
            % Direction: right
            for i = 1:10
                if ~inRange(x + i, y) 
                    break
                end
                if checkEmpty(x + i, y)
                    outputArg(x + i, y) = 1;
                    continue
                end
                checkBlack(x + i, y);
                break
            end
            % Direction: left
            for i = 1:10
                if ~inRange(x - i, y) 
                    break
                end
                if checkEmpty(x - i, y)
                    outputArg(x - i, y) = 1;
                    continue
                end
                checkBlack(x - i, y);
                break
            end
            % Direction: up
            for i = 1:10
                if ~inRange(x, y - i) 
                    break
                end
                if checkEmpty(x, y - i)
                    outputArg(x, y - i) = 1;
                    continue
                end
                checkBlack(x, y - i);
                break
            end
            % Direction: down
            for i = 1:10
                if ~inRange(x, y + i) 
                    break
                end
                if checkEmpty(x, y + i)
                    outputArg(x, y + i) = 1;
                    continue
                end
                checkBlack(x, y + i);
                break
            end

        case 6
            % Direction: right
            for i = 1:10
                if ~inRange(x + i, y) 
                    break
                end
                if checkEmpty(x + i, y)
                    outputArg(x + i, y) = 1;
                    continue
                end
                for j = (i + 1):10
                    if ~inRange(x + j, y)
                        break
                    end
                    if ~checkEmpty(x + j, y)
                        if ChessBoard(x + j, y) >= 8
                            outputArg(x + j, y) = 1;
                        end
                        break;
                    end
                end
                break
            end
            % Direction: left
            for i = 1:10
                if ~inRange(x - i, y) 
                    break
                end
                if checkEmpty(x - i, y)
                    outputArg(x - i, y) = 1;
                    continue
                end
                for j = (i + 1):10
                    if ~inRange(x - j, y)
                        break
                    end
                    if ~checkEmpty(x - j, y)
                        if ChessBoard(x - j, y) >= 8
                            outputArg(x - j, y) = 1;
                        end
                        break;
                    end
                end
                break
            end
            % Direction: up
            for i = 1:10
                if ~inRange(x, y - i) 
                    break
                end
                if checkEmpty(x, y - i)
                    outputArg(x, y - i) = 1;
                    continue
                end
                for j = (i + 1):10
                    if ~inRange(x, y - j)
                        break
                    end
                    if ~checkEmpty(x, y - j)
                        if ChessBoard(x, y - j) >= 8
                            outputArg(x, y - j) = 1;
                        end
                        break;
                    end
                end
                break
            end
            % Direction: down
            for i = 1:10
                if ~inRange(x, y + i) 
                    break
                end
                if checkEmpty(x, y + i)
                    outputArg(x, y + i) = 1;
                    continue
                end
                for j = (i + 1):10
                    if ~inRange(x, y + j)
                        break
                    end
                    if ~checkEmpty(x, y + j)
                        if ChessBoard(x, y + j) >= 8
                            outputArg(x, y + j) = 1;
                        end
                        break;
                    end
                end
                break
            end

        case 7
            if y < 6
                checkBlack(x, y + 1);
            else
                checkRangeBlack(x, y + 1);
                checkRangeBlack(x - 1, y);
                checkRangeBlack(x + 1, y);
            end

        case 8
            switch 100 * x + y
                case 410
                    checkRangeRed(4, 9);
                    checkRangeRed(5, 10);
                case 510
                    checkRangeRed(4, 10);
                    checkRangeRed(6, 10);
                    checkRangeRed(5, 9);
                case 610
                    checkRangeRed(5, 10);
                    checkRangeRed(6, 9);
                case 409
                    checkRangeRed(4, 8);
                    checkRangeRed(5, 9);
                    checkRangeRed(4, 10);
                case 509
                    checkRangeRed(4, 9);
                    checkRangeRed(5, 10);
                    checkRangeRed(6, 9);
                    checkRangeRed(5, 8);
                case 609
                    checkRangeRed(5, 9);
                    checkRangeRed(6, 8);
                    checkRangeRed(6, 10);
                case 408
                    checkRangeRed(4, 9);
                    checkRangeRed(5, 8);
                case 508
                    checkRangeRed(4, 8);
                    checkRangeRed(5, 9);
                    checkRangeRed(6, 8);
                case 608
                    checkRangeRed(5, 8);
                    checkRangeRed(6, 9);
            end

        case 9
            switch 100 * x + y
                case 410
                    checkRangeRed(5, 9);
                case 408
                    checkRangeRed(5, 9);
                case 608
                    checkRangeRed(5, 9);
                case 610
                    checkRangeRed(5, 9);
                case 509
                    checkRangeRed(4, 8);
                    checkRangeRed(4, 10);
                    checkRangeRed(6, 8);
                    checkRangeRed(6, 10);
            end

        case 10
            if inRange(x - 1, y - 1) && checkEmpty(x - 1, y - 1)
                checkRangeRed(x - 2, y - 2);
            end
            if inRange(x + 1, y - 1) && checkEmpty(x + 1, y - 1)
                checkRangeRed(x + 2, y - 2);
            end
            if inRange(x - 1, y + 1) && checkEmpty(x - 1, y + 1)
                checkRangeRed(x - 2, y + 2);
            end
            if inRange(x + 1, y + 1) && checkEmpty(x + 1, y + 1)
                checkRangeRed(x + 2, y + 2);
            end
            outputArg(:, 1:5) = zeros(9, 5);

        case 11
            if inRange(x + 1, y) && checkEmpty(x + 1, y)
                checkRangeRed(x + 2, y - 1);
                checkRangeRed(x + 2, y + 1);
            end
            if inRange(x, y + 1) && checkEmpty(x, y + 1)
                checkRangeRed(x + 1, y + 2);
                checkRangeRed(x - 1, y + 2);
            end
            if inRange(x - 1, y) && checkEmpty(x - 1, y)
                checkRangeRed(x - 2, y + 1);
                checkRangeRed(x - 2, y - 1);
            end
            if inRange(x, y - 1) && checkEmpty(x, y - 1)
                checkRangeRed(x - 1, y - 2);
                checkRangeRed(x + 1, y - 2);
            end

        case 12
            % Direction: right
            for i = 1:10
                if ~inRange(x + i, y) 
                    break
                end
                if checkEmpty(x + i, y)
                    outputArg(x + i, y) = 1;
                    continue
                end
                checkRed(x + i, y);
                break
            end
            % Direction: left
            for i = 1:10
                if ~inRange(x - i, y) 
                    break
                end
                if checkEmpty(x - i, y)
                    outputArg(x - i, y) = 1;
                    continue
                end
                checkRed(x - i, y);
                break
            end
            % Direction: up
            for i = 1:10
                if ~inRange(x, y - i) 
                    break
                end
                if checkEmpty(x, y - i)
                    outputArg(x, y - i) = 1;
                    continue
                end
                checkRed(x, y - i);
                break
            end
            % Direction: down
            for i = 1:10
                if ~inRange(x, y + i) 
                    break
                end
                if checkEmpty(x, y + i)
                    outputArg(x, y + i) = 1;
                    continue
                end
                checkRed(x, y + i);
                break
            end

        case 13
            % Direction: right
            for i = 1:10
                if ~inRange(x + i, y) 
                    break
                end
                if checkEmpty(x + i, y)
                    outputArg(x + i, y) = 1;
                    continue
                end
                for j = (i + 1):10
                    if ~inRange(x + j, y)
                        break
                    end
                    if ~checkEmpty(x + j, y)
                        if ChessBoard(x + j, y) < 8
                            outputArg(x + j, y) = 1;
                        end
                        break;
                    end
                end
                break
            end
            % Direction: left
            for i = 1:10
                if ~inRange(x - i, y) 
                    break
                end
                if checkEmpty(x - i, y)
                    outputArg(x - i, y) = 1;
                    continue
                end
                for j = (i + 1):10
                    if ~inRange(x - j, y)
                        break
                    end
                    if ~checkEmpty(x - j, y)
                        if ChessBoard(x - j, y) < 8
                            outputArg(x - j, y) = 1;
                        end
                        break;
                    end
                end
                break
            end
            % Direction: up
            for i = 1:10
                if ~inRange(x, y - i) 
                    break
                end
                if checkEmpty(x, y - i)
                    outputArg(x, y - i) = 1;
                    continue
                end
                for j = (i + 1):10
                    if ~inRange(x, y - j)
                        break
                    end
                    if ~checkEmpty(x, y - j)
                        if ChessBoard(x, y - j) < 8
                            outputArg(x, y - j) = 1;
                        end
                        break;
                    end
                end
                break
            end
            % Direction: down
            for i = 1:10
                if ~inRange(x, y + i) 
                    break
                end
                if checkEmpty(x, y + i)
                    outputArg(x, y + i) = 1;
                    continue
                end
                for j = (i + 1):10
                    if ~inRange(x, y + j)
                        break
                    end
                    if ~checkEmpty(x, y + j)
                        if ChessBoard(x, y + j) < 8
                            outputArg(x, y + j) = 1;
                        end
                        break;
                    end
                end
                break
            end

        case 14
            if y > 5
                checkRed(x, y - 1);
            else
                checkRangeRed(x, y - 1);
                checkRangeRed(x - 1, y);
                checkRangeRed(x + 1, y);
            end
    end

    outputArg = logical(outputArg);
end