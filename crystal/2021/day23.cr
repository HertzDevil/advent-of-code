require "../support"

enum Cell : UInt8
  None
  A
  B
  C
  D

  def cost
    case self
    in .a?    then 1
    in .b?    then 10
    in .c?    then 100
    in .d?    then 1000
    in .none? then 0
    end
  end

  def to_s : String
    none? ? "." : super
  end

  def to_s(io : IO) : Nil
    case self
    in .a?    then io << 'A'
    in .b?    then io << 'B'
    in .c?    then io << 'C'
    in .d?    then io << 'D'
    in .none? then io << '.'
    end
  end
end

record State4, cells : StaticArray(Cell, 23) do
  CAPACITY = [2, 4, 1, 4, 1, 4, 1, 4, 2]
  STACK_START = CAPACITY.accumulate(0)[..-2]
  ROOMS = [nil, Cell::A, nil, Cell::B, nil, Cell::C, nil, Cell::D, nil]

  def initialize(input)
    lines = input.lines
    @cells = StaticArray[
      Cell::None, Cell::None,
      Cell.parse(lines[3][3].to_s), Cell::D, Cell::D, Cell.parse(lines[2][3].to_s),
      Cell::None,
      Cell.parse(lines[3][5].to_s), Cell::B, Cell::C, Cell.parse(lines[2][5].to_s),
      Cell::None,
      Cell.parse(lines[3][7].to_s), Cell::A, Cell::B, Cell.parse(lines[2][7].to_s),
      Cell::None,
      Cell.parse(lines[3][9].to_s), Cell::C, Cell::A, Cell.parse(lines[2][9].to_s),
      Cell::None, Cell::None,
    ]
  end

  private def stack_slice(pos)
    slice = @cells.to_slice[STACK_START[pos], CAPACITY[pos]]
    while slice.last?.try &.none?
      slice = slice[..-2]
    end
    slice
  end

  def reachable?(from, to)
    return false if from.odd? == to.odd?

    from_stack = stack_slice(from)
    to_stack = stack_slice(to)

    return false if from_stack.empty?
    return false if to_stack.size >= CAPACITY[to]

    end1, end2 = {from, to}.minmax
    {2, 4, 6}.each do |hall_pos|
      return false if end1 < hall_pos && end2 > hall_pos && !stack_slice(hall_pos).empty?
    end

    top = from_stack.last
    if goal_cell = ROOMS[from]?
      return false if top == goal_cell && from_stack.all? &.==(goal_cell)
    end
    if goal_cell = ROOMS[to]?
      return false unless top == goal_cell && to_stack.all? &.==(goal_cell)
    end

    case {top, to}
    when {.a?, 4}
      return false if @cells[6].c? || @cells[6].d?
    when {.a?, 6}
      return false if @cells[6].d? || @cells[11].d?
    when {.b?, 6}
      return false if @cells[11].d?
    when {.c?, 2}
      return false if @cells[11].a?
    when {.d?, 2}
      return false if @cells[11].a? || @cells[16].a?
    when {.d?, 4}
      return false if @cells[16].a? || @cells[16].b?
    end

    true
  end

  def each_next_state(&)
    (0..8).each do |from|
      (0..8).each do |to|
        if reachable?(from, to)
          yield move(from, to)
        end
      end
    end
  end

  protected def move!(from, to)
    from_stack = stack_slice(from)
    to_stack = stack_slice(to)

    dist = CAPACITY[from] - from_stack.size
    dist += 1 if from.odd?
    dist += (from - to).abs
    dist += 1 if to.odd?
    dist += CAPACITY[to] - to_stack.size - 1

    top = from_stack.last
    from_stack[-1] = Cell::None
    to_stack.to_unsafe[to_stack.size] = top

    {self, dist * top.cost}
  end

  def move(from, to)
    State4.new(@cells).move!(from, to)
  end
end

solve do
  answer do |input|
    origin = State4.new(input)
    frontier = Set{origin}
    min_scores = {origin => 0}

    32.times do
      new_frontier = Set(State4).new
      frontier.each do |state|
        old_score = min_scores[state]
        state.each_next_state do |(next_state, score_add)|
          new_frontier << next_state
          min_scores[next_state] = {min_scores[next_state]? || Int32::MAX, old_score + score_add}.min
        end
      end
      frontier = new_frontier
    end

    min_scores[frontier.first]
  end
end
