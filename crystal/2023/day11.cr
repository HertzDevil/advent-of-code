require "../support"
require "bit_array"

def calc(input, expansion)
  map = input.each_line.map(&.chars).to_a
  expand_x = BitArray.new(map[0].size) { |x| map.all? &.[x].== '.' }
  expand_y = BitArray.new(map.size) { |y| map[y].all? &.== '.' }

  galaxies = [] of Point2D
  map.each_with_index do |line, y|
    line.each_with_index do |ch, x|
      galaxies << Point2D.new(x, y) if ch == '#'
    end
  end

  galaxies.each_combination(2).sum do |(a, b)|
    VonNeumann2D.distance(a, b).to_i64 + expansion * (
      a.x.to(b.x).count { |x| expand_x[x] } +
      a.y.to(b.y).count { |y| expand_y[y] })
  end
end

solve do
  test <<-INPUT, 374
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
    INPUT

  answer do |input|
    calc(input, 1)
  end
end

solve do
  answer do |input|
    calc(input, 999999)
  end
end
