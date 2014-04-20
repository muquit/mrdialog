#!/usr/bin/env ruby

# Example for gauge widget. It is similar to the 
# one comes with dialog source code.
# muquit@muquit.com Apr-02-2014 
require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')

class TestGauge
  ME = File.basename($0)    
  def initialize
  end

  def doit
    text = "Hi, this is a gauge widget"

    height = 20
    width = 70
    percent = 0

    dialog = MRDialog.new
    dialog.logger = Logger.new(ENV["HOME"] + "/dialog_" + ME + ".log")
    dialog.clear = true
    dialog.title = "GAUGE"

    dialog.gauge(text, height, width, percent) do |f|
        1.upto(100) do |a|
            f.puts "XXX"
            f.puts a
            f.puts "The new\nmessage (#{a} percent)"
            f.puts "XXX"
            sleep 0.05
        end
    end
  end
end

if __FILE__ == $0
    TestGauge.new.doit
end
