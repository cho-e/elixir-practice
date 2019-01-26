defmodule Practice.Calc do
  # This should handle +,-,*,/ with order of operations,
  # but doesn't need to handle parens.
  def calc(expr) do
    [firstNum | tail] =
      expr
      |> String.split(~r/\s+/)
    tail
      |> tag_tokens
      |> List.flatten
      |> convert_to_postfix([],[{:num, parse_float(firstNum)}])
      |> evaluate([])
  end

  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def tag_tokens(list) do
    list
    |> Enum.chunk_every(2)
    |> Enum.map(fn(x) -> tag(x) end)
  end

  def tag(tuple) do
    op = List.first(tuple)
    num = parse_float(List.last(tuple))
    [op: op] ++ [num: num]
  end

  def precedence(op) do
    case op do
      "*" -> 1
      "/" -> 1
      "+" -> 0
      "-" -> 0
    end
  end

  # Pseudocode for infix to postfix expression algorithm from
  # http://ice-web.cc.gatech.edu/ce21/1/static/audio/static/pythonds/BasicDS/InfixPrefixandPostfixExpressions.html
    # Create an empty stack called opstack for keeping operators. Create an empty list for output.
    # Convert the input infix string to a list by using the string method split.
    # Scan the token list from left to right.
    # If the token is an operand, append it to the end of the output list.
    # If the token is an operator, *, /, +, or -, push it on the opstack.
    # However, first remove any operators already on the opstack that
    # have higher or equal precedence and append them to the output list.
    # When the input expression has been completely processed, check the opstack.
    # Any operators still on the stack can be removed and appended to the end of the output list.
  #
  def convert_to_postfix(input_list, op_stack, output_list) do
    if length(input_list) == 0 do
      output_list ++ op_stack
    else
      input = List.first(input_list)
      case input do
        {:num, num} ->
          convert_to_postfix(tl(input_list), op_stack, output_list ++ [num: num])
        {:op, op} ->
          if length(op_stack) > 0 do
            first_op = List.first(op_stack)
            if precedence(elem(first_op, 1)) >= precedence(op) do
              convert_to_postfix(input_list, tl(op_stack), output_list ++ [first_op])
            else
              convert_to_postfix(tl(input_list), [op: op] ++ op_stack, output_list)
            end
          else
            convert_to_postfix(tl(input_list), [op: op] ++ op_stack, output_list)
          end
      end
    end
  end

  def evaluate(input_list, stack) do
    if length(input_list) == 0 do
      hd(stack)
    else
      input = hd(input_list)
      num1 = Enum.at(stack, 0)
      num2 = Enum.at(stack, 1)
      case input do
        {:num, num} ->
          evaluate(tl(input_list),  [num] ++ stack)
        {:op, "*"} ->
          res = num1 * num2
          evaluate(tl(input_list), [res] ++ tl(tl(stack)))
        {:op, "/"} ->
          res = num2 / num1
          evaluate(tl(input_list), [res] ++ tl(tl(stack)))
        {:op, "+"} ->
          res = num1 + num2
          evaluate(tl(input_list), [res] ++ tl(tl(stack)))
        {:op, "-"} ->
          res = num2 - num1
          evaluate(tl(input_list), [res] ++ tl(tl(stack)))
      end
    end
  end
end
