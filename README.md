# Table Print
Print enumerable Ruby objects like MySQL tables.

## Installation
```
gem install table_print
```

## Quick Start

```
require 'table_print'

# array of arrays
TablePrint.print([
["Foo", "Bar", "Baz"],
["Long Foo", nil, "Even Longer Bar"]
])
+----------+------+-----------------+
| Foo      | Bar  | Baz             |
+----------+------+-----------------+
| Long Foo | NULL | Even Longer Bar |
+----------+------+-----------------+

# array of hashes gives headers
TablePrint.print([
{foo: "Foo", bar: "Bar", baz: "Baz"},
{foo: "Long Foo", bar: nil, baz: "Even Longer Bar"}
])
+----------+------+-----------------+
| foo      | bar  | baz             |
+----------+------+-----------------+
| Foo      | Bar  | Baz             |
+----------+------+-----------------+
| Long Foo | NULL | Even Longer Bar |
+----------+------+-----------------+

# print! will raise if the object is not printable
# print will just do nothing in this case

not_enumerable = 1
TablePrint.print(not_enumerable) #does nothing
TablePrint.print!(not_enumerable) #raises TablePrint::NotPrintable

values_not_enumberable = [1,2,3]
TablePrint.print(not_enumerable) #does nothing
TablePrint.print!(not_enumerable) #raises TablePrint::NotPrintable

not_rectangular = [[1,2], [1]]
TablePrint.print(not_enumerable) #does nothing
TablePrint.print!(not_enumerable) #raises TablePrint::NotPrintable
```

`TablePrint` doesn't require an array of arrays, or an array of hashes. If the toplevel object at least implements a minimal enumerable interface and the objects it contains do the same then it will be able to print them to a table.

If the contained objects respond to `keys` and `values` then the table will also have a header row.

