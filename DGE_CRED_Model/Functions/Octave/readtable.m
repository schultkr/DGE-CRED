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
%readtable(sWorkbookNameInput, 'Sheet', 'Start','Range','A:C')
%file = sWorkbookNameInput
%sRange = "A:C"
%sSheetName = "Structural Parameters"
function obj = readtable(file, varargin)

  % get sheet name
  sSheetName = varargin{2};
  % get range
  sRange = varargin{4};
  [tempnumdat, tempcasdat] = xlsread (file, sSheetName, [],'OCT');
  obj.Parameter = tempcasdat(2:end,1);
  obj.Value = tempnumdat(1:end,1);

end
