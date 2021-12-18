require "../support"

def explode_number(str)
  nest = 0
  str.each_char_with_index do |ch, i|
    case ch
    when '['
      nest += 1
    when ']'
      nest -= 1
    when '0'..'9'
      if nest >= 5
        # i-1: [
        # i:   x
        # i+1: ,
        # i+2: y
        # i+3: ]
        x_m = str.match(/\d+/, i).not_nil!
        x = x_m[0].to_i
        y_m = str.match(/\d+/, x_m.end).not_nil!
        y = y_m[0].to_i
        prev_index = str.rindex(/\d+/, x_m.begin - 1)
        next_index = str.index(/\d+/, y_m.end)
        return String.build do |io|
          if prev_index
            prev_match = str.match(/\d+/, prev_index).not_nil!
            io << str[0...prev_index]
            io << prev_match[0].to_i + x
            io << str[prev_match.end..x_m.begin - 2]
          else
            io << str[0..x_m.begin - 2]
          end
          io << 0
          if next_index
            next_match = str.match(/\d+/, next_index).not_nil!
            io << str[y_m.end + 1...next_index]
            io << next_match[0].to_i + y
            io << str[next_match.end..]
          else
            io << str[y_m.end + 1..]
          end
        end
      end
    end
  end
  nil
end

# explode_number("[[[[[9,8],1],2],3],4]")
# explode_number("[7,[6,[5,[4,[3,2]]]]]")
# explode_number("[[6,[5,[4,[3,2]]]],1]")
# explode_number("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]")
# explode_number("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]")

def split_number(str)
  if m = str.match(/(\d\d)/)
    x = $1.to_i
    "#{m.pre_match}[#{x // 2},#{(x + 1) // 2}]#{m.post_match}"
  end
end

# split_number("[[[[0,7],4],[15,[0,13]]],[1,1]]")
# split_number("[[[[0,7],4],[[7,8],[0,13]]],[1,1]]")

def reduce_number(str)
  while true
    if str2 = explode_number(str)
      str = str2
      next
    end

    if str2 = split_number(str)
      str = str2
      next
    end

    return str
  end
end

def magnitude(str)
  while str.includes?('[')
    str = str.gsub(/\[(\d+),(\d+)\]/) { ($1.to_i64 * 3 + $2.to_i64 * 2).to_s }
  end
  str.to_i
end

solve do
  test "[9,1]", 29
  test "[1,9]", 21
  test "[[9,1],[1,9]]", 129
  test "[[1,2],[[3,4],5]]", 143
  test "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]", 1384
  test "[[[[1,1],[2,2]],[3,3]],[4,4]]", 445
  test "[[[[3,0],[5,3]],[4,4]],[5,5]]", 791
  test "[[[[5,0],[7,4]],[5,5]],[6,6]]", 1137
  test "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]", 3488

  answer do |input|
    magnitude(input.each_line.reduce do |x, y|
      reduce_number "[#{x},#{y}]"
    end)
  end
end

solve do
  test <<-INPUT, 3993
    [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
    [[[5,[2,8]],4],[5,[[9,9],0]]]
    [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
    [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
    [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
    [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
    [[[[5,4],[7,7]],8],[[8,3],8]]
    [[9,3],[[9,9],[6,[4,9]]]]
    [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
    [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
    INPUT

  answer &.lines
    .each_permutation(2)
    .max_of { |(x, y)|
      magnitude(reduce_number "[#{x},#{y}]")
    }
end
