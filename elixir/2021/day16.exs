#! /usr/bin/env elixir

defmodule AoC do
  def to_bits(<<char::utf8, rest::binary>>) when char >= ?0 and char <= ?F do
    hex = if char >= ?A, do: char - ?A + 10, else: char - ?0
    <<(<<hex::4>>)::bits, to_bits(rest)::bits>>
  end

  def to_bits(_), do: <<>>

  def parse_literal(<<1::size(1), digit::size(4), rest::bits>>) do
    {more_digits, rest2} = parse_literal(rest)
    {[digit | more_digits], rest2}
  end

  def parse_literal(<<0::size(1), digit::size(4), rest::bits>>), do: {[digit], rest}

  def parse(<<version::size(3), 4::size(3), rest::bits>>) do
    {digits, rest2} = parse_literal(rest)
    {%{version: version, type_id: 4, value: digits |> Integer.undigits(16)}, rest2}
  end

  def parse(
        <<version::size(3), type_id::size(3), 0::size(1), length::size(15),
          subpackets::bits-size(length), rest::bits>>
      ) do
    subpackets =
      Stream.unfold(subpackets, fn
        <<>> -> nil
        other -> parse(other)
      end)
      |> Enum.to_list()

    {%{version: version, type_id: type_id, subpackets: subpackets}, rest}
  end

  def parse(<<version::size(3), type_id::size(3), 1::size(1), count::size(11), rest::bits>>) do
    {subpackets, rest2} =
      Enum.reduce(1..count, {[], rest}, fn _, {packets, stream} ->
        {packet, stream_rest} = parse(stream)
        {[packet | packets], stream_rest}
      end)

    {%{version: version, type_id: type_id, subpackets: subpackets |> Enum.reverse()}, rest2}
  end

  def total_version(%{version: version, type_id: 4}), do: version

  def total_version(%{version: version, subpackets: subpackets}),
    do: version + (subpackets |> Enum.map(&total_version/1) |> Enum.sum())

  def evaluate(%{value: value}), do: value

  def evaluate(%{type_id: 0, subpackets: subpackets}),
    do: subpackets |> Enum.map(&evaluate/1) |> Enum.sum()

  def evaluate(%{type_id: 1, subpackets: subpackets}),
    do: subpackets |> Enum.map(&evaluate/1) |> Enum.product()

  def evaluate(%{type_id: 2, subpackets: subpackets}),
    do: subpackets |> Enum.map(&evaluate/1) |> Enum.min()

  def evaluate(%{type_id: 3, subpackets: subpackets}),
    do: subpackets |> Enum.map(&evaluate/1) |> Enum.max()

  def evaluate(%{type_id: 5, subpackets: [x, y]}) do
    x = evaluate(x)
    y = evaluate(y)
    if x > y, do: 1, else: 0
  end

  def evaluate(%{type_id: 6, subpackets: [x, y]}) do
    x = evaluate(x)
    y = evaluate(y)
    if x < y, do: 1, else: 0
  end

  def evaluate(%{type_id: 7, subpackets: [x, y]}) do
    x = evaluate(x)
    y = evaluate(y)
    if x == y, do: 1, else: 0
  end
end

defmodule Main do
  def main do
    {:ok, input} = File.read(Path.expand("../../input/2021/day16", __DIR__))
    {packet, _padding} = input |> AoC.to_bits() |> AoC.parse()
    # IO.inspect(packet)
    IO.inspect(packet |> AoC.total_version())
    IO.inspect(packet |> AoC.evaluate())
  end
end

Main.main()
