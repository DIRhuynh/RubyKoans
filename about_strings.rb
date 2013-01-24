require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutStrings < EdgeCase::Koan
  def test_double_quoted_strings_are_strings
    string = "Hello, World"
    assert_equal(true, string.is_a?(String))
  end

  def test_single_quoted_strings_are_also_strings
    string = 'Goodbye, World'
    assert_equal(true, string.is_a?(String))
  end

  def test_use_single_quotes_to_create_string_with_double_quotes
    string = 'He said, "Go Away."'
    assert_equal("He said, \"Go Away.\"", string)
  end

  def test_use_double_quotes_to_create_strings_with_single_quotes
    string = "Don't"
    assert_equal('Don\'t', string)
  end

  def test_use_backslash_for_those_hard_cases
    a = "He said, \"Don't\""
    b = 'He said, "Don\'t"'
    assert_equal(true, a == b)
  end

  def test_use_flexible_quoting_to_handle_really_hard_cases
    # REALLY COOL!
    a = %(flexible quotes can handle both ' and " characters)
    b = %!flexible quotes can handle both ' and " characters!
    c = %{flexible quotes can handle both ' and " characters}
    assert_equal(true, a == b)
    assert_equal(true, a == c)
  end

  def test_flexible_quotes_can_handle_multiple_lines
    # First line is empty with a \n character. => char count = 1
    # Second line has 25 characters plus a \n. => char count = 26
    # Third line has 26 character plus a \n.   => char count = 27
    # Fourth line closes the } and is empty.   => char count = 0
    #
    # Total is 26 + 27 + 1 = 54
    long_string = %{
It was the best of times,
It was the worst of times.
}
    assert_equal(54, long_string.length)
    assert_equal(3, long_string.lines.count)
  end

  def test_here_documents_can_also_handle_multiple_lines
    # Another cool way of writing long strings!
    #
    # It is different from %{ ... }.
    #
    # The first line with <<EOS does not have a \n.
    # The rest of the lines are the same.
    long_string = <<EOS
It was the best of times,
It was the worst of times.
EOS
    assert_equal(53, long_string.length)
    assert_equal(2, long_string.lines.count)
  end

  def test_plus_will_concatenate_two_strings
    string = "Hello, " + "World"
    assert_equal("Hello, World", string)
  end

  def test_plus_concatenation_will_leave_the_original_strings_unmodified
    hi     = "Hello, "
    there  = "World"
    string = hi + there

    assert_equal("Hello, " , hi)
    assert_equal("World" , there)
  end

  def test_plus_equals_will_concatenate_to_the_end_of_a_string
    hi    = "Hello, "
    there = "World"
    hi    += there
    assert_equal("Hello, World", hi)
  end

  def test_plus_equals_also_will_leave_the_original_string_unmodified
    original_string = "Hello, "

    # Isn't Ruby create a new object with the assignment operator?
    # So of course it wouldn't affect original string?
    #
    # Correction: It would appear Ruby is a copy on write language
    #   e.g.
    #   1.9.3-p286 :001 > s = "hi!"
    #    => "hi!"
    #   1.9.3-p286 :002 > s2 = s
    #    => "hi!"
    #   1.9.3-p286 :004 > s2.object_id
    #    => 70099529129640
    #   1.9.3-p286 :005 > s.object_id
    #    => 70099529129640
    #   1.9.3-p286 :006 > s2.object_id == s.object_id
    #    => true
    #   1.9.3-p286 :007 > s2 += "hiHI"
    #    => "hi!hiHI"
    #   1.9.3-p286 :008 > s2.object_id == s.object_id
    #    => false
    #
    # Correction-Correction: I am silly, ruby is a pass by reference
    #   langauge.
    #
    #   The behavior in the first correction is explained here:
    #   e.g.
    #
    #   The objects are initially the same because Ruby is a pass by
    #   reference language and so the assignment operator simply
    #   assigns the reference to the original object referenced by
    #   s into the variable s2.
    #   1.9.3-p286 :006 > s2.object_id == s.object_id
    #    => true
    #
    #   The String#+= method takes a String, concatenates it's contents
    #   with the contents of the String that it was called from and returns
    #   a new String object containing this value. It then takes this new
    #   String object and assigns it back into the variable that once held
    #   the string that the String#+= method was called from.
    #
    #   This is why after the String#+=, the strings are different.
    #   1.9.3-p286 :007 > s2 += "hiHI"
    #    => "hi!hiHI"
    #   1.9.3-p286 :008 > s2.object_id == s.object_id
    #    => false
    #
    #   The following example further hilights this:
    #   e.g.
    #   1.9.3-p286 :015 > s = "hi"
    #    => "hi"
    #   1.9.3-p286 :016 > s2 = s
    #    => "hi"
    #   1.9.3-p286 :017 > s2.object_id == s.object_id
    #    => true
    #   1.9.3-p286 :018 > s2 + " fishy"
    #    => "hi fishy"
    #   1.9.3-p286 :019 > s2.object_id == s.object_id
    #    => true
    #   1.9.3-p286 :020 > s2
    #    => "hi"

    hi    = original_string
    there = "World"
    hi    += there

    assert_equal("Hello, ", original_string)
  end

  def test_the_shovel_operator_will_also_append_content_to_a_string
    hi    = "Hello, "
    there = "World"

    hi << there

    assert_equal("Hello, World", hi)
    assert_equal("World", there)
  end

  def test_the_shovel_operator_modifies_the_original_string
    original_string = "Hello, "
    hi              = original_string
    there           = "World"

    hi << there
    assert_equal("Hello, World", original_string)

    # THINK ABOUT IT:
    #
    # Ruby programmers tend to favor the shovel operator (<<) over the
    # plus equals operator (+=) when building up strings.  Why?
    #
    # - It saves space in memory.
    # - It doesn't have to create as many interim String objects.
  end

  def test_double_quoted_string_interpret_escape_characters
    string = "\n"
    assert_equal(1, string.size)
  end

  def test_single_quoted_string_do_not_interpret_escape_characters
    string = '\n'
    assert_equal(2, string.size)
  end

  def test_single_quotes_sometimes_interpret_escape_characters
    # The first \, escapes the second \.
    # The third \, escapes the '.
    # They must be special case escapes for single quotes(').
    string = '\\\''
    assert_equal(2, string.size)
    assert_equal(%{\\'}, string)
  end

  def test_double_quoted_strings_interpolate_variables
    value  = 123
    string = "The value is #{value}"
    assert_equal("The value is 123", string)
  end

  def test_single_quoted_strings_do_not_interpolate
    value  = 123
    string = 'The value is #{value}'
    # The %{} string wrappers work just like the double quoted ones.
    assert_equal(%{The value is #\{value\}}, string)
  end

  def test_any_ruby_expression_may_be_interpolated
    string = "The square root of 5 is #{Math.sqrt(5)}"
    assert_equal("The square root of 5 is 2.23606797749979", string)
  end

  def test_you_can_get_a_substring_from_a_string
    # How slicing numbers work.
    # -1   0   1    2    3    4    5    6    7    8    9   10    11
    #  o       B    a    c    n    ,    _    l    e    t    t     u    ...
    # How indexing works:
    #       0    1    2    3    4    5    6    7    8    9    10    11
    # The numbers mark the space before the character...
    # Think pointer to the space in memory in C.
    string = "Bacon, lettuce and tomato"
    assert_equal("let", string[7,3])
    # Ranges passed to the String#[] method behaves similar to that
    # of the Array. The ".." means inclusive.
    assert_equal("lettuce and toma", string[7..-3])
  end

  def test_you_can_get_a_single_character_from_a_string
    string = "Bacon, lettuce and tomato"
    assert_equal("a", string[1]) # 0 based index, you dunce.

    # Surprised?
    # - NAH, Strings are just arrays with some extra features anyways.
  end

  # A special way to specify which Ruby version. How cool.
  in_ruby_version("1.8") do
    def test_in_ruby_1_8_single_characters_are_represented_by_integers
      # C ASCII representation.
      assert_equal("a", ?a)
      assert_equal(true, ?a == 97)

      assert_equal(true, ?b == (?a + 1))
    end
  end

  in_ruby_version("1.9") do
    def test_in_ruby_1_9_single_characters_are_represented_by_strings
      # I wonder why...
      assert_equal("a", ?a)
      assert_equal(false, ?a == 97)
    end
  end

  def test_strings_can_be_split
    string = "Sausage Egg Cheese"
    words = string.split
    assert_equal(["Sausage", "Egg", "Cheese"], words)
  end

  def test_strings_can_be_split_with_different_patterns
    string = "the:rain:in:spain"
    # /:/ is a regex.
    words = string.split(/:/)
    assert_equal(["the", "rain", "in", "spain"], words)

    # NOTE: Patterns are formed from Regular Expressions.  Ruby has a
    # very powerful Regular Expression library.  We will become
    # enlightened about them soon.
  end

  def test_strings_can_be_joined
    words = ["Now", "is", "the", "time"]
    assert_equal("Now is the time", words.join(" "))
  end

  def test_strings_are_unique_objects
    a = "a string"
    b = "a string"

    # String#== returns a boolean after comparing the contents of the
    # strings.
    assert_equal(true, a == b)
    # This is because "..." is a Literal String Constructor and
    # returns a new String object in memory.
    #
    # This new String object's reference is subsequently stored
    # in the variable that the = method is called from.
    assert_equal(false, a.object_id == b.object_id)
  end
end
