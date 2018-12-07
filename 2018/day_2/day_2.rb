require_relative '../common/file_helpers'
FILE_LOCATION = "#{File.dirname(__FILE__)}/input.txt"

def input_file_checksum
  values = FileHelpers.read_file(FILE_LOCATION)

  twos_count = 0
  threes_count = 0

  values.each do |string|
    twos_count += 1 if has_same_letters?(string, 2)
    threes_count += 1 if has_same_letters?(string, 3)
  end

  twos_count * threes_count
end

def has_same_letters?(value, count)
  char_array = value.split('')

  letter_hash = {}
  char_array.each do |letter|
    letter_hash[letter] = (letter_hash[letter] || 0) + 1
  end

  letter_hash.values.include?(count)
end

def differ_by_one?(s1, s2)
  a1 = s1.split('')
  a2 = s2.split('')
  difference_count = 0

  a1.each_with_index do |letter, idx|
    difference_count += 1 if letter != a2[idx]
    break if difference_count == 2
  end

  difference_count < 2
end

def matching_boxes
  values = FileHelpers.read_file(FILE_LOCATION)

  b1 = nil
  b2 = nil
  values.each_with_index do |s1, idx|
    (idx+1..values.length-1).each do |idx2|
      s2 = values[idx2]
      if differ_by_one?(s1, s2)
        b1 = s1
        b2 = s2
        break
      end
    end
  end

  [b1, b2]
end

def matching_letters(s1, s2)
  a1 = s1.split('')
  a2 = s2.split('')
  matching_letters = []

  a1.each_with_index do |letter, idx|
    matching_letters << letter if letter == a2[idx]
  end
  matching_letters.join('')
end

puts "Checksum: #{input_file_checksum}"

(s1, s2) = matching_boxes
puts "Matching boxes:\n#{s1}#{s2}"
puts "Matching letters: #{matching_letters(s1,s2)}"
