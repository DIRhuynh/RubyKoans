require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutSandwichCode < EdgeCase::Koan

  def count_lines(file_name)
    file = open(file_name)
    count = 0
    # After the last line, File#gets will return nil and thus
    # it will evaluate to false.
    while line = file.gets
      count += 1
    end
    count
  # This is probably one of the cleanest way to close a file that
  # I have ever seen. Using ensure makes it certain that a code is
  # executed and it makes it obvious to future programmers.
  #
  # Code in the ensure section are always run before the a return but
  # the magic is that the ensure section can be put at the bottom so the
  # code is more clean to read.
  ensure
    file.close if file
  end

  def test_counting_lines
    assert_equal(4, count_lines("example_file.txt"))
  end

  # ------------------------------------------------------------------

  def find_line(file_name)
    file = open(file_name)
    while line = file.gets
      return line if line.match(/e/) # <= Matches any line that has an "e".
    end
  ensure
    # Right before the line is returned, file is close. If you couldn't tell
    # I really like the ensure mechanism.
    file.close if file
  end

  def test_finding_lines
    # File#gets also extracts the new line.
    assert_equal("test\n", find_line("example_file.txt"))
  end

  # ------------------------------------------------------------------
  # THINK ABOUT IT:
  #
  # The count_lines and find_line are similar, and yet different.
  # They both follow the pattern of "sandwich code".
  #
  # Sandwich code is code that comes in three parts: (1) the top slice
  # of bread, (2) the meat, and (3) the bottom slice of bread.  The
  # bread part of the sandwich almost always goes together, but
  # the meat part changes all the time.
  #
  # Because the changing part of the sandwich code is in the middle,
  # abstracting the top and bottom bread slices to a library can be
  # difficult in many languages.
  #
  # (Aside for C++ programmers: The idiom of capturing allocated
  # pointers in a smart pointer constructor is an attempt to deal with
  # the problem of sandwich code for resource allocation.)
  #
  # Consider the following code:
  #

  def file_sandwich(file_name)
    file = open(file_name) # <= Top slice of bread.
    yield(file)            # <= Meat is passed a block to the #file_sandwich.
  ensure                   # <= Bottom slice of bread.
    file.close if file
  end

  # Now we write:

  def count_lines2(file_name)
    file_sandwich(file_name) do |file|
      count = 0
      while line = file.gets
        count += 1
      end
      count
    end
  end

  def test_counting_lines2
    assert_equal(4, count_lines2("example_file.txt"))
  end

  # ------------------------------------------------------------------

  def find_line2(file_name)
    line_checker = proc do |file|
      while line =  file.gets
        return line if line.match(/e/)
      end
    end

    # I need to prefix block variables with ampersand(&)
    file_sandwich(file_name, &line_checker)
  end

  def test_finding_lines2
    assert_equal("test\n", find_line2("example_file.txt"))
  end

  # ------------------------------------------------------------------

  def count_lines3(file_name)
    open(file_name) do |file|
      count = 0
      while line = file.gets
        count += 1
      end
      count
    end
  end

  def test_open_handles_the_file_sandwich_when_given_a_block
    # Why yes, yes it does handle the file sandwich.
    # This must be a design pattern. The open/filler/close.
    assert_equal(4, count_lines3("example_file.txt"))
  end

end
