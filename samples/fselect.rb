#!/usr/bin/env ruby

# muquit@muquit.com Apr-01-2014 
require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')
require 'pp'

begin
    ME = File.basename($0)
    text = <<EOF
Please set the time...
EOF


    dialog = MRDialog.new
    dialog.clear = true
    dialog.title = "Please choose a file"

    h = 14
    w = 48
    file_path = ENV["HOME"] + "/"
    file = dialog.fselect(file_path, h, w)

    puts "Result is: #{file}"

rescue => e
    puts "#{$!}"
    t = e.backtrace.join("\n\t")
    puts "Error: #{t}"
end
