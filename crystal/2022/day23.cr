require "../support"

solve do
  test <<-INPUT, 25
    .....
    ..##.
    ..#..
    .....
    ..##.
    .....
    INPUT

  test <<-INPUT, 110
    ....#..
    ..###.#
    #...#.#
    .#...##
    #.###..
    ##.#.##
    .#..#..
    INPUT

  answer do |input|
    dirs = [
      {Vector2D.new(-1, -1), Vector2D.new(0, -1), Vector2D.new(1, -1)}, # N
      {Vector2D.new(1, 1), Vector2D.new(0, 1), Vector2D.new(-1, 1)},    # S
      {Vector2D.new(-1, 1), Vector2D.new(-1, 0), Vector2D.new(-1, -1)}, # W
      {Vector2D.new(1, -1), Vector2D.new(1, 0), Vector2D.new(1, 1)},    # E
    ]

    elves = input.each_line
      .with_index
      .flat_map { |row, y| row.each_char
        .with_index
        .select { |ch, _| ch != '.' }
        .map { |_, x| Point2D.new(x, y) } }
      .to_set

    10.times do |i|
      proposals = elves.group_by do |elf|
        next nil if Moore2D.neighbors(elf).none? { |v| elves.includes?(v) }

        dirs.each do |dir|
          dests = dir.map &.+(elf)
          break dests[1] if dests.all? { |v| !elves.includes?(v) }
        end
      end

      elves.clear
      proposals.each do |k, vs|
        if k.nil? || vs.size != 1
          elves.concat(vs)
        else
          elves << k
        end
      end

      dirs << dirs.shift
    end

    xmin, xmax = elves.minmax_of &.x
    ymin, ymax = elves.minmax_of &.y
    (xmax - xmin + 1) * (ymax - ymin + 1) - elves.size
  end
end

solve do
  test <<-INPUT, 4
    .....
    ..##.
    ..#..
    .....
    ..##.
    .....
    INPUT

  test <<-INPUT, 20
    ....#..
    ..###.#
    #...#.#
    .#...##
    #.###..
    ##.#.##
    .#..#..
    INPUT

  answer do |input|
    dirs = [
      {Vector2D.new(-1, -1), Vector2D.new(0, -1), Vector2D.new(1, -1)}, # N
      {Vector2D.new(1, 1), Vector2D.new(0, 1), Vector2D.new(-1, 1)},    # S
      {Vector2D.new(-1, 1), Vector2D.new(-1, 0), Vector2D.new(-1, -1)}, # W
      {Vector2D.new(1, -1), Vector2D.new(1, 0), Vector2D.new(1, 1)},    # E
    ]

    elves = input.each_line
      .with_index
      .flat_map { |row, y| row.each_char
        .with_index
        .select { |ch, _| ch != '.' }
        .map { |_, x| Point2D.new(x, y) } }
      .to_set

    (0..).each do |i|
      proposals = elves.group_by do |elf|
        next nil if Moore2D.neighbors(elf).none? { |v| elves.includes?(v) }

        dirs.each do |dir|
          dests = dir.map &.+(elf)
          break dests[1] if dests.all? { |v| !elves.includes?(v) }
        end
      end

      break i + 1 if proposals.size == 1 && proposals.keys == [nil]

      elves.clear
      proposals.each do |k, vs|
        if k.nil? || vs.size != 1
          elves.concat(vs)
        else
          elves << k
        end
      end

      dirs << dirs.shift
    end
  end
end
