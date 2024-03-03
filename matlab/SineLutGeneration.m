x = 0:63;
y = round(4095*sin(pi*x/127));
plot(x,y)
fid=fopen('sin_table.mem','w');  % Open file for writing
for idx=1:64
   fprintf(fid,'%02x\n',y(idx));  % Write hex data, one byte per line
end
fclose(fid); % close file