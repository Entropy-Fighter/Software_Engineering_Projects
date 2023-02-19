classdef controller<handle
    properties
        % 1 minute in the program = 1 second in reality
        % hour and minute does not stands for time in reality
        % instead,it stand for time passed since  the first time injector is on
        state=0;                % state of the injector, 0 off, 1 on
        Baseline=0.01;          % medicine injected automatically per minute, 0.01-0.1
        Bolus=0.2;              % medicine injected manually per shoot,0.2-0.5
        Amount=10;              % total capacity of injector
        Left_amount=10;         % left amount of injector
        limit_per_day=3;        % limit per day
        exceed_limit_day=0;     % state of whether day limit exceed,0 not exceed,1 exceed
        limit_per_hour=1;       % limit per hour
        exceed_limit_hour=0;    % state of whether hour limit exceed,0 not exceed,1 exceed
        hour=0;                 % hour passed since  the first time injector is on
        day_injected=0;         % total injection today
        minute=0;               % minute passed since the first time injector is on
        hour_injected=0;        % total injection this hour
        t                       % control injection
        t1                      % count hour and minute      
        patient_UI              % patient_UI.mlapp
        physician_UI            % physician_UI.mlapp
        minute_count=0          % decide the function to calculate minute and hour
        minute_elapsed=0        % the minute passes since the first time injector is on start, >=60  >=14400
        hour_vec=ones(1,600)-1  % store every minute in an hour
        func_hour_vec=ones(1,14400)-1   % store inject amount each hour(cumulated)
        day_vec=ones(1,14400)-1 % store every minute in a day
        func_day_vec=ones(1,14400)-1    % store inject amount each day(cumulated)
        hour_vec_ptr=1          % store index of element in hour_vec (1<=ptr<=600)
        func_hour_vec_ptr=1;    % store index of element in func_hour_vec (1<=ptr<=14400)
        day_vec_ptr=1           % store index of element in day_vec (1<=ptr<=14400)
        func_day_vec_ptr=1;      % store index of element in func_day_vec (1<=ptr<=14400)
        auto_inject_on=0        % decide whetjer auto inject is on,1 is on,0 is off 
    end
    methods
        function obj=controller()
            obj.t=timer;
            obj.t.TimerFcn=@obj.auto_inject;
            obj.t.Period=0.1;
            obj.t.ExecutionMode='fixedRate';
            obj.t1=timer;
            obj.t1.TimerFcn=@obj.limit_control;
            obj.t1.Period=0.1;
            obj.t1.ExecutionMode='fixedRate';
        end
        
        % medicine injected automatically per 0.1 minute
        function auto_inject(Obj,~,~)   
            switch Obj.state
                case 0  % injector off 
                case 1  % injector on
                    if (Obj.Left_amount<=0)  % when empty,stop timer but injector is still on 
                        stop(Obj.t);
                        Obj.Left_amount=0;
                    else    % when non-empty,inject and Left_amount decrease
                        if ((Obj.exceed_limit_day==0)&&(Obj.exceed_limit_hour==0))    % not exceed day limit or hour limit
                            Obj.Left_amount=Obj.Left_amount-Obj.Baseline*0.1;
                        end
                    end
            end
            Obj.physician_UI.changeState(Obj.state,Obj.Baseline,Obj.Left_amount);   %change message and lamp in physician_UI
        end
        
        % control not to exceed day limit and hour limit
        function limit_control(Obj,~,~) 
            Obj.minute_elapsed=Obj.minute_elapsed+0.1;
            Obj.exceed_limit_hour=0;
            Obj.exceed_limit_day=0;
            Obj.auto_inject_on=0;
            %judge whether exceed limit
            if (Obj.hour_injected>=Obj.limit_per_hour-Obj.Baseline*0.1) % exceed hour limit
                Obj.exceed_limit_hour=1;
            end
            if (Obj.day_injected>=Obj.limit_per_day-Obj.Baseline*0.1) % exceed hour limit
                Obj.exceed_limit_day=1;
            end
            %judge whether auto inject is on 
            if ((Obj.state==1)&&(Obj.Left_amount>0)&&(Obj.exceed_limit_day==0)&&(Obj.exceed_limit_hour==0))
                Obj.auto_inject_on=1;
            end
            % store func_hour_vec and func_day_vec
            if (Obj.minute_elapsed>0.1)
                Obj.func_hour_vec(Obj.func_hour_vec_ptr+1)=Obj.hour_injected;
                Obj.func_day_vec(Obj.func_day_vec_ptr+1)=Obj.day_injected;
            end
            % index out of range,reset index
            Obj.func_hour_vec_ptr=Obj.func_hour_vec_ptr+1;
            Obj.func_day_vec_ptr=Obj.func_day_vec_ptr+1;
            if (Obj.func_hour_vec_ptr>14400)
                Obj.func_hour_vec_ptr=1;
            end
            if (Obj.func_day_vec_ptr>14400)
                Obj.func_day_vec_ptr=1;
            end
            % store amount this minute and calculate hour_injected and
            % day_injected
            if(Obj.auto_inject_on==1)
                if(Obj.minute_elapsed>1440)
                    % when sub,only need to sub Obj.hour_vec(Obj.hour_vec_ptr)
                    % and Obj.day_vec(Obj.day_vec_ptr) since they contain both
                    % auto_inject and Bolus
                    Obj.hour_injected=Obj.hour_injected-Obj.hour_vec(Obj.hour_vec_ptr);
                    Obj.day_injected=Obj.day_injected-Obj.day_vec(Obj.day_vec_ptr); 
                    % initially,contains only baselin,so later Bolus will be
                    % added to it 
                    Obj.hour_vec(Obj.hour_vec_ptr)=Obj.Baseline*0.1;
                    Obj.day_vec(Obj.day_vec_ptr)=Obj.Baseline*0.1; 
                    % when add,need to add Obj.hour_vec(Obj.hour_vec_ptr)
                    % and Obj.day_vec(Obj.day_vec_ptr) since they contain 
                    % auto_inject .So when Bolus, Obj.hour_vec(Obj.hour_vec_ptr)
                    % and Obj.day_vec(Obj.day_vec_ptr) and also hour_injected
                    % and day_injected all need to be added
                    Obj.hour_injected=Obj.hour_injected+Obj.hour_vec(Obj.hour_vec_ptr);
                    Obj.day_injected=Obj.day_injected+Obj.day_vec(Obj.day_vec_ptr);
                elseif((Obj.minute_elapsed>60)&&(Obj.minute_elapsed<=1440))
                    Obj.hour_injected=Obj.hour_injected-Obj.hour_vec(Obj.hour_vec_ptr); 
                    Obj.hour_vec(Obj.hour_vec_ptr)=Obj.Baseline*0.1;
                    Obj.day_vec(Obj.day_vec_ptr)=Obj.Baseline*0.1; 
                    Obj.hour_injected=Obj.hour_injected+Obj.hour_vec(Obj.hour_vec_ptr);
                    Obj.day_injected=Obj.day_injected+Obj.day_vec(Obj.day_vec_ptr);
                else
                    Obj.hour_vec(Obj.hour_vec_ptr)=Obj.Baseline*0.1;
                    Obj.day_vec(Obj.day_vec_ptr)=Obj.Baseline*0.1; 
                    Obj.hour_injected=Obj.hour_injected+Obj.hour_vec(Obj.hour_vec_ptr);
                    Obj.day_injected=Obj.day_injected+Obj.day_vec(Obj.day_vec_ptr);
                end
            else
                if(Obj.minute_elapsed>1440)
                    Obj.hour_injected=Obj.hour_injected-Obj.hour_vec(Obj.hour_vec_ptr);
                    Obj.day_injected=Obj.day_injected-Obj.day_vec(Obj.day_vec_ptr);
                    Obj.hour_vec(Obj.hour_vec_ptr)=0;
                    Obj.day_vec(Obj.day_vec_ptr)=0; 
                elseif((Obj.minute_elapsed>60)&&(Obj.minute_elapsed<=1440))
                    Obj.hour_injected=Obj.hour_injected-Obj.hour_vec(Obj.hour_vec_ptr);
                    Obj.hour_vec(Obj.hour_vec_ptr)=0;
                    Obj.day_vec(Obj.day_vec_ptr)=0; 
                else
                    Obj.hour_vec(Obj.hour_vec_ptr)=0;
                    Obj.day_vec(Obj.day_vec_ptr)=0;
                end

            end
            %move to next index
            Obj.hour_vec_ptr=Obj.hour_vec_ptr+1;
            Obj.day_vec_ptr=Obj.day_vec_ptr+1;
            % if exceed the limit,go to begin of vec 
            if (Obj.hour_vec_ptr>600)
                Obj.hour_vec_ptr=1;
            end
            if (Obj.day_vec_ptr>14400)
                Obj.day_vec_ptr=1;
            end
            % calculate time
            Obj.minute=Obj.minute+0.1;
            if( Obj.minute>=60)
                Obj.minute=0;
                Obj.hour=Obj.hour+1;
                if(Obj.hour>=24)
                    Obj.hour=0;
                end
            end
            Obj.physician_UI.showTime(Obj.hour,Obj.minute,Obj.day_injected,Obj.hour_injected);   %change message  in physician_UI
        end
    % medicine injected automatically per 0.1 minute ONLY FOR TEST
        function auto_inject_test(Obj,~,~)   
            switch Obj.state
                case 0  % injector off 
                case 1  % injector on
                    if (Obj.Left_amount<=0)  % when empty,stop timer but injector is still on 
                        Obj.Left_amount=0;
                    else    % when non-empty,inject and Left_amount decrease
                        if ((Obj.exceed_limit_day==0)&&(Obj.exceed_limit_hour==0))    % not exceed day limit or hour limit
                            Obj.Left_amount=Obj.Left_amount-Obj.Baseline*0.1;
                        end
                    end
            end
           
        end
        function limit_control_test(Obj,~,~) 
            Obj.minute_elapsed=Obj.minute_elapsed+0.1;
            Obj.exceed_limit_hour=0;
            Obj.exceed_limit_day=0;
            Obj.auto_inject_on=0;
            %judge whether exceed limit
            if (Obj.hour_injected>=Obj.limit_per_hour-Obj.Baseline*0.1) % exceed hour limit
                Obj.exceed_limit_hour=1;
            end
            if (Obj.day_injected>=Obj.limit_per_day-Obj.Baseline*0.1) % exceed hour limit
                Obj.exceed_limit_day=1;
            end
            %judge whether auto inject is on 
            if ((Obj.state==1)&&(Obj.Left_amount>0)&&(Obj.exceed_limit_day==0)&&(Obj.exceed_limit_hour==0))
                Obj.auto_inject_on=1;
            end
            % store func_hour_vec and func_day_vec
            if (Obj.minute_elapsed>0.1)
                Obj.func_hour_vec(Obj.func_hour_vec_ptr)=Obj.hour_injected;
                Obj.func_day_vec(Obj.func_day_vec_ptr)=Obj.day_injected;
            end
            % index out of range,reset index
            Obj.func_hour_vec_ptr=Obj.func_hour_vec_ptr+1;
            Obj.func_day_vec_ptr=Obj.func_day_vec_ptr+1;
            if (Obj.func_hour_vec_ptr>14400)
                Obj.func_hour_vec_ptr=1;
            end
            if (Obj.func_day_vec_ptr>14400)
                Obj.func_day_vec_ptr=1;
            end
            % store amount this minute and calculate hour_injected and
            % day_injected
            if(Obj.auto_inject_on==1)
                if(Obj.minute_elapsed>1440)
                    % when sub,only need to sub Obj.hour_vec(Obj.hour_vec_ptr)
                    % and Obj.day_vec(Obj.day_vec_ptr) since they contain both
                    % auto_inject and Bolus
                    Obj.hour_injected=Obj.hour_injected-Obj.hour_vec(Obj.hour_vec_ptr);
                    Obj.day_injected=Obj.day_injected-Obj.day_vec(Obj.day_vec_ptr); 
                    % initially,contains only baselin,so later Bolus will be
                    % added to it 
                    Obj.hour_vec(Obj.hour_vec_ptr)=Obj.Baseline*0.1;
                    Obj.day_vec(Obj.day_vec_ptr)=Obj.Baseline*0.1; 
                    % when add,need to add Obj.hour_vec(Obj.hour_vec_ptr)
                    % and Obj.day_vec(Obj.day_vec_ptr) since they contain 
                    % auto_inject .So when Bolus, Obj.hour_vec(Obj.hour_vec_ptr)
                    % and Obj.day_vec(Obj.day_vec_ptr) and also hour_injected
                    % and day_injected all need to be added
                    Obj.hour_injected=Obj.hour_injected+Obj.hour_vec(Obj.hour_vec_ptr);
                    Obj.day_injected=Obj.day_injected+Obj.day_vec(Obj.day_vec_ptr);
                elseif((Obj.minute_elapsed>60)&&(Obj.minute_elapsed<=1440))
                    Obj.hour_injected=Obj.hour_injected-Obj.hour_vec(Obj.hour_vec_ptr); 
                    Obj.hour_vec(Obj.hour_vec_ptr)=Obj.Baseline*0.1;
                    Obj.day_vec(Obj.day_vec_ptr)=Obj.Baseline*0.1; 
                    Obj.hour_injected=Obj.hour_injected+Obj.hour_vec(Obj.hour_vec_ptr);
                    Obj.day_injected=Obj.day_injected+Obj.day_vec(Obj.day_vec_ptr);
                else
                    Obj.hour_vec(Obj.hour_vec_ptr)=Obj.Baseline*0.1;
                    Obj.day_vec(Obj.day_vec_ptr)=Obj.Baseline*0.1; 
                    Obj.hour_injected=Obj.hour_injected+Obj.hour_vec(Obj.hour_vec_ptr);
                    Obj.day_injected=Obj.day_injected+Obj.day_vec(Obj.day_vec_ptr);
                end
            else
                if(Obj.minute_elapsed>1440)
                    Obj.hour_injected=Obj.hour_injected-Obj.hour_vec(Obj.hour_vec_ptr);
                    Obj.day_injected=Obj.day_injected-Obj.day_vec(Obj.day_vec_ptr);
                    Obj.hour_vec(Obj.hour_vec_ptr)=0;
                    Obj.day_vec(Obj.day_vec_ptr)=0; 
                elseif((Obj.minute_elapsed>60)&&(Obj.minute_elapsed<=1440))
                    Obj.hour_injected=Obj.hour_injected-Obj.hour_vec(Obj.hour_vec_ptr);
                    Obj.hour_vec(Obj.hour_vec_ptr)=0;
                    Obj.day_vec(Obj.day_vec_ptr)=0; 
                else
                    Obj.hour_vec(Obj.hour_vec_ptr)=0;
                    Obj.day_vec(Obj.day_vec_ptr)=0;
                end

            end
            %move to next index
            Obj.hour_vec_ptr=Obj.hour_vec_ptr+1;
            Obj.day_vec_ptr=Obj.day_vec_ptr+1;
            % if exceed the limit,go to begin of vec 
            if (Obj.hour_vec_ptr>600)
                Obj.hour_vec_ptr=1;
            end
            if (Obj.day_vec_ptr>14400)
                Obj.day_vec_ptr=1;
            end
            % calculate time
            Obj.minute=Obj.minute+0.1;
            if( Obj.minute>=60)
                Obj.minute=0;
                Obj.hour=Obj.hour+1;
                if(Obj.hour>=24)
                    Obj.hour=0;
                end
            end
        end
        
    end
end