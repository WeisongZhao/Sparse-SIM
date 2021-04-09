function Time_Str=get_time
Time=fix(clock);
Time_Str=0;
for T=size(Time,2)-2:-1:1
    Temp=strcat(num2str(Time(T)) , '_' );
    Time_Str=strcat(Temp,Time_Str );
end