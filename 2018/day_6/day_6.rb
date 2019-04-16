require_relative '../common/file_helpers'
require 'set'
require 'byebug'
FILE_LOCATION = "#{File.dirname(__FILE__)}/input.txt"

TEST_COORDS = [
  {x: 1, y: 1}, 
  {x: 1, y: 6}, 
  {x: 8, y: 3}, 
  {x: 3, y: 4}, 
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

def boundaries(coords)
    min_x = coords[0][:x]
    max_x = coords[0][:x]
    min_y = coords[0][:x]
    max_y = coords[0][:x]

    coords.each do |coord|
        min_x = min_x < coord[:x] ? min_x : coord[:x]
        min_y = min_y < coord[:y] ? min_y : coord[:y]
        max_x = max_x > coord[:x] ? max_x : coord[:x] 
        max_y = max_y > coord[:x] ? max_y : coord[:y]
    end

    { min_x: min_x, min_y: min_y, max_x: max_x, max_y: max_y }
end

def boundary_points(coords)
    mins_and_maxs = boundaries(coords)
    points = [] 
    coords.each_with_index do |coord, idx|
        if coord[:x] == mins_and_maxs[:min_x] || 
            coord[:x] == mins_and_maxs[:max_x] || 
            coord[:y] == mins_and_maxs[:min_y] || 
            coord[:y] == mins_and_maxs[:max_y] 
            points.push(idx)
        end
    end
    points
end

def get_areas(coords)
    bs = boundaries(coords)
    areas = {}
    (bs[:min_x]..bs[:max_x]).each do |x|
        (bs[:min_y]..bs[:max_y]).each do |y|
            i = get_closest_coordinate({ x: x, y: y }, coords)
            next if i.nil?
            areas[i] = (areas[i] || 0) + 1
        end
    end
    areas
end

def get_closest_coordinate(coord, coords)
    closest_set = Set.new([0])
    min_distance = manhattan_distance(coord, coords[0])
    coords.each_with_index do |c, idx|
        d = manhattan_distance(coord, c)
        if d < min_distance
            min_distance = d
            closest_set = Set.new([idx])
        elsif d == min_distance
            closest_set.add(idx)
        end
    end

    return nil if closest_set.length > 1
    closest_set.first
end

def get_max_area(areas, coords)
    boundary_set = Set.new(boundary_points(coords))
    max_area = 0
    areas.each do |key, value|
        if value > max_area && !boundary_set.include?(key)
            max_area = value
        end
    end
    max_area
end

areas = get_areas(read_input_file)
puts "Part I: #{get_max_area(areas, read_input_file)}"