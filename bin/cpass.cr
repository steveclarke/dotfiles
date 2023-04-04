#!/usr/bin/env ruby

letters = %w(b c d f g h j k l m n p q r s t v w x y z)
vowels = %w(a e i o u y)

5.times do
	password = "#{letters.sample.upcase}"
	password += vowels.sample

	password += password[/.$/] == "y" ? vowels.sample : letters.sample
	password += vowels.sample
	password += password[/.$/] == "y" ? vowels.sample : (rand(1..10) > 5 ? letters.sample : vowels.sample)

	# Numbers
	password += rand(10..99).to_s
	# 36-1295 is the range of 2 character Base36 numbers 10-ZZ
	password += rand(36..1295).to_s(36).upcase
	puts password
end
