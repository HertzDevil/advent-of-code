require "../support"

solve do
  test <<-INPUT, 739785
    Player 1 starting position: 4
    Player 2 starting position: 8
    INPUT

  answer do |input|
    p1 = input.match(/Player 1 starting position: (\d+)/).not_nil![1].not_nil!.to_i
    score1 = 0
    p2 = input.match(/Player 2 starting position: (\d+)/).not_nil![1].not_nil!.to_i
    score2 = 0

    (1..100).cycle.each_slice(3, reuse: true).map(&.sum).each_with_index do |tot, i|
      if i.even?
        p1 = (p1 + tot - 1) % 10 + 1
        score1 += p1
        break score2 * 3 * (i + 1) if score1 >= 1000
      else
        p2 = (p2 + tot - 1) % 10 + 1
        score2 += p2
        break score1 * 3 * (i + 1) if score2 >= 1000
      end
    end
  end
end

record State, p1 : Int32, p2 : Int32, score1 : Int32, score2 : Int32 do
  def each_next_state(p1_turn, &)
    if p1_turn
      yield State.new((p1 + 2) % 10 + 1, p2, score1 + ((p1 + 2) % 10 + 1), score2), 1_i64
      yield State.new((p1 + 3) % 10 + 1, p2, score1 + ((p1 + 3) % 10 + 1), score2), 3_i64
      yield State.new((p1 + 4) % 10 + 1, p2, score1 + ((p1 + 4) % 10 + 1), score2), 6_i64
      yield State.new((p1 + 5) % 10 + 1, p2, score1 + ((p1 + 5) % 10 + 1), score2), 7_i64
      yield State.new((p1 + 6) % 10 + 1, p2, score1 + ((p1 + 6) % 10 + 1), score2), 6_i64
      yield State.new((p1 + 7) % 10 + 1, p2, score1 + ((p1 + 7) % 10 + 1), score2), 3_i64
      yield State.new((p1 + 8) % 10 + 1, p2, score1 + ((p1 + 8) % 10 + 1), score2), 1_i64
    else
      yield State.new(p1, (p2 + 2) % 10 + 1, score1, score2 + (p2 + 2) % 10 + 1), 1_i64
      yield State.new(p1, (p2 + 3) % 10 + 1, score1, score2 + (p2 + 3) % 10 + 1), 3_i64
      yield State.new(p1, (p2 + 4) % 10 + 1, score1, score2 + (p2 + 4) % 10 + 1), 6_i64
      yield State.new(p1, (p2 + 5) % 10 + 1, score1, score2 + (p2 + 5) % 10 + 1), 7_i64
      yield State.new(p1, (p2 + 6) % 10 + 1, score1, score2 + (p2 + 6) % 10 + 1), 6_i64
      yield State.new(p1, (p2 + 7) % 10 + 1, score1, score2 + (p2 + 7) % 10 + 1), 3_i64
      yield State.new(p1, (p2 + 8) % 10 + 1, score1, score2 + (p2 + 8) % 10 + 1), 1_i64
    end
  end
end

solve do
  test <<-INPUT, 444356092776315
    Player 1 starting position: 4
    Player 2 starting position: 8
    INPUT

  answer do |input|
    p1 = input.match(/Player 1 starting position: (\d+)/).not_nil![1].not_nil!.to_i
    p2 = input.match(/Player 2 starting position: (\d+)/).not_nil![1].not_nil!.to_i
    states = Hash(State, Int64).new { 0_i64 }
    states[State.new(p1, p2, 0, 0)] = 1_i64
    p1_wins = 0_i64
    p2_wins = 0_i64
    turn = 0

    until states.empty?
      new_states = Hash(State, Int64).new { 0_i64 }
      states.each do |state, count|
        state.each_next_state(turn.even?) do |next_state, next_count|
          if next_state.score1 >= 21
            p1_wins += count * next_count
          elsif next_state.score2 >= 21
            p2_wins += count * next_count
          else
            new_states[next_state] += count * next_count
          end
        end
      end
      states = new_states
      turn += 1
    end

    {p1_wins, p2_wins}.max
  end
end
