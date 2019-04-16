require 'set'
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

# Get a Set of all jobs based on the dependencies and jobs list
def jobs_set
  jobs = read_input_file.map { |d| d[:job] }
  dependencies = read_input_file.map { |d| d[:dependency] }
  Set.new(jobs + dependencies)
end

# Creates a hash where the keys are the jobs, and the values are
# a Set with all the dependencies needed for each job
def dependency_hash
  dependencies = {}
  jobs_set.each { |j| dependencies[j] = Set.new }

  read_input_file.each do |d|
    job = d[:job]
    dependency = d[:dependency]

    dependency_set = dependencies[job]
    dependency_set.add(dependency)
  end
  dependencies
end

def clear_job(dependency_hash, job)
  dependency_hash.each do |_, dependencies|
    dependencies.delete(job)
  end
  dependency_hash
end

def get_next_job(dependency_hash)
  no_dependencies = dependency_hash.reduce([]) do |memo, (job, dependencies)|
    memo << job if dependencies.empty?
    memo
  end
  no_dependencies.sort.first
end

def get_job_order
  dependencies = dependency_hash
  order = ""
  until dependencies.empty?
    job = get_next_job(dependencies)
    clear_job(dependencies, job)
    dependencies.delete(job)
    order += job
  end
  order
end

puts "Part I: #{get_job_order}"