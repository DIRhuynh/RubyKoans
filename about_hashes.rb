require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutHashes < EdgeCase::Koan
  def test_creating_hashes
    empty_hash = Hash.new
    assert_equal(Hash, empty_hash.class)
    assert_equal({}, empty_hash)
    assert_equal(0, empty_hash.size)
  end

  def test_hash_literals
    hash = { :one => "uno", :two => "dos" }
    assert_equal(2, hash.size)
  end

  def test_accessing_hashes
    hash = { :one => "uno", :two => "dos" }
    assert_equal("uno", hash[:one])
    assert_equal("dos", hash[:two])
    assert_equal(nil, hash[:doesnt_exist])
  end

  def test_accessing_hashes_with_fetch
    hash = { :one => "uno" }
    assert_equal("uno", hash.fetch(:one))
    assert_raise(KeyError) do
      hash.fetch(:doesnt_exist)
    end

    # THINK ABOUT IT:
    #
    # Why might you want to use #fetch instead of #[] when accessing hash keys?
    #
    # - Raises an exception instead of silently returning nil. This may be
    # beneficial if you were relying on the value associated with that key.
    #
    # nil is an object and so some of the messages passed to it may work. Using
    # fetch will prevent you code from implicity working with a nil object.
  end

  def test_changing_hashes
    hash = { :one => "uno", :two => "dos" }
    hash[:one] = "eins"

    expected = { :one => "eins", :two => "dos" }
    assert_equal(true, expected == hash)

    # Bonus Question: Why was "expected" broken out into a variable
    # rather than used as a literal?
    #
    # - code cleanliness
    # - to illustrate that hash have the #== method defined
  end

  def test_hash_is_unordered
    # Hashes are unordered. They are equal so long as the keys and
    # values match up.
    hash1 = { :one => "uno", :two => "dos" }
    hash2 = { :two => "dos", :one => "uno" }

    assert_equal(true, hash1 == hash2)
  end

  # Hash#keys and Hash#values return arrays.
  # e.g. Hash data structure
  #
  #        keys     keys_value      value
  # hash = [0]   => obj             [0]   => obj
  #        [1]   => obj             [1]   => obj
  #        [...] => obj             [...] => obj
  #        [n]   => obj             [n]   => obj

  def test_hash_keys
    hash = { :one => "uno", :two => "dos" }
    assert_equal(2, hash.keys.size)
    assert_equal(true, hash.keys.include?(:one))
    assert_equal(true, hash.keys.include?(:two))
    assert_equal(Array, hash.keys.class)
  end

  def test_hash_values
    hash = { :one => "uno", :two => "dos" }
    assert_equal(2, hash.values.size)
    assert_equal(true, hash.values.include?("uno"))
    assert_equal(true, hash.values.include?("dos"))
    assert_equal(Array, hash.values.class)
  end

  def test_combining_hashes
    # Hash#merge will return a new hash. It will contain the contents
    # of hash and other. When hash.merge(other) if there is a conflict
    # where both the same key with different values, other's value for
    # that key will overwrite hash's value for that key.
    hash = { "jim" => 53, "amy" => 20, "dan" => 23 }
    new_hash = hash.merge({ "jim" => 54, "jenny" => 26 })

    assert_equal(true, hash != new_hash)

    expected = { "jim" => 54, "amy" => 20, "dan" => 23, "jenny" => 26 }
    assert_equal(true, expected == new_hash)
  end

  def test_default_value
    hash1 = Hash.new
    hash1[:one] = 1

    assert_equal(1, hash1[:one])
    assert_equal(nil, hash1[:two])

    # When Hash#new is given a parameter, that parameter will bec the
    # default value for all uninitialized/undefined key.
    hash2 = Hash.new("dos")
    hash2[:one] = 1

    assert_equal(1, hash2[:one])
    assert_equal("dos", hash2[:two])
    # Even if a default key is provided, Hash#fetch will still raise and
    # exception.
    #
    # hash2.fetch(:will_raise)
  end

  def test_default_value_is_the_same_object
    hash = Hash.new([])

    # hash[:one] => []
    #   [] << "uno" will append "uno" to empty default value array
    hash[:one] << "uno"
    # hash[:two] => ["uno"]
    #   ["uno"] << "dos" will append "dos" to default value array
    hash[:two] << "dos"

    # After the end of these appends to the default value array
    # the keys :one and :two are still unitialized.

    assert_equal(["uno", "dos"], hash[:one])
    assert_equal(["uno", "dos"], hash[:two])
    assert_equal(["uno", "dos"], hash[:three])

    # This suggests that a single instance of the default value exists
    # per instance of Hash.
    #
    # Makes sense memory conservation wise.
    assert_equal(true, hash[:one].object_id == hash[:two].object_id)
  end

  def test_default_value_with_block
    hash = Hash.new { |hash, key| hash[key] = [] }

    # hash[:one] => block, which initializes the hash[:one] to []
    # Since the hash[:one] = [], is the last line evaluated in the block
    # the empty array is returned from the block.
    #
    # From there the empty array is appended with the value "uno".
    hash[:one] << "uno"
    # Same effect as above except the key is :two and the value is "dos".
    hash[:two] << "dos"

    assert_equal(["uno"], hash[:one])
    assert_equal(["dos"], hash[:two])

    # By passing a block as a parameter to a hash we are able to have
    # the hash execute special behaviours such as initializing an unknown
    # key with a default value.
    assert_equal([], hash[:three])
  end
end
