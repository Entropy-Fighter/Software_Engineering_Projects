classdef PresentationTest < matlab.uitest.TestCase

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
        
        function TestForPre(testcase)
            testcase.press(testcase.physicianapp.Switch);
            pause(3);
           
            %test lamp
            testcase.verifyEqual(testcase.physicianapp.PowerLamp.Color, [0,1,0]);
            testcase.press(testcase.patientapp.CallPhysicianButton);
            pause(2);
            testcase.verifyEqual(testcase.physicianapp.PatientCallingLamp.Color, [1,0,0]);
            testcase.press(testcase.physicianapp.ResolvePatientCallButton);
            pause(2);
            testcase.verifyEqual(testcase.physicianapp.PatientCallingLamp.Color, [0.5,0.5,0.5]);
            
            testcase.press(testcase.physicianapp.FillInjectorButton);
            pause(3);
            
            testcase.type(testcase.physicianapp.SetBaselineEditField, 0.04);
            testcase.verifyTrue(testcase.physicianapp.SetBaselineEditField.Value == 0.04);
            pause(8);
            testcase.type(testcase.physicianapp.SetBaselineEditField, 0.01);
            testcase.verifyTrue(testcase.physicianapp.SetBaselineEditField.Value == 0.01);
            pause(6);
            testcase.type(testcase.physicianapp.SetBaselineEditField, 0.15);
            pause(5);
            delete(testcase.physicianapp.error2);
            pause(5);
            
            testcase.press(testcase.patientapp.InjectBolusButton);
            pause(6);

            testcase.press(testcase.physicianapp.FunctionofthishourButton);
            pause(7);
            delete(testcase.physicianapp.hour_figure);
            pause(2);
            
            testcase.press(testcase.physicianapp.FunctionofTodayButton);
            pause(7);
            delete(testcase.physicianapp.day_figure);
            pause(10);
            
            testcase.press(testcase.patientapp.InjectBolusButton);
            pause(5);
            delete(testcase.patientapp.error4);
            pause(20);
            
            testcase.type(testcase.physicianapp.SetBolusEditField, 0.3);
            testcase.verifyTrue(testcase.physicianapp.SetBolusEditField.Value == 0.3);
            pause(6);
            testcase.press(testcase.patientapp.InjectBolusButton);
            pause(2);
            testcase.press(testcase.physicianapp.FunctionofthishourButton);
            pause(6);
            delete(testcase.physicianapp.hour_figure);
            pause(5);
            
            testcase.type(testcase.physicianapp.SetBolusEditField, 0.6);
            pause(1);
            delete(testcase.physicianapp.error1);
            pause(5);

        end 
    end
    
end