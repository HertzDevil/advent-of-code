require "../support"

solve do
  test <<-INPUT, 10605
    Monkey 0:
      Starting items: 79, 98
      Operation: new = old * 19
      Test: divisible by 23
        If true: throw to monkey 2
        If false: throw to monkey 3

    Monkey 1:
      Starting items: 54, 65, 75, 74
      Operation: new = old + 6
      Test: divisible by 19
        If true: throw to monkey 2
        If false: throw to monkey 0

    Monkey 2:
      Starting items: 79, 60, 97
      Operation: new = old * old
      Test: divisible by 13
        If true: throw to monkey 1
        If false: throw to monkey 3

    Monkey 3:
      Starting items: 74
      Operation: new = old + 3
      Test: divisible by 17
        If true: throw to monkey 0
        If false: throw to monkey 1
    INPUT

  answer do |input|
    monkeys = input.scan(Regex.new <<-'INPUT').map do |m|
      Monkey \d+:
        Starting items: ([\d, ]+)
        Operation: new = old ([+*]) (old|\d+)
        Test: divisible by (\d+)
          If true: throw to monkey (\d+)
          If false: throw to monkey (\d+)
      INPUT
      {m[1].split(", ").map(&.to_i), m[2], m[3].try(&.to_i?), m[4].to_i, m[5].to_i, m[6].to_i}
    end

    counts = {} of Int32 => Int32
    20.times do
      monkeys.each_with_index do |monkey, i|
        op = monkey[2]
        counts[i] ||= 0
        counts[i] += monkey[0].size
        monkey[0].each do |item|
          op2 = op.is_a?(Int32) ? op : item
          level = (monkey[1] == "+" ? item + op2 : item * op2) // 3
          monkeys[level % monkey[3] == 0 ? monkey[4] : monkey[5]][0] << level
        end
        monkey[0].clear
      end
    end
    counts.values.sort[-2..].product
  end
end

solve do
  test <<-INPUT, 2713310158
    Monkey 0:
      Starting items: 79, 98
      Operation: new = old * 19
      Test: divisible by 23
        If true: throw to monkey 2
        If false: throw to monkey 3

    Monkey 1:
      Starting items: 54, 65, 75, 74
      Operation: new = old + 6
      Test: divisible by 19
        If true: throw to monkey 2
        If false: throw to monkey 0

    Monkey 2:
      Starting items: 79, 60, 97
      Operation: new = old * old
      Test: divisible by 13
        If true: throw to monkey 1
        If false: throw to monkey 3

    Monkey 3:
      Starting items: 74
      Operation: new = old + 3
      Test: divisible by 17
        If true: throw to monkey 0
        If false: throw to monkey 1
    INPUT

  answer do |input|
    monkeys = input.scan(Regex.new <<-'INPUT').map do |m|
      Monkey \d+:
        Starting items: ([\d, ]+)
        Operation: new = old ([+*]) (old|\d+)
        Test: divisible by (\d+)
          If true: throw to monkey (\d+)
          If false: throw to monkey (\d+)
      INPUT
      {m[1].split(", ").map(&.to_i64), m[2], m[3].try(&.to_i?), m[4].to_i, m[5].to_i, m[6].to_i}
    end

    counts = {} of Int32 => UInt64
    mod = monkeys.product(&.[3])
    10000.times do |t|
      monkeys.each_with_index do |monkey, i|
        op = monkey[2]
        counts[i] ||= 0_u64
        counts[i] += monkey[0].size
        monkey[0].each do |item|
          op2 = op.is_a?(Int32) ? op : item
          level = (monkey[1] == "+" ? item + op2 : item * op2) % mod
          monkeys[level % monkey[3] == 0 ? monkey[4] : monkey[5]][0] << level
        end
        monkey[0].clear
      end
    end
    counts.values.sort[-2..].product
  end
end
