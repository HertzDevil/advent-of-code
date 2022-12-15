require "colorize"

private class AOCContext
  class_property current : AOCContext?
  class_property part = 0
  class_property last_answer : {Int32, Int32, Int32, String}?

  getter part : Int32
  setter solution = Proc(String, String).new { "" }
  getter test_cases = [] of {String, String}
  getter? test_mode = false

  def initialize(@fname : String, @part : Int32)
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
    Colorize.with.white.bold.surround(io) { io << "=== Part " << @part << " ===\n" }

    @test_mode = true
    has_failure = false
    test_cases.each do |input, expected|
      got = @solution.call(input)
      unless got == expected
        show_field io, "Input", input
        show_field io, "Expected", expected, color: :light_green
        show_field io, "Got", got, color: :light_red
        has_failure = true
      end
    end
    @test_mode = false

    unless has_failure
      ::check_input(@fname)
      input = File.read(@fname).chomp
      answer = ""
      t = Time.measure { answer = @solution.call(input) }
      show_field io, "Answer", answer
      Colorize.with.white.bold.surround(io) { io << "    Time:" }
      io.puts " %.6f ms" % (t.total_seconds * 1000.0)
    end

    io.puts
    answer
  end
end

def answer(&block : String -> _)
  AOCContext.current.try &.solution = ->(input : String) { block.call(input).to_s }
end

def test(input, output)
  AOCContext.current.try &.test_cases.<<({input.to_s, output.to_s})
end

def test_mode?
  !!AOCContext.current.try &.test_mode?
end

def solve(*, file = __FILE__, &block)
  year, day = file.match(%r(crystal[\\/](\d+)[\\/]day(\d+)\.cr\z)).not_nil!.captures.map(&.not_nil!)
  fname = File.expand_path("#{file}/../../../input/#{year}/day#{day}.txt")
  AOCContext.part = part = AOCContext.part + 1
  AOCContext.current = cxt = AOCContext.new(fname, part)
  yield
  cxt.run.try { |answer| AOCContext.last_answer = {year.to_i, day.to_i, part, answer} }
ensure
  AOCContext.current = nil
end

at_exit do
  AOCContext.last_answer.try do |(year, day, part, answer)|
    submit_answer(year, day, part, answer)
  end
end
