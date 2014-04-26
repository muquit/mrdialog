#!/usr/bin/env ruby

# muquit@muquit.com Apr-20-2014 
require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')
require 'pp'

class PauseBox
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
    dialog = MRDialog.new
    dialog.shadow = false
    dialog.logger = Logger.new(ENV["HOME"] + "/dialog_" + ME + ".log")
    dialog.clear = true
    dialog.title = "PAUSE BOX"

    secs = 20
    text = <<EOF
This is an example of pause box.

A  pause  box displays a meter along the bottom 
of the box. The meter indicates how many seconds
remain until the end of the pause. The pause exits
when timeout is reached or the user presses the 
OK button (status OK) or the user presses the 
Cancel button or Esc key.
EOF
    height = 15
    width = 0
    dialog.pause(text, height, width, secs)
    exit_code = dialog.exit_code
    puts "Exit code: #{exit_code}"
    case exit_code
      when 0
        puts "OK"
      when 1
        puts "Cancel button pressed"
      when 255
        puts "Error or ESC button pressed"
    end
  end
end

if __FILE__ == $0
  PauseBox.new.doit
end
