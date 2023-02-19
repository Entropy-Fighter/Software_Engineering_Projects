classdef FunctionalTest < matlab.uitest.TestCase

    properties
        control      
        patientapp         
        physicianapp     
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
            testcase.control = controller;
            testcase.patientapp = patient_UI;
            testcase.physicianapp = physician_UI;

            testcase.control.patient_UI=testcase.patientapp;
            testcase.patientapp.controller=testcase.control;
            testcase.control.physician_UI=testcase.physicianapp;
            testcase.physicianapp.controller=testcase.control;
        end
    end

    methods(TestMethodTeardown)
        function closeFigure(testcase)
            stop(testcase.physicianapp.controller.t1);
            stop(testcase.physicianapp.controller.t);
            delete(testcase.patientapp);
            delete(testcase.physicianapp);
        end
    end


    methods(Test)
        
        function CallPhysician(testcase) % T2.1.1
            % State: Physician is not called
            % Input: Click on "Call Physician"
            % Expected Output: CallingLamp becomes red
            testcase.press(testcase.patientapp.CallPhysicianButton);
            testcase.verifyEqual(testcase.physicianapp.PatientCallingLamp.Color, [1,0,0]);
            pause(2);
        end
        
        function ResolvePatientCall(testcase) % T2.2.1
            % State: Physician is not called
            % Input: Click on "Call Physician"
            % Expected Output: CallingLamp becomes red
            testcase.press(testcase.patientapp.CallPhysicianButton);
            pause(2);
            testcase.press(testcase.physicianapp.ResolvePatientCallButton);
            testcase.verifyEqual(testcase.physicianapp.PatientCallingLamp.Color, [0.5,0.5,0.5]);
            pause(2);
        end
        
        function FillInjector(testcase) % T2.2.2
            testcase.press(testcase.physicianapp.Switch);
            pause(2);
            stop(testcase.physicianapp.controller.t1);
            stop(testcase.physicianapp.controller.t);
            testcase.press(testcase.physicianapp.FillInjectorButton);
            testcase.verifyEqual(testcase.physicianapp.Left_amountTextArea.Value,{'10.00'});%%%%%%%%%
            pause(2);
        end
        
        function GetInformationByStatistics(testcase) % T2.2.3
            testcase.press(testcase.physicianapp.Switch);
            pause(2);
            
            tmp1 = testcase.physicianapp.controller.hour_injected;
            tmp2 = testcase.physicianapp.controller.day_injected;
            pause(2);
            testcase.verifyEqual(round(testcase.physicianapp.controller.Left_amount,2), round(10-0.04,2));
            testcase.verifyEqual(round(testcase.physicianapp.controller.Baseline,2), round(0.01,2));
            
            testcase.verifyEqual(round(testcase.physicianapp.controller.hour_injected,2), round(tmp1 + 0.02,2));
            testcase.verifyEqual(round(testcase.physicianapp.controller.day_injected,2), round(tmp2 + 0.02,2));
            pause(2);
            testcase.verifyEqual(round(testcase.physicianapp.controller.hour_injected,2), round(tmp1 + 0.04,2));
            testcase.verifyEqual(round(testcase.physicianapp.controller.day_injected,2), round(tmp2 + 0.04,2));
            stop(testcase.physicianapp.controller.t1);
            stop(testcase.physicianapp.controller.t);
            testcase.type(testcase.physicianapp.SetBaselineEditField, 0.02);
            start(testcase.physicianapp.controller.t1);
            start(testcase.physicianapp.controller.t);
            pause(2);    
            
            testcase.verifyEqual(round(testcase.physicianapp.controller.hour_injected,2), round(tmp1 + 0.08,2));
            testcase.verifyEqual(round(testcase.physicianapp.controller.day_injected,2), round(tmp2 + 0.08,2));
            
            testcase.type(testcase.physicianapp.SetBaselineEditField, 0.01);
            pause(1)
            
            tmp1 = testcase.physicianapp.controller.hour_injected;
            tmp2 = testcase.physicianapp.controller.day_injected;
            testcase.press(testcase.patientapp.InjectBolusButton);
            stop(testcase.physicianapp.controller.t1);
            stop(testcase.physicianapp.controller.t);
            testcase.verifyEqual(round(testcase.physicianapp.controller.hour_injected,2), round(tmp1 + 0.2,2));
            testcase.verifyEqual(round(testcase.physicianapp.controller.day_injected,2), round(tmp2 + 0.2,2));
        end
        
        function GetHour_injectedInformationByImage(testcase) % % T2.2.4
            testcase.press(testcase.physicianapp.Switch);
            pause(5);
            testcase.press(testcase.physicianapp.FunctionofthishourButton);
            pause(2);
            testcase.verifyTrue(testcase.physicianapp.hour_figure.Visible);
            delete(testcase.physicianapp.hour_figure);
            
            testcase.type(testcase.physicianapp.SetBaselineEditField, 0.03);
            pause(2);
            testcase.press(testcase.physicianapp.FunctionofthishourButton);
            pause(2);
            testcase.verifyTrue(testcase.physicianapp.hour_figure.Visible);
            delete(testcase.physicianapp.hour_figure);
            
            testcase.type(testcase.physicianapp.SetBaselineEditField, 0.02);
            pause(1);
            testcase.press(testcase.patientapp.InjectBolusButton);
            pause(2);
            testcase.press(testcase.physicianapp.FunctionofthishourButton);
            pause(2);
            testcase.verifyTrue(testcase.physicianapp.hour_figure.Visible);
            delete(testcase.physicianapp.hour_figure);
        end
        
        function  GetDay_injectedInformationByImage(testcase) % % T2.2.5
            testcase.press(testcase.physicianapp.Switch);
            pause(5);
            testcase.press(testcase.physicianapp.FunctionofTodayButton);
            pause(2);
            testcase.verifyTrue(testcase.physicianapp.day_figure.Visible);
            delete(testcase.physicianapp.day_figure);
            
            testcase.type(testcase.physicianapp.SetBaselineEditField, 0.03);
            pause(2);
            testcase.press(testcase.physicianapp.FunctionofTodayButton);
            pause(2);
            testcase.verifyTrue(testcase.physicianapp.day_figure.Visible);
            delete(testcase.physicianapp.day_figure);
            
            testcase.type(testcase.physicianapp.SetBaselineEditField, 0.02);
            pause(1);
            testcase.press(testcase.patientapp.InjectBolusButton);
            pause(2);
            testcase.press(testcase.physicianapp.FunctionofTodayButton);
            pause(2);
            testcase.verifyTrue(testcase.physicianapp.day_figure.Visible);
            delete(testcase.physicianapp.day_figure);
        end
        
        
        function InjectBolusValid(testcase) % T2.3.1
            %%%%%%%%%%%%
            % State: Panikiller is on, and patient hasn't injected bolus before
            % Input: Click on "Inject Bolus"
            % Expected Output: 
            testcase.press(testcase.physicianapp.Switch);
            pause(3);
            tmp1 = testcase.physicianapp.controller.hour_injected;
            tmp2 = testcase.physicianapp.controller.day_injected;
            
            testcase.press(testcase.patientapp.InjectBolusButton);
            stop(testcase.physicianapp.controller.t1);
            stop(testcase.physicianapp.controller.t);
            testcase.verifyEqual(round(testcase.physicianapp.controller.hour_injected,2), round(tmp1 + 0.2,2));
            testcase.verifyEqual(round(testcase.physicianapp.controller.day_injected,2), round(tmp2 + 0.2,2));
            start(testcase.physicianapp.controller.t1);
            start(testcase.physicianapp.controller.t);
            pause(2);
            testcase.press(testcase.physicianapp.FunctionofthishourButton);
            pause(2);
            delete(testcase.physicianapp.hour_figure);
            
            tmp1 = testcase.physicianapp.controller.hour_injected;
            tmp2 = testcase.physicianapp.controller.day_injected;
            
            testcase.press(testcase.patientapp.InjectBolusButton);
            stop(testcase.physicianapp.controller.t1);
            stop(testcase.physicianapp.controller.t);
            testcase.verifyEqual(round(testcase.physicianapp.controller.hour_injected,2), round(tmp1 + 0.2,2));
            testcase.verifyEqual(round(testcase.physicianapp.controller.day_injected,2), round(tmp2 + 0.2,2));
            start(testcase.physicianapp.controller.t1);
            start(testcase.physicianapp.controller.t);
            testcase.press(testcase.physicianapp.FunctionofthishourButton);
            pause(2);
            delete(testcase.physicianapp.hour_figure);
        end
        
        function InjectBolusInalid(testcase) % T2.3.2
            %%%%%%%%%%%%
            % State: Panikiller is on, 
            % Input: Click on "Inject Bolus"
            % Expected Output: 
            testcase.press(testcase.physicianapp.Switch);
            pause(2);
            testcase.press(testcase.patientapp.InjectBolusButton);
            pause(1);
            testcase.press(testcase.patientapp.InjectBolusButton);
            pause(0.5);
            testcase.press(testcase.patientapp.InjectBolusButton);
            pause(0.5);
            testcase.press(testcase.patientapp.InjectBolusButton);
            pause(2);
            testcase.press(testcase.physicianapp.FunctionofthishourButton);
            pause(2);
            delete(testcase.physicianapp.hour_figure);
            
            tmp1 = testcase.physicianapp.controller.hour_injected;
            tmp2 = testcase.physicianapp.controller.day_injected;
            testcase.press(testcase.patientapp.InjectBolusButton);
            stop(testcase.physicianapp.controller.t1);
            stop(testcase.physicianapp.controller.t);
            testcase.verifyFalse(round(testcase.physicianapp.controller.hour_injected,2)==round(tmp1 + 0.2,2));
            testcase.verifyFalse(round(testcase.physicianapp.controller.day_injected,2)==round(tmp2 + 0.2,2));
            pause(1);
            delete(testcase.patientapp.error4);
            start(testcase.physicianapp.controller.t1);
            start(testcase.physicianapp.controller.t);
            
            testcase.press(testcase.physicianapp.FunctionofthishourButton);
            pause(2);
            delete(testcase.physicianapp.hour_figure);
        end
        
        function SetBolusValid(testcase) % T2.4.1
            testcase.press(testcase.physicianapp.Switch);
            testcase.press(testcase.patientapp.InjectBolusButton);
            pause(1);
            testcase.type(testcase.physicianapp.SetBolusEditField, 0.4);
            testcase.verifyTrue(testcase.physicianapp.SetBolusEditField.Value == 0.4);
            
            tmp1 = testcase.physicianapp.controller.hour_injected;
            tmp2 = testcase.physicianapp.controller.day_injected;
            testcase.press(testcase.patientapp.InjectBolusButton);
            stop(testcase.physicianapp.controller.t1);
            stop(testcase.physicianapp.controller.t);
            testcase.verifyEqual(round(testcase.physicianapp.controller.hour_injected,2),round(tmp1 + 0.4,2));
            testcase.verifyEqual(round(testcase.physicianapp.controller.day_injected,2),round(tmp2 + 0.4,2));
            start(testcase.physicianapp.controller.t1);
            start(testcase.physicianapp.controller.t);
            pause(2);
            testcase.press(testcase.physicianapp.FunctionofthishourButton);
            pause(2);
            delete(testcase.physicianapp.hour_figure);
        end
        
         function SetBaselineValid(testcase) % T2.4.2
            testcase.press(testcase.physicianapp.Switch);
            pause(1);
            testcase.type(testcase.physicianapp.SetBaselineEditField, 0.05);
            testcase.verifyTrue(testcase.physicianapp.SetBaselineEditField.Value == 0.05);
            pause(2);
            
            tmp1 = testcase.physicianapp.controller.hour_injected;
            tmp2 = testcase.physicianapp.controller.day_injected;
            pause(2);
            stop(testcase.physicianapp.controller.t1);
            stop(testcase.physicianapp.controller.t);
            testcase.verifyEqual(round(testcase.physicianapp.controller.hour_injected,2),round(tmp1 + 0.1,2));
            testcase.verifyEqual(round(testcase.physicianapp.controller.day_injected,2),round(tmp2 + 0.1,2));
            start(testcase.physicianapp.controller.t1);
            start(testcase.physicianapp.controller.t);
            testcase.press(testcase.physicianapp.FunctionofthishourButton);
            pause(2);
            delete(testcase.physicianapp.hour_figure);

        end
        
        function SetBolusInvalid(testcase) % T2.4.3
            testcase.press(testcase.physicianapp.Switch);
            testcase.press(testcase.patientapp.InjectBolusButton);
            pause(1);
            testcase.type(testcase.physicianapp.SetBolusEditField, 0.6);
            pause(1);
            testcase.verifyTrue(testcase.physicianapp.SetBolusEditField.Value == 0.2);
            delete(testcase.physicianapp.error1);

            tmp1 = testcase.physicianapp.controller.hour_injected;
            tmp2 = testcase.physicianapp.controller.day_injected;
            testcase.press(testcase.patientapp.InjectBolusButton);
            stop(testcase.physicianapp.controller.t1);
            stop(testcase.physicianapp.controller.t);
            testcase.verifyEqual(round(testcase.physicianapp.controller.hour_injected,2),round(tmp1 + 0.2,2));
            testcase.verifyEqual(round(testcase.physicianapp.controller.day_injected,2),round(tmp2 + 0.2,2));
            start(testcase.physicianapp.controller.t1);
            start(testcase.physicianapp.controller.t);
            pause(1);
            
            testcase.press(testcase.physicianapp.FunctionofthishourButton);
            pause(2);
            delete(testcase.physicianapp.hour_figure);
        end
         
        function SetBaselineInvalid(testcase) % T2.4.4
            testcase.press(testcase.physicianapp.Switch);
            pause(1);
            testcase.type(testcase.physicianapp.SetBaselineEditField, 0.05);
            testcase.verifyTrue(testcase.physicianapp.SetBaselineEditField.Value == 0.05);
            pause(2);
            
            testcase.type(testcase.physicianapp.SetBaselineEditField, 0.15);
            pause(1);
            testcase.verifyTrue(testcase.physicianapp.SetBaselineEditField.Value == 0.05);
            pause(2);
            delete(testcase.physicianapp.error2);
                                  
            tmp1 = testcase.physicianapp.controller.hour_injected;
            tmp2 = testcase.physicianapp.controller.day_injected;
            pause(2);
            stop(testcase.physicianapp.controller.t1);
            stop(testcase.physicianapp.controller.t);
            testcase.verifyEqual(round(testcase.physicianapp.controller.hour_injected,2),round(tmp1 + 0.1,2));
            testcase.verifyEqual(round(testcase.physicianapp.controller.day_injected,2),round(tmp2 + 0.1,2));
            start(testcase.physicianapp.controller.t1);
            start(testcase.physicianapp.controller.t);
            testcase.press(testcase.physicianapp.FunctionofthishourButton);
            pause(2);
            delete(testcase.physicianapp.hour_figure);
        end
        
    end
    
end