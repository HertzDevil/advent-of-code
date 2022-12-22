require "../support"

RIGHT = Vector2D.new(1, 0)
UP    = Vector2D.new(0, -1)
LEFT  = Vector2D.new(-1, 0)
DOWN  = Vector2D.new(0, 1)
DIRS  = [RIGHT, DOWN, LEFT, UP]

solve do
  test <<-INPUT, 6032
            ...#
            .#..
            #...
            ....
    ...#.......#
    ........#...
    ..#....#....
    ..........#.
            ...#....
            .....#..
            .#......
            ......#.

    10R5L5R10L4R5L5
    INPUT

  answer do |input|
    grid, _, path = input.partition("\n\n")

    grid = grid.each_line
      .with_index
      .flat_map { |row, y| row.each_char
        .with_index
        .select { |ch, _| ch != ' ' }
        .map { |ch, x| {Point2D.new(x, y), ch} } }
      .to_h

    edges = {} of {Point2D, Vector2D} => Point2D
    grid.each do |k, ch|
      next if ch == '#'
      DIRS.each do |v|
        k2 = k + v
        unless grid.has_key?(k2)
          k2 = k
          while grid.has_key?(k3 = k2 - v)
            k2 = k3
          end
        end
        edges[{k, v}] = k2 if grid[k2] == '.'
      end
    end

    pos = grid.each_key.select(&.y.== 0).min_by(&.x)
    v = RIGHT

    path.scan(/\d+|L|R/) do |m|
      m = m[0]
      if i = m.to_i?
        i.times { pos = edges[{pos, v}]? || break }
      else
        v = m == "L" ? v.ccw : v.cw
      end
    end

    1000 * (pos.y + 1) + 4 * (pos.x + 1) + DIRS.index!(v)
  end
end

solve do
  test <<-INPUT, 5031
            ...#
            .#..
            #...
            ....
    ...#.......#
    ........#...
    ..#....#....
    ..........#.
            ...#....
            .....#..
            .#......
            ......#.

    10R5L5R10L4R5L5
    INPUT

  answer do |input|
    slen = test_mode? ? 4 : 50
    wraps = test_mode? ? [
      {2, 0, LEFT, 1, 1, UP},
      {2, 0, UP, 0, 1, UP},
      {2, 0, RIGHT, 3, 2, RIGHT},
      {2, 1, RIGHT, 3, 2, UP},
      {0, 1, LEFT, 3, 2, DOWN},
      {0, 1, DOWN, 2, 2, DOWN},
      {1, 1, DOWN, 2, 2, LEFT},
    ] : [
      {1, 0, UP, 0, 3, LEFT},
      {1, 0, LEFT, 0, 2, LEFT},
      {1, 1, LEFT, 0, 2, UP},
      {2, 0, UP, 0, 3, DOWN},
      {2, 0, RIGHT, 1, 2, RIGHT},
      {2, 0, DOWN, 1, 1, RIGHT},
      {1, 2, DOWN, 0, 3, RIGHT},
    ]
    wraps = wraps.flat_map do |(sx1, sy1, v1, sx2, sy2, v2)|
      [
        { {sx1, sy1, v1}, {sx2, sy2, -v2} },
        { {sx2, sy2, v2}, {sx1, sy1, -v1} },
      ]
    end.to_h

    grid, _, path = input.partition("\n\n")

    grid = grid.each_line
      .with_index
      .flat_map { |row, y| row.each_char
        .with_index
        .select { |ch, _| ch != ' ' }
        .map { |ch, x| {Point2D.new(x, y), ch} } }
      .to_h

    edges = {} of {Point2D, Vector2D} => {Point2D, Vector2D}
    grid.each do |k, ch|
      next if ch == '#'
      DIRS.each do |v|
        k2 = k + v
        v2 = v
        unless grid.has_key?(k2)
          s1x = k.x // slen * slen
          s1y = k.y // slen * slen
          s2x, s2y, v2 = wraps[{k.x // slen, k.y // slen, v}]
          k2 = Point2D.new(s2x * slen, s2y * slen)
          case v
          when RIGHT; d = slen - 1 - (k.y - s1y)
          when DOWN ; d = k.x - s1x
          when LEFT ; d = k.y - s1y
          when UP   ; d = slen - 1 - (k.x - s1x)
          else        raise ""
          end

          case v2
          when RIGHT; k2 += Vector2D.new(0, slen - 1 - d)
          when DOWN ; k2 += Vector2D.new(d, 0)
          when LEFT ; k2 += Vector2D.new(slen - 1, d)
          when UP   ; k2 += Vector2D.new(slen - 1 - d, slen - 1)
          end
        end
        edges[{k, v}] = {k2, v2} if grid[k2]? == '.'
      end
    end

    pos = grid.each_key.select(&.y.== 0).min_by(&.x)
    v = RIGHT

    path.scan(/\d+|L|R/) do |m|
      m = m[0]
      if i = m.to_i?
        i.times { pos, v = edges[{pos, v}]? || break }
      else
        v = m == "L" ? v.ccw : v.cw
      end
    end

    1000 * (pos.y + 1) + 4 * (pos.x + 1) + DIRS.index!(v)
  end
end
