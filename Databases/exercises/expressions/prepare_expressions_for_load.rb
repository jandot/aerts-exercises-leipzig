#!/usr/bin/env ruby
probeset_counter = 0
File.open("RMAvalues0.05.txt").reject{|l| l =~ /^#/}.each do |line|
  probeset_counter += 1
  probeset, human1, human2, human3, human4, chimp1, chimp2, chimp3, chimp4 = line.chomp.split(/\t/)
  
  puts [probeset_counter, 1, human1].join(",")
  puts [probeset_counter, 2, human2].join(",")
  puts [probeset_counter, 3, human3].join(",")
  puts [probeset_counter, 4, human4].join(",")
  puts [probeset_counter, 5, chimp1].join(",")
  puts [probeset_counter, 6, chimp2].join(",")
  puts [probeset_counter, 7, chimp3].join(",")
  puts [probeset_counter, 8, chimp4].join(",")
end