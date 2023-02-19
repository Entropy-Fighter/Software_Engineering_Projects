function main()
    close all force; clear; clc;
    if ~isempty(timerfind)
        stop(timerfind);
        delete(timerfind);
    end
    addpath("imgs/");
    addpath("Model/");
    addpath("ViewModel/");
    addpath("View/")
    addpath("recordings/");

    Timekeeper = ChessTimer();
    ChessBoard(Timekeeper);