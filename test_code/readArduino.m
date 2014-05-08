s= serial('/dev/tty.usbmodem1421', 'BaudRate', 115200);
fopen(s);
x = zeros(6,16);
while 1
    try
        tmp = fscanf(s,'%*s%d:%d%,%d,%d,%d,%d,%d,;');
        if tmp(1)==0
            x =[tmp(2:length(tmp)) x(:,2:14)];
            for i=1:13
                try
                    tmp2 = fscanf(s,'%d:%d%,%d,%d,%d,%d,%d,;');
                    if tmp2(1)~=14
                        x =[x(:,1:i) tmp2(2:length(tmp)) x(:,i+2:14)];
                        x(i+1) = tmp(2:length(tmp));
                    else
                        fclose(s);
                        delete(s);
                    end
                end
            end
        end
    end
    colormap('jet')
    imagesc(x)
    colorbar
    drawnow;
end
fclose(s);
delete(s);