#!/usr/bin/env ruby

# muquit@muquit.com Apr-01-2014 
require [File.expand_path(File.dirname(__FILE__)), '../..', 'lib', 'mrdialog'].join('/')
require 'pp'

begin
    ME = File.basename($0)
    if ENV['CHANGE_TITLE']
      if ME =~ /(.+)\.rb$/
        base = $1
        puts "\033]0;mrdialog - #{base}\007"
      end
    end

    dialog = MRDialog.new
    dialog.clear = true
    dialog.title = "Please choose a file"
    dialog.extra_button = true
    dialog.ok_label = "Copy"
    dialog.extra_label = "Delete"
    dialog.cancel_label = "Quit"

    h = 14
    w = 48
    file_path = ENV["HOME"] + "/"
    file = dialog.fselect(file_path, h, w)

    puts "Exit code: #{dialog.exit_code}"
    puts "Result is: #{file}"

rescue => e
    puts "#{$!}"
    t = e.backtrace.join("\n\t")
    puts "Error: #{t}"
end
