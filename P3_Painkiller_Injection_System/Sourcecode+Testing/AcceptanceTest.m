classdef AcceptanceTest < matlab.uitest.TestCase

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
        
        function TestNormalCases(testcase) % T3.1
            
            
            
            testcase.press(testcase.physicianapp.Switch);
            pause(2);
            %get information by statistics
            tmp1 = testcase.physicianapp.controller.hour_injected;
            tmp2 = testcase.physicianapp.controller.day_injected;
            pause(2);
            testcase.verifyEqual(round(testcase.physicianapp.controller.Left_amount,2), round(10-0.04,2));
            testcase.verifyEqual(round(testcase.physicianapp.controller.Baseline,2), round(0.01,2));
            testcase.verifyEqual(round(testcase.physicianapp.controller.hour_injected,2), round(tmp1 + 0.02,2));
            testcase.verifyEqual(round(testcase.physicianapp.controller.day_injected,2), round(tmp2 + 0.02,2));
            
            %test lamp
            testcase.verifyEqual(testcase.physicianapp.PowerLamp.Color, [0,1,0]);
            testcase.press(testcase.patientapp.CallPhysicianButton);
            pause(2);
            testcase.verifyEqual(testcase.physicianapp.PatientCallingLamp.Color, [1,0,0]);
            testcase.press(testcase.physicianapp.ResolvePatientCallButton);
            pause(1);
            testcase.verifyEqual(testcase.physicianapp.PatientCallingLamp.Color, [0.5,0.5,0.5]);
            pause(1);
            
            stop(testcase.physicianapp.controller.t1);
            stop(testcase.physicianapp.controller.t);
            testcase.press(testcase.physicianapp.FillInjectorButton);
            testcase.verifyEqual(testcase.physicianapp.Left_amountTextArea.Value,{'10.00'});%%%%%%%%%
            start(testcase.physicianapp.controller.t1);
            start(testcase.physicianapp.controller.t);
            pause(2);
            
            testcase.type(testcase.physicianapp.SetBaselineEditField, 0.04);
            testcase.verifyTrue(testcase.physicianapp.SetBaselineEditField.Value == 0.04);
            pause(2);
            
            tmp1 = testcase.physicianapp.controller.hour_injected;
            tmp2 = testcase.physicianapp.controller.day_injected;
            pause(2);
            stop(testcase.physicianapp.controller.t1);
            stop(testcase.physicianapp.controller.t);
            testcase.verifyEqual(round(testcase.physicianapp.controller.hour_injected,2),round(tmp1 + 0.08,2));
            testcase.verifyEqual(round(testcase.physicianapp.controller.day_injected,2),round(tmp2 + 0.08,2));
            start(testcase.physicianapp.controller.t1);
            start(testcase.physicianapp.controller.t);
            pause(2);
            testcase.press(testcase.physicianapp.FunctionofthishourButton);
            pause(2);
            delete(testcase.physicianapp.hour_figure);
            pause(2);
            testcase.press(testcase.physicianapp.FunctionofTodayButton);
            pause(2);
            delete(testcase.physicianapp.day_figure);
            
            testcase.type(testcase.physicianapp.SetBaselineEditField, 0.01);
            testcase.verifyTrue(testcase.physicianapp.SetBaselineEditField.Value == 0.01);
            pause(2);
            
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
            testcase.verifyFalse(round(testcase.physicianapp.controller.hour_injected,2)==round(tmp1 + 0.2,2));
            testcase.verifyFalse(round(testcase.physicianapp.controller.day_injected,2)==round(tmp2 + 0.2,2));
            pause(1);
            delete(testcase.patientapp.error4);
            start(testcase.physicianapp.controller.t1);
            start(testcase.physicianapp.controller.t);
            testcase.press(testcase.physicianapp.FunctionofthishourButton);
            pause(2);
            delete(testcase.physicianapp.hour_figure);
            
            pause(50);
            
            testcase.type(testcase.physicianapp.SetBolusEditField, 0.3);
            testcase.verifyTrue(testcase.physicianapp.SetBolusEditField.Value == 0.3);
            pause(6);
            testcase.press(testcase.patientapp.InjectBolusButton);
            pause(2);
            testcase.press(testcase.physicianapp.FunctionofthishourButton);
            pause(2);
            delete(testcase.physicianapp.hour_figure);
        end
        
        function TestExtremeCases(testcase) % T3.2
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
            
            %
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

        
    end
    
end