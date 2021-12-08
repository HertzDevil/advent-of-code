require "../support"
require "digest/md5"

solve do
  test "abcdef", 609043
  test "pqrstuv", 1048970

  answer do |input|
    (1..).find { |x| Digest::MD5.hexdigest("#{input}#{x}").starts_with?("00000") }
  end
end

solve do
  answer do |input|
    (1..).find { |x| Digest::MD5.hexdigest("#{input}#{x}").starts_with?("000000") }
  end
end
