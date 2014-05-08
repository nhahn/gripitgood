% a = instrfind;
% if (~isempty(a))
%     flose(a);
% end

s= serial('COM6', 'BaudRate', 115200);
fopen(s);
x = zeros(16,16);
y = [];
tail = zeros(10,1);
while 1
    try
        tmp = fscanf(s,'%d:%d,%d,%d,%d,%d,%d,;');
        if tmp(1)==0
            tmp = [tmp;tail];
%             for m = 1:size(tmp,1)
%                 if tmp(m) ~= 0
%                     tmp(m) = tmp(m)/1024.0*5.0
%                     tmp(m) = ((5.0-tmp(m))/tmp(m));
%                 end
%             end
            x =[tmp(2:length(tmp)) x(:,2:16)];
            for i=1:15
                try
                    tmp2 = fscanf(s,'%d:%d,%d,%d,%d,%d,%d,;');
                    if tmp2(1)~=15
                        tmp2 = [tmp2;tail];
%                         for n = 1:size(tmp2,1)
%                             if tmp2(n) ~= 0
%                                 tmp2(n) = tmp2(n)/1024.0*5.0
%                                 tmp2(n) = ((5.0-tmp2(n))/tmp2(n));
%                             end
%                         end
                        x =[x(:,1:i) tmp2(2:length(tmp2)) x(:,i+2:16)];
                        %x(i+1) = tmp2(2:length(tmp2));
                    else
                    end
                end
            end
        end
    end
    %temp = x(1,1:16);
    %x(1,1:16) = x(7,1:16);
    %x(7,1:16) = temp;
    %y = [y ; x];
    l =[1:16];
    w =[1:16];
    colormap('jet')
    h = pcolor(x)
    caxis([0,800]);
    set(h, 'EdgeColor', 'none')
    colorbar
    
    drawnow;
end
fclose(s);
delete(s);