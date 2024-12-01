% Pi approximation using Leibniz series: 1 - 1/3 + 1/5 - 1/7 + 1/9 - ... = pi/4
clc; clear; close all

pie=0; % pi approximation
den=1; % denominator

fprintf ('real pi:   %.48f\n', pi); % print real Pi value
fprintf ('pie:       ');
pause

while true
    pie = pie + 4/den;
    den = (abs(den) + 2)*(-sign(den)); % compute new denominator
    fprintf ('\033[12G%.48f', pie); % move cursor to home position and print Pi approximation
end