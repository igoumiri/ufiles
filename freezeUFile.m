function uf = freezeUFile(uf, val, dim)
% Replicate a slice of data from a Ufile along a dimension.
%
% uf = freezeUFile(uf, val)
% uf = freezeUFile(uf, val, dim)
%
% `uf` is the structure representing the Ufile. `val` is the value along
% the `dim` dimension which should be replicated for all points along this
% dimension. If `dim` is unspecified, it defaults to 1.
%

%% Default value for dim
if nargin < 3
    dim = 1;
end

%% Freeze
if dim > uf.dim
    error('dim is out of bounds')
end
switch uf.dim
    case 1
        slice = interp1(uf.x, uf.f, val);
    case 2
        dims = {uf.x uf.y};
        slice = shiftdim(interp1(dims{dim}, shiftdim(uf.f, dim - 1), val), uf.dim - dim + 1);
    case 3
        dims = {uf.x uf.y uf.z};
        slice = shiftdim(interp1(dims{dim}, shiftdim(uf.f, dim - 1), val), uf.dim - dim + 1);
    otherwise
        error('dim is out of bounds')
end
dims = ones(1, uf.dim + 1); % Add trailing 1 to prevent repmat quirk in 1d
dims(dim) = size(uf.f, dim);
uf.f = repmat(slice, dims);

