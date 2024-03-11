## Copyright (C) 2024 schul
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{retval} =} readtable (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: schul <schul@CHRISLAPTOP>
## Created: 2024-03-07

function obj = readtable(file, varargin)
  pkg load io
  % get sheet name
  sSheetName = varargin{3};
  % get range
  sRange = varargin{5};
  xlsread (file, 1, [], 'OCT');
  if nargin >= 2
    # check for delimiter
    DelimiterIndex = find( strcmp( varargin, 'delimiter' ) == 1);
    if isempty(DelimiterIndex)
      sep = ',';
    else
      sep = varargin{DelimiterIndex + 1};
    end

    # check for headers
    HeaderIndex = find( strcmp( varargin, 'HeaderLines' ) == 1);
    if isempty(HeaderIndex)
      heads = 0;
    else
      heads = varargin{HeaderIndex + 1};
    end

  end

  # open file
  if strcmp(e, '.xlsx')
    ret = xlsread(file);
  else
    ret = read_file(file, sep, heads);
  end

  if heads == 0
    try
      obj = table(ret(2:end,:), 'VariableNames', ret(1,:));
    catch
      obj = table(ret, 'VariableNames', {n});
    end
  else
      obj = table(ret, 'VariableNames', 'Var');
  end

end

function ret = read_file(file, sep, heads)
  # open file
  f = fopen(file);
  if f < 3
    error('Unable to open file')
    return
  end


  # skip headers
  if heads > 0
    for n = 1:heads
      fgetl(f);
    end
  end

  # count separators
  mark = ftell(f);
  tmp = fgetl(f);
  num_sep = numel(strfind(tmp,sep));
  fseek(f, mark, 'bof');

  # read values
  ret = fread (f, 'char=>char').';

  # check end of line
  if tmp(end)~=sep
    ret = regexprep (ret,'\n',[sep '\n']);
    num_sep = num_sep + 1;
  end
  # remove all newlines
  ret=regexprep (ret,'(\n)+','');

  # parsing values
  ret = regexp(ret,sep,'split');

  # format output
  # delete empty last field
  if mod(size(ret,2),num_sep)~=0
    # yes, because we split after each separator
    if numel(ret{1,end}) == 0
      ret = ret(1,1:end-1);
    end

    if mod(size(ret,2),num_sep)==0
      ret = reshape (ret,num_sep,[])';
    end
  else
    ret = reshape (ret,num_sep,[])';
  end


end
