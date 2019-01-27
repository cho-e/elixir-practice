defmodule Practice.Factor do
  require Integer

  def factor(x) do
    factor(x, [], 2)
  end

  def factor(x, list, p) do
    if (x >= p * p) do
      if (Integer.mod(x, p) == 0) do
        factor(div(x, p), list ++ [p], p)
      else
        factor(x, list, p + 1)
      end
    else
      list ++ [x]
    end
  end
end
