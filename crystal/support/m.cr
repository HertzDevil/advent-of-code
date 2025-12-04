module M
  module Object
    Itself = ->(x) do
      x
    end
  end

  module Math
    Log10 = ->(x) do
      x >= 1000000000 ? 9 :
        x >= 100000000 ? 8 :
        x >= 10000000 ? 7 :
        x >= 1000000 ? 6 :
        x >= 100000 ? 5 :
        x >= 10000 ? 4 :
        x >= 1000 ? 3 :
        x >= 100 ? 2 :
        x >= 10 ? 1 : 0
    end

    Max = ->(a, b) do
      a > b ? a : b
    end

    Min = ->(a, b) do
      a < b ? a : b
    end

    FromDigits = ->(digits : ArrayLiteral, base : NumberLiteral) : NumberLiteral do
      value = 0_i64
      digits.each_with_index do |digit, i|
        value += 10_i64 ** i * digit
      end
      value
    end
  end

  module Array
    Transpose = ->(arr : ArrayLiteral) : ArrayLiteral do
      if arr.empty?
        [] of ::NoReturn
      else
        height = arr.size
        width = nil
        arr.each do |v|
          width ||= v.size
          arr.raise "jagged array" unless v.size == width
        end

        (0...width).map do |x|
          (0...height).map do |y|
            arr[y][x]
          end
        end
      end
    end

    TallyBy = ->(arr : ArrayLiteral, block : ProcLiteral, data) : HashLiteral do
      tallies = {} of _ => _
      arr.each do |k|
        value = data ? block.call(k, data) : block.call(k)
        tallies[value] = (tallies[value] || 0) + 1
      end
      tallies
    end

    Tally = ->(arr : ArrayLiteral) : HashLiteral do
      ::M::Array::TallyBy.call(arr, ::M::Object::Itself)
    end

    Max = ->(arr : ArrayLiteral) do
      arr.reduce do |a, b|
        a > b ? a : b
      end
    end

    Count = ->(arr : ArrayLiteral, block : ProcLiteral, data) : NumberLiteral do
      arr.reduce(0) do |acc, v|
        acc + ((data ? block.call(v, data) : block.call(v)) ? 1 : 0)
      end
    end

    Sum = ->(arr : ArrayLiteral, block : ProcLiteral, data) : NumberLiteral do
      arr.reduce(0_i64) do |acc, v|
        acc + (block ? (data ? block.call(v, data) : block.call(v)) : v)
      end
    end

    Index = ->(arr : ArrayLiteral, value) : NumberLiteral | NilLiteral do
      index = nil
      arr.each_with_index do |v, i|
        index = i if !index && v == value
      end
      index
    end

    ReverseB = ->(arr : ArrayLiteral) do
      (0...arr.size // 2).each do |i|
        arr[i], arr[-i - 1] = arr[-i - 1], arr[i]
      end
      arr
    end
  end
end
