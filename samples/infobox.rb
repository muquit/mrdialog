#!/usr/bin/env ruby

# muquit@muquit.com Apr-20-2014 
require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')
require 'pp'

class TestInfobox
  ME = File.basename($0)    
  def initialize
  end

  def doit
    dialog = MRDialog.new
    dialog.logger = Logger.new(ENV["HOME"] + "/dialog_" + ME + ".log")
    dialog.clear = true
    dialog.title = "INFOBOX"

    text = <<EOF
Hi, this is an information box. It is
different from a message box: it will
not pause waiting for input after displaying
the message. The pause here is only introduced
by the sleep command within dialog.

You have 10 seconds to read this...

EOF
    dialog.sleep = 10
    result = dialog.infobox(text, 10, 52)
    puts "result: #{result}"
  end
end

if __FILE__ == $0
  TestInfobox.new.doit
end
