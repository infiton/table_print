module TablePrint
  def self.print(obj)
    Table.new(obj).print
  end

  def self.print!(obj)
    Table.new(obj).print!
  end
end

require 'table_print/table'
require 'table_print/exceptions'
