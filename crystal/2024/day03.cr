require "../support"

solve do
  test <<-INPUT, 161
    xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
    INPUT

  answer &.scan(/mul\((\d+),(\d+)\)/)
    .sum { |m| m[1].to_i * m[2].to_i }
end

solve do
  test <<-INPUT, 48
    xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
    INPUT

  answer &.scan(/mul\((\d+),(\d+)\)|(don't\(\))|(do\(\))/)
    .reduce({0, true}) do |(acc, enable), v|
      v[3]? ? {acc, false} : v[4]? ? {acc, true} : enable ? {acc + v[1].to_i * v[2].to_i, enable} : {acc, enable}
    end[0]
end
