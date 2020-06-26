function obj = table(varargin)


  # input check
  if (nargin == 0)
    # create empy table
    obj = [];

  elseif (nargin > 0)
    # check for given variablenames
    VarNameIndex = find( strcmp( varargin, 'VariableNames' ) == 1);

    if isempty(VarNameIndex)
      VarName = 'Var';
      Vars    = varargin;
    else
      VarName = varargin(VarNameIndex + 1);
      Vars    = varargin(1:nargin-2);
    end
  end

  obj = createTable(VarName, Vars);

end


function obj = createTable(VarName, Vars)

  if iscell(Vars{1})
    for n = 1:columns(Vars{1})
      obj.(char([VarName{1} num2str(n)])) = (Vars{1}(:,n));
    end
  elseif strcmp(VarName, 'Var')
    for n = 1:numel(Vars)
      obj.(['Var' num2str(n)]) = Vars{n};
    end
  else
    for n = 1:numel(Vars)
      obj.(char(VarName{1}(n))) = Vars{n};
    end
  end

end