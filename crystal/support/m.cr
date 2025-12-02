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

    TallyBy = ->(arr : ArrayLiteral, block : ProcLiteral) : HashLiteral do
      tallies = {} of _ => _
      arr.each do |k|
        value = block.call(k)
        tallies[value] = (tallies[value] || 0) + 1
      end
      tallies
    end

    Tally = ->(arr : ArrayLiteral) : HashLiteral do
      ::M::Array::TallyBy.call(arr, ::M::Object::Itself)
    end
  end
end
