require "../support"

def eval(nodes, name, cache = {} of String => Int64)
  cache.fetch(name) do
    cache[name] =
      case v = nodes[name]
      in Int64
        v
      in NamedTuple
        left = eval(nodes, v[:left], cache)
        right = eval(nodes, v[:right], cache)
        case v[:op]
        when "+"
          left + right
        when "-"
          left - right
        when "*"
          left * right
        else
          left // right
        end
      end
  end
end

solve do
  test <<-INPUT, 152
    root: pppw + sjmn
    dbpl: 5
    cczh: sllz + lgvd
    zczc: 2
    ptdq: humn - dvpt
    dvpt: 3
    lfqf: 4
    humn: 5
    ljgn: 2
    sjmn: drzm * dbpl
    sllz: 4
    pppw: cczh / lfqf
    lgvd: ljgn * ptdq
    drzm: hmdt - zczc
    hmdt: 32
    INPUT

  answer do |input|
    nodes = input.lines.to_h do |line|
      name, _, exp = line.partition(": ")
      if i = exp.to_i64?
        {name, i}
      else
        left, op, right = exp.split(' ')
        {name, {left: left, op: op, right: right}}
      end
    end
    eval(nodes, "root")
  end
end

solve do
  test <<-INPUT, 301
    root: pppw + sjmn
    dbpl: 5
    cczh: sllz + lgvd
    zczc: 2
    ptdq: humn - dvpt
    dvpt: 3
    lfqf: 4
    humn: 5
    ljgn: 2
    sjmn: drzm * dbpl
    sllz: 4
    pppw: cczh / lfqf
    lgvd: ljgn * ptdq
    drzm: hmdt - zczc
    hmdt: 32
    INPUT

  answer do |input|
    nodes = input.lines.to_h do |line|
      name, _, exp = line.partition(": ")
      if i = exp.to_i64?
        {name, i}
      else
        left, op, right = exp.split(' ')
        {name, {left: left.as(Int64 | String), op: op, right: right.as(Int64 | String)}}
      end
    end
    nodes.delete("humn")
    eq = nodes.delete("root").as(NamedTuple)

    values = {} of String => Int64
    while true
      found = false
      nodes.each do |k, v|
        if v.is_a?(Int64)
          values[k] = v
          nodes.delete(k)
          found = true
        else
          left = v[:left]
          left = left.is_a?(Int64) ? left : values[v[:left]]?
          right = v[:right]
          right = right.is_a?(Int64) ? right : values[v[:right]]?

          if left && right
            values[k] = case v[:op]
                        when "+"
                          left + right
                        when "-"
                          left - right
                        when "*"
                          left * right
                        else
                          left // right
                        end
            nodes.delete(k)
            found = true
          elsif left.is_a?(Int64) && !v[:left].is_a?(Int64)
            nodes[k] = {left: left, op: v[:op], right: v[:right]}
            found = true
          elsif right.is_a?(Int64) && !v[:right].is_a?(Int64)
            nodes[k] = {left: v[:left], op: v[:op], right: right}
            found = true
          end
        end
      end
      break unless found
    end

    target = values[eq[:right]]
    name = eq[:left]
    while node = nodes[name]?.as?(NamedTuple)
      left = node[:left]
      op = node[:op]
      right = node[:right]
      old = target

      if right.is_a?(Int64)
        name = left.as(String)
        target = case op
                 when "+"
                   target - right
                 when "-"
                   target + right
                 when "*"
                   target // right
                 else
                   target * right
                 end
      else
        name = right
        left = left.as(Int64)
        target = case op
                 when "+"
                   target - left
                 when "-"
                   left - target
                 when "*"
                   target // left
                 else
                   left // target
                 end
      end
    end
    target
  end
end
