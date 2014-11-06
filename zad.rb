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
  def initialize(file, file_output)
    @file = file
    @file_output = file_output
    @records = []
    parse_entries(read).each do |record|
      @records << Record.new(*Record.parse_data(record))
    end
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

  def write
    file = File.open(@file_output, 'w')
    file.write(to_s)
    file.close
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

end



until ARGV[0].nil? do
  if ARGV[0] == '-i' or ARGV[0] == '--input'
    ARGV.shift
    file = ARGV[0]
    ARGV.shift
  end

  if ARGV[0] == '-o' or ARGV[0] == '--output'
    ARGV.shift
    file_output = ARGV[0]
    ARGV.shift
  end

  if ARGV[0] == '-s' or ARGV[0] == '--sort'
    ARGV.shift
    order = ARGV[0]
    ARGV.shift
    b = true
  end

  if file.nil? or file_output.nil?
    puts 'wrong command. should be: '
    puts "ruby #{$0} --input <path> --output <path> [--sort <order>]"
    exit
  end
end


unless File.file?(file)
  puts 'There is not such file'
  exit
end


r = Records.new(file, file_output)

unless order.nil?
  r.sort!{|x, y| x.type.downcase <=> y.type.downcase}

  if order.downcase == 'desc'
    r.reverse!
  end
end

r.write
