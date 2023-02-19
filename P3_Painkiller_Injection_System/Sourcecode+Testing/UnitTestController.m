classdef UnitTestController < matlab.unittest.TestCase
   properties
        control       
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
        end
    end

    methods(TestMethodTeardown)
        
    end
    
    methods(Test)
 
        function auto_inject_for_different_states(testCase) %T1.1.1.1
            testCase.control.state = 0;
            testCase.control.auto_inject_test();
            testCase.verifyEqual(testCase.control.Left_amount, 10);
            testCase.verifyEqual(testCase.control.exceed_limit_day, 0);
            testCase.verifyEqual(testCase.control.exceed_limit_hour, 0);
            testCase.verifyEqual(testCase.control.Baseline, 0.01);
            
            testCase.control.state = 1;
            testCase.control.auto_inject_test();
            testCase.verifyEqual(testCase.control.Left_amount, 9.999);
            testCase.verifyEqual(testCase.control.exceed_limit_day, 0);
            testCase.verifyEqual(testCase.control.exceed_limit_hour, 0);
            testCase.verifyEqual(testCase.control.Baseline, 0.01);
        end
        
        function auto_inject_for_different_Left_amounts(testCase) %T1.1.1.2
            testCase.control.state = 1;
            testCase.control.Left_amount = -5;
            testCase.control.auto_inject_test();
            testCase.verifyEqual(testCase.control.Left_amount, 0);
            testCase.verifyEqual(testCase.control.exceed_limit_day, 0);
            testCase.verifyEqual(testCase.control.exceed_limit_hour, 0);
            testCase.verifyEqual(testCase.control.Baseline, 0.01);
            
            testCase.control.state = 1;
            testCase.control.Left_amount = 5;
            testCase.control.auto_inject_test();
            testCase.verifyEqual(testCase.control.Left_amount, 4.999);
            testCase.verifyEqual(testCase.control.exceed_limit_day, 0);
            testCase.verifyEqual(testCase.control.exceed_limit_hour, 0);
            testCase.verifyEqual(testCase.control.Baseline, 0.01);
        end
            
 
        function auto_inject_for_extreme_cases(testCase) %T1.1.1.3
            testCase.control.state = 1;
            testCase.control.exceed_limit_day = 1;
            testCase.control.auto_inject_test();
            testCase.verifyEqual(testCase.control.Left_amount, 10);
            testCase.verifyEqual(testCase.control.exceed_limit_day, 1);
            testCase.verifyEqual(testCase.control.exceed_limit_hour, 0);
            testCase.verifyEqual(testCase.control.Baseline, 0.01);
            
            testCase.control.state = 1;
            testCase.control.exceed_limit_hour = 1;
            testCase.control.auto_inject_test();
            testCase.verifyEqual(testCase.control.Left_amount, 10);
            testCase.verifyEqual(testCase.control.exceed_limit_day, 1);
            testCase.verifyEqual(testCase.control.exceed_limit_hour, 1);
            testCase.verifyEqual(testCase.control.Baseline, 0.01);
            
            testCase.control.state = 1;
            testCase.control.exceed_limit_hour = 0;
            testCase.control.exceed_limit_day = 0;
            testCase.control.auto_inject_test();
            testCase.verifyEqual(testCase.control.Left_amount, 9.999);
            testCase.verifyEqual(testCase.control.exceed_limit_day, 0);
            testCase.verifyEqual(testCase.control.exceed_limit_hour, 0);
            testCase.verifyEqual(testCase.control.Baseline, 0.01);
        end
        
        function limit_control_initialization(testCase) %T1.1.2.1
            testCase.control.state = 1;
            testCase.control.exceed_limit_hour = 1;
            testCase.control.exceed_limit_day = 1;
            testCase.control.auto_inject_on = 0;
            testCase.control.limit_control_test();
            testCase.verifyEqual(testCase.control.minute_elapsed, 0.1);
            testCase.verifyEqual(testCase.control.exceed_limit_day, 0);
            testCase.verifyEqual(testCase.control.exceed_limit_hour, 0);
            testCase.verifyEqual(testCase.control.auto_inject_on, 1);
        end
        
        function limit_control_for_hour_limit_exceeding(testCase) %T1.1.2.2
            testCase.control.state = 1;
            testCase.control.hour_injected = 1;
            testCase.control.limit_control_test();
            testCase.verifyEqual(testCase.control.exceed_limit_hour, 1);
        end
        
        function limit_control_for_day_limit_exceeding(testCase) %T1.1.2.3
            testCase.control.state = 1;
            testCase.control.day_injected = 3;
            testCase.control.limit_control_test();
            testCase.verifyEqual(testCase.control.exceed_limit_day, 1);
        end
        
        function limit_control_for_auto_inject_on(testCase) %T1.1.2.4
            testCase.control.state = 1;
            testCase.control.limit_control_test();
            testCase.verifyEqual(testCase.control.auto_inject_on, 1);
            
            testCase.control.day_injected = 3;
            testCase.control.limit_control_test();
            testCase.verifyEqual(testCase.control.auto_inject_on, 0);
            
            testCase.control.hour_injected = 1;
            testCase.control.limit_control_test();
            testCase.verifyEqual(testCase.control.auto_inject_on, 0);
            
            testCase.control.state = 0;
            testCase.control.limit_control_test();
            testCase.verifyEqual(testCase.control.auto_inject_on, 0);
            
            testCase.control.state = 1;
            testCase.control.hour_injected = 0;
            testCase.control.day_injected = 0;
            testCase.control.Left_amount = 0;
            testCase.control.limit_control_test();
            testCase.verifyEqual(testCase.control.auto_inject_on, 0);
        end
        
        function limit_control_for_hour_injected_calculation(testCase) %T1.1.2.5
            testCase.control.state = 1;
            for i = 1 : 1000
                testCase.control.limit_control_test();
            end
            testCase.verifyEqual(round(testCase.control.hour_injected,2), 0.60);
            
            testCase.control.Baseline = 0.02;
            for i = 1 : 600
                testCase.control.limit_control_test();
            end
            testCase.verifyEqual(round(testCase.control.hour_injected,2), 1.00);
            
            testCase.control.state = 0;
            for i = 1 : 100
                testCase.control.limit_control_test();
            end
            testCase.verifyEqual(round(testCase.control.hour_injected,2), 0.80);
            
            for i = 1 : 490
                testCase.control.limit_control_test();
            end
            testCase.verifyEqual(round(testCase.control.hour_injected,2), 0.01);
        end
        
        function limit_control_for_day_injected_calculation(testCase) %T1.1.2.6
            testCase.control.state = 1;
            for i = 1 : 600
                testCase.control.limit_control_test();
            end
            testCase.verifyEqual(round(testCase.control.day_injected,2), 0.60);
            
            for i = 1 : 600
                testCase.control.limit_control_test();
            end
            testCase.verifyEqual(round(testCase.control.day_injected,2), 1.20);
            
            testCase.control.state = 0;
            for i = 1 : 100
                testCase.control.limit_control_test();
            end
            testCase.verifyEqual(round(testCase.control.day_injected,2), 1.20);
            
            testCase.control.state = 1;
            for i = 1 : 600
                testCase.control.limit_control_test();
            end
            testCase.verifyEqual(round(testCase.control.day_injected,2), 1.80);
            
            testCase.control.Baseline = 0.02;
             for i = 1 : 600
                testCase.control.limit_control_test();
             end
             testCase.verifyEqual(round(testCase.control.day_injected,2), 2.80);
             
             for i = 1 : 200
                testCase.control.limit_control_test();
             end
             testCase.verifyEqual(round(testCase.control.day_injected,2), 3.00);
        end
        
              
    end
 
end