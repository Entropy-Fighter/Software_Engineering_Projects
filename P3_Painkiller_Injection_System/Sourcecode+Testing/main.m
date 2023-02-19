close all force;
clear;
clc;

if ~isempty(timerfind)
    stop(timerfind);
    delete(timerfind);
end


control = controller;
patientapp = patient_UI;
physicianapp = physician_UI;

control.patient_UI=patientapp;
patientapp.controller=control;
control.physician_UI=physicianapp;
physicianapp.controller=control;
