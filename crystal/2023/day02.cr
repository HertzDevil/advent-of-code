require "../support"

LIMIT = {"red" => 12, "green" => 13, "blue" => 14}

solve do
  test <<-INPUT, 8
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    INPUT

  answer &.each_line
    .sum do |line|
      game, _, records = line.partition(": ")
      id = game.lchop("Game ").to_i
      records = records.split("; ").map(&.split(", ").map(&.partition(' ')))
      records.all?(&.all? { |count, _, color| count.to_i <= LIMIT[color] }) ? id.to_i : 0
    end
end

solve do
  test <<-INPUT, 2286
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    INPUT

  answer &.each_line
    .sum do |line|
      game, _, records = line.partition(": ")
      id = game.lchop("Game ").to_i
      records = records.split("; ").map(&.split(", ").map(&.partition(' ')))
      {"red", "green", "blue"}.product do |color|
        records.max_of { |v| v.find(&.[2].== color).try(&.[0].to_i) || 0 }
      end
    end
end
