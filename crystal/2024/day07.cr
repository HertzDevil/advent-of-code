require "../support"

add = ->(x : Int64, y : Int64) { x + y }
mul = ->(x : Int64, y : Int64) { x * y }
cat = ->(x : Int64, y : Int64) do
  {% for i in 1..18 %}
    return x * {{ 10_i64 ** i }} + y if y < {{ 10_i64 ** i }}
  {% end %}
  raise OverflowError.new
end

solve do
  test <<-INPUT, 3749
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    INPUT

  answer &.each_line.sum do |line|
    target, _, values = line.partition(": ")
    target = target.to_i64
    values = values.split(' ').map(&.to_i64)

    Indexable.each_cartesian(Array.new(values.size - 1, {add, mul}), reuse: true).any? do |ops|
      x = values[0]
      ops.each_with_index do |op, i|
        x = op.call(x, values[i + 1])
      end
      x == target
    end ? target : 0_i64
  end
end

solve do
  test <<-INPUT, 11387
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    INPUT

  answer &.each_line.sum do |line|
    target, _, values = line.partition(": ")
    target = target.to_i64
    values = values.split(' ').map(&.to_i64)

    Indexable.each_cartesian(Array.new(values.size - 1, {add, mul, cat}), reuse: true).any? do |ops|
      x = values[0]
      ops.each_with_index do |op, i|
        x = op.call(x, values[i + 1])
      end
      x == target
    end ? target : 0_i64
  end
end
