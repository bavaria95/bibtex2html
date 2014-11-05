class Record
  def initialize(fields, type, tag)
    @filds = fields
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

  end

end

class Records
  def initialize
    @records = []
    # read
    parse_entries(read).each do |record|
      @records << Record.new(*Record.parse_data(record))
    end
  end

  def ret_rec
    @records
  end

  private
  def read
    f = File.open('test.bib', 'r')
    text = ''
    f.each_line {|l| text += l}
    f.close
    text
  end

  def parse_entries(text)
    records = []
    text.scan(/@\w+{.*,\n[^@]*}/){|x| records << x}
    records
  end


end

# text.gsub!(/{\noopsort{\d{4}\w}}/, '')
r = Records.new
puts r.ret_rec

# a = []
# text.scan(/@\w+{.*,\n[^@]*}/){|x| a << x}

# puts a.length
