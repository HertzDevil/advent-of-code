require "http"
require "colorize"

def submit_answer(year, day, part, answer)
  token_fname = File.expand_path("../../.session_token", __DIR__)
  unless File.file?(token_fname)
    STDERR.puts "`#{token_fname}` not found! Submit your answer manually".colorize.light_red.bold
    return
  end

  puts "Submitting answer for #{year} day #{day} part #{part}...".colorize.light_blue

  cookies = HTTP::Cookies{HTTP::Cookie.new("session", File.read(token_fname))}
  headers = HTTP::Headers.new
  cookies.add_request_headers(headers)

  form = {"level" => part.to_s, "answer" => answer.to_s}
  uri = "https://adventofcode.com/#{year}/day/#{day}/answer"
  HTTP::Client.post(uri, headers: headers, form: form)
end
