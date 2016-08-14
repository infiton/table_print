require_relative 'helper'

class ArrayLike
  include Enumerable

  def initialize(ary)
    @ary = ary
  end

  def each
    @ary.each do |x|
      yield x
    end
  end
end

class HashLike
  attr_reader :foo, :bar

  def initialize(foo, bar)
    @foo = foo
    @bar = bar
  end

  def keys
    [:foo, :bar]
  end

  def values
    [foo, bar]
  end
end

class TestTable < Minitest::Test
  def test_valid_arrays
    arrays = [
      [342, "this is a longer string", :symbol],
      ["hi there", 1, "the"]
    ]

    table = TablePrint::Table.new(arrays)

    assert_equal table.table, """\
+----------+-------------------------+--------+
| 342      | this is a longer string | symbol |
+----------+-------------------------+--------+
| hi there | 1                       | the    |
+----------+-------------------------+--------+
"""
  end

  def test_valid_hashes
    hashes = [
      {first_name: "Foo", last_name: "Bar"},
      {first_name: "Baz", last_name: "Longlonglong last name"}
    ]

    table = TablePrint::Table.new(hashes)

    assert_equal table.table, """\
+------------+------------------------+
| first_name | last_name              |
+------------+------------------------+
| Foo        | Bar                    |
+------------+------------------------+
| Baz        | Longlonglong last name |
+------------+------------------------+
"""
  end

  def test_enumerable_array_like
    array_like = ArrayLike.new([
      [342, "this is a longer string", :symbol],
      ["hi there", 1, "the"]
    ])

    table = TablePrint::Table.new(array_like)

    assert_equal table.table, """\
+----------+-------------------------+--------+
| 342      | this is a longer string | symbol |
+----------+-------------------------+--------+
| hi there | 1                       | the    |
+----------+-------------------------+--------+
"""
  end

  def test_enumerable_hash_like
    hash_like = ArrayLike.new([
      HashLike.new("Foo", "Bar"),
      HashLike.new("LongerFoo","B"),
      HashLike.new(nil, "This Is Longer")
    ])

    table = TablePrint::Table.new(hash_like)

    assert_equal table.table, """\
+-----------+----------------+
| foo       | bar            |
+-----------+----------------+
| Foo       | Bar            |
+-----------+----------------+
| LongerFoo | B              |
+-----------+----------------+
| NULL      | This Is Longer |
+-----------+----------------+
"""
  end

  def test_non_enumerable
    not_enumerable = 1

    table = TablePrint::Table.new(not_enumerable)

    assert_raises(TablePrint::NotPrintable) { table.print! }
  end

  def test_not_rectangular
    non_rectangular = [[1,2,3], [4,3]]

    table = TablePrint::Table.new(non_rectangular)

    assert_raises(TablePrint::NotPrintable) { table.print! }
  end

  def test_values_not_enumberable
    values_not_enumerable = [1,2,3,4,5]

    table = TablePrint::Table.new(values_not_enumerable)

    assert_raises(TablePrint::NotPrintable) { table.print! }
  end
end
