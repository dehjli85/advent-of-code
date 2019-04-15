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

def manhattan_distance(coord1, coord2)
  (coord1[:x] - coord2[:x]).abs + (coord1[:y] - coord2[:y]).abs
end

read_input_file.each { |coord| puts manhattan_distance(coord, {x: 0, y:5} )}