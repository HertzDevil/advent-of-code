require "../support"

def ilog10(x)
  {% for i in 1..18 %}
    return {{ i }} if x < {{ 10_i64 ** i }}
  {% end %}
  raise OverflowError.new
end

solve do
  test <<-INPUT, 55312
    125 17
    INPUT

  answer do |input|
    f = Hash({Int64, Int32}, Int64).new do |hsh, (stone, t)|
      hsh[{stone, t}] =
        if t <= 0
          1_i64
        elsif stone == 0
          hsh[{1_i64, t - 1}]
        else
          digits = ilog10(stone)
          if digits.even?
            m = 10_i64 ** (digits // 2)
            a = stone.tdiv(m)
            b = stone.remainder(m)
            hsh[{a, t - 1}] + hsh[{b, t - 1}]
          else
            hsh[{stone * 2024, t - 1}]
          end
        end
    end

    input.split(' ').sum { |v| f[{v.to_i64, 25}] }
  end
end

solve do
  answer do |input|
    f = Hash({Int64, Int32}, Int64).new do |hsh, (stone, t)|
      hsh[{stone, t}] =
        if t <= 0
          1_i64
        elsif stone == 0
          hsh[{1_i64, t - 1}]
        else
          digits = ilog10(stone)
          if digits.even?
            m = 10_i64 ** (digits // 2)
            a = stone.tdiv(m)
            b = stone.remainder(m)
            hsh[{a, t - 1}] + hsh[{b, t - 1}]
          else
            hsh[{stone * 2024, t - 1}]
          end
        end
    end

    input.split(' ').sum { |v| f[{v.to_i64, 75}] }
  end
end
