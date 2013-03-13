require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutScope < EdgeCase::Koan
  module Jims
    class Dog
      def identify
        :jims_dog
      end
    end
  end

  module Joes
    class Dog
      def identify
        :joes_dog
      end
    end
  end

  def test_dog_is_not_available_in_the_current_scope
    assert_raise(NameError) do
      fido = Dog.new
    end
  end

  def test_you_can_reference_nested_classes_using_the_scope_operator
    fido = Jims::Dog.new
    rover = Joes::Dog.new
    assert_equal(:jims_dog, fido.identify)
    assert_equal(:joes_dog, rover.identify)

    # They are different because the class name include the scope.
    assert_equal(true, fido.class != rover.class)
    # The line below, performs the same comparison as the line above.
    assert_equal(true, Jims::Dog != Joes::Dog)
  end

  # ------------------------------------------------------------------

  class String
  end

  # AboutScope is a Class, which inherits Module, which explains their how
  # Class has the scope operator.
  def test_bare_bones_class_names_assume_the_current_scope
    assert_equal(true, AboutScope::String == String)
  end

  # This is because the system string does not have any scope whereas our custom
  # string is within the AboutScope scope.
  def test_nested_string_is_not_the_same_as_the_system_string
    assert_equal(false, String == "HI".class)
  end

  def test_use_the_prefix_scope_operator_to_force_the_global_scope
    assert_equal(true, ::String == "HI".class)
  end

  # ------------------------------------------------------------------

  PI = 3.1416

  # Does that mean all classes and modules are constants?
  def test_constants_are_defined_with_an_initial_uppercase_letter
    assert_equal(3.1416, PI)
  end

  # ------------------------------------------------------------------

  MyString = ::String

  # Well that answered my question above...
  # Does that mean, the 'class' keyword is, essentially, a method that
  # takes a constant as a argument, to access the instance of a particular
  # Class object with that name, and a block to add new methods/instance
  # variables(properties/attributes)?
  def test_class_names_are_just_constants
    assert_equal(true, MyString == ::String)
    assert_equal(true, MyString == "HI".class)
  end

  def test_constants_can_be_looked_up_explicitly
    assert_equal(true, PI == AboutScope.const_get("PI"))
    assert_equal(true, MyString == AboutScope.const_get("MyString"))
  end

  def test_you_can_get_a_list_of_constants_for_any_class_or_module
    # Constants are stored as Symbols.
    assert_equal([:Dog], Jims.constants)
    # _n_ is 999999...
    # assert Object.constants.size > _n_
    assert Object.constants.size < _n_
  end
end
