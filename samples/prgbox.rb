#!/usr/bin/env ruby

# muquit@muquit.com Apr-01-2014 
require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')
require 'pp'

class TestPrgBox1
  ME = File.basename($0)    

  def initialize
    if ENV['CHANGE_TITLE']
      if ME =~ /(.+)\.rb$/
        base = $1
        puts "\033]0;mrdialog - #{base}\007"
      end
    end
  end

  def doit
    dialog = MRDialog.new
    dialog.logger = Logger.new(ENV["HOME"] + "/dialog_" + ME + ".log")
    dialog.clear = true
    dialog.title = "PRGBOX"

    path = File.expand_path(File.dirname(__FILE__))
    command = path + "/shortlist"
    height = 20
    width = 70
    dialog.prgbox(command, height, width)


    text = "Hi, this is prgbox text"
    command = path + "/shortlist 2"
    dialog.prgbox(command, height, width, text)

  end
end

if __FILE__ == $0
  TestPrgBox1.new.doit
end
