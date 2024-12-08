require "../support"

solve do
  test <<-INPUT, 14
    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............
    INPUT

  answer do |input|
    grid = {} of Point2D => Char
    antennas = Hash(Char, Array(Point2D)).new { |h, k| h[k] = [] of Point2D }
    input.each_line.with_index do |line, y|
      line.each_char_with_index do |ch, x|
        v = Point2D.new(x, y)
        grid[v] = ch
        antennas[ch] << v unless ch == '.'
      end
    end

    antinodes = Set(Point2D).new
    antennas.each do |_, vs|
      vs.each_permutation(2) do |(a, b)|
        c = a + (a - b)
        antinodes << c if grid.has_key?(c)
      end
    end

    antinodes.size
  end
end

solve do
  test <<-INPUT, 34
    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............
    INPUT

  answer do |input|
    grid = {} of Point2D => Char
    antennas = Hash(Char, Array(Point2D)).new { |h, k| h[k] = [] of Point2D }
    input.each_line.with_index do |line, y|
      line.each_char_with_index do |ch, x|
        v = Point2D.new(x, y)
        grid[v] = ch
        antennas[ch] << v unless ch == '.'
      end
    end

    antinodes = Set(Point2D).new
    antennas.each do |_, vs|
      vs.each_permutation(2) do |(a, b)|
        d = a - b
        c = a
        while grid.has_key?(c)
          antinodes << c
          c += d
        end
      end
    end

    antinodes.size
  end
end
