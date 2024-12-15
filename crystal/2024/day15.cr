require "../support"

solve do
  test <<-INPUT, 2028
    ########
    #..O.O.#
    ##@.O..#
    #...O..#
    #.#.O..#
    #...O..#
    #......#
    ########

    <^^>>>vv<v>>v<<
    INPUT

  test <<-INPUT, 10092
    ##########
    #..O..O.O#
    #......O.#
    #.OO..O.O#
    #..O@..O.#
    #O#..O...#
    #O..O..O.#
    #.OO.O.OO#
    #....O...#
    ##########

    <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
    vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
    ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
    <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
    ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
    ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
    >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
    <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
    ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
    v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
    INPUT

  answer do |input|
    grid0, _, moves = input.partition("\n\n")

    grid = grid0.each_line
      .with_index
      .flat_map { |row, y| row.each_char
        .with_index
        .map { |ch, x| {Point2D.new(x, y), ch} } }
      .to_h

    v = grid.key_for('@')
    moves.each_char do |ch|
      dir =
        case ch
        when '^' then Vector2D::NORTH
        when '<' then Vector2D::WEST
        when 'v' then Vector2D::SOUTH
        when '>' then Vector2D::EAST
        else
          next
        end

      v1 = v + dir
      while grid[v1]? == 'O'
        v1 += dir
      end
      if grid[v1]? != '#'
        # .@
        # @.

        # .OOO@
        # OOO@.
        grid[v1] = grid[v1 - dir]
        grid[v + dir] = '@'
        grid[v] = '.'
        v += dir
      end
    end

    grid.sum do |v2, ch|
      ch == 'O' ? v2.y * 100 + v2.x : 0
    end
  end
end

solve do
  test <<-INPUT, 618
    #######
    #...#.#
    #.....#
    #..OO@#
    #..O..#
    #.....#
    #######

    <vv<<^^<<^^
    INPUT

  test <<-INPUT, 9021
    ##########
    #..O..O.O#
    #......O.#
    #.OO..O.O#
    #..O@..O.#
    #O#..O...#
    #O..O..O.#
    #.OO.O.OO#
    #....O...#
    ##########

    <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
    vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
    ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
    <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
    ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
    ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
    >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
    <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
    ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
    v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
    INPUT

  answer do |input|
    grid0, _, moves = input.partition("\n\n")

    wall = Set(Point2D).new
    boxes = Set(Point2D).new
    robot0 = nil

    grid0.each_line.with_index do |line, y|
      line.each_char.with_index do |ch, x|
        case ch
        when '#'
          wall << Point2D.new(x * 2, y)
          wall << Point2D.new(x * 2 + 1, y)
        when 'O'
          boxes << Point2D.new(x * 2, y)
        when '@'
          robot0 = Point2D.new(x * 2, y)
        end
      end
    end

    robot = robot0.not_nil!
    moving = Array(Point2D).new

    moves.each_char do |ch|
      moving.clear

      case ch
      when '^'
        dir = Vector2D::NORTH
        next if wall.includes?(robot + dir)
        check_move_v(moving, boxes, robot, dir)
        if moving.any? { |v| wall.includes?(v + Vector2D.new(0, -1)) || wall.includes?(v + Vector2D.new(1, -1)) }
          boxes.concat(moving)
        else
          boxes.concat(moving.map &.+(dir))
          robot += dir
        end
      when 'v'
        dir = Vector2D::SOUTH
        next if wall.includes?(robot + dir)
        check_move_v(moving, boxes, robot, dir)
        if moving.any? { |v| wall.includes?(v + Vector2D.new(0, 1)) || wall.includes?(v + Vector2D.new(1, 1)) }
          boxes.concat(moving)
        else
          boxes.concat(moving.map &.+(dir))
          robot += dir
        end
      when '<'
        dir = Vector2D::WEST
        next if wall.includes?(robot + dir)
        v1 = robot + Vector2D.new(-2, 0)
        while boxes.delete(v1)
          moving << v1
          v1 += Vector2D.new(-2, 0)
        end
        if moving.any? { |v| wall.includes?(v + Vector2D.new(-1, 0)) }
          boxes.concat(moving)
        else
          boxes.concat(moving.map &.+(dir))
          robot += dir
        end
      when '>'
        dir = Vector2D::EAST
        next if wall.includes?(robot + dir)
        v1 = robot + dir
        while boxes.delete(v1)
          moving << v1
          v1 += Vector2D.new(2, 0)
        end
        if moving.any? { |v| wall.includes?(v + Vector2D.new(2, 0)) }
          boxes.concat(moving)
        else
          boxes.concat(moving.map &.+(dir))
          robot += dir
        end
      else
        next
      end
    end

    boxes.sum { |v| v.y * 100 + v.x }
  end
end

def check_move_v(moving, boxes, v0, dir)
  v1 = v0 + dir
  if boxes.delete(v1)
    moving << v1
    check_move_v(moving, boxes, v1, dir)
    check_move_v(moving, boxes, v1 + Vector2D.new(1, 0), dir)
  elsif boxes.delete(v1 + Vector2D.new(-1, 0))
    moving << v1 + Vector2D.new(-1, 0)
    check_move_v(moving, boxes, v1 + Vector2D.new(-1, 0), dir)
    check_move_v(moving, boxes, v1, dir)
  end
end
