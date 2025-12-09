require "../support"

solve do
  test <<-INPUT, 50
    7,1
    11,1
    11,7
    9,7
    9,5
    2,5
    2,3
    7,3
    INPUT

  answer &.lines
    .map(&.split(',').map(&.to_i64))
    .each_combination(2)
    .max_of { |((x1, y1), (x2, y2))| ((x2 - x1).abs + 1) * ((y2 - y1).abs + 1) }
end

m_solve do
  m_test <<-INPUT, 50_i64
    7,1
    11,1
    11,7
    9,7
    9,5
    2,5
    2,3
    7,3
    INPUT

  m_answer do |input|
    red = input.lines.map(&.split(',').map { |v| M::String::ToI64.call(v) })
    max = 0_i64
    (0..red.size - 2).each do |i|
      x1, y1 = red[i]
      (i + 1..red.size - 1).each do |j|
        x2, y2 = red[j]
        max = M::Math::Max.call(max, (M::Math::Abs.call(x2 - x1) + 1) * (M::Math::Abs.call(y2 - y1) + 1))
      end
    end
    max
  end
end

solve do
  test <<-INPUT, 24
    7,1
    11,1
    11,7
    9,7
    9,5
    2,5
    2,3
    7,3
    INPUT

  answer do |input|
    # red = input.lines.map(&.split(',').map(&.to_i64))
    red = input.lines.map { |line| x, _, y = line.partition(','); {x.to_i64, y.to_i64} }
    edges = red.each_cons_pair.to_a << {red.last, red.first}
    edges_vert = edges.compact_map { |(x1, y1), (x2, y2)| {x1, *{y1, y2}.minmax} if x1 == x2 }

    xs = red.map(&.first).uniq!.sort!
    ys = red.map(&.last).uniq!.sort!
    xs_h = xs.each_with_index.to_h
    ys_h = ys.each_with_index.to_h
    xmids = xs.each_cons_pair.map { |a, b| (a + b) / 2 }.to_a
    ymids = ys.each_cons_pair.map { |a, b| (a + b) / 2 }.to_a

    inside = xmids.map do |x|
      ymids.map do |y|
        crossings = edges_vert.count { |ex, ey1, ey2| x < ex && y.in?(ey1..ey2) }
        crossings.odd?
      end
    end

    red.each_combination(2).max_of do |((xi, yi), (xj, yj))|
      x1, x2 = {xi, xj}.minmax
      y1, y2 = {yi, yj}.minmax
      (xs_h[x1]...xs_h[x2]).all? do |xmid_i|
        (ys_h[y1]...ys_h[y2]).all? do |ymid_i|
          inside[xmid_i][ymid_i]
        end
      end ? (x2 - x1 + 1) * (y2 - y1 + 1) : 0
    end
  end
end

Intersects = ->(edge_vert, data) do
  ex, ey1, ey2 = edge_vert
  x, y = data
  x < ex && (ey1 <= y <= ey2)
end

m_solve do
  m_test <<-INPUT, 24_i64
    7,1
    11,1
    11,7
    9,7
    9,5
    2,5
    2,3
    7,3
    INPUT

  m_answer do |input|
    red = input.lines.map(&.split(',').map { |v| M::String::ToI64.call(v) })
    edges = [] of _
    edges_vert = [] of _
    red.each_with_index do |v1, i|
      v2 = red[(i + 1) % red.size]
      edges << {v1, v2}
      if v1[0] == v2[0]
        edges_vert << {v1[0], M::Math::Min.call(v1[1], v2[1]), M::Math::Max.call(v1[1], v2[1])}
      end
    end

    xs = red.map(&.first).uniq.sort
    ys = red.map(&.last).uniq.sort
    xs_h = {} of _ => _
    ys_h = {} of _ => _
    xmids = [] of _
    ymids = [] of _
    xs.each_with_index do |x, i|
      xmids << (xs[i - 1] + x) / 2 unless i == 0
      xs_h[x] = i
    end
    ys.each_with_index do |y, i|
      ymids << (ys[i - 1] + y) / 2 unless i == 0
      ys_h[y] = i
    end

    inside = xmids.map do |x|
      ymids.map do |y|
        crossings = M::Array::Count.call(edges_vert, Intersects, {x, y})
        crossings % 2 == 1
      end
    end

    max = 0_i64
    (0..red.size - 2).each do |i|
      xi, yi = red[i]
      (i + 1..red.size - 1).each do |j|
        xj, yj = red[j]
        x1, x2 = M::Math::Min.call(xi, xj), M::Math::Max.call(xi, xj)
        y1, y2 = M::Math::Min.call(yi, yj), M::Math::Max.call(yi, yj)
        xmid_is = (xs_h[x1]...xs_h[x2]).to_a
        ymid_is = (ys_h[y1]...ys_h[y2]).to_a
        if xmid_is.all? { |xmid_i| ymid_is.all? { |ymid_i| inside[xmid_i][ymid_i] } }
          max = M::Math::Max.call(max, (x2 - x1 + 1) * (y2 - y1 + 1))
        end
      end
    end
    max
  end
end
