require "../support"

solve do
  test <<-INPUT, 31
    Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi
    INPUT

  answer do |input|
    grid = input.each_line
      .with_index
      .flat_map { |row, y| row.each_char
        .with_index
        .map { |ch, x| {Point2D.new(x, y), ch} } }
      .to_h
    s_v = grid.key_for('S')
    e_v = grid.key_for('E')
    grid[s_v] = 'a'
    grid[e_v] = 'z'

    GridBFS.new(grid, VonNeumann2D)
      .path { |_, src, _, dst| dst - src >= -1 }
      .finish(&.has_key?(s_v))
      .run(e_v)
  end
end

solve do
  test <<-INPUT, 29
    Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi
    INPUT

  answer do |input|
    grid = input.each_line
      .with_index
      .flat_map { |row, y| row.each_char
        .with_index
        .map { |ch, x| {Point2D.new(x, y), ch} } }
      .to_h
    s_v = grid.key_for('S')
    e_v = grid.key_for('E')
    grid[s_v] = 'a'
    grid[e_v] = 'z'

    GridBFS.new(grid, VonNeumann2D)
      .path { |_, src, _, dst| dst - src >= -1 }
      .finish(&.any? { |v, _| grid[v] == 'a' })
      .run(e_v)
  end
end
