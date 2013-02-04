require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutClasses < EdgeCase::Koan
  class Dog
  end

  def test_instances_of_classes_can_be_created_with_new
    # Object#new can be considered malloc. It just allocates the space in
    # memory... What would happen if we overwrote Object#new?
    #
    # Does Object#new call Object#initialize or whatever definition that is
    # closest to the class (SomeObject#initialize)?
    #
    # If so, that must be why SomeObject#initialize is all that we need to get
    # desired attributes defined when an instance of an object is created.
    #
    # - Correction, I have discovered in the Ruby Docs that Class#new is what
    # gets invoked and it is what calls the instance method #initialize. Now if
    # we think about, we call # new as such "SomeClass.new" and so it is clear
    # that is a class method. All classes inherit from Class.
    fido = Dog.new
    assert_equal(Dog, fido.class)
  end

  # ------------------------------------------------------------------

  class Dog2
    def set_name(a_name)
      @name = a_name
    end
  end

  def test_instance_variables_can_be_set_by_assigning_to_them
    fido = Dog2.new
    # Object#instance_variables returns an array of instance variables.
    assert_equal([], fido.instance_variables)

    fido.set_name("Fido")
    # Apparently it returns an array of symbols for all of the set attributes
    assert_equal([:@name], fido.instance_variables)
  end

  def test_instance_variables_cannot_be_accessed_outside_the_class
    fido = Dog2.new
    fido.set_name("Fido")

    assert_raise(NoMethodError) do
      fido.name
    end

    assert_raise(SyntaxError) do
      # They use eval because it prevents the content of the string from being
      # evaluated until run time. Otherwise this whole Ruby Koan thing would be
      # broken.
      eval "fido.@name"
      # NOTE: Using eval because the above line is a syntax error.
    end
  end

  def test_you_can_politely_ask_for_instance_variable_values
    fido = Dog2.new
    fido.set_name("Fido")

    # This is interesting. It bypasses a lot of modularity imposed by a
    # class/object oriented design. I wonder if this is to facilitate meta
    # programming.
    assert_equal("Fido", fido.instance_variable_get("@name"))
  end

  def test_you_can_rip_the_value_out_using_instance_eval
    fido = Dog2.new
    fido.set_name("Fido")

    # I believe Object#instance_eval evaluates the string/block within the
    # context/scope of the instance of a class and thus exposes the instance
    # variables/attributes.
    assert_equal("Fido", fido.instance_eval("@name"))  # string version
    assert_equal("Fido", fido.instance_eval { @name }) # block version
  end

  # ------------------------------------------------------------------

  class Dog3
    def set_name(a_name)
      @name = a_name
    end
    def name
      @name
    end
  end

  def test_you_can_create_accessor_methods_to_return_instance_variables
    fido = Dog3.new
    fido.set_name("Fido")

    assert_equal("Fido", fido.name)
  end

  # ------------------------------------------------------------------

  class Dog4
    # Object#attr_reader takes a variable number of arguments, which are
    # symbols. These symbols are used to generate attribute getter/setters.
    attr_reader :name

    def set_name(a_name)
      @name = a_name
    end
  end


  def test_attr_reader_will_automatically_define_an_accessor
    fido = Dog4.new
    fido.set_name("Fido")

    assert_equal("Fido", fido.name)
  end

  # ------------------------------------------------------------------

  class Dog5
    attr_accessor :name
  end


  def test_attr_accessor_will_automatically_define_both_read_and_write_accessors
    fido = Dog5.new

    fido.name = "Fido"
    assert_equal("Fido", fido.name)
  end

  # ------------------------------------------------------------------

  class Dog6
    attr_reader :name
    # Tried overloading #new in a class and failed... Maybe there are some
    # methods you just can't overload. I suppose it protects from breaking
    # Ruby's object oriented features. If new was overloaded then the malloc and
    # initialize behaviors would be broken.
    #
    # - Correction This is because I was trying to define an instance method
    # called new. I have to overload the class method.
    #
    # e.g.
    #   class << self
    #     def new
    #       ...
    #     end
    #   end
    #
    #   or
    #
    #   def self.new
    #     ...
    #   end
    def initialize(initial_name)
      @name = initial_name
    end
  end

  def test_initialize_provides_initial_values_for_instance_variables
    fido = Dog6.new("Fido")
    assert_equal("Fido", fido.name)
  end

  def test_args_to_new_must_match_initialize
    assert_raise(ArgumentError) do
      Dog6.new
    end
    # THINK ABOUT IT:
    # Why is this so?
    #
    # I discussed this earlier in this file, Object#new calls
    # SomeObject/Object#initialize and so if there are not enough arguments
    # provided then of course things blows up.
  end

  def test_different_objects_have_different_instance_variables
    fido = Dog6.new("Fido")
    rover = Dog6.new("Rover")

    assert_equal(true, rover.name != fido.name)
  end

  # ------------------------------------------------------------------

  class Dog7
    attr_reader :name

    def initialize(initial_name)
      @name = initial_name
    end

    def get_self
      self
    end

    def to_s
      @name.to_s
    end

    # You can overwrite the inspect method to display pertinent contents in a
    # more readable way. Awesome
    def inspect
      "<Dog named '#{name}'>"
    end
  end

  def test_inside_a_method_self_refers_to_the_containing_object
    fido = Dog7.new("Fido")

    fidos_self = fido.get_self
    assert_equal(fido, fidos_self)
  end

  def test_to_s_provides_a_string_version_of_the_object
    fido = Dog7.new("Fido")
    assert_equal("Fido", fido.to_s)
  end

  def test_to_s_is_used_in_string_interpolation
    fido = Dog7.new("Fido")
    assert_equal("My dog is #{fido}", "My dog is #{fido}")
  end

  def test_inspect_provides_a_more_complete_string_version
    fido = Dog7.new("Fido")
    assert_equal("<Dog named 'Fido'>", fido.inspect)
  end

  # This must mean that it their core the objects inherit from Object#to_s
  def test_all_objects_support_to_s_and_inspect
    array = [1,2,3]

    assert_equal("[1, 2, 3]", array.to_s)
    assert_equal("[1, 2, 3]", array.inspect)

    assert_equal("STRING", "STRING".to_s)
    assert_equal("\"STRING\"", "STRING".inspect)
  end

end
