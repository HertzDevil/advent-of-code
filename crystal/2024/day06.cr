require "../support"

solve do
  test <<-INPUT, 41
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    INPUT

  answer do |input|
    v0 = nil

    grid = input.each_line
      .with_index
      .flat_map { |row, y| row.each_char
        .with_index
        .map { |ch, x| {Point2D.new(x, y), ch}.tap { |(v, _)| v0 = v if ch == '^' } } }
      .to_h

    v1 = v0.not_nil!
    dir = Vector2D::NORTH
    path = Set(Point2D).new

    while grid.has_key?(v1)
      path << v1
      v2 = v1 + dir
      while grid[v2]? == '#'
        dir = dir.cw
        v2 = v1 + dir
      end
      v1 = v2
    end

    path.size
  end
end

solve do
  test <<-INPUT, 6
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    INPUT

  answer do |input|
    v0 = nil

    grid = input.each_line
      .with_index
      .flat_map { |row, y| row.each_char
        .with_index
        .map { |ch, x| {Point2D.new(x, y), ch}.tap { |(v, _)| v0 = v if ch == '^' } } }
      .to_h

    grid.count do |obs_v, ch|
      next if ch == '#'

      begin
        grid[obs_v] = '#'
        v1 = v0.not_nil!
        dir = Vector2D::NORTH
        loop = Set({Point2D, Vector2D}).new

        while grid.has_key?(v1)
          v2 = v1 + dir
          while grid[v2]? == '#'
            dir = dir.cw
            v2 = v1 + dir
          end
          break true unless loop.add?({v1, dir})
          v1 = v2
        end
      ensure
        grid[obs_v] = '.'
      end
    end
  end
end
