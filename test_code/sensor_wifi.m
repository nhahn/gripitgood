sensor = tcpip('192.168.1.236', 3000);
fopen(sensor);
fprintf(sensor,'hello');
pause(1);

while(get(sensor, 'BytesAvailable') > 0)
   sensor.BytesAvailable;
   data = fread(sensor,[16,8],'int8');
end

fclose(sensor);
delete(sensor);
clear sensor;