FILE_LOCATION = "#{File.dirname(__FILE__)}/input.txt"

def read_file(file)
  text = File.open(file).read
  values = []
  text.each_line do |line|
    values.push(Integer(line))
  end
  values
end

def get_end_frequency_from_file
  frequency_changes = read_file(FILE_LOCATION)
  current_value = 0
  frequency_changes.each do |delta|
    current_value += delta
  end
  current_value
end

def get_first_duplicate_frequency
  frequency_changes = read_file(FILE_LOCATION)
  changes_count = frequency_changes.length
  current_value = 0
  values = { 0 => 1 }

  count = 0
  while (values[current_value] || 0) < 2
    frequency_change = frequency_changes[count % changes_count]
    current_value += frequency_change
    values[current_value] = (values[current_value] || 0) + 1
    count += 1
  end
  current_value
end

puts "End Of Input Frequency: #{get_end_frequency_from_file}"
puts "First Duplicate Frequency: #{get_first_duplicate_frequency}"
