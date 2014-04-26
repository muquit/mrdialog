#!/usr/bin/env ruby

# muquit@muquit.com Apr-01-2014 
require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')
require 'pp'

class TestYesNo
  ME = File.basename($0)
  if ENV['CHANGE_TITLE']
    if ME =~ /(.+)\.rb$/
      base = $1
      puts "\033]0;mrdialog - #{base}\007"
    end
  end

  def initialize
  end

  def doit
    text = <<EOF
Hi, this is a yes/no dialog box. You can use this to ask 
questions that have an answer of either yes or no. 
BTW, do you notice that long lines will be automatically
wrapped around so that they can fit in the box? You can
also control line breaking explicitly by inserting
'backslash n' at any place you like, but in this case,
auto wrap around will be disabled and you will have to
control line breaking yourself.

EOF
    dialog = MRDialog.new
    dialog.logger = Logger.new(ENV["HOME"] + "/dialog_" + ME + ".log")
    dialog.clear = true
    dialog.title = "YES/NO BOX"
#        dialog.ascii_lines = true

    yesno = dialog.yesno(text,0, 0)

    puts "yesno: #{yesno}"

  end
end

if __FILE__ == $0
  TestYesNo.new.doit
end
