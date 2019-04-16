module Day7
  require 'set'
  require 'byebug'
  require_relative '../common/file_helpers'
  FILE_LOCATION = "#{File.dirname(__FILE__)}/input.txt"

  module_function 

  ORD_OFFSET = "A".ord

  @@worker_count = 5
  @@job_queue = {}
  @@dependencies = {}

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
  def reset_dependency_hash
    @@dependencies = {}
    jobs_set.each { |j| @@dependencies[j] = Set.new }

    read_input_file.each do |d|
      job = d[:job]
      dependency = d[:dependency]

      dependency_set = @@dependencies[job]
      dependency_set.add(dependency)
    end
  end

  def clear_job(job)
    @@dependencies.each do |_, dependencies|
      dependencies.delete(job)
    end
  end

  def get_next_job
    no_dependencies = @@dependencies.reduce([]) do |memo, (job, dependencies)|
      memo << job if dependencies.empty?
      memo
    end
    no_dependencies.sort.first
  end

  def get_job_order
    reset_dependency_hash
    order = ""
    until @@dependencies.empty?
      job = get_next_job
      clear_job(job)
      @@dependencies.delete(job)
      order += job
    end
    order
  end

  def job_finish_time(job)
    job.ord - ORD_OFFSET + 1 + 60
  end

  def start_job(job)
    @@job_queue[job] = job_finish_time(job)
    @@worker_count -= 1
  end

  def finish_job(job)
    @@job_queue.delete(job)
    @@worker_count += 1
    clear_job(job)
    @@dependencies.delete(job)
  end

  def get_next_job_to_work_on
    no_dependencies = @@dependencies.reduce([]) do |memo, (job, dependencies)|
      memo << job if dependencies.empty? && @@job_queue[job].nil?
      memo
    end
    no_dependencies.sort.first
  end

  def update_queue_completion_times
    @@job_queue.each do |job, time_to_completion|
      @@job_queue[job] = time_to_completion - 1
    end
  end

  def clear_finished_jobs
    @@job_queue.each do |job, time_to_completion|
      finish_job(job) if time_to_completion == 1
    end
  end

  def work_on_jobs
    reset_dependency_hash
    seconds = 0
    until @@dependencies.empty?
      # puts "#{seconds}: #{@@job_queue}"
      clear_finished_jobs
      update_queue_completion_times
      put_elves_to_work
      puts "#{seconds}: #{@@job_queue}"
      seconds += 1
    end
    seconds - 1
  end

  def put_elves_to_work
    while @@worker_count > 0
      job = get_next_job_to_work_on
      break if job.nil?
      start_job(job)
    end
  end
end

puts "Part I: #{Day7.get_job_order}"
puts "Part II: #{Day7.work_on_jobs}"
