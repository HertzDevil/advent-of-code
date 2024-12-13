require "../support"

solve do
  test <<-INPUT, 280
    Button A: X+94, Y+34
    Button B: X+22, Y+67
    Prize: X=8400, Y=5400
    INPUT

  test <<-INPUT, 0
    Button A: X+26, Y+66
    Button B: X+67, Y+21
    Prize: X=12748, Y=12176
    INPUT

  test <<-INPUT, 200
    Button A: X+17, Y+86
    Button B: X+84, Y+37
    Prize: X=7870, Y=6450
    INPUT

  test <<-INPUT, 0
    Button A: X+69, Y+23
    Button B: X+27, Y+71
    Prize: X=18641, Y=10279
    INPUT

  test <<-INPUT, 480
    Button A: X+94, Y+34
    Button B: X+22, Y+67
    Prize: X=8400, Y=5400

    Button A: X+26, Y+66
    Button B: X+67, Y+21
    Prize: X=12748, Y=12176

    Button A: X+17, Y+86
    Button B: X+84, Y+37
    Prize: X=7870, Y=6450

    Button A: X+69, Y+23
    Button B: X+27, Y+71
    Prize: X=18641, Y=10279
    INPUT

  answer &.scan(/\d+/).map(&.[0].to_i).in_slices_of(6).sum do |(ax, ay, bx, by, x, y)|
    det = ax * by - ay * bx
    next 0 if det == 0

    a = by * x - bx * y
    b = -ay * x + ax * y
    next 0 unless a % det == 0 && b % det == 0

    (a * 3 + b) // det
  end
end

solve do
  answer &.scan(/\d+/).map(&.[0].to_i128).in_slices_of(6).sum do |(ax, ay, bx, by, x, y)|
    det = ax * by - ay * bx
    next 0 if det == 0

    a = by * (10000000000000 + x) - bx * (10000000000000 + y)
    b = -ay * (10000000000000 + x) + ax * (10000000000000 + y)
    next 0 unless a % det == 0 && b % det == 0

    (a * 3 + b) // det
  end
end
