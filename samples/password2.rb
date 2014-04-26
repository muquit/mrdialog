#!/usr/bin/env ruby

########################################################################
# Example of password. It takes in the init arg and also set
# insecure option to dialog
# muquit@muquit.com Apr-02-2014 
########################################################################
require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')
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
Hi, this is an password dialog box. You can use
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
  dialog.title = "Password box"
  dialog.insecure = true

  result = dialog.passwordbox(text, 0, 0, "stupid")

  puts "Result is: #{result}"

rescue => e
  puts "#{$!}"
  t = e.backtrace.join("\n\t")
  puts "Error: #{t}"
end
