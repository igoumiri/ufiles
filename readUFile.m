function uf = readUFile(filename)
% Load a Ufile as a structure.
%
% uf = readUFile(filename)
%
% `filename` is the path to the input Ufile. `uf` is the structure
% representing the Ufile.
%

fid = fopen(filename);

%% Read Shot #, Tokamak ID, dimension and date
uf.shot = fscanf(fid, '%d', 1);
uf.tokamak = fscanf(fid, '%4c', 1);
uf.dim = fscanf(fid, '%d', 1);
fgets(fid); % Discard end of line including comments
% Date might be empty, make sure scanf doesn't go too far
line = fgets(fid);
uf.date = strtrim(sscanf(line, ' %10c', 1));
uf.nscalars = fscanf(fid, '%d', 1);
fgets(fid);

%% Error checks
if all(uf.dim ~= 0:3)
    error('dimension should be 0, 1, 2 or 3')
end

%% Read scalars
for i=1:uf.nscalars
    uf.scalars(i).val = fscanf(fid, '%f', 1);
    fgets(fid);
    uf.scalars(i).key = strtrim(fscanf(fid, ' %10[^\n]', 1));
    uf.scalars(i).desc = strtrim(fscanf(fid, '%10[^\n]', 1));
    uf.scalars(i).unit = strtrim(fscanf(fid, '%10[^\n]', 1));
    fgets(fid);
end

%% Handle 1d, 2d and 3d
if uf.dim > 0
    %% Read variable names and units
    uf.xlabel = strtrim(fscanf(fid, ' %20[^\n]', 1));
    uf.xunits = strtrim(fscanf(fid, '%10[^\n]', 1));
    fgets(fid);
    if uf.dim > 1
        uf.ylabel = strtrim(fscanf(fid, ' %20[^\n]', 1));
        uf.yunits = strtrim(fscanf(fid, '%10[^\n]', 1));
        fgets(fid);
    end
    if uf.dim > 2
        uf.zlabel = strtrim(fscanf(fid, ' %20[^\n]', 1));
        uf.zunits = strtrim(fscanf(fid, '%10[^\n]', 1));
        fgets(fid);
    end
    uf.flabel = strtrim(fscanf(fid, ' %20[^\n]', 1));
    uf.funits = strtrim(fscanf(fid, '%10[^\n]', 1));
    fgets(fid);
    
    %% Read processing mode
    uf.processing = fscanf(fid, '%d', 1);
    fgets(fid);
    
    %% Read Number of points
    uf.nx = fscanf(fid, '%d', 1);
    fgets(fid);
    if uf.dim > 1
        uf.ny = fscanf(fid, '%d', 1);
        fgets(fid);
    end
    if uf.dim > 2
        uf.nz = fscanf(fid, '%d', 1);
        fgets(fid);
    end
    
    %% Read data
    uf.x = fscanf(fid, '%f', uf.nx);
    dims = uf.nx;
    if uf.dim > 1
        uf.y = fscanf(fid, '%f', uf.ny);
        dims = [dims uf.ny];
    end
    if uf.dim > 2
        uf.z = fscanf(fid, '%f', uf.nz);
        dims = [dims uf.nz];
        uf.f = reshape(fscanf(fid, '%f', prod(dims)), dims);
    else
        uf.f = fscanf(fid, '%f', dims);
    end
    fgets(fid);
    
end

%% Read Comments
% Remove trailer record if present as it will be added back when writing
uf.comments = fscanf(fid, ' ;----END-OF-DATA-----------------COMMENTS:-----------\n');
while ~feof(fid)
    uf.comments = [uf.comments fgets(fid)];
end

%% Close file
fclose(fid);

