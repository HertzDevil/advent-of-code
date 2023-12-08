require "../support"

solve do
  test <<-INPUT, 2
    RL

    AAA = (BBB, CCC)
    BBB = (DDD, EEE)
    CCC = (ZZZ, GGG)
    DDD = (DDD, DDD)
    EEE = (EEE, EEE)
    GGG = (GGG, GGG)
    ZZZ = (ZZZ, ZZZ)
    INPUT

  test <<-INPUT, 6
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
    INPUT

  answer do |input|
    path, _, network = input.partition("\n\n")
    network = network.lines.to_h do |line|
      from, _, to = line.partition " = "
      l, _, r = to.lchop('(').rchop(')').partition(", ")
      {from, {l, r}}
    end
    at = "AAA"
    path = path.each_char.cycle
    (1..).each do |i|
      at = network[at][path.next == 'R' ? 1 : 0]
      break i if at == "ZZZ"
    end
  end
end

solve do
  test <<-INPUT, 6
    LR

    11A = (11B, XXX)
    11B = (XXX, 11Z)
    11Z = (11B, XXX)
    22A = (22B, XXX)
    22B = (22C, 22C)
    22C = (22Z, 22Z)
    22Z = (22B, 22B)
    XXX = (XXX, XXX)
    INPUT

  answer do |input|
    path, _, network = input.partition("\n\n")
    network = network.lines.to_h do |line|
      from, _, to = line.partition " = "
      l, _, r = to.lchop('(').rchop(')').partition(", ")
      {from, {l, r}}
    end
    path = path.chars

    all_steps = network.keys.select(&.ends_with?('Z')).map do |z|
      at = network.keys.select &.ends_with?('A')
      (0_i64..).each do |i|
        r = path[i % path.size] == 'R' ? 1 : 0
        at.map! { |v| network[v][r] }
        break i + 1 if at.includes?(z)
      end
    end

    all_steps.reduce { |x, y| x.lcm(y) }
  end
end
