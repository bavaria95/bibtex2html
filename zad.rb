class Record

  attr_reader :type
  def initialize(fields, type, tag)
    @fields = fields
    @type = type
    @tag = tag
  end

  def self.parse_data(text)
    fields = Hash.new
    entry_type, tag = '', ''
    text.scan(/@(\w+){(.*),/){|x, y| entry_type = x; tag = y}
    text.scan(/\s*(\w+)\s*=[{'" ](.+)[}'", ],?\s*/){|x, y| fields[x] = y}
    (fields.each_value {|value| value.gsub!(/"/, '')}).delete('key')
    return fields, entry_type, tag
  end

  def to_s
    html = <<-END
    <table border="1"><tbody>
        <tr>
          <td valign="top" colspan="2">#{@type}
          </td>
        </tr>
    END

    @fields.each_pair do |key, value|
        html += <<-END
        <tr>
          <td valign="top">#{key}<br />
          </td>
          <td valign="top">
        END

        if key == 'author' or key == 'editor'
          html += '<ul>'
          value.split(/ and /).each do |name|
            html += "<li>#{name}</li>"
          end
          html += '</ul>'
        else
          html += "#{value}"
        end

      html += <<-END
        </td>
        </tr>
      END
    end

    html += <<-END
        </table>
        <br>
    END
  end
end

class Records
  def initialize(argv)
    @argv = argv
    argv_processing
    check_file
    @records = []
    parse_entries(read).each do |record|
      @records << Record.new(*Record.parse_data(record))
    end
    make_order
    write
  end

  include Enumerable

  def each(&block)
    @records.each(&block)
  end

  def sort!(&block)
    @records.sort!(&block)
  end

  def sort(&block)
    @records.sort(&block)
  end

  def reverse!
    @records.reverse!
  end

  def reverse
    @records.reverse
  end

  def to_s
    html_all = ''
    @records.each do |record|
      html_all += record.to_s
    end
    html_all
  end


  private
  def read
    text = ''
    File.open(@file, 'r').each_line {|l| text += l}.close
    text.gsub!(/{\noopsort{\d{4}\w}}/, '')
    text
  end

  def parse_entries(text)
    records = []
    text.scan(/@\w+{.*,\n[^@]*}/){|x| records << x}
    records
  end

  def argv_processing
    until @argv[0].nil? do
      if @argv[0] == '-i' or @argv[0] == '--input'
        @argv.shift
        @file = @argv[0]
        @argv.shift
      end

      if @argv[0] == '-o' or @argv[0] == '--output'
        @argv.shift
        @file_output = @argv[0]
        @argv.shift
      end

      if @argv[0] == '-s' or @argv[0] == '--sort'
        @argv.shift
        @order = @argv[0]
        @argv.shift
        b = true
      end

      if @file.nil? or @file_output.nil?
        puts 'wrong command. should be: '
        puts "ruby #{$0} --input <path> --output <path> [--sort <order>]"
        exit
      end
    end
  end

  def check_file
    unless File.file?(@file)
      puts 'There is not such file'
      exit
    end
  end

  def make_order
    unless @order.nil?
      @records.sort!{|x, y| x.type.downcase <=> y.type.downcase}

      if @order.downcase == 'desc'
        @records.reverse!
      end
    end
  end

  def write
    file = File.open(@file_output, 'w')
    file.write(to_s)
    file.close
  end

end


r = Records.new(ARGV)
