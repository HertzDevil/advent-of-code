require "../support"

def foo(current, distances, limit, result = [] of Array({String, Int32}))
  from, t = current.last
  has_next = false
  distances[from].each do |to, (dist, rate)|
    next unless t + dist < limit
    next if current.any? { |(from2, _)| from2 == to }
    has_next = true
    current << {to, t + dist}
    foo(current, distances, limit, result)
    current.pop
  end
  result << current.dup unless has_next
  result
end

solve do
  test <<-INPUT, 1651
    Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
    Valve BB has flow rate=13; tunnels lead to valves CC, AA
    Valve CC has flow rate=2; tunnels lead to valves DD, BB
    Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
    Valve EE has flow rate=3; tunnels lead to valves FF, DD
    Valve FF has flow rate=0; tunnels lead to valves EE, GG
    Valve GG has flow rate=0; tunnels lead to valves FF, HH
    Valve HH has flow rate=22; tunnel leads to valve GG
    Valve II has flow rate=0; tunnels lead to valves AA, JJ
    Valve JJ has flow rate=21; tunnel leads to valve II
    INPUT

  # AA -> DD -> BB -> JJ -> HH -> EE -> CC

  answer do |input|
    graph = input.scan(/([A-Z][A-Z]) has flow rate=(\d+).*?((?:[A-Z][A-Z]|, )+)/).to_h do |m|
      {m[1], {rate: m[2].to_i, tunnels: m[3].split(", ")}}
    end
    flowing = graph.select { |_, v| v[:rate] > 0 }.keys
    distances = ["AA"].concat(flowing).to_h do |from|
      tos = flowing.to_h do |to|
        reachable = Set{from}
        dist = (1..).each do |d|
          frontier = reachable.flat_map { |v| graph[v][:tunnels] }.to_set
          break d if frontier.includes?(to)
          reachable.concat(frontier)
        end
        {to, {dist + 1, graph[to][:rate]}}
      end.reject { |to, _| from == to }
      {from, tos}
    end

    result = foo([{"AA", 0}], distances, 30)
    distances.each { |from, tos| tos.each { |to, (d, _)| puts "#{from} = #{graph[from][:rate]}\t#{to} = #{graph[to][:rate]}\t#{d}" } }
    result.max_of &.sum { |(v, t)| (30 - t) * graph[v][:rate] }
  end
end

def foo2(current, distances, limit, result = [] of Array({String, Int32}))
  from, t = current.last
  distances[from].each do |to, (dist, rate)|
    next unless t + dist < limit
    next if current.any? { |(from2, _)| from2 == to }
    current << {to, t + dist}
    foo2(current, distances, limit, result)
    current.pop
  end
  result << current.dup # unless has_next
  result
end

solve do
  test <<-INPUT, 1707
    Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
    Valve BB has flow rate=13; tunnels lead to valves CC, AA
    Valve CC has flow rate=2; tunnels lead to valves DD, BB
    Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
    Valve EE has flow rate=3; tunnels lead to valves FF, DD
    Valve FF has flow rate=0; tunnels lead to valves EE, GG
    Valve GG has flow rate=0; tunnels lead to valves FF, HH
    Valve HH has flow rate=22; tunnel leads to valve GG
    Valve II has flow rate=0; tunnels lead to valves AA, JJ
    Valve JJ has flow rate=21; tunnel leads to valve II
    INPUT

  # AA -> JJ -> BB -> CC
  # AA -> DD -> HH -> EE

  answer do |input|
    graph = input.scan(/([A-Z][A-Z]) has flow rate=(\d+).*?((?:[A-Z][A-Z]|, )+)/).to_h do |m|
      {m[1], {rate: m[2].to_i, tunnels: m[3].split(", ")}}
    end
    flowing = graph.select { |_, v| v[:rate] > 0 }.keys
    distances = ["AA"].concat(flowing).to_h do |from|
      tos = flowing.to_h do |to|
        reachable = Set{from}
        dist = (1..).each do |d|
          frontier = reachable.flat_map { |v| graph[v][:tunnels] }.to_set
          break d if frontier.includes?(to)
          reachable.concat(frontier)
        end
        {to, {dist + 1, graph[to][:rate]}}
      end.reject { |to, _| from == to }
      {from, tos}
    end

    result = foo2([{"AA", 0}], distances, 26)
    result.each_with_index.max_of do |r, i|
      print '.' if i % 100 == 0

      used = r.map(&.first)[1..]
      distances2 = distances.reject { |from, _| used.includes?(from) }.transform_values &.reject { |to, _| used.includes?(to) }
      result2 = foo([{"AA", 0}], distances2, 26)

      r.sum { |(v, t)| (26 - t) * graph[v][:rate] } +
        result2.max_of &.sum { |(v, t)| (26 - t) * graph[v][:rate] }
    end
  end
end
