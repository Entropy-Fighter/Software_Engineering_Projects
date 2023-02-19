classdef Database < handle
    properties
        user_data = cell(1000,3);
        account_data = cell(1000,3);
        records_data = cell(1000,4);
        account_cnt = 0;
        user_cnt = 0;
        records_cnt = 0;
        current_index1 = 0;
    end
    methods
        function BankDatabase = Database()
            BankDatabase.user_data = readcell('user_data.xlsx','Range','A1:C1000');
            BankDatabase.account_data = readcell('account_data.xlsx','Range','A1:C1000');
            BankDatabase.records_data = readcell('records_data.xlsx','Range','A1:D1000'); 
            cell2 = readcell('user_data.xlsx','Range','D1');
            BankDatabase.user_cnt = cell2{1};
            cell1 = readcell('account_data.xlsx','Range','D1');
            BankDatabase.account_cnt = cell1{1};
            cell3 =  readcell('records_data.xlsx','Range','E1');
            BankDatabase.records_cnt = cell3{1};
        end
        
        function addAccount(BankDatabase,data)
            BankDatabase.user_data = readcell('user_data.xlsx','Range','A1:C1000');
            BankDatabase.account_data = readcell('account_data.xlsx','Range','A1:C1000');
            cell2 = readcell('user_data.xlsx','Range','D1');
            BankDatabase.user_cnt = cell2{1};
            cell1 = readcell('account_data.xlsx','Range','D1');
            BankDatabase.account_cnt = cell1{1};
            
            BankDatabase.account_cnt = BankDatabase.account_cnt + 1;
            BankDatabase.account_data(BankDatabase.account_cnt, :) = data; 
            writecell(BankDatabase.account_data, 'Data/account_data.xlsx');
            writematrix(BankDatabase.account_cnt, 'Data/account_data.xlsx', 'Range', 'D1');
            %xlswrite
        end
        
        function new_account = createAccount(BankDatabase)
            BankDatabase.user_data = readcell('user_data.xlsx','Range','A1:C1000');
            BankDatabase.account_data = readcell('account_data.xlsx','Range','A1:C1000');
            cell2 = readcell('user_data.xlsx','Range','D1');
            BankDatabase.user_cnt = cell2{1};
            cell1 = readcell('account_data.xlsx','Range','D1');
            BankDatabase.account_cnt = cell1{1};
            
            new_account = BankDatabase.account_cnt+100000;
        end
        
        function addUser(BankDatabase,data)
            BankDatabase.user_data = readcell('user_data.xlsx','Range','A1:C1000');
            BankDatabase.account_data = readcell('account_data.xlsx','Range','A1:C1000');
            cell2 = readcell('user_data.xlsx','Range','D1');
            BankDatabase.user_cnt = cell2{1};
            cell1 = readcell('account_data.xlsx','Range','D1');
            BankDatabase.account_cnt = cell1{1};
            
            BankDatabase.user_cnt = BankDatabase.user_cnt + 1;
            BankDatabase.user_data(BankDatabase.user_cnt, :) = data; 
            writecell(BankDatabase.user_data, 'Data/user_data.xlsx');
            writematrix(BankDatabase.user_cnt, 'Data/user_data.xlsx', 'Range', 'D1');
        end
        
        function new_user = createUser(BankDatabase)
            BankDatabase.user_data = readcell('user_data.xlsx','Range','A1:C1000');
            BankDatabase.account_data = readcell('account_data.xlsx','Range','A1:C1000');
            cell2 = readcell('user_data.xlsx','Range','D1');
            BankDatabase.user_cnt = cell2{1};
            cell1 = readcell('account_data.xlsx','Range','D1');
            BankDatabase.account_cnt = cell1{1};
            
            new_user = BankDatabase.user_cnt+10000;
        end
        
        function changeUserpassword(BankDatabase,password)
            BankDatabase.user_data = readcell('user_data.xlsx','Range','A1:C1000');
            BankDatabase.account_data = readcell('account_data.xlsx','Range','A1:C1000');
            cell2 = readcell('user_data.xlsx','Range','D1');
            BankDatabase.user_cnt = cell2{1};
            cell1 = readcell('account_data.xlsx','Range','D1');
            BankDatabase.account_cnt = cell1{1};
            
            BankDatabase.user_data{BankDatabase.current_index1, 3} = password; 
            writecell(BankDatabase.user_data, 'Data/user_data.xlsx');
        end
        
        function balance = appQuery(BankDatabase, current_index)
            BankDatabase.user_data = readcell('user_data.xlsx','Range','A1:C1000');
            BankDatabase.account_data = readcell('account_data.xlsx','Range','A1:C1000');
            cell2 = readcell('user_data.xlsx','Range','D1');
            BankDatabase.user_cnt = cell2{1};
            cell1 = readcell('account_data.xlsx','Range','D1');
            BankDatabase.account_cnt = cell1{1};
            
            balance = BankDatabase.account_data{current_index, 3};
        end
        
        function appTransfer(BankDatabase,current_index, account_index, amount)
            BankDatabase.user_data = readcell('user_data.xlsx','Range','A1:C1000');
            BankDatabase.account_data = readcell('account_data.xlsx','Range','A1:C1000');
            cell2 = readcell('user_data.xlsx','Range','D1');
            BankDatabase.user_cnt = cell2{1};
            cell1 = readcell('account_data.xlsx','Range','D1');
            BankDatabase.account_cnt = cell1{1};
            
            BankDatabase.account_data{current_index, 3} = BankDatabase.account_data{current_index, 3} - amount;
            BankDatabase.account_data{account_index, 3} = BankDatabase.account_data{account_index, 3} + amount;
            writecell(BankDatabase.account_data, 'Data/account_data.xlsx');
        end
        
        function changeAccountPIN(BankDatabase,current_index,password)
            BankDatabase.user_data = readcell('user_data.xlsx','Range','A1:C1000');
            BankDatabase.account_data = readcell('account_data.xlsx','Range','A1:C1000');
            cell2 = readcell('user_data.xlsx','Range','D1');
            BankDatabase.user_cnt = cell2{1};
            cell1 = readcell('account_data.xlsx','Range','D1');
            BankDatabase.account_cnt = cell1{1};
            
            BankDatabase.account_data{current_index, 2} = password; 
            writecell(BankDatabase.account_data, 'Data/account_data.xlsx');
        end
        
        function Deposit(BankDatabase,current_index, amount)
            BankDatabase.user_data = readcell('user_data.xlsx','Range','A1:C1000');
            BankDatabase.account_data = readcell('account_data.xlsx','Range','A1:C1000');
            cell2 = readcell('user_data.xlsx','Range','D1');
            BankDatabase.user_cnt = cell2{1};
            cell1 = readcell('account_data.xlsx','Range','D1');
            BankDatabase.account_cnt = cell1{1};
            
            BankDatabase.account_data{current_index, 3} = BankDatabase.account_data{current_index, 3} + amount;
            writecell(BankDatabase.account_data, 'Data/account_data.xlsx');
        end
        
        function Withdraw(BankDatabase,current_index, amount)
            BankDatabase.user_data = readcell('user_data.xlsx','Range','A1:C1000');
            BankDatabase.account_data = readcell('account_data.xlsx','Range','A1:C1000');
            cell2 = readcell('user_data.xlsx','Range','D1');
            BankDatabase.user_cnt = cell2{1};
            cell1 = readcell('account_data.xlsx','Range','D1');
            BankDatabase.account_cnt = cell1{1};
            
            BankDatabase.account_data{current_index, 3} = BankDatabase.account_data{current_index, 3} - amount;
             writecell(BankDatabase.account_data, 'Data/account_data.xlsx');
        end
        
        function Record(BankDatabase, account, operation, amount, account1)
            BankDatabase.user_data = readcell('user_data.xlsx','Range','A1:C1000');
            BankDatabase.account_data = readcell('account_data.xlsx','Range','A1:C1000');
            BankDatabase.records_data = readcell('records_data.xlsx','Range','A1:D1000'); 
            cell2 = readcell('user_data.xlsx','Range','D1');
            BankDatabase.user_cnt = cell2{1};
            cell1 = readcell('account_data.xlsx','Range','D1');
            BankDatabase.account_cnt = cell1{1};
            cell3 =  readcell('records_data.xlsx','Range','E1');
            BankDatabase.records_cnt = cell3{1};
            
            BankDatabase.records_cnt = BankDatabase.records_cnt + 1;
            BankDatabase.records_data{BankDatabase.records_cnt, 1} = account;
            BankDatabase.records_data{BankDatabase.records_cnt, 2} = operation;
            BankDatabase.records_data{BankDatabase.records_cnt, 3} = amount;
            BankDatabase.records_data{BankDatabase.records_cnt, 4} = account1;
             writecell(BankDatabase.records_data, 'Data/records_data.xlsx');
             writematrix(BankDatabase.records_cnt, 'Data/records_data.xlsx', 'Range', 'E1');
        end
        
        function Cancel(BankDatabase,current_index)
            BankDatabase.user_data = readcell('user_data.xlsx','Range','A1:C1000');
            BankDatabase.account_data = readcell('account_data.xlsx','Range','A1:C1000');
            cell2 = readcell('user_data.xlsx','Range','D1');
            BankDatabase.user_cnt = cell2{1};
            cell1 = readcell('account_data.xlsx','Range','D1');
            BankDatabase.account_cnt = cell1{1};
            
            BankDatabase.account_data{current_index, 1} = BankDatabase.account_data{current_index, 1} + 1000000;
            writecell(BankDatabase.account_data, 'Data/account_data.xlsx');
        end
        
        function Freeze(BankDatabase,current_index)
            BankDatabase.user_data = readcell('user_data.xlsx','Range','A1:C1000');
            BankDatabase.account_data = readcell('account_data.xlsx','Range','A1:C1000');
            cell2 = readcell('user_data.xlsx','Range','D1');
            BankDatabase.user_cnt = cell2{1};
            cell1 = readcell('account_data.xlsx','Range','D1');
            BankDatabase.account_cnt = cell1{1};
            
            BankDatabase.account_data{current_index, 1} = BankDatabase.account_data{current_index, 1} + 2000000;
             writecell(BankDatabase.account_data, 'Data/account_data.xlsx');
        end
        
        function Unfreeze(BankDatabase,current_index)
            BankDatabase.user_data = readcell('user_data.xlsx','Range','A1:C1000');
            BankDatabase.account_data = readcell('account_data.xlsx','Range','A1:C1000');
            cell2 = readcell('user_data.xlsx','Range','D1');
            BankDatabase.user_cnt = cell2{1};
            cell1 = readcell('account_data.xlsx','Range','D1');
            BankDatabase.account_cnt = cell1{1};
            
            BankDatabase.account_data{current_index, 1} = BankDatabase.account_data{current_index, 1} - 2000000;
            writecell(BankDatabase.account_data, 'Data/account_data.xlsx');
        end
        
        function flag = CheckAccount(BankDatabase,index, account)
            BankDatabase.user_data = readcell('user_data.xlsx','Range','A1:C1000');
            BankDatabase.account_data = readcell('account_data.xlsx','Range','A1:C1000');
            cell2 = readcell('user_data.xlsx','Range','D1');
            BankDatabase.user_cnt = cell2{1};
            cell1 = readcell('account_data.xlsx','Range','D1');
            BankDatabase.account_cnt = cell1{1};
            
            if BankDatabase.account_data{index, 1} == account
                flag = 1;
            else
                flag = 0;
            end

        end
        
    end
end