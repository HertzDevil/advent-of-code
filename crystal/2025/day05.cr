require "../support"

solve do
  test <<-INPUT, 3
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
    INPUT

  answer do |input|
    ranges, _, ids = input.partition("\n\n")
    ranges = ranges.scan(/\d+/).map(&.[0].to_i64).in_slices_of(2)
    ids.each_line.map(&.to_i64).count { |v| ranges.any? { |(lo, hi)| v.in?(lo..hi) } }
  end
end

ToI64 = ->(str) do
  0_i64 + parse_type("Foo(#{str.id})").type_vars[0]
end

InRange = ->(v, data) do
  ranges = data
  ranges.any? { |(lo, hi)| lo <= v <= hi }
end

m_solve do
  m_test <<-INPUT, 3
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
    INPUT

  m_answer do |input|
    ranges, ids = input.split("\n\n")
    ranges = ranges.lines.map(&.split('-').map { |v| ToI64.call(v) })
    M::Array::Count.call(ids.lines.map { |v| ToI64.call(v) }, InRange, ranges)
  end
end

solve do
  test <<-INPUT, 14
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
    INPUT

  answer do |input|
    ranges, _, _ = input.partition("\n\n")
    ranges = ranges.scan(/\d+/).map(&.[0].to_i64).in_slices_of(2).sort!

    vs = nil
    sum = 0_i64
    ranges.each do |(lo, hi)|
      if vs && lo <= vs.max_of(&.last) + 1 && hi >= vs.min_of(&.first) - 1
        vs << {lo, hi}
      else
        if vs
          sum += vs.max_of(&.last) - vs.min_of(&.first) + 1
        end
        vs = [{lo, hi}]
      end
    end
    if vs
      sum += vs.max_of(&.last) - vs.min_of(&.first) + 1
    end
    sum
  end
end

First = ->(arr) do
  arr[0]
end

Last = ->(arr) do
  arr[-1]
end

m_solve do
  m_test <<-INPUT, 14_i64
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
    INPUT

  m_answer do |input|
    ranges, ids = input.split("\n\n")
    ranges = ranges.lines.map(&.split('-').map { |v| ToI64.call(v) }).sort_by { |v| (1_i128 << 64) * v[0] + v[1] }

    vs = nil
    sum = 0_i64
    ranges.each do |(lo, hi)|
      if vs && lo <= M::Array::MaxOf.call(vs, Last, nil) + 1 && hi >= M::Array::MinOf.call(vs, First, nil) - 1
        vs << {lo, hi}
      else
        if vs
          sum += M::Array::MaxOf.call(vs, Last, nil) - M::Array::MinOf.call(vs, First, nil) + 1
        end
        vs = [{lo, hi}]
      end
    end
    if vs
      sum += M::Array::MaxOf.call(vs, Last, nil) - M::Array::MinOf.call(vs, First, nil) + 1
    end
    sum
  end
end
