require "http"
require "colorize"
require "file_utils"

def check_input(fname)
  return if File.file?(fname)

  token_fname = File.expand_path("../../.session_token", __DIR__)
  unless File.file?(token_fname)
    STDERR.puts "`#{token_fname}` not found! Download `#{fname}` manually".colorize.light_red.bold
    exit 1
  end

  FileUtils.mkdir_p(File.dirname(fname))
  year, day = fname.match(%r(input/(\d+)/day0?(\d+))).not_nil!.captures
  puts "Caching input for #{year} day #{day}...".colorize.light_blue

  cookies = HTTP::Cookies{HTTP::Cookie.new("session", File.read(token_fname))}
  headers = HTTP::Headers.new
  cookies.add_request_headers(headers)

  HTTP::Client.get("https://adventofcode.com/#{year}/day/#{day}/input", headers: headers) do |io|
    File.open(fname, "w") do |f|
      IO.copy(io.body_io, f)
    end
  end
end
