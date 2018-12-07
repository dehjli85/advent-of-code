module FileHelpers
  module_function

  def read_file(file)
    text = File.open(file).read
    values = []
    text.each_line do |line|
      values << line
    end
    values
  end
end