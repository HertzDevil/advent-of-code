require "../support"

solve do
  test <<-INPUT, 150
    forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2
    INPUT

  answer &.each_line
    .reduce({0, 0}) { |(x, y), line|
      case line
      when /forward (\d+)/; {x + $1.to_i, y}
      when /down (\d+)/   ; {x, y + $1.to_i}
      when /up (\d+)/     ; {x, y - $1.to_i}
      else                  raise ""
      end
    }
    .product
end

solve do
  test <<-INPUT, 900
    forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2
    INPUT

  answer &.each_line
    .reduce({0, 0, 0}) { |(x, y, aim), line|
      case line
      when /forward (\d+)/; {x + $1.to_i, y + aim * $1.to_i, aim}
      when /down (\d+)/   ; {x, y, aim + $1.to_i}
      when /up (\d+)/     ; {x, y, aim - $1.to_i}
      else                  raise ""
      end
    }
    .[0..1]
    .product
end
