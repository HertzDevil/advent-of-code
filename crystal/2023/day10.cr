require "../support"

PIPES_OUT = {
  '-' => [Vector2D::EAST, Vector2D::WEST],
  '|' => [Vector2D::SOUTH, Vector2D::NORTH],
  'L' => [Vector2D::EAST, Vector2D::NORTH],
  'J' => [Vector2D::NORTH, Vector2D::WEST],
  '7' => [Vector2D::WEST, Vector2D::SOUTH],
  'F' => [Vector2D::SOUTH, Vector2D::EAST],
  'S' => [Vector2D::NORTH, Vector2D::WEST, Vector2D::SOUTH, Vector2D::EAST],
  '.' => [] of Vector2D,
}

PIPES_IN = PIPES_OUT.transform_values &.map &.-

def find_loop(grid, s)
  v1 = s
  loop = Set{v1}

  while true
    v1_pipe = PIPES_OUT[grid[v1]]
    v1 = VonNeumann2D.neighbors(v1) do |v2|
      next if loop.includes?(v2)
      v2_pipe = PIPES_IN[grid[v2]? || next]
      dv = v2 - v1
      break v2 if dv.in?(v1_pipe) && dv.in?(v2_pipe)
    end || break
    loop << v1
  end

  grid[s] = PIPES_OUT.each do |ch, outs|
    next if ch == 'S'
    break ch if outs.all? { |v| v.in?(PIPES_IN[grid[s + v]? || next false]) }
  end.not_nil!

  loop
end

solve do
  test <<-INPUT, 4
    -L|F7
    7S-7|
    L|7||
    -L-J|
    L|-JF
    INPUT

  test <<-INPUT, 8
    ..F7.
    .FJ|.
    SJ.L7
    |F--J
    LJ...
    INPUT

  answer do |input|
    grid = input.each_line
      .with_index
      .flat_map { |row, y| row.each_char
        .with_index
        .map { |ch, x| {Point2D.new(x, y), ch} } }
      .to_h

    s = grid.each { |k, v| break k if v == 'S' }.not_nil!
    find_loop(grid, s).size // 2
  end
end

solve do
  test <<-INPUT, 4
    ...........
    .S-------7.
    .|F-----7|.
    .||.....||.
    .||.....||.
    .|L-7.F-J|.
    .|..|.|..|.
    .L--J.L--J.
    ...........
    INPUT

  test <<-INPUT, 4
    ..........
    .S------7.
    .|F----7|.
    .||....||.
    .||....||.
    .|L-7F-J|.
    .|..||..|.
    .L--JL--J.
    ..........
    INPUT

  test <<-INPUT, 8
    .F----7F7F7F7F-7....
    .|F--7||||||||FJ....
    .||.FJ||||||||L7....
    FJL7L7LJLJ||LJ.L-7..
    L--J.L7...LJS7F-7L7.
    ....F-J..F7FJ|L7L7L7
    ....L7.F7||L7|.L7L7|
    .....|FJLJ|FJ|F7|.LJ
    ....FJL-7.||.||||...
    ....L---J.LJ.LJLJ...
    INPUT

  test <<-INPUT, 10
    FF7FSF7F7F7F7F7F---7
    L|LJ||||||||||||F--J
    FL-7LJLJ||||||LJL-77
    F--JF--7||LJLJ7F7FJ-
    L---JF-JLJ.||-FJLJJ7
    |F|F-JF---7F7-L7L|7|
    |FFJF7L7F-JF7|JL---7
    7-L-JL7||F7|L7F-7F7|
    L.L7LFJ|||||FJL7||LJ
    L7JLJL-JLJLJL--JLJ.L
    INPUT

  answer do |input|
    grid = input.each_line
      .with_index
      .flat_map { |row, y| row.each_char
        .with_index
        .map { |ch, x| {Point2D.new(x, y), ch} } }
      .to_h

    s = grid.each { |k, v| break k if v == 'S' }.not_nil!
    loop = find_loop(grid, s)

    width = grid.max_of &.[0].x
    height = grid.max_of &.[0].y
    inside = Array.new(width, Inside::None)
    total = 0

    height.times do |y|
      width.times do |x|
        v = Point2D.new(x, y)
        if loop.includes?(v)
          inside[x] =
            case {inside[x], grid[v]}
            when {Inside::None, 'F'}  then Inside::Right
            when {Inside::None, '-'}  then Inside::All
            when {Inside::None, '7'}  then Inside::Left
            when {Inside::All, 'F'}   then Inside::Left
            when {Inside::All, '-'}   then Inside::None
            when {Inside::All, '7'}   then Inside::Right
            when {Inside::Right, 'L'} then Inside::None
            when {Inside::Right, 'J'} then Inside::All
            when {Inside::Left, 'J'}  then Inside::None
            when {Inside::Left, 'L'}  then Inside::All
            end || inside[x]
        else
          total += 1 if inside[x] == Inside::All
        end
      end
    end

    total
  end
end

@[Flags]
enum Inside
  Left
  Right
end
