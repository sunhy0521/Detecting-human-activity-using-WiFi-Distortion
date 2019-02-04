t=xlsread('C:\Users\Kush21\Desktop\WirelessProject\test.xlsx');
SD=t(:,1);
Mean=t(:,2);
MaxValue=t(:,3);
AbsoluteMedian=t(:,4);
twntyfifth=t(:,5);
seventyfifth=t(:,6);
mytable=table(SD,Mean,MaxValue,AbsoluteMedian,twntyfifth,seventyfifth );
yfit=trainedModel3.predictFcn(mytable);
jumpcount=0;
clapcount=0;
for idx = 1:numel(yfit)
    element = yfit(idx);
    tf = strcmp(string(element),"jump") ;
    if tf
        jumpcount=jumpcount+1;     
    else
         clapcount=clapcount+1;
    end
end
if jumpcount>clapcount
    disp("Action performed is jump");
else
    disp("Action performed is clap");
end

