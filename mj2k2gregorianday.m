function [date_string] = mj2k2gregorianday(mj2kday)
% convert a mj2k variable to a gregorian hour, day, month and year
%
% 1- INPUT:
%   mj2kday = Modified Julian day 2000 to convert.
%
% 2- OUTPUT:
%   date_string = date in Gregorian calendar in 'yyyy/mm/dd HH:MM:SS'
%   format.
%
% 3- EXAMPLES:
%   >> [date_string] = mj2k2greg(0)
%   date_string =
%
%       "2000/01/01 00:00:00"
% 
%   >> [date_string] = mj2k2greg(7689)
% 
%   date_string = 
% 
%       "2021/01/19 00:00:00"
% 
%   >> [date_string] = mj2k2greg(-1710.23)
% 
%   date_string = 
% 
%       "1995/04/26 18:28:48"
% 
% 4- NOTES:
%   offset parameters are:
%   - mjd_conv, which is added to a modified julian day to get the
%   corresponding true julian day
%   - mjd2k_conv, which is added to the modified julian day 2000 to get the
%   corresponding modified julian day
%   - igreg, parameter corresponding to starting of the Modified Julian
%   calendar '1582/10/15'
%
%
% 5- REFERENCES
%   Author: Antonio Giovanni Bruno, University of Leicester
%   Email:  agbbruno90@gmail.com
%           agb22@leicester.ac.uk
%   RG: https://www.researchgate.net/profile/Antonio_Giovanni_Bruno
%

% constant parameters
mjd2k_conv = 51544;
mjd_conv = 2400000.5;
igreg=2299161;

% conversion to julian day
julday = mj2kday + mjd_conv + mjd2k_conv;

% yearday of beginning of each month
% iyd=[1,32,60,91,121,152,182,213,244,274,305,335,366];
% iydl=[1,32,61,92,122,153,183,214,245,275,306,336,367]; %leap year

% get fractional part of the julian day
jday=floor(julday+0.5);
fracday=julday-jday+0.5;

if jday >= igreg
    jalpha = floor((jday-1867216.25)/36524.25);
    ja = jday+1+jalpha-floor(0.25*jalpha);
else
    ja = jday;
end

jb = ja+1524;

jc = floor((jb-122.1)./365.25);%(6680.+((jb-2439870)-122.1)/365.25);
jd = floor(365.25*jc);%365*jc+floor(0.25*jc);
je = floor((jb-jd)/30.6001);
day = floor(jb-jd-floor(30.6001*je));

% months are into the range [1, 12]
ii = find(je <= 13);
month(ii) = je(ii)-1;

ii = find(je > 13);
month(ii) = je(ii)-13;

ii = find(month < 3);
year(ii) = jc(ii)-4715;

ii = find(month >= 3);
year(ii) = jc(ii)-4716;

leap=mod(year,4);

% time of the day
time = datestr(fracday, 'HH:MM:SS');

if month < 10
    str_month = strcat('0',string(month));
else
    str_month = string(month);
end

if day < 10
    str_day = strcat('0',string(day));
else
    str_day = string(day);
end

% date in string format 'yyyy/mm/dd HH:MM:SS'
date_string = strcat(string(year),'/',str_month,'/',str_day,{' '}, string(time)');

