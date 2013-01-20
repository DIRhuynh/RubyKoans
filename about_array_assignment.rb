require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutArrayAssignment < EdgeCase::Koan
  def test_non_parallel_assignment
    names = ["John", "Smith"]
    assert_equal(["John", "Smith"], names)
  end

  def test_parallel_assignments
    first_name, last_name = ["John", "Smith"]
    assert_equal("John", first_name)
    assert_equal("Smith", last_name)
  end

  def test_parallel_assignments_with_extra_values
    first_name, last_name = ["John", "Smith", "III"]
    assert_equal("John", first_name)
    assert_equal("Smith", last_name)
  end

  def test_parallel_assignments_with_splat_operator
    # I can think of the splat(*) as a pointer to a point in
    # the array after the prior variables assigned value.
    first_name, *last_name = ["John", "Smith", "III"]
    assert_equal("John", first_name)
    assert_equal(["Smith", "III"], last_name)
  end

  def test_parallel_assignments_with_too_few_variables
    first_name, last_name = ["Cher"]
    assert_equal("Cher", first_name)
    assert_equal(nil, last_name)
  end

  def test_parallel_assignments_with_subarrays
    first_name, last_name = [["Willie", "Rae"], "Johnson"]
    assert_equal(["Willie", "Rae"], first_name)
    assert_equal("Johnson", last_name)
  end

  def test_parallel_assignment_with_one_variable
    # Don't over look the comma at the end of first_name.
    first_name, = ["John", "Smith"]
    assert_equal("John", first_name)
  end

  def test_swapping_with_parallel_assignment
    first_name = "Roy"
    last_name = "Rob"
    # The swapping parrallel assignment is syntactic sugar for 
    # swapping with a temporary variable.
    first_name, last_name = last_name, first_name
    assert_equal("Rob", first_name)
    assert_equal("Roy", last_name)
  end
end
