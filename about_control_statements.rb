require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutControlStatements < EdgeCase::Koan

  def test_if_then_else_statements
    if true
      result = :true_value
    else
      result = :false_value
    end
    assert_equal(:true_value, result)
  end

  def test_if_then_statements
    result = :default_value
    if true
      result = :true_value
    end
    assert_equal(:true_value, result)
  end

  def test_if_statements_return_values
    # Cool, a clean way to initialize w.o. the ternary operator.
    # If statements, returns the last expression evaluated in the
    # construct.
    value = if true
              :true_value
            else
              :false_value
            end
    assert_equal(:true_value, value)

    value = if false
              :true_value
            else
              :false_value
            end
    assert_equal(:false_value, value)

    # NOTE: Actually, EVERY statement in Ruby will return a value, not
    # just if statements.
  end

  def test_if_statements_with_no_else_with_false_condition_return_value
    value = if false
              :true_value
            end
    # My mental image is that all if statements have a corresponding else.
    # If the else is not explicity defined, then it is empty and thus returns
    # a nil.
    assert_equal(nil, value)
  end

  def test_condition_operators
    # the "?" in <expression> ? <expression for true> : <expression for false> is
    # called a ternary operator
    assert_equal(:true_value, (true ? :true_value : :false_value))
    assert_equal(:false_value, (false ? :true_value : :false_value))
  end

  def test_if_statement_modifiers
    result = :default_value
    result = :true_value if true

    assert_equal(:true_value, result)
  end

  def test_unless_statement
    result = :default_value
    # This can be interpreted as, do everything in this construct unless the
    # expression the "unless" prefixes evaluates to true.
    #
    # i.e. Do unless this is true.
    unless false    # same as saying 'if !false', which evaluates as 'if true'
      result = :false_value
    end
    assert_equal(:false_value, result)
  end

  def test_unless_statement_evaluate_true
    result = :default_value
    unless true    # same as saying 'if !true', which evaluates as 'if false'
      result = :true_value
    end
    assert_equal(:default_value, result)
  end

  def test_unless_statement_modifier
    result = :default_value
    result = :false_value unless false

    assert_equal(:false_value, result)
  end

  def test_while_statement
    i = 1
    result = 1
    while i <= 10
      result = result * i
      i += 1
    end
    assert_equal(3628800, result)
  end

  def test_break_statement
    i = 1
    result = 1
    while true
      # Perform the break unless i <= 10. So when i = 11.
      break unless i <= 10
      result = result * i
      i += 1
    end
    assert_equal(3628800, result)
  end

  def test_break_statement_returns_values
    i = 1
    result = while i <= 10
      # You need to pass break a parameter to return?
      break i if i % 2 == 0
      i += 1
    end

    assert_equal(2, result)
  end

  def test_next_statement
    i = 0
    result = []
    while i < 10
      i += 1
      # skip all remaining code after this next in this iteration of the loop.
      next if (i % 2) == 0
      result << i
    end
    assert_equal([1, 3, 5, 7, 9], result)
  end

  def test_for_statement
    array = ["fish", "and", "chips"]
    result = []
    # This can be substitute with array.each { |item| result << item }
    for item in array
      result << item.upcase
    end
    assert_equal(["FISH", "AND", "CHIPS"], result)
  end

end
