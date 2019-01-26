defmodule Practice.Factor do
  require Integer

  def factor(x) do
    num = String.to_integer(x)
    factor(num, [], 2)
  end

  def factor(x, list, p) do
    if (x > p * p) do
      if (Integer.mod(x, p) == 0) do
        div = Integer.to_string(p)
        factor(div(x, p), list ++ [div], p)
      else
        factor(x, list, p + 1)
      end
    else
      num = Integer.to_string(x)
      list ++ [num]
    end
  end
end
