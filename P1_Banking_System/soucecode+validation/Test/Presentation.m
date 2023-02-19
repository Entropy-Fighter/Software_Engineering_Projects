classdef Presentation < matlab.uitest.TestCase

    properties
        DB              Database
        sapp            StaffAPP
        capp            CustomerAPP
        atm             ATM
    end

    methods(TestClassSetup)
        function Init(~)
            close all force;
            clear;
            clc;
        end
    end

    methods(TestMethodSetup)
        function createFigure(testcase)
            testcase.DB = Database;
            testcase.sapp = StaffAPP;
            testcase.atm = ATM;
            testcase.capp = CustomerAPP;

            
            testcase.sapp.BankDatabase = testcase.DB;
            testcase.atm.AccountDatabase = testcase.DB;
            testcase.capp.AccountDatabase = testcase.DB;
        end
    end

    methods(TestMethodTeardown)
        function closeFigure(testcase)
            delete(testcase.sapp.acc);
            delete(testcase.sapp.rec);
            delete(testcase.sapp);
            delete(testcase.DB);
            delete(testcase.capp);
            delete(testcase.atm);
        end
    end


    methods(Test)
        
        function case1(testcase)
            % This testcase aims to show that balance is instantly updated
            pause(5);
            testcase.type(testcase.sapp.LogUserIDEditField, 10000);
            testcase.type(testcase.sapp.LogPasswordEditField, 123456);
            testcase.press(testcase.sapp.LogInButton);
            testcase.press(testcase.sapp.ManageAccountButton);
            testcase.type(testcase.sapp.acc.AccountEditField, 100003);
            pause(1);
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.type(testcase.capp.AccountEditField, 100003);
            testcase.type(testcase.capp.PINEditField, 123123);
            pause(10);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.QueryButton);
            testcase.press(testcase.sapp.acc.ManageButton);
            testcase.press(testcase.sapp.acc.QueryButton);
            testcase.press(testcase.capp.LogInButton);
            testcase.press(testcase.capp.QueryButton);
            if (testcase.atm.BalanceEditField.Value ~= testcase.capp.BalanceEditField.Value || testcase.capp.BalanceEditField.Value ~= testcase.sapp.acc.BalanceEditField.Value)
                testcase.verifyFail;
            end
            pause(5)
            testcase.press(testcase.atm.ReturnButton);
            testcase.press(testcase.atm.WithdrawButton);
            testcase.type(testcase.atm.WithdrawAmountEditField, 400);
            testcase.press(testcase.atm.WithdrawConfirmButton);
            pause(5);
            testcase.press(testcase.atm.CNYImage);
            testcase.press(testcase.atm.ReturnButton);
            testcase.press(testcase.atm.QueryButton);
            pause(5);
            testcase.press(testcase.capp.ReturnButton);
            testcase.press(testcase.capp.QueryButton);
            testcase.press(testcase.sapp.acc.ReturnButton);
            testcase.press(testcase.sapp.acc.QueryButton);
            if (testcase.atm.BalanceEditField.Value ~= testcase.capp.BalanceEditField.Value || testcase.capp.BalanceEditField.Value ~= testcase.sapp.acc.BalanceEditField.Value)
                testcase.verifyFail;
            end
            pause(10);
        end

    end
    
end
