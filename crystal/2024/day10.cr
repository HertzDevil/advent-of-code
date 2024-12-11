require "../support"

solve do
  test <<-INPUT, 2
    ...0...
    ...1...
    ...2...
    6543456
    7.....7
    8.....8
    9.....9
    INPUT

  test <<-INPUT, 4
    ..90..9
    ...1.98
    ...2..7
    6543456
    765.987
    876....
    987....
    INPUT

  test <<-INPUT, 3
    10..9..
    2...8..
    3...7..
    4567654
    ...8..3
    ...9..2
    .....01
    INPUT

  test <<-INPUT, 36
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    INPUT

  answer do |input|
    grid = input.each_line
      .with_index
      .flat_map { |row, y| row.each_char
        .with_index
        .map { |ch, x| {Point2D.new(x, y), ch == '.' ? -1 : ch.to_i} } }
      .to_h

    grid.sum do |v0, ch|
      next 0 unless ch == 0

      head = Set{v0}
      (1..9).each do |d|
        head2 = Set(Point2D).new
        head.each do |v1|
          VonNeumann2D.neighbors(v1) do |v2|
            if grid[v2]? == d
              head2 << v2
            end
          end
        end
        head = head2
      end
      head.size
    end
  end
end

solve do
  test <<-INPUT, 3
    .....0.
    ..4321.
    ..5..2.
    ..6543.
    ..7..4.
    ..8765.
    ..9....
    INPUT

  test <<-INPUT, 13
    ..90..9
    ...1.98
    ...2..7
    6543456
    765.987
    876....
    987....
    INPUT

  test <<-INPUT, 227
    012345
    123456
    234567
    345678
    4.6789
    56789.
    INPUT

  test <<-INPUT, 81
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    INPUT

  answer do |input|
    grid = input.each_line
      .with_index
      .flat_map { |row, y| row.each_char
        .with_index
        .map { |ch, x| {Point2D.new(x, y), ch == '.' ? -1 : ch.to_i} } }
      .to_h

    totals = grid.select { |_, ch| ch == 0 }.transform_values { 1 }
    (1..9).each do |d|
      totals2 = Hash(Point2D, Int32).new(0)
      totals.each do |v1, k|
        VonNeumann2D.neighbors(v1) do |v2|
          if grid[v2]? == d
            totals2[v2] += k
          end
        end
      end
      totals = totals2
    end
    totals.sum(&.last)
  end
end
