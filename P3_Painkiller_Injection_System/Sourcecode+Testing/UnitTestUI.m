classdef UnitTestUI < matlab.uitest.TestCase

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
        
        function CallPhysicianButtonPushed(testcase) % T1.2.1.1
            % State: Physician is not called
            % Input: Click on "Call Physician"
            % Expected Output: CallingLamp becomes red
            testcase.press(testcase.patientapp.CallPhysicianButton);
            testcase.verifyEqual(testcase.physicianapp.PatientCallingLamp.Color, [1,0,0]);
            pause(2);
        end
        
        function InjectBolusButtonPushed(testcase) % T1.2.1.2
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
            pause(2);
        end
        
        function SwitchValueChanged(testcase) % T1.2.2.1
            % State: Power is on
            % Input: Click on switch
            % Expected Output: Power is off, PowerLamp becomes grey
            testcase.press(testcase.physicianapp.Switch);
            testcase.verifyEqual(testcase.physicianapp.PowerLamp.Color, [0,1,0]);
            pause(2);
            testcase.press(testcase.physicianapp.Switch);
            testcase.verifyEqual(testcase.physicianapp.PowerLamp.Color, [0.5,0.5,0.5]);
            pause(2);
        end
        
        function ResolvePatientCallButtonPushed(testcase) % T1.2.2.2
            % State: Physician is not called
            % Input: Click on "Call Physician"
            % Expected Output: CallingLamp becomes red
            testcase.press(testcase.patientapp.CallPhysicianButton);
            pause(2);
            testcase.press(testcase.physicianapp.ResolvePatientCallButton);
            testcase.verifyEqual(testcase.physicianapp.PatientCallingLamp.Color, [0.5,0.5,0.5]);
            pause(2);
        end
        
        function FillInjectorButtonPushed(testcase) % T1.2.2.3
            testcase.press(testcase.physicianapp.Switch);
            pause(2);
            stop(testcase.physicianapp.controller.t1);
            stop(testcase.physicianapp.controller.t);
            testcase.press(testcase.physicianapp.FillInjectorButton);
            testcase.verifyEqual(testcase.physicianapp.Left_amountTextArea.Value,{'10.00'});%%%%%%%%%
            pause(2);

        end
        
        function FuctionOfThisHour(testcase) % % T1.2.2.4
            testcase.press(testcase.physicianapp.Switch);
            pause(5);
            testcase.press(testcase.physicianapp.FunctionofthishourButton);
            pause(2);
            testcase.verifyTrue(testcase.physicianapp.hour_figure.Visible);
            delete(testcase.physicianapp.hour_figure);
        end
        
        function FuctionOfToday(testcase) % % T1.2.2.5
            testcase.press(testcase.physicianapp.Switch);
            pause(5);
            testcase.press(testcase.physicianapp.FunctionofTodayButton);
            pause(2);
            testcase.verifyTrue(testcase.physicianapp.day_figure.Visible);
            delete(testcase.physicianapp.day_figure);
        end
        
        
    end
    
end