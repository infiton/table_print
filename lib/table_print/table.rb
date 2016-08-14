module TablePrint
  class Table
    alias_method :rb_print, :print
    attr_reader :object

    MINIMAL_INTERFACE = %i{first map}
    NULL = " NULL "

    def initialize(obj)
      @object = obj
    end

    def print
      print!
    rescue NotPrintable
      nil
    end

    def print!
      raise NotPrintable, not_implemented_message unless implements_minimal_interface?
      rb_print table
    end

    def table
      @table ||= build_table
    end

    private

    def implements_minimal_interface?
      MINIMAL_INTERFACE.all? do |meth|
        object.respond_to?(meth)
      end
    end

    def not_implemented_message
      "The object #{object} does not implement the minimal interface to be table printed: #{MINIMAL_INTERFACE.join(', ')}"
    end

    def build_table
      begin      
        fill_line + rows.map {|row| table_form % row}.join(fill_line) + fill_line
      rescue ArgumentError
        raise NotPrintable, "Cannot print table that is not rectangular, ensure all rows are of equal size."
      end
    end

    def table_form
      "|" + widths.map{ |l| "%-#{l}s" }.join('|') + "|\n"
    end

    def fill_line
      @fill_line ||= "+" + widths.map{ |l| "-"*l }.join('+') + "+\n"
    end

    def has_header?
      object.first.respond_to?(:keys)
    end

    def header
      @header ||= build_header
    end

    def build_header
      if object.first.respond_to?(:keys)
        object.first.keys.map {|k| line_format(k)}
      else
        []
      end
    end

    def rows
      @rows ||= build_rows
    end

    def build_rows
      if has_header?
        [header] + object.map{|x| lines(x)}
      else
        object.map{|x| lines(x)}
      end
    end

    def lines(x)
      values = x.respond_to?(:values) ? x.values : x
      begin
        values.map do |v|
          line_format(v)
        end
      rescue NoMethodError
        raise NotPrintable, "Expected every row in the table to be enumerable, however #{x} isn't"
      end
    end

    def line_format(v)
      v.nil? ? NULL : " #{v} "
    end

    def width
      return 0 unless rows.any?
      rows.first.count
    end

    def widths
      @widths ||= calculate_widths
    end

    def calculate_widths
      _widths = Array.new(width) { 0 }

      rows.each do |row|
        row.each_with_index do |val, idx|
          len = val.length
          _widths[idx] = len if len > _widths[idx]
        end
      end

      _widths
    end
  end
end
