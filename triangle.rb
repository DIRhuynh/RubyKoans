# Triangle Project Code.

# Triangle analyzes the lengths of the sides of a triangle
# (represented by a, b and c) and returns the type of triangle.
#
# It returns:
#   :equilateral  if all sides are equal
#   :isosceles    if exactly 2 sides are equal
#   :scalene      if no sides are equal
#
# The tests for this method can be found in
#   about_triangle_project.rb
# and
#   about_triangle_project_2.rb
#
def triangle(a, b, c)
  match_count = 0

  match_count = match_count + 1 if a == b
  match_count = match_count + 1 if b == c
  match_count = match_count + 1 if c == a

  case match_count
  when 0
    return :scalene
  when 1
    return :isosceles
  else # <= This has to be 3, 2 is impossible.
    return :equilateral
  end
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end
