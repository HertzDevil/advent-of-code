require "../support"
require "bit_array"

ADJ = [
  {-1, -1},
  {-1, 0},
  {-1, 1},
  {0, -1},
  {0, 0},
  {0, 1},
  {1, -1},
  {1, 0},
  {1, 1},
]

solve do
  test <<-INPUT, 35
    ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

    #..#.
    #....
    ##..#
    ..#..
    ..###
    INPUT

  answer do |input|
    lines = input.lines
    algo = BitArray.new(512)
    lines.shift.each_char_with_index do |ch, i|
      algo[i] = ch == '#'
    end

    lines.shift
    grid = Set({Int32, Int32}).new
    lines.each_with_index do |line, y|
      line.each_char_with_index do |ch, x|
        grid << {y, x} if ch == '#'
      end
    end
    far = false

    2.times do
      new_grid = Hash({Int32, Int32}, Int32).new { 0 }
      ADJ.each_with_index do |(dy, dx), i|
        grid.each do |(y, x)|
          new_grid[{y + dy, x + dx}] += 1 << i
        end
      end
      grid = Set({Int32, Int32}).new
      (-10..109).each do |y|
        (-10..109).each do |x|
          cell = x.in?(-10, 109) || y.in?(-10, 109) ? (far ? 511 : 0) : new_grid[{y, x}]
          grid << {y, x} if algo[cell]
        end
      end
      far = algo[far ? 511 : 0]
    end

    grid.size
  end
end

solve do
  test <<-INPUT, 3351
    ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

    #..#.
    #....
    ##..#
    ..#..
    ..###
    INPUT

  answer do |input|
    lines = input.lines
    algo = BitArray.new(512)
    lines.shift.each_char_with_index do |ch, i|
      algo[i] = ch == '#'
    end

    lines.shift
    grid = Set({Int32, Int32}).new
    lines.each_with_index do |line, y|
      line.each_char_with_index do |ch, x|
        grid << {y, x} if ch == '#'
      end
    end
    far = false

    50.times do
      new_grid = Hash({Int32, Int32}, Int32).new { 0 }
      ADJ.each_with_index do |(dy, dx), i|
        grid.each do |(y, x)|
          new_grid[{y + dy, x + dx}] += 1 << i
        end
      end
      grid = Set({Int32, Int32}).new
      (-60..159).each do |y|
        (-60..159).each do |x|
          cell = x.in?(-60, 159) || y.in?(-60, 159) ? (far ? 511 : 0) : new_grid[{y, x}]
          grid << {y, x} if algo[cell]
        end
      end
      far = algo[far ? 511 : 0]
    end

    grid.size
  end
end
