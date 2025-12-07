require "../support"

solve do
  test <<-INPUT, 4277556
    123 328  51 64
     45 64  387 23
      6 98  215 314
    *   +   *   +
    INPUT

  answer do |input|
    input.lines.map(&.split).transpose.sum do |row|
      row.pop == "*" ? row.product(&.to_i64) : row.sum(&.to_i64)
    end
  end
end

ToI64 = ->(str) do
  0_i64 + parse_type("Foo(#{str.id})").type_vars[0]
end

Problem = ->(row) do
  (row[-1] == "*" ? M::Array::Product : M::Array::Sum).call(row[..-2].map { |v| ToI64.call(v) }, nil, nil)
end

m_solve do
  m_test <<-INPUT, 4277556_i64
    123 328  51 64
     45 64  387 23
      6 98  215 314
    *   +   *   +
    INPUT

  m_answer do |input|
    M::Array::Sum.call(M::Array::Transpose.call(input.lines.map(&.split)), Problem, nil)
  end
end

solve do
  test <<-INPUT, 3263827
    123 328  51 64\x20
     45 64  387 23\x20
      6 98  215 314
    *   +   *   +\x20\x20
    INPUT

  answer do |input|
    input.lines.map(&.chars).transpose.chunk { |v| Enumerable::Chunk::Drop if v.all?(' ') }.map(&.last).sum do |row|
      row.map(&.pop)[0] == '*' ? row.product(&.join.to_i64) : row.sum(&.join.to_i64)
    end
  end
end

DropEmpty = ->(arr) do
  :drop if arr.all?(&.== ' ')
end

m_solve do
  m_test <<-INPUT, 3263827_i64
    123 328  51 64\x20
     45 64  387 23\x20
      6 98  215 314
    *   +   *   +\x20\x20
    INPUT

  m_answer do |input|
    problems = M::Array::Transpose.call(input.lines.map(&.chars))
    problems = M::Array::Chunks.call(problems, DropEmpty, nil).map(&.last)
    problems = problems.map { |row| row.map(&.[..-2].join("")) << row[0][-1].id.stringify }
    M::Array::Sum.call(problems, Problem, nil)
  end
end
