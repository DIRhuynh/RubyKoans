require File.expand_path(File.dirname(__FILE__) + '/edgecase')

# Constants are defined outsite of methods in the class.
C = "top level"

class AboutConstants < EdgeCase::Koan

  C = "nested"

  def test_nested_constants_may_also_be_referenced_with_relative_paths
    assert_equal("nested", C)
  end

  def test_top_level_constants_are_referenced_by_double_colons
    # ::<constant_variable_name>
    assert_equal("top level", ::C)
  end

  def test_nested_constants_are_referenced_by_their_complete_path
    # So in a class we can use the <Classname>::<constant_variable_name>
    # The "::" is a namespace indicator... Is a class a namespace?
    assert_equal("nested", AboutConstants::C)
    assert_equal("nested", ::AboutConstants::C)
  end

  # ------------------------------------------------------------------

  class Animal
    LEGS = 4
    def legs_in_animal
      LEGS
    end

    class NestedAnimal
      def legs_in_nested_animal
        LEGS
      end
    end
  end

  def test_nested_classes_inherit_constants_from_enclosing_classes
    assert_equal(4, Animal::NestedAnimal.new.legs_in_nested_animal)
  end

  # ------------------------------------------------------------------

  class Reptile < Animal
    def legs_in_reptile
      LEGS
    end
  end

  def test_subclasses_inherit_constants_from_parent_classes
    assert_equal(4, Reptile.new.legs_in_reptile)
  end

  # ------------------------------------------------------------------

  class MyAnimals
    LEGS = 2

    class Bird < Animal
      def legs_in_bird
        LEGS
      end
    end
  end

  def test_who_wins_with_both_nested_and_inherited_constants
    # It looks like the nested constant beat the inherited constant...
    # Why?
    assert_equal(2, MyAnimals::Bird.new.legs_in_bird)
  end

  # QUESTION: Which has precedence: The constant in the lexical scope,
  # or the constant from the inheritance hierarchy?
  #
  # I think the Inheritance Hierarchy has the precedence and so it is evaluated
  # first. Then the Lexical Scope constant over writes the constant...?
  #
  # Well it is a constant so maybe we can't overwrite it. In that case my answer
  # is reverse and the Lexical Scope constant has precedence and thus it is
  # evaluated first.

  # ------------------------------------------------------------------

  class MyAnimals::Oyster < Animal
    def legs_in_oyster
      LEGS
    end
  end

  def test_who_wins_with_explicit_scoping_on_class_definition
    assert_equal(4, MyAnimals::Oyster.new.legs_in_oyster)
  end

  # QUESTION: Now which has precedence: The constant in the lexical
  # scope, or the constant from the inheritance hierarchy?  Why is it
  # different than the previous answer?
  #
  # The inheritance hierarchy has precedence...
  #
  # My guess is that this is because we are loading the Lexical Scope constant
  # first before we inherit from the Animal Inheritance Hierarchy and thus the
  # latter over write the former...
end
