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

  text = <<EOF
Hi, this is an input dialog box. You can use
this to ask questions that require the user
to input a string as the answer. You can
input strings of length longer than the
width of the input box, in that case, the
input field will be automatically scrolled.
You can use BACKSPACE to correct errors. 
Try entering your name below:

EOF
  dialog = MRDialog.new
  dialog.logger = Logger.new(ENV["HOME"] + "/dialog_" + ME + ".log")
  dialog.clear = true
  dialog.title = "INPUT BOX"
  dialog.extra_button = true
  dialog.ok_label = "Send"
  dialog.extra_label = "Save"
  dialog.cancel_label = "Quit"

  height = 16
  width = 51
  init = "blah"
  result = dialog.inputbox(text, height, width, init)

  puts "Exit Code: #{dialog.exit_code}"
  puts "Result is: #{result}"

rescue => e
  puts "#{$!}"
  t = e.backtrace.join("\n\t")
  puts "Error: #{t}"
end
