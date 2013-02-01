require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutBlocks < EdgeCase::Koan
  def method_with_block
    # Yield will call block and then return the value of that block.
    result = yield
    result
  end

  def test_methods_can_take_blocks
    yielded_result = method_with_block { 1 + 2 }
    assert_equal(3, yielded_result)
  end

  def test_blocks_can_be_defined_with_do_end_too
    yielded_result = method_with_block do 1 + 2 end
    assert_equal(3, yielded_result)
  end

  # ------------------------------------------------------------------

  def method_with_block_arguments
    yield("Jim")
  end

  def test_blocks_can_take_arguments
    result = method_with_block_arguments do |argument|
      assert_equal("Jim", argument)
    end
  end

  # ------------------------------------------------------------------

  def many_yields
    yield(:peanut)
    yield(:butter)
    yield(:and)
    yield(:jelly)
  end

  def test_methods_can_call_yield_many_times
    result = []
    # This hints that a block is within the scope of the calling method and thus
    # has access to the scope's variables. In this case I am referring to
    # results.
    #
    # The block passed to many yield was created within the scope of the
    # test_methods_can_call_yield_many_times. Thus is has access to the results.
    # When the block is passed to many_yields, it still retains information
    # about the scope it was created in (stack frame?) and thus when the
    # many_yields method yields to the block, it can append to result array
    # without any complaints about undefined << for nil class.
    many_yields { |item| result << item }
    assert_equal([:peanut, :butter, :and, :jelly], result)
  end

  # ------------------------------------------------------------------

  def yield_tester
    # Kernel#block_given? returns a boolean. Sweet deal.
    if block_given?
      yield
    else
      :no_block
    end
  end

  def test_methods_can_see_if_they_have_been_called_with_a_block
    assert_equal(:with_block, yield_tester { :with_block })
    assert_equal(:no_block, yield_tester)
  end

  # ------------------------------------------------------------------

  def test_block_can_affect_variables_in_the_code_where_they_are_created
    value = :initial_value
    method_with_block { value = :modified_in_a_block }
    # BOOM! I was right. Check line 42.
    assert_equal(:modified_in_a_block, value)
  end

  def test_blocks_can_be_assigned_to_variables_and_called_explicitly
    add_one = lambda { |n| n + 1 }
    assert_equal(11, add_one.call(10))

    # Alternative calling sequence
    # Proc#[] is a short hand for call. It's a bit confusing and ugly in my
    # opinion. People, like me, could confuse this with the array syntax.
    assert_equal(11, add_one[10])
  end

  def test_stand_alone_blocks_can_be_passed_to_methods_expecting_blocks
    make_upper = lambda { |n| n.upcase }
    result = method_with_block_arguments(&make_upper)
    assert_equal __, result
  end

  # ------------------------------------------------------------------

  def method_with_explicit_block(&block)
    block.call(10)
  end

  def test_methods_can_take_an_explicit_block_argument
    assert_equal __, method_with_explicit_block { |n| n * 2 }

    add_one = lambda { |n| n + 1 }
    assert_equal __, method_with_explicit_block(&add_one)
  end

end
