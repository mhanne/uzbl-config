["s", "c", "j", "p"].each_with_index {|f,i|
  print "<span foreground='#{ARGV[i]=="1" ? 'green' : 'red'}'>#{f}</span> " }
