AOCMacroContext = {
  answer:     nil,
  test_cases: [] of NoReturn,
}

macro m_finish
  \{%
    {% for test_case in AOCMacroContext[:test_cases] %}
      {% input, expected = test_case %}
      {{ AOCMacroContext[:answer].args[0] }} = {{ input }}
      answer = begin; {{ AOCMacroContext[:answer].body }}; end
      raise "expected {{ expected }}, got #{answer}" unless answer == {{ expected }}
    {% end %}

    fname = __FILE__.gsub(%r(crystal[\\/](\d+)[\\/](day\d+)\.cr\z), "input/\\1/\\2")
    if file_exists?(fname)
      {{ AOCMacroContext[:answer].args[0] }} = read_file(fname)
      answer = begin; {{ AOCMacroContext[:answer].body }}; end
      puts "Answer: `#{answer}`"
    else
      puts "File `#{fname}` does not exist; skipping m_solve"
    end
    AOCMacroContext[:answer] = nil
    AOCMacroContext[:test_cases] = [] of NoReturn
  %}
end

macro m_answer(&block)
  {% AOCMacroContext[:answer] = block %}
end

macro m_test(input, expected)
  {% AOCMacroContext[:test_cases] << {input, expected} %}
end

macro m_solve(&block)
  {{ block.body }}
  m_finish
end
