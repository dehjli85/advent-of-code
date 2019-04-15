require_relative '../common/file_helpers'
FILE_LOCATION = "#{File.dirname(__FILE__)}/input.txt"

TEST_COORDS = [
  {x: 1, y: 1}, 
  {x: 1, y: 6}, 
  {x: 8, y: 3}, 
  {x: 5, y: 5}, 
  {x: 8, y: 9}
];

def read_input_file
  coords = FileHelpers.read_file(FILE_LOCATION)
  coords.map { |string| parse_coords(string) }
end

def parse_coords(string)
  parts = string.split(', ')
  { x: Integer(parts[0]), y: Integer(parts[1]) }
end

puts read_input_file