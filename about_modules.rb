require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutModules < EdgeCase::Koan
  module Nameable
    def set_name(new_name)
      @name = new_name
    end

    def here
      :in_module
    end
  end

  def test_cant_instantiate_modules
    assert_raise(NoMethodError) do
      Nameable.new
    end
  end

  # ------------------------------------------------------------------

  class Dog
    # Modules are used to mixin into a class. It's like inheritance
    # except there is no super from the mixin.
    include Nameable

    attr_reader :name

    def initialize
      @name = "Fido"
    end

    def bark
      "WOOF"
    end

    def here
      :in_object
    end
  end

  def test_normal_methods_are_available_in_the_object
    fido = Dog.new
    assert_equal("WOOF", fido.bark)
  end

  def test_module_methods_are_also_available_in_the_object
    fido = Dog.new
    assert_nothing_raised(Exception) do
      fido.set_name("Rover")
    end
  end

  def test_module_methods_can_affect_instance_variables_in_the_object
    fido = Dog.new
    assert_equal("Fido", fido.name)

    # The mixed in methods can act upon the instance variables of the
    # instance objects of the class that the module was mixed into.
    fido.set_name("Rover")
    assert_equal("Rover", fido.name)
  end

  def test_classes_can_override_module_methods
    fido = Dog.new
    assert_equal(:in_object, fido.here)
  end
end
