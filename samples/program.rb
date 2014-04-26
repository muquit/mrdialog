#!/usr/bin/env ruby

# Example for progressbox widget. It is similar to the 
# one comes with dialog source code.
# muquit@muquit.com Apr-02-2014 
require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')
begin
  ME = File.basename($0)
  if ENV['CHANGE_TITLE']
    if ME =~ /(.+)\.rb$/
      base = $1
      puts "\033]0;mrdialog - #{base}\007"
    end
  end

  text = "Hi, this is a gauge widget"

  height = 20
  width = 70
  percent = 0

  dialog = MRDialog.new
  dialog.logger = Logger.new(ENV["HOME"] + "/dialog_" + ME + ".log")
  dialog.clear = true
  dialog.title = "PROGRAMBOX"

  
  description="Description of progress:"
  dialog.programbox(description,height, width) do |f|
      la = `/bin/ls -l1`.split("\n")
      la.each do |l|
          f.puts l
          sleep 0.05
      end
  end
rescue => e
  puts "#{$!}"
  t = e.backtrace.join("\n\t")
  puts "Error: #{t}"
end
