require "../support"

solve do
  test <<-INPUT, 40
    162,817,812
    57,618,57
    906,360,560
    592,479,940
    352,342,300
    466,668,158
    542,29,236
    431,825,988
    739,650,466
    52,470,668
    216,146,977
    819,987,18
    117,168,530
    805,96,715
    346,949,466
    970,615,88
    941,993,340
    862,61,35
    984,92,344
    425,690,689
    INPUT

  answer do |input|
    boxes = input.lines.map(&.split(',').map(&.to_i64))
    groups = (0...boxes.size).to_a
    edges = groups.combinations(2).sort_by! { |(i, j)| boxes[i].zip(boxes[j]).sum { |k, l| (k - l) ** 2 } }

    edges.first(test_mode? ? 10 : 1000).each do |(i, j)|
      gi = groups[i]
      gj = groups[j]
      if gi != gj
        new_group = {gi, gj}.min
        groups.map! { |g| g.in?(gi, gj) ? new_group : g }
      end
    end

    groups.tally.values.sort!.last(3).product
  end
end

m_solve do
  m_test <<-INPUT, 40_i64
    162,817,812
    57,618,57
    906,360,560
    592,479,940
    352,342,300
    466,668,158
    542,29,236
    431,825,988
    739,650,466
    52,470,668
    216,146,977
    819,987,18
    117,168,530
    805,96,715
    346,949,466
    970,615,88
    941,993,340
    862,61,35
    984,92,344
    425,690,689
    INPUT

  m_answer do |input|
    boxes = input.lines.map(&.split(',').map { |v| M::String::ToI64.call(v) })
    groups = (0...boxes.size).map { |v| v }

    edges = [] of {Int32, Int32}
    (0..boxes.size - 2).each do |i|
      (i + 1..boxes.size - 1).each do |j|
        edges << {i, j}
      end
    end
    edges = edges.sort_by do |(i, j)|
      x1, y1, z1 = boxes[i]
      x2, y2, z2 = boxes[j]
      (x1 - x2) ** 2 + (y1 - y2) ** 2 + (z1 - z2) ** 2
    end

    edges[0, m_test_mode ? 10 : 1000].each do |(i, j)|
      gi = groups[i]
      gj = groups[j]
      if gi != gj
        new_group = M::Math::Min.call(gi, gj)
        groups.each_with_index do |g, k|
          if g == gi || g == gj
            groups[k] = new_group
          end
        end
      end
    end

    M::Array::Product.call(M::Array::Tally.call(groups).values.sort[-3..], nil, nil)
  end
end

solve do
  test <<-INPUT, 25272
    162,817,812
    57,618,57
    906,360,560
    592,479,940
    352,342,300
    466,668,158
    542,29,236
    431,825,988
    739,650,466
    52,470,668
    216,146,977
    819,987,18
    117,168,530
    805,96,715
    346,949,466
    970,615,88
    941,993,340
    862,61,35
    984,92,344
    425,690,689
    INPUT

  answer do |input|
    boxes = input.lines.map(&.split(',').map(&.to_i64))
    groups = (0...boxes.size).to_a
    edges = groups.combinations(2).sort_by! { |(i, j)| boxes[i].zip(boxes[j]).sum { |k, l| (k - l) ** 2 } }

    count = 1
    edges.find_value do |(i, j)|
      gi = groups[i]
      gj = groups[j]
      if gi != gj
        new_group = {gi, gj}.min
        groups.map! { |g| g.in?(gi, gj) ? new_group : g }
        count += 1

        if count == groups.size
          boxes[i][0] * boxes[j][0]
        end
      end
    end
  end
end

m_solve do
  m_test <<-INPUT, 25272_i64
    162,817,812
    57,618,57
    906,360,560
    592,479,940
    352,342,300
    466,668,158
    542,29,236
    431,825,988
    739,650,466
    52,470,668
    216,146,977
    819,987,18
    117,168,530
    805,96,715
    346,949,466
    970,615,88
    941,993,340
    862,61,35
    984,92,344
    425,690,689
    INPUT

  m_answer do |input|
    boxes = input.lines.map(&.split(',').map { |v| M::String::ToI64.call(v) })
    groups = (0...boxes.size).map { |v| v }

    edges = [] of {Int32, Int32}
    (0..boxes.size - 2).each do |i|
      (i + 1..boxes.size - 1).each do |j|
        edges << {i, j}
      end
    end
    edges = edges.sort_by do |(i, j)|
      x1, y1, z1 = boxes[i]
      x2, y2, z2 = boxes[j]
      (x1 - x2) ** 2 + (y1 - y2) ** 2 + (z1 - z2) ** 2
    end

    count = 1
    edge = edges.find do |(i, j)|
      if count < groups.size
        gi = groups[i]
        gj = groups[j]
        if gi != gj
          new_group = M::Math::Min.call(gi, gj)
          groups.each_with_index do |g, k|
            if g == gi || g == gj
              groups[k] = new_group
            end
          end
          count += 1
          count == groups.size
        end
      end
    end
    boxes[edge[0]][0] * boxes[edge[1]][0]
  end
end
