ENV["WATCHR"] = "1"
system 'clear'

def growl(message)
  growlnotify = `which growlnotify`.chomp
  title = "Watchr Test Results"

  message.gsub!(/\e\[\d+m/, "")

  image = message.include?('fail: 0,  error: 0') ? "~/.watchr_images/passed.png" : "~/.watchr_images/failed.png"
  options = "-w -n Watchr --image '#{File.expand_path(image)}' -m '#{message}' '#{title}'"
  system %(#{growlnotify} #{options} &)
end

def run(cmd)
  puts(cmd)
  `#{cmd}`
end

def run_test_file(file)
  system('clear')
  result = run(%Q(ruby -I"lib:test" -rubygems #{file}))
  lines  = result.split("\n")
  msg    = lines[lines.count - 3].strip + "\n" + lines[lines.count - 2].strip

  growl msg rescue nil
  puts result
end

def run_all_tests
  system('clear')
  result = run "rake test"
  growl result.split("\n").last rescue nil
  puts result
end

def run_all_features
  system('clear')
  system("cucumber")
end

def related_test_files(path)
  Dir['test/**/*.rb'].select { |file| file =~ /#{File.basename(path).split(".").first}_test.rb/ }
end

def run_suite
  run_all_tests
  run_all_features
end

watch('test/test_helper\.rb') { run_all_tests }
watch('test/.*/.*_test\.rb') { |m| run_test_file(m[0]) }
watch('app/.*/.*\.rb') { |m| related_test_files(m[0]).map {|tf| run_test_file(tf) } }
watch('features/.*/.*\.feature') { run_all_features }

# Ctrl-\
Signal.trap 'QUIT' do
  puts " --- Running all tests ---\n\n"
  run_all_tests
end

@interrupted = false

# Ctrl-C
Signal.trap 'INT' do
  if @interrupted then
    @wants_to_quit = true
    abort("\n")
  else
    puts "Interrupt a second time to quit"
    @interrupted = true
    Kernel.sleep 1.5
    # raise Interrupt, nil # let the run loop catch it
    run_suite
  end
end
