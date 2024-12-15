require "../support"

solve do
  test <<-INPUT, 12
    p=0,4 v=3,-3
    p=6,3 v=-1,-3
    p=10,3 v=-1,2
    p=2,0 v=2,-1
    p=0,0 v=1,3
    p=3,0 v=-2,-2
    p=7,6 v=-1,-3
    p=3,0 v=-1,-2
    p=9,3 v=2,3
    p=7,3 v=-1,2
    p=2,4 v=2,-3
    p=9,5 v=-3,-3
    INPUT

  answer do |input|
    w, h = test_mode? ? {11, 7} : {101, 103}
    robots = input.scan(/-?\d+/).in_slices_of(4).map do |m|
      x0 = m[0][0].to_i
      y0 = m[1][0].to_i
      dx = m[2][0].to_i
      dy = m[3][0].to_i
      {(x0 + 100 * dx) % w, (y0 + 100 * dy) % h}
    end

    whalf = w // 2
    hhalf = h // 2
    robots.count { |(x, y)| x < whalf && y < hhalf } *
      robots.count { |(x, y)| x < whalf && y > hhalf } *
      robots.count { |(x, y)| x > whalf && y < hhalf } *
      robots.count { |(x, y)| x > whalf && y > hhalf }
  end
end

solve do
  answer do |input|
    w, h = test_mode? ? {11, 7} : {101, 103}
    robots = input.scan(/-?\d+/).in_slices_of(4).map do |m|
      x0 = m[0][0].to_i
      y0 = m[1][0].to_i
      dx = m[2][0].to_i
      dy = m[3][0].to_i
      {x0, y0, dx, dy}
    end
    grid = Array.new(h) { Array.new(w, false) }

    (0..).each do |t|
      grid.each &.fill(false)
      robots.map! do |(x, y, dx, dy)|
        grid[y][x] = true
        {(x + dx) % w, (y + dy) % h, dx, dy}
      end

      puts "t = #{t}"
      grid.each do |row|
        row.each do |ch|
          print(ch ? '#' : '.')
        end
        print '\n'
      end
      STDIN.gets
    end

    0
  end
end

# x = 8 mod 101
# x = 54 mod 103
# 8088
