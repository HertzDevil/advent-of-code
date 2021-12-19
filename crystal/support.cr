private class AOCContext
  class_property current : AOCContext?

  setter answer = Proc(String, String).new { "" }
  getter test_cases = [] of {String, String}

  def initialize(@input : String)
  end

  def run
    has_failure = false
    test_cases.each do |input, expected|
      got = @answer.call(input)
      unless got == expected
        puts "Expected `#{input.inspect}` => `#{expected.inspect}`, got `#{got.inspect}`"
        has_failure = true
      end
    end

    unless has_failure
      answer = ""
      t = Time.measure { answer = @answer.call(@input) }
      puts "Answer: `#{answer}`"
      puts "  Time: #{t.total_seconds * 1000.0} ms"
    end

    puts
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
