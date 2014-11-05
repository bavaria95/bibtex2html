f = File.open('test.bib', 'r')
text = ''
f.each_line {|l| text += l}

text.gsub!(/{\noopsort{\d{4}\w}}/, '')

a = []
text.scan(/@\w+{.*,\n[^@]*}/){|x| a << x}

puts a.length
