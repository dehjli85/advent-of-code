require_relative '../common/file_helpers'
FILE_LOCATION = "#{File.dirname(__FILE__)}/input.txt"

def read_input_file
  coords = FileHelpers.read_file(FILE_LOCATION)
  coords.map { |string| parse_instructions(string) }
end

def parse_instructions(string)
  string = string.sub("Step ", "")
  string = string.sub(" must be finished before step ", ",")
  string = string.sub(" can begin.\n", "")
  parts = string.split(",")
  { job: parts[1], dependency: parts[0] }
end
