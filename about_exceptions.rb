require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutExceptions < EdgeCase::Koan

  class MySpecialError < RuntimeError
  end

  def test_exceptions_inherit_from_Exception
    # RuntimeError is standard...? Criteria for standard?
    assert_equal(RuntimeError, MySpecialError.ancestors[1])
    # I wonder what is a non standard error.
    assert_equal(StandardError, MySpecialError.ancestors[2])
    # Exception is the root of all exception related objects.
    assert_equal(Exception, MySpecialError.ancestors[3])
    # Everything in Ruby is an object.
    assert_equal(Object, MySpecialError.ancestors[4])
  end

  def test_rescue_clause
    result = nil
    begin
      # the #fail nested in the begin initializes the StandardError's message.
      fail "Oops"
    rescue StandardError => ex
      result = :exception_handled
    end

    assert_equal(:exception_handled, result)

    # The third parameter to #assert_equal is the message to prepend
    # the fail output.
    assert_equal(true, ex.is_a?(StandardError), "Should be a Standard Error")
    # RuntimeError inherits from StandardError. Since ex is a Standard error,
    # it cannot be a runtime error.
    # 
    # - Well I was wrong... It is a RuntimeError... WTF? Does that mean
    # Object#ancestors does not return the SuperClasses in order of inheritance?
    assert_equal(true, ex.is_a?(RuntimeError),  "Should be a Runtime Error")

    assert RuntimeError.ancestors.include?(StandardError),
      "RuntimeError is a subclass of StandardError"

    assert_equal("Oops", ex.message)
  end

  def test_raising_a_particular_error
    result = nil
    begin
      # 'raise' and 'fail' are synonyms
      # #raise is like #fail, except that it takes an error class as the first
      # object and the message as the second argument.
      #
      # Look at line 82...
      raise MySpecialError, "My Message"
    rescue MySpecialError => ex
      result = :exception_handled
    end

    assert_equal(:exception_handled, result)
    assert_equal("My Message", ex.message)
  end

  def test_ensure_clause
    result = nil
    begin
      fail "Oops"
    rescue StandardError => ex
      # no code here
    ensure # <= Run regardless of if the contents of "begin" raises and error.
      result = :always_run
    end

    assert_equal(:always_run, result)
  end

  # Sometimes, we must know about the unknown
  def test_asserting_an_error_is_raised
    # A do-end is a block, a topic to explore more later
    # #assert_raise is a good way to test exception handling. It is probably
    # a wrapper for a rescue followed by a comparison.
    assert_raise(MySpecialError) do
      # If you give #raise a a second argument it must use it to create an
      # instance of the first argument(an Exception class) with the message and
      # returns it. If an instance of an Exception is passed as the first
      # parameter, it probably just returns it.
      raise MySpecialError.new("New instances can be raised directly.")
    end
  end

end
