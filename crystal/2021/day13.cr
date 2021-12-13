require "../support"

solve do
  test <<-INPUT, 17
    6,10
    0,14
    9,10
    0,3
    10,4
    4,11
    6,0
    6,12
    4,1
    0,13
    10,12
    3,4
    3,0
    8,4
    1,10
    2,14
    8,10
    9,0

    fold along y=7
    fold along x=5
    INPUT

  answer do |input|
    dots = [] of {Int32, Int32}
    input.each_line do |line|
      case line
      when /\A(\d+),(\d+)\z/
        dots << {$1.to_i, $2.to_i}
      when /\Afold along x=(\d+)\z/
        x0 = $1.to_i
        dots.map! { |(x, y)| {x > x0 ? x0 + x0 - x : x, y} }
        dots.uniq!
        break
      when /\Afold along y=(\d+)\z/
        y0 = $1.to_i
        dots.map! { |(x, y)| {x, y > y0 ? y0 + y0 - y : y} }
        dots.uniq!
        break
      end
    end
    dots.size
  end
end

solve do
  answer do |input|
    dots = [] of {Int32, Int32}
    input.each_line do |line|
      case line
      when /\A(\d+),(\d+)\z/
        dots << {$1.to_i, $2.to_i}
      when /\Afold along x=(\d+)\z/
        x0 = $1.to_i
        dots.map! { |(x, y)| {x > x0 ? x0 + x0 - x : x, y} }
        dots.uniq!
      when /\Afold along y=(\d+)\z/
        y0 = $1.to_i
        dots.map! { |(x, y)| {x, y > y0 ? y0 + y0 - y : y} }
        dots.uniq!
      end
    end
    max_x = dots.max_of &.[0]
    max_y = dots.max_of &.[1]
    (0..max_y).each do |y|
      (0..max_x).each do |x|
        print dots.includes?({x, y}) ? '#' : '.'
      end
      print '\n'
    end
  end
end
