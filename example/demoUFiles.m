%% Demo: reading, freezing and writing a sample 2d Ufile in Matlab

%% Read
% You need to be in the `example` directory for the relative path to work

uf = readUFile('S133775.TER');

%% Plot input data

surf(uf.x, uf.y, uf.f')
xlabel([uf.xlabel ' (' uf.xunits ')'])
ylabel([uf.ylabel ' (' uf.yunits ')'])
title([uf.flabel ' (' uf.funits ')'])

%% Freeze data at given time

t_freeze = 0.605;
uf = freezeUFile(uf, t_freeze);

%% Plot frozen data

surf(uf.x, uf.y, uf.f')
xlabel([uf.xlabel ' (' uf.xunits ')'])
ylabel([uf.ylabel ' (' uf.yunits ')'])
title([uf.flabel ' (' uf.funits ')'])

%% Write frozen data to output

writeUFile('S133775_OUT.TER', uf)
