#!/usr/bin/env ruby

# run all the sample apps
# muquit@muquit.com Apr-26-2014 

require 'logger'

class RunSampleApps
  ME = File.basename($0)

  def initialize
    @logger = Logger.new(STDERR)
    @sleep_secs = 5
  end

  def log(msg)
    @logger.info "#{msg}"
  end

  trap('INT') {
    puts "Interrupt caught.. exiting"
    exit 1
  }
  
  def check_args
    if ARGV.length != 1
      puts <<EOF
  Usage: #{ME} <sleep in secs>
  Specify the number of seconds to sleep between apps
  Example: #{ME} 5
EOF
    exit 1
    end
    @sleep_secs = 5
  end

  def doit
#    check_args
    pwd = Dir.pwd
    entries = Dir.entries(pwd)
    entries.each do |prog|
      next if prog == '.' || prog == '..' || prog =~ /run_all.rb/
      cmd = ""
      cmd << "ruby ./#{prog}"
      system(cmd)
    end
  end
end

if __FILE__ == $0
  RunSampleApps.new.doit
end
