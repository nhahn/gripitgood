% a = arduino('/dev/tty.usbmodem1411');
% 
% digital_pins = 2:13;
% analog_pins = 0:5;
% 
% A = zeros(numel(digital_pins),numel(analog_pins));
% colormap('hot')
% 
% while(true)
% 
%     for idx = 1:numel(digital_pins)
%        a.pinMode(digital_pins(idx),'output');
%        a.digitalWrite(digital_pins(idx),0);
%     end
% 
%     for idx = 1:numel(digital_pins)
%        a.digitalWrite(digital_pins(idx),1);
%        for ang = 1:numel(analog_pins)
%          A(idx,ang) = a.analogRead(analog_pins(ang));
%        end
%        a.digitalWrite(digital_pins(idx),0);
%     end
%     imagesc(A)
%     colorbar
%     drawnow;
% end
ser = serial('/dev/tty.usbmodem1411','BaudRate',9600);
try 
   fopen(ser);
catch ME,
    disp(ME.message)
    delete(ser);
    error(['Could not make connection to arduino']);
end
    
fprintf(1,'Attempting connection .');
for i=1:2,
    pause(1);
    fprintf(1,'.');
end
fprintf(1,'\n');

while(true)
    data = fgetl(ser)
end

fclose(ser);
delete(ser);
                

