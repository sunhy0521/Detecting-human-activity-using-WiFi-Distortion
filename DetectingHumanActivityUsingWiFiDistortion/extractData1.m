

% Before you run this code:
% 1.Download : https://github.com/dhalperi/linux-80211n-csitool-supplementary
% 2.Go to Matlab directory from the downloaded above
% 3.Put current file to the Matlab directory
% 4.Run this code under Matlab directory (Add to path)


function example

clc;
clear;
warning('off','all');


% Path of ile that are going to be read
%filePath = '/filePath/filename.dat';
filePath = 'C:\Study\Wireless_Networks\Group05 - Copy\clap27.dat';


sampleRate = 100;
starts = 0;
ends = 0;

%See function discription
DataSample = getCSI(filePath,sampleRate, starts, ends);
sizeofData = size(DataSample,2);

%Amo and Phase respectively
DataAmp = zeros(30,sizeofData);
DataPhase = zeros(30,sizeofData);

for CarrierNum = 1:30
    DataAmp(CarrierNum,:) = db(abs(DataSample(CarrierNum,:).'));
    DataPhase(CarrierNum,:) = angle(DataSample(CarrierNum,:).');
end


%example: plot the amplitude of the 15th subcarrier
%  figure;
% plot(DataAmp(15,:));

%  figure;
%  varance = var(DataAmp,0,1);
%  plot(varance);

% figure;

stanD = std(DataAmp,0,2);
  figure;
plot(stanD);

 meanD =mean(DataAmp,2);
 maxVal=max(DataAmp,[],2);
 medianAbso=mad(DataAmp,1,2);
  percen=prctile(DataAmp,[25 75],2);

final=[stanD meanD maxVal medianAbso percen];
 %readFinal=xlsread('C:\Users\Kush21\Desktop\WirelessProject\train5.xlsx');
readFinal=xlsread('C:\Users\Kush21\Desktop\WirelessProject\test.xlsx');
finalResult=[readFinal;final];
% xlswrite('C:\Users\Kush21\Desktop\WirelessProject\train5.xlsx',finalResult);
xlswrite('C:\Users\Kush21\Desktop\WirelessProject\test.xlsx',finalResult);

%plot(stanD);
% readSD=xlsread('C:\Users\Kush21\Desktop\WirelessProject\sdexcel.xlsx');
% 
% readSD1=[readSD;stanD];
% 
% 
% 
% xlswrite('C:\Users\Kush21\Desktop\WirelessProject\sdexcel.xlsx',readSD1);


% figure;

% readMean=xlsread('C:\Users\Kush21\Desktop\WirelessProject\meanexcel.xlsx');
% readMean1=[readMean;meanD];
% xlswrite('C:\Users\Kush21\Desktop\WirelessProject\meanexcel.xlsx',readMean1);
% %plot(meanD);
% disp(meanD);
% 
% 
% readMax=xlsread('C:\Users\Kush21\Desktop\WirelessProject\maxValue.xlsx');
%  readMax1=[maxVal;readMax];
% xlswrite('C:\Users\Kush21\Desktop\WirelessProject\maxValue.xlsx',readMax1);
% 
% 
% readmedianAbso=xlsread('C:\Users\Kush21\Desktop\WirelessProject\medianAbsolute.xlsx');
%  readmedianAbso1=[medianAbso;readmedianAbso];
% xlswrite('C:\Users\Kush21\Desktop\WirelessProject\medianAbsolute.xlsx',readmedianAbso1);


end



%-----Input parameters--------------
%%%%filePath: Path of ile that are going to be read
%%%%sampleRate: 100 in your case
%%%%starts: If you want to read dat file start from "starts" seconds. Default
%           set to 0
%%%%ends: If you want to read dat file ends at  "ends" seconds. Default set to
%         0
%-----Output parameters--------------
%%%%CSIData: output the csi data of 30 subcarriers from the 1st stream
function CSIData = getCSI(filePath,sampleRate, starts, ends)
    csi_trace = read_bf_file(filePath);
    
    data_initialsize=size(csi_trace,1);
    data_allsize = data_initialsize;
    
    % Igonre this part
    for i = data_initialsize:-1:1
        temp_csi = csi_trace{i};
        if (size(temp_csi,1)~=0 && size(temp_csi,1)~=0)
            data_allsize = i;
            break;
        end
    end
    
    
    %start point: delete the first "starts" seconds
    start_point = sampleRate*starts+1;
    
    %end point: delete the last "ends" seconds
    end_point = data_allsize - mod(data_allsize,sampleRate) - sampleRate*ends;
    
    
    data_size = end_point - start_point + 1;
    NumCarriers = 30;
    
    DataSample=zeros(NumCarriers,data_size);

     for i=start_point:end_point
        csi_entry = csi_trace{i};
        csi = get_scaled_csi(csi_entry);

        for j= 1 : NumCarriers
            DataSample(j,i-start_point+1)=csi(1,1,j);
        end  
    end
    
    CSIData=inpaint_nans(DataSample);
end