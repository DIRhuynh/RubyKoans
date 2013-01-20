require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutArrays < EdgeCase::Koan
  def test_creating_arrays
    empty_array = Array.new
    assert_equal(Array, empty_array.class)
    assert_equal(0, empty_array.size)
  end

  def test_array_literals
    array = Array.new
    assert_equal([], array)

    array[0] = 1
    assert_equal([1], array)

    array[1] = 2
    assert_equal([1, 2], array)

    array << 333
    assert_equal([1, 2, 333], array)
  end

  def test_accessing_array_elements
    array = [:peanut, :butter, :and, :jelly]

    assert_equal(:peanut, array[0])
    assert_equal(:peanut, array.first)
    assert_equal(:jelly, array[3])
    assert_equal(:jelly, array.last)
    assert_equal(:jelly, array[-1])
    assert_equal(:butter, array[-3])
  end

  def test_slicing_arrays
    array = [:peanut, :butter, :and, :jelly]

    assert_equal([:peanut], array[0,1])
    assert_equal([:peanut, :butter], array[0,2])
    assert_equal([:and, :jelly], array[2,2])
    assert_equal([:and, :jelly], array[2,20])

    # The following three peculiar behaviors are explained here:
    #   http://stackoverflow.com/a/3568281
    # It is expected and good behavior.
    #
    # When slicing, the number marks the beginning of a section where
    # the object you would get via indexing exists.
    assert_equal([], array[4,0])
    assert_equal([], array[4,100])
    assert_equal(nil, array[5,0])
  end

  def test_arrays_and_ranges
    assert_equal(Range, (1..5).class)
    # A range is not an array of number from 1 to 5.
    assert_not_equal([1,2,3,4,5], (1..5))
    assert_equal([1,2,3,4,5], (1..5).to_a)
    # "..." is the range from BUT including.
    # ".." is the range from AND including.
    assert_equal([1,2,3,4], (1...5).to_a)
  end

  def test_slicing_with_ranges
    array = [:peanut, :butter, :and, :jelly]

    assert_equal([:peanut,:butter,:and], array[0..2])
    assert_equal([:peanut, :butter], array[0...2])
    # Starts at array[2] and slices until you reach the array at position
    # -1, which is jelly.
    #
    # This is confirmed by array[2..-2], which is equal to [:and] since
    # :and is at the 2 and -2 position.
    #
    # assert_equal([:and], array[2..-2])
    assert_equal([:and, :jelly], array[2..-1])
  end

  def test_pushing_and_popping_arrays
    array = [1,2]
    array.push(:last)

    assert_equal([1, 2, :last], array)

    popped_value = array.pop
    assert_equal(:last, popped_value)
    assert_equal([1, 2], array)
  end

  def test_shifting_arrays
    array = [1,2]
    array.unshift(:first)

    assert_equal([:first, 1, 2], array)

    shifted_value = array.shift
    assert_equal(:first, shifted_value)
    assert_equal([1, 2], array)
  end

end
