require "../support"

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
      records = records.split("; ").map(&.split(", "))
      next 0 unless records.all? do |cubes|
                      cubes.all? do |cube|
                        count, _, color = cube.partition(' ')
                        case color
                        when "red"
                          count.to_i <= 12
                        when "green"
                          count.to_i <= 13
                        when "blue"
                          count.to_i <= 14
                        else
                          true
                        end
                      end
                    end
      id.to_i
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
      r = records.max_of { |v| v.find(&.[2].== "red").try(&.[0].to_i) || 0 }
      g = records.max_of { |v| v.find(&.[2].== "green").try(&.[0].to_i) || 0 }
      b = records.max_of { |v| v.find(&.[2].== "blue").try(&.[0].to_i) || 0 }
      r*g*b
    end
end
