clc; clear

while true
    pause (0.03)
    chars = char (randi ([33 126], 1, randi (120)));
    disp (chars)
end