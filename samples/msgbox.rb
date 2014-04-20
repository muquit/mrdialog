#!/usr/bin/env ruby

# muquit@muquit.com Apr-01-2014 
require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')
require 'pp'

class TestMsgbox
  ME = File.basename($0)    
  def initialize
  end

  def doit
    dialog = MRDialog.new
    dialog.logger = Logger.new(ENV["HOME"] + "/dialog_" + ME + ".log")
    dialog.clear = true
    dialog.title = "MESSAGE BOX"

    text = <<EOF
Hi, this is a simple message box. You can use this to \
display any message you like. The box will remain until \
you press the ENTER key.

EOF
    result = dialog.msgbox(text, 10, 41)
    puts "result: #{result}"
  end
end

if __FILE__ == $0
  TestMsgbox.new.doit
end
