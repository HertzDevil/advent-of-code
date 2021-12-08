require "../support"
require "bit_array"

solve do
  test <<-INPUT, 5
    0,9 -> 5,9
    8,0 -> 0,8
    9,4 -> 3,4
    2,2 -> 2,1
    7,0 -> 7,4
    6,4 -> 2,0
    0,9 -> 2,9
    3,4 -> 1,4
    0,0 -> 8,8
    5,5 -> 8,2
    INPUT

  answer do |input|
    field = BitArray.new(1000 * 1000)
    field2 = BitArray.new(1000 * 1000)
    input.each_line do |line|
      x1, y1, x2, y2 = line.match(/\A(\d+),(\d+) -> (\d+),(\d+)\z/).not_nil!.captures.map(&.not_nil!.to_i)

      path = case
             when x1 == x2
               y1.to(y2).map { |y| y * 1000 + x1 }
             when y1 == y2
               x1.to(x2).map { |x| y1 * 1000 + x }
             else
               Tuple.new.each
             end

      path.each do |idx|
        (field[idx] ? field2 : field)[idx] = true
      end
    end

    field2.count(true)
  end
end

solve do
  test <<-INPUT, 12
    0,9 -> 5,9
    8,0 -> 0,8
    9,4 -> 3,4
    2,2 -> 2,1
    7,0 -> 7,4
    6,4 -> 2,0
    0,9 -> 2,9
    3,4 -> 1,4
    0,0 -> 8,8
    5,5 -> 8,2
    INPUT

  answer do |input|
    field = BitArray.new(1000 * 1000)
    field2 = BitArray.new(1000 * 1000)
    input.each_line do |line|
      x1, y1, x2, y2 = line.match(/\A(\d+),(\d+) -> (\d+),(\d+)\z/).not_nil!.captures.map(&.not_nil!.to_i)

      path = case
             when x1 == x2
               y1.to(y2).map { |y| y * 1000 + x1 }
             when y1 == y2
               x1.to(x2).map { |x| y1 * 1000 + x }
             when (y1 > y2) == (x1 > x2)
               y1.to(y2).map { |y| y * 1000 + x1 + y - y1 }
             else
               y1.to(y2).map { |y| y * 1000 + x1 - y + y1 }
             end

      path.each do |idx|
        (field[idx] ? field2 : field)[idx] = true
      end
    end

    field2.count(true)
  end
end
