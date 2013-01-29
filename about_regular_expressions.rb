# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutRegularExpressions < EdgeCase::Koan
  def test_a_pattern_is_a_regular_expression
    # /.../ are the delimeters for a Regexp.
    assert_equal(Regexp, /pattern/.class)
  end

  def test_a_regexp_can_search_a_string_for_matching_content
    # The String#[] can take a Regexp as an argument and
    # will return the string that matches the pattern.
    assert_equal("match", "some matching content"[/match/])
  end

  def test_a_failed_match_returns_nil
    # nil is return from String#[] when no match is found.
    # It's the same behavior as when we pass an index or
    # range as an parameter to the method.
    #
    # It returns the first string sequence that matches the
    # entire pattern. This is shown by the method
    # test_question_mark_means_optional.
    assert_equal(nil, "some matching content"[/missing/])
  end

  # ------------------------------------------------------------------

  def test_question_mark_means_optional
    assert_equal("ab", "abbcccddddeeeee"[/ab?/])
    assert_equal("a", "abbcccddddeeeee"[/az?/])
  end

  def test_plus_means_one_or_more
    assert_equal("bccc", "abbcccddddeeeee"[/bc+/])
  end

  def test_asterisk_means_zero_or_more
    assert_equal("abb", "abbcccddddeeeee"[/ab*/])
    assert_equal("a", "abbcccddddeeeee"[/az*/])
    assert_equal("", "abbcccddddeeeee"[/z*/])

    # THINK ABOUT IT:
    #
    # When would * fail to match?
    # - It would only fail if the prefixing target wasn't in the
    #   string.
    # - It would break ruby if there is no target prefixing it.
  end

  # THINK ABOUT IT:
  #
  # We say that the repetition operators above are "greedy."
  #
  # Why?
  # - They are greedy because they match as many of the target
  #   prefixing them as possible.

  # ------------------------------------------------------------------

  def test_the_left_most_match_wins
    # Matching starts from left to right. The first instance wins.
    assert_equal("a", "abbccc az"[/az*/])
  end

  # ------------------------------------------------------------------

  def test_character_classes_give_options_for_a_character
    animals = ["cat", "bat", "rat", "zat"]
    # That is why they no longer represent characters as Integers.
    # In Ruby 1.9 onwards characters are represented as Strings so
    # we can use the String#[Regexp] method.
    #
    # One reason for why anyways...
    assert_equal(["cat", "bat", "rat"], animals.select { |a| a[/[cbr]at/] })
  end

  def test_slash_d_is_a_shortcut_for_a_digit_character_class
    assert_equal("42", "the number is 42"[/[0123456789]+/])
    assert_equal("42", "the number is 42"[/\d+/])
  end

  def test_character_classes_can_include_ranges
    # This range is equivalent to that of the string.
    assert_equal("42", "the number is 42"[/[0-9]+/])
  end

  def test_slash_s_is_a_shortcut_for_a_whitespace_character_class
    # WHITE SPACE YOU DUNCE!!!
    assert_equal(" \t\n", "space: \t\n"[/\s+/])
  end

  def test_slash_w_is_a_shortcut_for_a_word_character_class
    # NOTE:  This is more like how a programmer might define a word.
    # - Do you mean white space delimited sequence of non white space
    #   characters?
    assert_equal("variable_1", "variable_1 = 42"[/[a-zA-Z0-9_]+/])
    # Yup looks like it...
    assert_equal("variable_1", "variable_1 = 42"[/\w+/])
  end

  def test_period_is_a_shortcut_for_any_non_newline_character
    assert_equal("abc", "abc\n123"[/a.+/])
  end

  def test_a_character_class_can_be_negated
    # REMEMBER "^" is negate in Regex...
    # Git uses that as an up one and a negate?
    assert_equal("the number is ", "the number is 42"[/[^0-9]+/])
  end

  def test_shortcut_character_classes_are_negated_with_capitals
    # AWESOME!~!
    assert_equal("the number is ", "the number is 42"[/\D+/])
    assert_equal("space:", "space: \t\n"[/\S+/])
    # ... a programmer would most likely do
    assert_equal(" = ", "variable_1 = 42"[/[^a-zA-Z0-9_]+/])
    # Apparently the "w" or "W" stands for [a-zA-Z0-9_]+.
    # Interesting. I think the above representation is more verbose
    # and obvious than the shortcuts.
    assert_equal(" = ", "variable_1 = 42"[/\W+/])
  end

  # ------------------------------------------------------------------

  def test_slash_a_anchors_to_the_start_of_the_string
    assert_equal("start", "start end"[/\Astart/])
    # The String#[Regex] returns nil or the first substring that
    # matches the pattern from the left.
    assert_equal(nil, "start end"[/\Aend/])
  end

  def test_slash_z_anchors_to_the_end_of_the_string
    assert_equal("end", "start end"[/end\z/])
    assert_equal(nil, "start end"[/start\z/])
  end

  def test_caret_anchors_to_the_start_of_lines
    # "^" matchs beginning of line if it is outside of the
    # Regex brackets which designate a set.
    assert_equal("2", "num 42\n2 lines"[/^\d+/])
  end

  def test_dollar_sign_anchors_to_the_end_of_lines
    # Just like Vim... Yay!
    assert_equal("42", "2 lines\nnum 42"[/\d+$/])
  end

  def test_slash_b_anchors_to_a_word_boundary
    # What is a word boundary?...
    # - I suppose blank spaces.
    assert_equal("vines", "bovine vines"[/\bvine./])
  end

  # ------------------------------------------------------------------

  def test_parentheses_group_contents
    # (...) is group of characters that must all be matched in it's sequence.
    # [...] is a set of potential characters.
    assert_equal("hahaha", "ahahaha"[/(ha)+/])
  end

  # ------------------------------------------------------------------

  def test_parentheses_also_capture_matched_content_by_number
    # It's like backreferencing in Vim's substitute command.
    assert_equal("Gray", "Gray, James"[/(\w+), (\w+)/, 1])
    assert_equal("James", "Gray, James"[/(\w+), (\w+)/, 2])
  end

  def test_variables_can_also_be_used_to_access_captures
    assert_equal("Gray, James", "Name:  Gray, James"[/(\w+), (\w+)/])
    # Hi Ho digity! backreferencing!!!
    assert_equal("Gray", $1)
    assert_equal("James", $2)
  end

  # ------------------------------------------------------------------

  def test_a_vertical_pipe_means_or
    # OOOOOH storing a Regex in a variable and the |, pipe, for OR-ing.
    grays = /(James|Dana|Summer) Gray/
    assert_equal("James Gray", "James Gray"[grays])
    # In your haste you forgot the "1" parameter. Backreferencing to get
    # the "Summer" string.
    assert_equal("Summer", "Summer Gray"[grays, 1])
    assert_equal(nil, "Jim Gray"[grays, 1])
  end

  # THINK ABOUT IT:
  #
  # Explain the difference between a character class ([...]) and alternation (|).
  # - The [...] is for a set of characters. The alternation/pipe/OR operator is
  #   a word/grouping/pattern.
  #
  # - I think the [...] could work if I nested groupings a la [(...)|(...)]
  # - Looks like I was wrong... :( oh well I learned.
  # 1.9.3-p286 :001 > string = "fish, n chips"
  #  => "fish, n chips" 
  # 1.9.3-p286 :005 > string[/[(fish)(chip)]/]
  #  => "f" 

  # ------------------------------------------------------------------

  def test_scan_is_like_find_all
    # Looks like a word is delimited by whitespace characters and dashses(-).
    assert_equal(["one", "two", "three"], "one two-three".scan(/\w+/))
  end

  def test_sub_is_like_find_and_replace
    # /(t\w*)/ matches any word that begind with "t" followed by any sequence of
    # words. The Regex matchs and returns "two" because "-" is a space
    # deliminter.
    #
    # It essentially negates the "*" splat operator.
    #
    # The String#sub method takes the Regex as the first parameter and the block
    # as the second.
    #
    # The block gets the first group matching via $1 and returns "t" by slicing
    # the string. It goes to the space beore the first "t" and slices after
    # moving one character space over.
    #
    # String#sub takes the "t" character string retured by the block and
    # substitutes the original matched string "two" with the "t".
    #
    # Hence why we get "one t-three."
    assert_equal("one t-three", "one two-three".sub(/(t\w*)/) { $1[0, 1] })
  end

  def test_gsub_is_like_find_and_replace_all
    assert_equal("one t-t", "one two-three".gsub(/(t\w*)/) { $1[0, 1] })
  end
end
