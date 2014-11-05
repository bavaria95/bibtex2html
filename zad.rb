text = <<END
@BOOK{whole-collection,
   editor = "David J. Lipcoll and D. H. Lawrie and A. H. Sameh",
   title = "High Speed Computer and Algorithm Organization",
   booktitle = "High Speed Computer and Algorithm Organization",
   number = 23,
   series = "Fast Computers",
   publisher = "Academic Press",
   address = "New York",
   edition = "Third",
   month = sep,
   year = 1977,
   note = "This is a cross-referenced BOOK (collection) entry",
}

@MANUAL{manual-minimal,
   key = "Manmaker",
   title = "The Definitive Computer Manual",
}

@MANUAL{manual-full,
   author = "Larry Manmaker",
   title = "The Definitive Computer Manual",
   organization = "Chips-R-Us",
   address = "Silicon Valley",
   edition = "Silver",
   month = apr # "-" # may,
   year = 1986,
   note = "This is a full MANUAL entry",
}

@MASTERSTHESIS{mastersthesis-minimal,
   author = "{\'{E}}douard Masterly",
   title = "Mastering Thesis Writing",
   school = "Stanford University",
   year = 1988,
}

@MASTERSTHESIS{mastersthesis-full,
   author = "{\'{E}}douard Masterly",
   title = "Mastering Thesis Writing",
   school = "Stanford University",
   type = "Master's project",
   address = "English Department",
   month = jun # "-" # aug,
   year = 1988,
   note = "This is a full MASTERSTHESIS entry",
}

@MISC{misc-minimal,
   key = "Missilany",
   note = "This is a minimal MISC entry",
}

@MISC{misc-full,
   author = "Joe-Bob Missilany",
   title = "Handing out random pamphlets in airports",
   howpublished = "Handed out at O'Hare",
   month = oct,
   year = 1984,
   note = "This is a full MISC entry",
}
END


text.gsub!(/{\noopsort{\d{4}\w}}/, '')

a = []
text.scan(/@\w+{.*,\n[^@]*}/)#{|x| a << x}
puts a[0]
# puts a[6]
