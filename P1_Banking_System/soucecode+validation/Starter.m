close all force;
clear;
clc;

addpath('./UI');
addpath('./Data');
addpath('./Test');

DB = Database;
sapp = StaffAPP;
atm = ATM;
capp = CustomerAPP;

sapp.BankDatabase = DB;
atm.AccountDatabase = DB;
capp.AccountDatabase = DB;