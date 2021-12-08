require "../support"

class Board
  @values : Array(Int32?)

  getter score = 0

  def initialize(values)
    @values = values.map &.as(Int32?)
  end

  def mark(num)
    @values.map! { |v| v == num ? nil : v }
    @score = num * @values.compact.sum
  end

  def win?
    {
      {0, 1, 2, 3, 4},
      {5, 6, 7, 8, 9},
      {10, 11, 12, 13, 14},
      {15, 16, 17, 18, 19},
      {20, 21, 22, 23, 24},
      {0, 5, 10, 15, 20},
      {1, 6, 11, 16, 21},
      {2, 7, 12, 17, 22},
      {3, 8, 13, 18, 23},
      {4, 9, 14, 19, 24},
    }.any? { |idxs| @values.values_at(*idxs).none? }
  end
end

solve do
  test <<-INPUT, 4512
    7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

    22 13 17 11  0
     8  2 23  4 24
    21  9 14 16  7
     6 10  3 18  5
     1 12 20 15 19

     3 15  0  2 22
     9 18 13 17  5
    19  8  7 25 23
    20 11 10 24  4
    14 21 16 12  6

    14 21 17 24  4
    10 16 15  9 19
    18  8 23 26 20
    22 11 13  6  5
     2  0 12  3  7
    INPUT

  answer do |input|
    io = IO::Memory.new(input)
    calls = io.gets.not_nil!.strip.split(",").map(&.to_i)
    boards = io.gets_to_end.not_nil!.strip.split(/\s+/).map(&.to_i).each_slice(25).to_a.map { |v| Board.new(v) }

    while true
      call = calls.shift
      boards.each &.mark(call)
      if winner = boards.find(&.win?)
        break winner.score
      end
    end
  end
end

solve do
  test <<-INPUT, 1924
    7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

    22 13 17 11  0
     8  2 23  4 24
    21  9 14 16  7
     6 10  3 18  5
     1 12 20 15 19

     3 15  0  2 22
     9 18 13 17  5
    19  8  7 25 23
    20 11 10 24  4
    14 21 16 12  6

    14 21 17 24  4
    10 16 15  9 19
    18  8 23 26 20
    22 11 13  6  5
     2  0 12  3  7
    INPUT

  answer do |input|
    io = IO::Memory.new(input)
    calls = io.gets.not_nil!.strip.split(",").map(&.to_i)
    boards = io.gets_to_end.not_nil!.strip.split(/\s+/).map(&.to_i).each_slice(25).to_a.map { |v| Board.new(v) }

    while true
      call = calls.shift
      boards.each &.mark(call)
      winners, boards = boards.partition(&.win?)
      break winners.first.score if boards.empty?
    end
  end
end
