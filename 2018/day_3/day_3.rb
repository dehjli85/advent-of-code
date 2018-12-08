require_relative '../common/file_helpers'
FILE_LOCATION = "#{File.dirname(__FILE__)}/input.txt"

CLAIM_STRINGS = [
  '#1 @ 1,3: 4x4',
  '#2 @ 3,1: 4x4',
  '#3 @ 5,5: 2x2'
];

def claim_overlap_count
  total_overlap_count = 0

  iterate_through_coordinates do |w, h, claims|
    overlap_count = 0
    claims.each do |claim|
      overlap_count += 1 if coorderinate_within_claim(w, h, claim)
      break if overlap_count == 2
    end
    total_overlap_count += 1 if overlap_count == 2
  end
  total_overlap_count
end

def non_overlapping_claim
  claim_strings = FileHelpers.read_file(FILE_LOCATION)
  claims = claim_strings.map { |string| parse_claim(string) }
  overlap_coordinates = get_overlap_coordinates
  puts get_overlap_coordinates.join(",")

  claims.each do |claim|
    contains_overlap_coordinate = false
    overlap_coordinates.each do |coord|
      contains_overlap_coordinate = true if coorderinate_within_claim(coord[:x], coord[:y], claim)
      break if contains_overlap_coordinate
    end
    if contains_overlap_coordinate
      next
    else
      return claim
    end
  end
end

def get_overlap_coordinates
  overlap_coordinates = []
  iterate_through_coordinates do |w, h, claims|
    overlap_count = 0
    claims.each do |claim|
      overlap_count += 1 if coorderinate_within_claim(w, h, claim)
      break if overlap_count == 2
    end
    overlap_coordinates << { x: w, y: h } if overlap_count == 2
  end
  overlap_coordinates
end

def iterate_through_coordinates
  claim_strings = FileHelpers.read_file(FILE_LOCATION)

  puts "Total Claims: #{claim_strings.length}"
  claims = claim_strings.map { |string| parse_claim(string) }

  puts "Claims Max Width: #{max_width(claims)}"
  puts "Claims Max Height: #{max_height(claims)}"

  (0..max_width(claims)).each do |w|
    (0..max_height(claims)).each do |h|
      yield(w, h, claims)
    end
  end
end

# Input example: '#1 @ 1,3: 4x4'
# Output example: { id: '#1', top: 1, left: 3, width: 4, height: 4 }
def parse_claim(string)
  parts = string.split(' ')
  { id: parts.first }.merge(parse_coordinates(parts[2]))
                     .merge(parse_area(parts[3]))
end

# Input example: '1,3'
# Output example: { top: 1, left: 3 }
def parse_coordinates(coord_string)
  coords = coord_string.split(/,|:/)
  { top: Integer(coords[1]), left: Integer(coords[0]) }
end

# Input example: '4x4'
# Output example: { width: 4, height: 4}
def parse_area(area_string)
  area = area_string.split('x')
  { width: Integer(area[0]), height: Integer(area[1]) }
end

# Input example: (1, 3, { id: '#1', top: 3, left: 1, width: 4, height: 4 })
# Output example: false
#
# Input example: (1, 3, { id: '#2', top: 1, left: 3, width: 4, height: 4 })
# Output example: true
def coorderinate_within_claim(x, y, claim)
  left = claim[:left]
  right = claim[:left] + claim[:width] - 1
  top = claim[:top]
  bottom = claim[:top] + claim[:height] -1
  return (x >= left && x <= right) && (y >= top && y <= bottom)
end

def max_width(claims)
  max = claims[0][:left] + claims[0][:width]
  claims.each do |claim|
    right = claim[:left] + claim[:width]
    max = right if right > max
  end
  max
end

def max_height(claims)
  max = claims[0][:top] + claims[0][:height]
  claims.each do |claim|
    right = claim[:top] + claim[:height]
    max = right if right > max
  end
  max
end

puts "Total Overlap Count: #{claim_overlap_count}"
puts "Non-overlapping claim: #{non_overlapping_claim}"
