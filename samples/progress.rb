#!/usr/bin/env ruby

# Example for progressbox widget. It is similar to the 
# one comes with dialog source code.
# muquit@muquit.com Apr-02-2014 
require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')
begin
  ME = File.basename($0)
  text = "Hi, this is a gauge widget"

  height = 20
  width = 70
  percent = 0

  dialog = MRDialog.new
  dialog.logger = Logger.new(ENV["HOME"] + "/dialog_" + ME + ".log")
  dialog.clear = true
  dialog.title = "PROGRESSBOX"

  
  description="Description of progress:"
  dialog.progressbox(description,height, width) do |f|
      la = `/bin/ls -l1`.split("\n")
      la.each do |l|
          f.puts l
          sleep 1
      end
  end
rescue => e
  t = e.backtrace.join("\n")
  puts "Error: #{t}"
end
