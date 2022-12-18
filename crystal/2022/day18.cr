require "../support"

SIDES = [
  Vector3D.new(0, 0, -1),
  Vector3D.new(0, 0, 1),
  Vector3D.new(0, -1, 0),
  Vector3D.new(0, 1, 0),
  Vector3D.new(-1, 0, 0),
  Vector3D.new(1, 0, 0),
]

solve do
  test <<-INPUT, 64
    2,2,2
    1,2,2
    3,2,2
    2,1,2
    2,3,2
    2,2,1
    2,2,3
    2,2,4
    2,2,6
    1,2,5
    3,2,5
    2,1,5
    2,3,5
    INPUT

  answer do |input|
    cells = input.scan(/\d+/)
      .map(&.[0].to_i)
      .each_slice(3)
      .map { |(x, y, z)| Point3D.new(x, y, z) }
      .to_set

    SIDES.sum do |offset|
      cells.count do |cell|
        !cells.includes?(cell + offset)
      end
    end
  end
end

solve do
  test <<-INPUT, 58
    2,2,2
    1,2,2
    3,2,2
    2,1,2
    2,3,2
    2,2,1
    2,2,3
    2,2,4
    2,2,6
    1,2,5
    3,2,5
    2,1,5
    2,3,5
    INPUT

  answer do |input|
    cells = input.scan(/\d+/)
      .map(&.[0].to_i)
      .each_slice(3)
      .map { |(x, y, z)| Point3D.new(x, y, z) }
      .to_set

    imin, imax = cells.flat_map(&.to_tuple.each).minmax
    imin -= 1
    imax += 1

    v0 = Point3D.new(imin, imin, imin)
    air = Set{v0}
    queue = Deque{v0}

    while a = queue.pop?
      SIDES.each do |offset|
        a2 = a + offset
        next unless a2.to_tuple.all? &.in?(imin..imax)
        next if air.includes?(a2) || cells.includes?(a2)
        air << a2
        queue << a2
      end
    end

    SIDES.sum do |offset|
      air.count do |a|
        !air.includes?(a + offset)
      end
    end - 6 * (imax - imin + 1) ** 2
  end
end
