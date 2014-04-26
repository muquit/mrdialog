#!/usr/bin/env ruby

########################################################################
# Example for calendar widget. 
# muquit@muquit.com Apr-02-2014 
########################################################################
#
require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')
require 'date'

begin
    ME = File.basename($0)
    if ENV['CHANGE_TITLE']
      if ME =~ /(.+)\.rb$/
        base = $1
        puts "\033]0;mrdialog - #{base}\007"
      end
    end

    text = "Please choose a date..."

    height = 0
    width = 0
    day = Date.today.mday
    month =Date.today.mon
    year =Date.today.year

    dialog = MRDialog.new
    dialog.logger = Logger.new(ENV["HOME"] + "/dialog_" + ME + ".log")
    dialog.clear = true
    dialog.title = "CALENDAR"

    date = dialog.calendar(text, height, width, day, month, year)
    puts "Result is: #{date.to_s}"

rescue => e
    puts "#{$!}"
    t = e.backtrace.join("\n\t")
    puts "Error: #{t}"
end
