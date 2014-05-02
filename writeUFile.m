function writeUFile(filename, uf)
% Save a structure representing a Ufile to an actual Ufile.
%
% writeUFile(filename, uf)
%
% `filename` is the path to the output Ufile. `uf` is the structure
% representing the Ufile.
%

fid = fopen(filename, 'w');

%% Write header
fprintf(fid, ' %6d%-4.4s %1d 0 6              ;-SHOT #- F(X) DATA -UF2DWR- 19Nov2013 \n', uf.shot, uf.tokamak, uf.dim);
fprintf(fid, ' %-10.10s                    ;-SHOT DATE-  UFILES ASCII FILE SYSTEM\n', uf.date);
fprintf(fid, ' %3d                           ;-NUMBER OF ASSOCIATED SCALAR QUANTITIES-\n', uf.nscalars);

%% Write scalars
for i=1:length(uf.scalars)
    fprintf(fid, ' % 10.4E                 ;-SCALAR, LABEL FOLLOWS:\n', uf.scalars(i).val);
    fprintf(fid, ' %-10.10s%-10.10s%-10.10s\n', uf.scalars(i).key, uf.scalars(i).desc, uf.scalars(i).unit);
end

%% Handle 1d, 2d and 3d
if uf.dim > 0
    %% Write variable names and units
    fprintf(fid, ' %-20.20s%-10.10s;-INDEPENDENT VARIABLE LABEL: X-\n', uf.xlabel, uf.xunits);
    if uf.dim > 1
        fprintf(fid, ' %-20.20s%-10.10s;-INDEPENDENT VARIABLE LABEL: Y-\n', uf.ylabel, uf.yunits);
    end
    if uf.dim > 2
        fprintf(fid, ' %-20.20s%-10.10s;-INDEPENDENT VARIABLE LABEL: Z-\n', uf.zlabel, uf.zunits);
    end
    fprintf(fid, ' %-20.20s%-10.10s;-DEPENDENT VARIABLE LABEL-\n', uf.flabel, uf.funits);
    fprintf(fid, ' %1d                             ;-PROC CODE- 0:RAW 1:AVG 2:SM 3:AVG+SM\n', uf.processing);
    fprintf(fid, ' %10d                    ;-# OF X PTS-', uf.nx);
    if uf.dim == 1
        fprintf(fid, ' X,F(X) DATA FOLLOW:\n');
    else
        fprintf(fid, '\n %10d                    ;-# OF Y PTS-', uf.ny);
        if uf.dim == 2
            fprintf(fid, ' X,Y,F(X,Y) DATA FOLLOW:\n');
        else
            fprintf(fid, '\n %10d                    ;-# OF Z PTS- X,Y,Z,F(X,Y,Z) DATA FOLLOW:\n', uf.nz);
        end
    end
    
    %% Write data
    fprintf(fid, ' % 12E% 12E% 12E% 12E% 12E% 12E\n', uf.x);
    if mod(uf.nx, 6) > 0
        fprintf(fid, '\n');
    end
    if uf.dim > 1
        fprintf(fid, ' % 12E% 12E% 12E% 12E% 12E% 12E\n', uf.y);
        if mod(uf.ny, 6) > 0
            fprintf(fid, '\n');
        end
    end
    if uf.dim > 2
        fprintf(fid, ' % 12E% 12E% 12E% 12E% 12E% 12E\n', uf.z);
        if mod(uf.ny, 6) > 0
            fprintf(fid, '\n');
        end
    end
    fprintf(fid, ' % 12E% 12E% 12E% 12E% 12E% 12E\n', uf.f(:));
    if mod(numel(uf.f), 6) > 0
        fprintf(fid, '\n');
    end
    
end

%% Write comments
% Even if the spec doesn't say so, this trailer record seems to be required
fprintf(fid, ' ;----END-OF-DATA-----------------COMMENTS:-----------\n');
fprintf(fid, uf.comments);

%% Close file
fclose(fid);

