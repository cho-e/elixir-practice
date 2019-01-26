defmodule Practice.Palindrome do

  def palindrome?(str) do
    reverse = str
    |> String.downcase()
    |> String.reverse()
    reverse == String.downcase(str)
  end
end
