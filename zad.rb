class Record

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

  attr_accessor :fields, :type, :tag
end

class Records
  def initialize
    @records = []
    parse_entries(read).each do |record|
      @records << Record.new(*Record.parse_data(record))
    end
  end

  attr_accessor :records

  private
  def read
    text = ''
    File.open('test.bib', 'r').each_line {|l| text += l}.close
    text.gsub!(/{\noopsort{\d{4}\w}}/, '')
    text
  end

  def parse_entries(text)
    records = []
    text.scan(/@\w+{.*,\n[^@]*}/){|x| records << x}
    records
  end


end

# text.
r = Records.new
puts r.records[-3]
# puts r.ret_rec

# a = []
# text.scan(/@\w+{.*,\n[^@]*}/){|x| a << x}

# puts a.length
