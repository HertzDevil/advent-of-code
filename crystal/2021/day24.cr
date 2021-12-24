require "../support"

# solved by hand
solve { answer { "41299994879959" } }
solve { answer { "11189561113216" } }

# w = input
# x *= 0
# x += z
# x %= 26
# z /= var1
# x += var2
# x = x == w ? 1 : 0
# x = x == 0 ? 1 : 0
# y *= 0
# y += 25
# y *= x
# y += 1
# z *= y
# y *= 0
# y += w
# y += var3
# y *= x
# z += y
#
#
#
# var1  1     1     1     26    26    1     1     26    1     1     26    26    26    26
# var2  11    12    13    -5    -3    14    15    -16   14    15    -7    -11   -6    -11
# var3  16    11    12    12    12    2     11    4     12    9     10    11    6     15
#
#
#
# local z = 0
# for w in inputs
#   local x = z % 26 + var2
#   z /= var1
#   if x != w
#     z *= 26
#     z += (w + var3)
#   end
# end
# return z == 0
#
#
#
# var1  1     1     1     1     1     1     1     26    26    26    26    26    26    26
# var2  11    12    13    14    15    14    15    -5    -3    -16   -7    -11   -6    -11
# var3  16    11    12    2     11    12    9     12    12    4     10    11    6     15
#
#
#
# local zl = 0
# local zh = 0
# for w in inputs
#   # 1 <= w <= 9
#   # 2 <= var3 <= 16
#   if var1 == 1
#     # 11 <= var2 <= 15
#     local x = zl + var2
#     if x != w
#       zh = zh * 26 + zl
#       zl = w + var3
#     end
#   else # var1 == 26
#     # -16 <= var2 <= -3
#     local x = zl + var2
#     if x != w
#       zl = w + var3
#     else
#       zl = zh % 26
#       zh /= 26
#     end
#   end
# end
# return zl == 0 && zh == 0
#
#
#
# local z = [0]
# for w in inputs
#   if var1 == 1
#     z << (w + var3)
#   else
#     if w == z.last + var2
#       z.pop
#     else
#       z.last = w + var3
#     end
#   end
# end
# return z == [0]
#
#
#
# var1  1     1     1     26    26    1     1     26    1     1     26    26    26    26
# var2  11    12    13    -5    -3    14    15    -16   14    15    -7    -11   -6    -11
# var3  16    11    12    12    12    2     11    4     12    9     10    11    6     15
#
# 41299994879959
# ((())(()(())))
# 11189561113216
