#!/usr/bin/env ruby
File.open('genotypes.vcf').each do |line|
  chr, pos, one, two, three, four, five, six = line.chomp.split(/\t/)
  r = rand
  if r < 0.1
    if rand < 0.5
      one.sub!(/./,'*')
    else
      one.sub!(/.$/,'*')
    end
  elsif r < 0.3
    if rand < 0.5
      two.sub!(/./,'*')
    else
      two.sub!(/.$/,'*')
    end
  elsif r < 0.4
    if rand < 0.5
      three.sub!(/./,'*')
    else
      three.sub!(/.$/,'*')
    end
  elsif r < 0.6
    if rand < 0.5
      four.sub!(/./,'*')
    else
      four.sub!(/.$/,'*')
    end
  elsif r < 0.8
    if rand < 0.5
      five.sub!(/./,'*')
    else
      five.sub!(/.$/,'*')
    end
  else
    if rand < 0.5
      six.sub!(/./,'*')
    else
      six.sub!(/.$/,'*')
    end
  end
  puts [chr, pos, one, two, three, four, five, six].join("\t")
end