module Day8
  require 'byebug'
  require_relative '../common/file_helpers'
  FILE_LOCATION = "#{File.dirname(__FILE__)}/input.txt"
  TEST_INPUT = '2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2'

  class Node 
    attr_accessor :original_string, :children, :metadata, :string_remainder
    
    def initialize(string)
      @original_string = string
      @children = [] # array of other Nodes
      @metadata = [] # array of integers
      parse_header
      parse_body
    end

    def parse_header
      numbers = @original_string.split(' ')
      @children_count = Integer(numbers[0])
      @metadata_count = Integer(numbers[1])
    end

    def parse_body
      numbers = @original_string.split(' ')
      string = numbers[2..-1].join(' ')

      @children_count.times do |i| 
        string = parse_child(string)
      end
      
      @metadata = string.split(' ')[0..(@metadata_count-1)].map { |i| Integer(i)}
      @string_remainder = string.split(' ')[(@metadata_count)..-1].join(' ')
      @string_remainder
    end

    # parses the string by adding the next node to the @children instance variable
    # and returning the remaining string
    def parse_child(string)
      child_node = Node.new(string)
      @children << child_node
      child_node.string_remainder
    end

    def metadata_sum
      @metadata.sum + @children.reduce(0) do |memo, node|
        memo + node.metadata_sum
      end
    end

    def value
      return @metadata.sum if @children_count == 0

      @metadata.reduce(0) do |memo, idx|
        node = children[idx - 1]
        memo += node.nil? ? 0 : node.value
      end
    end
  end
  
  module_function

  def test_node
    Node.new(TEST_INPUT)
  end

  def read_input_file
    FileHelpers.read_file(FILE_LOCATION)[0]
  end

  def build_node
    Node.new(read_input_file)
  end
end

puts "Part I: #{Day8.build_node.metadata_sum}"
puts "Part II: #{Day8.build_node.value}"
