classdef UItestStaff < matlab.uitest.TestCase

    properties
        DB              Database
        sapp            StaffAPP
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
            testcase.sapp.BankDatabase = testcase.DB;
        end
    end

    methods(TestMethodTeardown)
        function closeFigure(testcase)
            delete(testcase.sapp.acc);
            delete(testcase.sapp.rec);
            delete(testcase.sapp);
            delete(testcase.DB);
        end
    end


    methods(Test)
        
        function CorrectLogin(testcase) % T1.1
            % State: Startpage
            % Input: Type in correct UserID and password, click login
            % Expected Output: Main function page
            testcase.type(testcase.sapp.LogUserIDEditField, 10000);
            testcase.type(testcase.sapp.LogPasswordEditField, 123456);
            testcase.press(testcase.sapp.LogInButton);
            testcase.verifyTrue(testcase.sapp.CreateAccountButton.Visible);
        end

        function IncorrectIDAndCorrectPsdLogin(testcase) % T1.2
            % State: Startpage
            % Input: Incorrect UserID and correct password, click login
            % Expected Output: Notify about incorrect ID
            testcase.type(testcase.sapp.LogUserIDEditField, 1000110);
            testcase.type(testcase.sapp.LogPasswordEditField, 123456);
            testcase.press(testcase.sapp.LogInButton);
            testcase.verifyEqual(string(testcase.sapp.LogTextArea.Value), "Wrong ID! Try again!");
        end

        function CorrectIDAndIncorrectPsdLogin(testcase) % T1.3
            % State: Startpage
            % Input: Correct UserID and correct password, click login
            % Expected Output: Notify about incorrect password
            testcase.type(testcase.sapp.LogUserIDEditField, 10000);
            testcase.type(testcase.sapp.LogPasswordEditField, 654321);
            testcase.press(testcase.sapp.LogInButton);
            testcase.verifyEqual(string(testcase.sapp.LogTextArea.Value), "Wrong Password! Try again!");
        end

        function CreateAccount(testcase) % T2.1
            % State: Main function page
            % Input: Click CreateAccount
            % Expected Output: CreateAccount page
            testcase.type(testcase.sapp.LogUserIDEditField, 10000);
            testcase.type(testcase.sapp.LogPasswordEditField, 123456);
            testcase.press(testcase.sapp.LogInButton);
            testcase.press(testcase.sapp.CreateAccountButton);
            testcase.verifyTrue(testcase.sapp.CreateAccountLabel.Visible);
        end

        function CorrectPINCreateAccount(testcase) % T2.2
            % State: CreateAccount page
            % Input: Two identical valid PINs, click confirm
            % Expected Output: Notify about successful register
            testcase.type(testcase.sapp.LogUserIDEditField, 10000);
            testcase.type(testcase.sapp.LogPasswordEditField, 123456);
            testcase.press(testcase.sapp.LogInButton);
            testcase.press(testcase.sapp.CreateAccountButton);
            testcase.type(testcase.sapp.CreatePINEditField, 987789);
            testcase.type(testcase.sapp.CreateRepeatPINEditField, 987789);
            testcase.press(testcase.sapp.CreateConfirmButton);
            testcase.verifyEqual(string(testcase.sapp.CreateTextArea.Value), "Register sucessfully! Return to manage your account.")
        end

        function NotIdenticalPINCreateAccount(testcase) % T2.3
            % State: CreateAccount page
            % Input: Two non-identical 6-bit PINs, click confirm
            % Expected Output: Notify about non-identical password
            testcase.type(testcase.sapp.LogUserIDEditField, 10000);
            testcase.type(testcase.sapp.LogPasswordEditField, 123456);
            testcase.press(testcase.sapp.LogInButton);
            testcase.press(testcase.sapp.CreateAccountButton);
            testcase.type(testcase.sapp.CreatePINEditField, 987789);
            testcase.type(testcase.sapp.CreateRepeatPINEditField, 789987);
            testcase.press(testcase.sapp.CreateConfirmButton);
            testcase.verifyEqual(string(testcase.sapp.CreateTextArea.Value), "Check your password again!")
        end

        function IdenticalInvalidPINCreateAccount(testcase) % T2.4
            % State: CreateAccount page
            % Input: Two identical non-6-bit PINs
            % Expected Output: Notify about non-6-bit
            testcase.type(testcase.sapp.LogUserIDEditField, 10000);
            testcase.type(testcase.sapp.LogPasswordEditField, 123456);
            testcase.press(testcase.sapp.LogInButton);
            testcase.press(testcase.sapp.CreateAccountButton);
            testcase.type(testcase.sapp.CreatePINEditField, 987);
            testcase.type(testcase.sapp.CreateRepeatPINEditField, 987);
            testcase.press(testcase.sapp.CreateConfirmButton);
            testcase.verifyEqual(string(testcase.sapp.CreateTextArea.Value), "Your password is not 6-bit. Try again!")
        end

        function ValidCreateAccountAndReturn(testcase) % T2.5
            % State: CreateAccount page
            % Input: Two identical valid PINs, click confirm, click return
            % Expected Output: Main function page
            testcase.type(testcase.sapp.LogUserIDEditField, 10000);
            testcase.type(testcase.sapp.LogPasswordEditField, 123456);
            testcase.press(testcase.sapp.LogInButton);
            testcase.press(testcase.sapp.CreateAccountButton);
            testcase.type(testcase.sapp.CreatePINEditField, 987789);
            testcase.type(testcase.sapp.CreateRepeatPINEditField, 987789);
            testcase.press(testcase.sapp.CreateConfirmButton);
            testcase.press(testcase.sapp.ReturnButton);
            testcase.verifyTrue(testcase.sapp.CreateAccountButton.Visible);
        end

        function ManageAccount(testcase) % T3.1
            % State: Main function page
            % Input: Click ManageAccount
            % Expected Output: Open ManageAccountWindow
            testcase.type(testcase.sapp.LogUserIDEditField, 10000);
            testcase.type(testcase.sapp.LogPasswordEditField, 123456);
            testcase.press(testcase.sapp.LogInButton);
            testcase.press(testcase.sapp.ManageAccountButton);
            testcase.verifyNotEmpty(testcase.sapp.acc);
        end

        function InvalidManageAccount(testcase) % T3.2
            % State: ManageAccount
            % Input: Invalid account
            % Expected Output: Notify about WrongID
            testcase.type(testcase.sapp.LogUserIDEditField, 10000);
            testcase.type(testcase.sapp.LogPasswordEditField, 123456);
            testcase.press(testcase.sapp.LogInButton);
            testcase.press(testcase.sapp.ManageAccountButton);
            testcase.type(testcase.sapp.acc.AccountEditField, 10000003);
            testcase.press(testcase.sapp.acc.ManageButton);
            testcase.verifyEqual(string(testcase.sapp.acc.EnterAccountTextArea.Value), "Wrong ID! Try again!");
        end

        function ValidManageAccount(testcase) % T3.3
            % State: ManageAccount
            % Input: Valid account
            % Expected Output: Enter a new page
            testcase.type(testcase.sapp.LogUserIDEditField, 10000);
            testcase.type(testcase.sapp.LogPasswordEditField, 123456);
            testcase.press(testcase.sapp.LogInButton);
            testcase.press(testcase.sapp.ManageAccountButton);
            testcase.type(testcase.sapp.acc.AccountEditField, 100003);
            testcase.press(testcase.sapp.acc.ManageButton);
            testcase.verifyTrue(testcase.sapp.acc.UnFreezeButton.Visible);
        end

        function ReturnFromManageAccount(testcase) % T3.4
            % State: ManageAccount
            % Input: Click return
            % Expected Output: Main function page
            testcase.type(testcase.sapp.LogUserIDEditField, 10000);
            testcase.type(testcase.sapp.LogPasswordEditField, 123456);
            testcase.press(testcase.sapp.LogInButton);
            testcase.press(testcase.sapp.ManageAccountButton);
            testcase.press(testcase.sapp.acc.ReturnButton);
            try
                testcase.sapp.acc.AccountUIFigure;
            catch
                return
            end
            testcase.verifyFail;
        end

        function Record(testcase) % T4.1
            % State: Main function page
            % Input: Click Record
            % Expected Output: Record page
            testcase.type(testcase.sapp.LogUserIDEditField, 10000);
            testcase.type(testcase.sapp.LogPasswordEditField, 123456);
            testcase.press(testcase.sapp.LogInButton);
            testcase.press(testcase.sapp.RecordsButton);
            testcase.verifyNotEmpty(testcase.sapp.rec);
        end

        function RecordTest(testcase) % T4.2
            % State: Record page
            testcase.type(testcase.sapp.LogUserIDEditField, 10000);
            testcase.type(testcase.sapp.LogPasswordEditField, 123456);
            testcase.press(testcase.sapp.LogInButton);
            testcase.press(testcase.sapp.RecordsButton);
            testcase.type(testcase.sapp.rec.AccountEditField, 100003);
            testcase.press(testcase.sapp.rec.QueryButton);
            temp = testcase.sapp.rec.UITable.Data(:, 1);
            for i = 1:length(temp)
                if double(i) ~= 100003 && isempty(i)
                    testcase.verifyFail;
                    return
                end
            end
            testcase.press(testcase.sapp.rec.Query2Button);
            temp = testcase.sapp.rec.UITable.Data(:, 2);
            for i = 1:length(temp)
                if string(i) ~= "D" && isempty(i)
                    testcase.verifyFail;
                    return
                end
            end
        end

        function QuitRecord(testcase) % T4.3
            % State: Record page
            % Input: Click return
            % Expected Output: Main function page
            testcase.type(testcase.sapp.LogUserIDEditField, 10000);
            testcase.type(testcase.sapp.LogPasswordEditField, 123456);
            testcase.press(testcase.sapp.LogInButton);
            testcase.press(testcase.sapp.RecordsButton);
            testcase.press(testcase.sapp.rec.ReturnButton);
            try
                testcase.sapp.rec.AccountUIFigure;
            catch
                return
            end
            testcase.verifyFail;
        end

        function ChangePsd(testcase) % T5.1
            % State: Main function page
            % Input: Click change password
            % Expected Output: ChangePsd
            testcase.type(testcase.sapp.LogUserIDEditField, 10000);
            testcase.type(testcase.sapp.LogPasswordEditField, 123456);
            testcase.press(testcase.sapp.LogInButton);
            testcase.press(testcase.sapp.ChangePasswordButton);
            testcase.verifyTrue(testcase.sapp.NewPasswordLabel.Visible);
        end

        function QuitChangePsd(testcase) % T5.2
            % State: ChangePsd
            % Input: Click return
            % Expected Output: Main function page
            testcase.type(testcase.sapp.LogUserIDEditField, 10000);
            testcase.type(testcase.sapp.LogPasswordEditField, 123456);
            testcase.press(testcase.sapp.LogInButton);
            testcase.press(testcase.sapp.ChangePasswordButton);
            testcase.press(testcase.sapp.ReturnButton);
            testcase.verifyTrue(testcase.sapp.CreateAccountButton.Visible);
        end

        function Logout(testcase) % T6.1
            % State: Main function page
            % Input: Click Logout
            % Expected Output: Startpage
            testcase.type(testcase.sapp.LogUserIDEditField, 10000);
            testcase.type(testcase.sapp.LogPasswordEditField, 123456);
            testcase.press(testcase.sapp.LogInButton);
            testcase.press(testcase.sapp.LogOutButton);
            testcase.verifyTrue(testcase.sapp.LogTextArea.Visible);
        end

        function Register(testcase) % T7.1
            % State: Startpage
            % Input: Click register
            % Expected Output: Register page
            testcase.press(testcase.sapp.LogRegisterButton);
            testcase.verifyTrue(testcase.sapp.RegRegisterButton.Visible);
        end

        function ValidRegisterAndReturn(testcase) % T7.2
            % State: Register page
            % Input: Random username and valid identical passwords, click register, click return
            % Expected Output: Notify about success, Then back to Startpage
            testcase.press(testcase.sapp.LogRegisterButton);
            testcase.type(testcase.sapp.RegUserNameEditField, "qwerqwer");
            testcase.type(testcase.sapp.RegPasswordEditField, 123098);
            testcase.type(testcase.sapp.RegRepeatPasswordEditField, 123098);
            testcase.press(testcase.sapp.RegRegisterButton);
            testcase.verifyEqual(string(testcase.sapp.RegTextArea.Value), "Register sucessfully! Return to log in.")
            testcase.press(testcase.sapp.ReturnButton);
            testcase.verifyTrue(testcase.sapp.LogTextArea.Visible);
        end

    end
    
end
