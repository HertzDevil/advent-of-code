require "colorize"

private class AOCContext
  class_property current : AOCContext?

  setter answer = Proc(String, String).new { "" }
  getter test_cases = [] of {String, String}

  def initialize(@input : String)
  end

  def show_field(io : IO, header, str, color : Colorize::Color = :light_yellow)
    Colorize.with.white.bold.surround(io) { header.rjust(io, 8); io << ':' }
    if str.includes?('\n')
      io << " ```\n"
      Colorize.with.fore(color).surround(io) { io << str }
      io << "\n```\n"
    else
      io << " `"
      Colorize.with.fore(color).surround(io) { str.inspect_unquoted(io) }
      io << "`\n"
    end
  end

  def run(io : IO = STDOUT)
    has_failure = false
    test_cases.each do |input, expected|
      got = @answer.call(input)
      unless got == expected
        show_field io, "Input", input
        show_field io, "Expected", expected, color: :light_green
        show_field io, "Got", got, color: :light_red
        has_failure = true
      end
    end

    unless has_failure
      answer = ""
      t = Time.measure { answer = @answer.call(@input) }
      show_field io, "Answer", answer
      Colorize.with.white.bold.surround(io) { io << "    Time:" }
      io.puts " %.6f ms" % (t.total_seconds * 1000.0)
    end

    io.puts
  end
end

def answer(&block : String -> _)
  AOCContext.current.try &.answer = ->(input : String) { block.call(input).to_s }
end

def test(input, output)
  AOCContext.current.try &.test_cases.<<({input.to_s, output.to_s})
end

def solve(*, file = __FILE__, &block)
  year, day = file.match(%r(crystal[\\/](\d+)[\\/](day\d+)\.cr\z)).not_nil!.captures
  fname = File.expand_path("#{file}/../../../input/#{year}/#{day}")
  input = File.read(fname).chomp
  AOCContext.current = cxt = AOCContext.new(input)
  yield
  cxt.run
ensure
  AOCContext.current = nil
end

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
    {{ AOCMacroContext[:answer].args[0] }} = read_file(fname)
    answer = begin; {{ AOCMacroContext[:answer].body }}; end
    puts "Answer: `#{answer}`"
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

require "./support/*"
