require "../support"

solve do
  test <<-INPUT, 140
    AAAA
    BBCD
    BBCC
    EEEC
    INPUT

  test <<-INPUT, 772
    OOOOO
    OXOXO
    OOOOO
    OXOXO
    OOOOO
    INPUT

  test <<-INPUT, 1930
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    INPUT

  answer do |input|
    grid = input.each_line
      .with_index
      .flat_map { |row, y| row.each_char
        .with_index
        .map { |ch, x| {Point2D.new(x, y), ch} } }
      .to_h

    visited = Set(Point2D).new

    grid.sum do |v0, ch|
      next 0 if visited.includes?(v0)

      head = Set{v0}
      region = Set{v0}
      until head.empty?
        head2 = Set(Point2D).new
        head.each do |v1|
          VonNeumann2D.neighbors(v1) do |v2|
            head2 << v2 if grid[v2]? == ch && !region.includes?(v2)
          end
        end
        region.concat(head2)
        head = head2
      end
      visited.concat(region)

      area = region.size
      perimeter = region.sum do |v1|
        VonNeumann2D.neighbors(v1).count do |v2|
          !region.includes?(v2)
        end
      end
      area * perimeter
    end
  end
end

solve do
  test <<-INPUT, 80
    AAAA
    BBCD
    BBCC
    EEEC
    INPUT

  test <<-INPUT, 436
    OOOOO
    OXOXO
    OOOOO
    OXOXO
    OOOOO
    INPUT

  test <<-INPUT, 236
    EEEEE
    EXXXX
    EEEEE
    EXXXX
    EEEEE
    INPUT

  test <<-INPUT, 368
    AAAAAA
    AAABBA
    AAABBA
    ABBAAA
    ABBAAA
    AAAAAA
    INPUT

  test <<-INPUT, 1206
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    INPUT

  answer do |input|
    grid = input.each_line
      .with_index
      .flat_map { |row, y| row.each_char
        .with_index
        .map { |ch, x| {Point2D.new(x, y), ch} } }
      .to_h

    visited = Set(Point2D).new

    grid.sum do |v0, ch|
      next 0 if visited.includes?(v0)

      head = Set{v0}
      region = Set{v0}
      until head.empty?
        head2 = Set(Point2D).new
        head.each do |v1|
          VonNeumann2D.neighbors(v1) do |v2|
            head2 << v2 if grid[v2]? == ch && !region.includes?(v2)
          end
        end
        region.concat(head2)
        head = head2
      end
      visited.concat(region)

      horz = [] of Point2D
      vert = [] of Point2D
      region.each do |v1|
        horz << v1 unless region.includes?(v1 + Vector2D::NORTH)
        horz << (v1 + Vector2D::SOUTH) unless region.includes?(v1 + Vector2D::SOUTH)
        vert << v1 unless region.includes?(v1 + Vector2D::WEST)
        vert << (v1 + Vector2D::EAST) unless region.includes?(v1 + Vector2D::EAST)
      end
      horz.sort_by! { |v| {v.y, v.x} }
      vert.sort_by! { |v| {v.x, v.y} }
      horz_count = horz.each_cons_pair.count do |v1, v2|
        v1.y != v2.y || v1.x != v2.x - 1 || region.includes?(v1) != region.includes?(v2)
      end + 1
      vert_count = vert.each_cons_pair.count do |v1, v2|
        v1.x != v2.x || v1.y != v2.y - 1 || region.includes?(v1) != region.includes?(v2)
      end + 1
      region.size * (horz_count + vert_count)
    end
  end
end
