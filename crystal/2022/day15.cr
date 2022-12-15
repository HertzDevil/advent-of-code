require "../support"

solve do
  test <<-INPUT, 26
    Sensor at x=2, y=18: closest beacon is at x=-2, y=15
    Sensor at x=9, y=16: closest beacon is at x=10, y=16
    Sensor at x=13, y=2: closest beacon is at x=15, y=3
    Sensor at x=12, y=14: closest beacon is at x=10, y=16
    Sensor at x=10, y=20: closest beacon is at x=10, y=16
    Sensor at x=14, y=17: closest beacon is at x=10, y=16
    Sensor at x=8, y=7: closest beacon is at x=2, y=10
    Sensor at x=2, y=0: closest beacon is at x=2, y=10
    Sensor at x=0, y=11: closest beacon is at x=2, y=10
    Sensor at x=20, y=14: closest beacon is at x=25, y=17
    Sensor at x=17, y=20: closest beacon is at x=21, y=22
    Sensor at x=16, y=7: closest beacon is at x=15, y=3
    Sensor at x=14, y=3: closest beacon is at x=15, y=3
    Sensor at x=20, y=1: closest beacon is at x=15, y=3
    INPUT

  answer do |input|
    blocked = [] of Range(Int32, Int32)
    has_beacon = Set(Int32).new
    input.scan(/-?\d+/).each_slice(4) do |(sx, sy, bx, by)|
      s = Point2D.new(sx[0].to_i, sy[0].to_i)
      b = Point2D.new(bx[0].to_i, by[0].to_i)
      d = VonNeumann2D.distance(s, b)
      y = 10
      has_beacon << b.x if b.y == y

      hdist = d - (s.y - y).abs
      xmin = s.x - hdist
      xmax = s.x + hdist
      next unless xmin <= xmax

      overlap, blocked = blocked.partition { |r2| r2.begin <= xmax + 1 && r2.end >= xmin - 1 }
      overlap << (xmin..xmax)
      blocked << (overlap.min_of(&.begin)..overlap.max_of(&.end))
    end

    blocked.sum do |r|
      r.end - r.begin + 1 - has_beacon.count(&.in?(r))
    end
  end
end

solve do
  test <<-INPUT, 56000011
    Sensor at x=2, y=18: closest beacon is at x=-2, y=15
    Sensor at x=9, y=16: closest beacon is at x=10, y=16
    Sensor at x=13, y=2: closest beacon is at x=15, y=3
    Sensor at x=12, y=14: closest beacon is at x=10, y=16
    Sensor at x=10, y=20: closest beacon is at x=10, y=16
    Sensor at x=14, y=17: closest beacon is at x=10, y=16
    Sensor at x=8, y=7: closest beacon is at x=2, y=10
    Sensor at x=2, y=0: closest beacon is at x=2, y=10
    Sensor at x=0, y=11: closest beacon is at x=2, y=10
    Sensor at x=20, y=14: closest beacon is at x=25, y=17
    Sensor at x=17, y=20: closest beacon is at x=21, y=22
    Sensor at x=16, y=7: closest beacon is at x=15, y=3
    Sensor at x=14, y=3: closest beacon is at x=15, y=3
    Sensor at x=20, y=1: closest beacon is at x=15, y=3
    INPUT

  answer &->(input : String) do
    beacons = input.scan(/-?\d+/).each_slice(4).map do |(sx, sy, bx, by)|
      s = Point2D.new(sx[0].to_i, sy[0].to_i)
      b = Point2D.new(bx[0].to_i, by[0].to_i)
      d = VonNeumann2D.distance(s, b)
      {s, b, d}
    end.to_a

    beacons.each do |s1, _, d1|
      VonNeumann2D.sphere(s1, d1 + 1) do |v|
        next unless 0 <= v.x <= 4000000 && 0 <= v.y <= 4000000
        if beacons.all? { |s2, _, d2| VonNeumann2D.distance(v, s2) > d2 }
          return 4000000_u64 * v.x + v.y
        end
      end
    end

    # (0..4000000).each do |y|
    #   blocked = [] of Range(Int32, Int32)
    #   beacons.each do |s, b, d|
    #     hdist = d - (s.y - y).abs
    #     xmin = s.x - hdist
    #     xmax = s.x + hdist
    #     next unless xmin <= xmax

    #     overlap, blocked = blocked.partition { |r2| r2.begin <= xmax + 1 && r2.end >= xmin - 1 }
    #     overlap << (xmin..xmax)
    #     blocked << (overlap.min_of(&.begin)..overlap.max_of(&.end))
    #   end

    #   if blocked.size > 1
    #     x = blocked[0].end + 1
    #     return 4000000_u64 * x + y
    #   end
    # end
  end
end
