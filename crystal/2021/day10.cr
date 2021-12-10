require "../support"

CLOSE = {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<',
}

SCORE = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137,
}

solve do
  test <<-INPUT, 26397
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    {([(<{}[<>[]}>{[]{[(<()>
    (((({<>}<{<{<>}{[]{[]{}
    [[<[([]))<([[{}[[()]]]
    [{[{({}]{}}([{[{{{}}([]
    {<[[]]>}<{[{[{[]{()[[[]
    [<(<(<(<{}))><([]([]()
    <{([([[(<>()){}]>(<<{{
    <{([{{}}[<[[[<>{}]]]>[]]
    INPUT

  answer &.each_line.sum do |line|
    score = 0
    stack = [] of Char

    line.each_char do |char|
      case char
      when '(', '[', '{', '<'
        stack << char
      when ')', ']', '}', '>'
        if stack.last? == CLOSE[char]
          stack.pop
        else
          score = SCORE[char]
          break
        end
      end
    end

    score
  end
end

BACK_SCORE = {
  '(' => 1,
  '[' => 2,
  '{' => 3,
  '<' => 4,
}

solve do
  test <<-INPUT, 288957
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    {([(<{}[<>[]}>{[]{[(<()>
    (((({<>}<{<{<>}{[]{[]{}
    [[<[([]))<([[{}[[()]]]
    [{[{({}]{}}([{[{{{}}([]
    {<[[]]>}<{[{[{[]{()[[[]
    [<(<(<(<{}))><([]([]()
    <{([([[(<>()){}]>(<<{{
    <{([{{}}[<[[[<>{}]]]>[]]
    INPUT

  answer do |input|
    scores = input.each_line.compact_map do |line|
      corrupted = false
      stack = [] of Char

      line.each_char do |char|
        case char
        when '(', '[', '{', '<'
          stack << char
        when ')', ']', '}', '>'
          if stack.last? == CLOSE[char]
            stack.pop
          else
            corrupted = true
            break
          end
        end
      end

      next if corrupted

      stack.reverse!
      stack.reduce(0_i64) do |score, char|
        score * 5 + BACK_SCORE[char]
      end
    end.to_a

    scores.sort!
    scores[scores.size // 2]
  end
end
