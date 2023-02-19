classdef UItestATM < matlab.uitest.TestCase

    properties
        DB              Database
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
            testcase.atm = ATM;
            testcase.atm.AccountDatabase = testcase.DB;
        end
    end

    methods(TestMethodTeardown)
        function closeFigure(testcase)
            delete(testcase.atm);
            delete(testcase.DB);
        end
    end


    methods(Test)
        
        function InsertCardValid(testcase) % T1.1
            % State: Card not inserted
            % Input: Click on "Insert Card"
            % Expected Output: Enter account and PIN
            testcase.press(testcase.atm.InsertCardButton);
            testcase.verifyFalse(testcase.atm.InsertCardLabel.Visible);
            testcase.verifyTrue(testcase.atm.EnterAccountTextArea.Visible);
        end

        function InsertCardInvalid(testcase) % T1.2
            % State: Card not inserted
            % Input: Input "n", click on "Insert Card"
            % Expected Output: Notify about invalid card
            testcase.atm.press('n');
            testcase.press(testcase.atm.InsertCardButton);
            testcase.verifyTrue(testcase.atm.InsertCardLabel.Visible);
            testcase.verifyEqual(string(testcase.atm.InsertCardLabel.Text), "Your card is invalid! Please try another!");
        end

        function CorrectAccountAndPIN(testcase) % T2.1
            % State: Enter account and PIN
            % Input: Correct account and PIN
            % Expected Output: Select transaction
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.verifyTrue(testcase.atm.TransactionLabel.Visible);
        end

        function IncorrectAccountCorrectPIN(testcase) % T2.2
            % State: Enter account and PIN
            % Input: Incorrect account and correct PIN
            % Expected Output: Display message about wrong account
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 11100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.verifyEqual(string(testcase.atm.EnterAccountTextArea.Value), "Wrong ID! Try again!");
        end

        function IncorrectPINcorrectAccount(testcase) % T2.3
            % State: Enter account and PIN
            % Input: Incorrect PIN and correct account
            % Expected Output: Display message about wrong PIN
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123423);
            testcase.press(testcase.atm.LogInButton);
            testcase.verifyEqual(string(testcase.atm.EnterAccountTextArea.Value), "Wrong Password! Try again!");
        end

        function IncorrectAccountAndPIN(testcase) % T2.4
            % State: Enter account and PIN
            % Input: Incorrect account and PIN
            % Expected Output: Display message about wrong account
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 11100003);
            testcase.type(testcase.atm.PINEditField, 34563456);
            testcase.press(testcase.atm.LogInButton);
            testcase.verifyEqual(string(testcase.atm.EnterAccountTextArea.Value), "Wrong ID! Try again!");
        end

        function ReturnFromLogin(testcase) % T2.5
            % State: Enter account and PIN
            % Input: Click return
            % Expected Output: Card not inserted
            testcase.press(testcase.atm.InsertCardButton);
            testcase.press(testcase.atm.ReturnButton);
            testcase.verifyTrue(testcase.atm.InsertImage.Visible);
        end

        function Query(testcase) % T3.1
            % State: Select transaction
            % Input: Click on Query
            % Expected Output: Display Balance
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.QueryButton);
            testcase.verifyTrue(testcase.atm.BalanceyuanLabel.Visible);
        end

        function QueryAndReturn(testcase) % T3.2
            % State: Select transaction
            % Input: Click on Query, then click on return
            % Expected Output: Unchanged
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.QueryButton);
            testcase.press(testcase.atm.ReturnButton);
            testcase.verifyTrue(testcase.atm.TransactionLabel.Visible);
        end

        function Withdraw(testcase) % T4.1
            % State: Select transaction
            % Input: Click on withdraw
            % Expected Output: Display withdraw page
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.WithdrawButton);
            testcase.verifyTrue(testcase.atm.WithdrawLabel.Visible);
            testcase.verifyEqual(string(testcase.atm.WithdrawLabel.Value), "Please fill in the amount you want to withdraw.");
        end

        function WithdrawCorrectTakeMoney(testcase) % T4.2
            % State: Withdraw page
            % Input: Correct amount of cash
            % Expected Output: Money appears
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.WithdrawButton);
            testcase.type(testcase.atm.WithdrawAmountEditField, 200);
            testcase.press(testcase.atm.WithdrawConfirmButton);
            testcase.verifyTrue(testcase.atm.CNYImage.Visible);
        end

        function TakeMoneyAwayAndReturn(testcase) % T4.3
            % State: Money appears
            % Input: Click on the money, then return
            % Expected Output: Select transaction
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.WithdrawButton);
            testcase.type(testcase.atm.WithdrawAmountEditField, 200);
            testcase.press(testcase.atm.WithdrawConfirmButton);
            testcase.press(testcase.atm.CNYImage);
            testcase.press(testcase.atm.ReturnButton);
            testcase.verifyTrue(testcase.atm.TransactionLabel.Visible);
        end

        function NotTakingMoneyAndReturn(testcase) % T4.4
            % State: Money appears
            % Input: Click on return
            % Expected Output: Notify about taking money away
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.WithdrawButton);
            testcase.type(testcase.atm.WithdrawAmountEditField, 200);
            testcase.press(testcase.atm.WithdrawConfirmButton);
            testcase.press(testcase.atm.ReturnButton);
            testcase.verifyEqual(string(testcase.atm.WithdrawLabel.Value), "Please take your money away!");
        end

        function WithdrawNegativeMoney(testcase) % T4.5
            % State: Withdraw page
            % Input: Negative number
            % Expected Output: Notify about negative money
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.WithdrawButton);
            testcase.type(testcase.atm.WithdrawAmountEditField, -200);
            testcase.press(testcase.atm.WithdrawConfirmButton);
            testcase.press(testcase.atm.ReturnButton);
            testcase.verifyEqual(string(testcase.atm.WithdrawLabel.Value), "The amount should be positive!");
        end

        function WithdrawInvalidMoney(testcase) % T4.6
            % State: Withdraw page
            % Input: Not multiples of 100
            % Expected Output: Notify about invalid money
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.WithdrawButton);
            testcase.type(testcase.atm.WithdrawAmountEditField, 234.56);
            testcase.press(testcase.atm.WithdrawConfirmButton);
            testcase.press(testcase.atm.ReturnButton);
            testcase.verifyEqual(string(testcase.atm.WithdrawLabel.Value), "You can only withdraw multiples of 100CNY.");
        end

        function WithdrawTooMuchMoney(testcase) % T4.7
            % State: Withdraw page
            % Input: A very big number
            % Expected Output: Notify about not enough
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.WithdrawButton);
            testcase.type(testcase.atm.WithdrawAmountEditField, 2138471628374);
            testcase.press(testcase.atm.WithdrawConfirmButton);
            testcase.press(testcase.atm.ReturnButton);
            testcase.verifyEqual(string(testcase.atm.WithdrawLabel.Value), "Not enough money!");
        end

        function WithdrawGiveUp(testcase) % T4.8
            % State: Withdraw page
            % Input: Click return
            % Expected Output: Select transaction
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.WithdrawButton);
            testcase.press(testcase.atm.ReturnButton);
            testcase.verifyTrue(testcase.atm.TransactionLabel.Visible);
        end

        function ChangePIN(testcase) % T5.1
            % State: Select transaction
            % Input: Click on change PIN
            % Expected Output: Change PIN page
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.ChangePINButton);
            testcase.verifyTrue(testcase.atm.ChangePINLabel.Visible);
        end

        function ValidChangePIN(testcase) % T5.2
            % State: Change PIN page
            % Input: Input valid PIN and same repetition, confirm
            % Expected Output: Notify about success
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.ChangePINButton);
            testcase.type(testcase.atm.NewPINEditField, 123123);
            testcase.type(testcase.atm.RepeatNewPINEditField, 123123);
            testcase.press(testcase.atm.ChangePINConfirmButton);
            testcase.verifyEqual(string(testcase.atm.ChangePINLabel.Value), "Change sucessfully!");
        end

        function InvalidNewPIN(testcase) % T5.3
            % State: Change PIN page
            % Input: Input non-6-bit identical PIN and confirm
            % Expected Output: Notify about invalid
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.ChangePINButton);
            testcase.type(testcase.atm.NewPINEditField, 12312312);
            testcase.type(testcase.atm.RepeatNewPINEditField, 12312312);
            testcase.press(testcase.atm.ChangePINConfirmButton);
            testcase.verifyEqual(string(testcase.atm.ChangePINLabel.Value), "Your new password is not 6-bit. Try again!");
        end

        function NonIdenticalNewPIN(testcase) % T5.4
            % State: Change PIN page
            % Input: Input non-identical 6-bit
            % Expected Output: Notify about non-identical
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.ChangePINButton);
            testcase.type(testcase.atm.NewPINEditField, 123123);
            testcase.type(testcase.atm.RepeatNewPINEditField, 321321);
            testcase.press(testcase.atm.ChangePINConfirmButton);
            testcase.verifyEqual(string(testcase.atm.ChangePINLabel.Value), "Check your new password again!");
        end

        function ValidChangePINAndReturn(testcase) % T5.5
            % State: Change PIN page
            % Input: Valid change PIN and return
            % Expected Output: Select transaction
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.ChangePINButton);
            testcase.type(testcase.atm.NewPINEditField, 123123);
            testcase.type(testcase.atm.RepeatNewPINEditField, 123123);
            testcase.press(testcase.atm.ChangePINConfirmButton);
            testcase.press(testcase.atm.ReturnButton);
            testcase.verifyTrue(testcase.atm.TransactionLabel.Visible);
        end

        function ChangePINGiveUp(testcase) % T5.6
            % State: Change PIN page
            % Input: Click return
            % Expected Output: Select transaction
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.ChangePINButton);
            testcase.press(testcase.atm.ReturnButton);
            testcase.verifyTrue(testcase.atm.TransactionLabel.Visible);
        end

        function Transfer(testcase) % T6.1
            % State: Select transaction
            % Input: Click transfer
            % Expected Output: Transfer page
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.TransferButton);
            testcase.verifyTrue(testcase.atm.TransferLabel.Visible);
        end

        function ValidTransfer(testcase) % T6.2
            % State: Transfer page
            % Input: Valid account and amount, confirm
            % Expected Output: Notify about success
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.TransferButton);
            testcase.type(testcase.atm.TransferEditField, 100004);
            testcase.type(testcase.atm.TransferAmountEditField, 123.45);
            testcase.press(testcase.atm.TransferConfirmButton);
            testcase.verifyEqual(string(testcase.atm.TransferLabel.Value), "Transfer successfully! If you want to transfer again, please return and continue.")
        end

        function InvalidAccount(testcase) % T6.3
            % State: Transfer page
            % Input: Invalid account, valid amount, confirm
            % Expected Output: Notify about invalid account
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.TransferButton);
            testcase.type(testcase.atm.TransferEditField, 10000004);
            testcase.type(testcase.atm.TransferAmountEditField, 123.45);
            testcase.press(testcase.atm.TransferConfirmButton);
            testcase.verifyEqual(string(testcase.atm.TransferLabel.Value), "Wrong account!")
        end

        function NegativeAmount(testcase) % T6.4
            % State: Transfer page
            % Input: Valid account, negative amount, confirm
            % Expected Output: Notify about negative
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.TransferButton);
            testcase.type(testcase.atm.TransferEditField, 100004);
            testcase.type(testcase.atm.TransferAmountEditField, -123.45);
            testcase.press(testcase.atm.TransferConfirmButton);
            testcase.verifyEqual(string(testcase.atm.TransferLabel.Value), "The amount should be positive!")
        end

        function TooMuchTransfer(testcase) % T6.5
            % State: Transfer page
            % Input: Valid account, no enough money, confirm
            % Expected Output: Notify about not enough
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.TransferButton);
            testcase.type(testcase.atm.TransferEditField, 100004);
            testcase.type(testcase.atm.TransferAmountEditField, 3289147298374);
            testcase.press(testcase.atm.TransferConfirmButton);
            testcase.verifyEqual(string(testcase.atm.TransferLabel.Value), "Not enough money!")
        end

        function ValidTransferAndReturn(testcase) % T6.6
            % State: Transfer page
            % Input: Valid account and amount, confirm, return
            % Expected Output: Select transaction
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.TransferButton);
            testcase.type(testcase.atm.TransferEditField, 100004);
            testcase.type(testcase.atm.TransferAmountEditField, 123.45);
            testcase.press(testcase.atm.TransferConfirmButton);
            testcase.press(testcase.atm.ReturnButton);
            testcase.verifyTrue(testcase.atm.TransactionLabel.Visible);
        end

        function TransferReturn(testcase) % T6.7
            % State: Transfer page
            % Input: Click return
            % Expected Output: Select transaction
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.TransferButton);
            testcase.press(testcase.atm.ReturnButton);
            testcase.verifyTrue(testcase.atm.TransactionLabel.Visible);
        end

        function Deposit(testcase) % T7.1
            % State: Select transaction
            % Input: Click deposit
            % Expected Output: Deposit page
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.DepositButton);
            testcase.verifyTrue(testcase.atm.DepositLabel.Visible);
        end

        function ValidDeposit(testcase) % T7.2
            % State: Deposit
            % Input: Enter amount, confirm
            % Expected Output: Notify about put cash
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.DepositButton);
            testcase.type(testcase.atm.DepositAmountEditField, 200);
            testcase.press(testcase.atm.DepositConfirmButton);
            testcase.verifyEqual(string(testcase.atm.DepositLabel.Value), "Please put your cash below.")
        end

        function NegativeDeposit(testcase) % T7.3
            % State: Deposit
            % Input: Enter negative amount, confirm
            % Expected Output: Notify about negative amount
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.DepositButton);
            testcase.type(testcase.atm.DepositAmountEditField, -200);
            testcase.press(testcase.atm.DepositConfirmButton);
            testcase.verifyEqual(string(testcase.atm.DepositLabel.Value), "The amount should be positive!")
        end

        function PutCash(testcase) % T7.4
            % State: Deposit
            % Input: Enter valid amount, confirm, press "m"
            % Expected Output: money appears
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.DepositButton);
            testcase.type(testcase.atm.DepositAmountEditField, 200);
            testcase.press(testcase.atm.DepositConfirmButton);
            testcase.atm.press('m');
            testcase.verifyTrue(testcase.atm.CNYImage.Visible);
        end

        function TakeAwayCash(testcase) % T7.5
            % State: Deposit
            % Input: Enter valid amount, confirm, press "m", Click on the money
            % Expected Output: money disappears
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.DepositButton);
            testcase.type(testcase.atm.DepositAmountEditField, 200);
            testcase.press(testcase.atm.DepositConfirmButton);
            testcase.atm.press('m');
            testcase.press(testcase.atm.CNYImage);
            testcase.verifyFalse(testcase.atm.CNYImage.Visible);
        end

        function InvalidCashDeposit(testcase) % T7.6
            % State: Deposit
            % Input: Enter valid amount, confirm, press "n", confirm
            % Expected Output: money disappears
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.DepositButton);
            testcase.type(testcase.atm.DepositAmountEditField, 200);
            testcase.press(testcase.atm.DepositConfirmButton);
            testcase.atm.press('n');
            testcase.press(testcase.atm.DepositConfirmButton);
            testcase.verifyEqual(string(testcase.atm.DepositLabel.Value), "The money is invalid!");
        end

        function PutCashAndReturn(testcase) % T7.7
            % State: Deposit
            % Input: Enter valid amount, confirm, press "m", Click on return
            % Expected Output: Notify about taking cash
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.DepositButton);
            testcase.type(testcase.atm.DepositAmountEditField, 200);
            testcase.press(testcase.atm.DepositConfirmButton);
            testcase.atm.press('m');
            testcase.press(testcase.atm.ReturnButton);
            testcase.verifyEqual(string(testcase.atm.DepositLabel.Value), "Please take your money away!");
        end

        function FinishDepositAndReturn(testcase) % T7.8
            % State: Deposit
            % Input: Enter valid amount, confirm, press "m", confirm, Click on return
            % Expected Output: Select transaction
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.DepositButton);
            testcase.type(testcase.atm.DepositAmountEditField, 200);
            testcase.press(testcase.atm.DepositConfirmButton);
            testcase.atm.press('m');
            testcase.press(testcase.atm.DepositConfirmButton);
            testcase.press(testcase.atm.ReturnButton);
            testcase.verifyTrue(testcase.atm.TransactionLabel.Visible);
        end

        function DepositGiveUp(testcase) % T7.9
            % State: Deposit
            % Input: Click return
            % Expected Output: Select transaction
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.DepositButton);
            testcase.press(testcase.atm.ReturnButton);
            testcase.verifyTrue(testcase.atm.TransactionLabel.Visible);
        end

        function Logout(testcase) % T8.1
            % State: Select transaction
            % Input: Click logout
            % Expected Output: Enter account and PIN
            testcase.press(testcase.atm.InsertCardButton);
            testcase.type(testcase.atm.AccountEditField, 100003);
            testcase.type(testcase.atm.PINEditField, 123123);
            testcase.press(testcase.atm.LogInButton);
            testcase.press(testcase.atm.LogOutButton);
            testcase.verifyFalse(testcase.atm.InsertCardLabel.Visible);
            testcase.verifyTrue(testcase.atm.EnterAccountTextArea.Visible);
        end
    end
    
end