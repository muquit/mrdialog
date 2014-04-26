#!/usr/bin/env ruby

# muquit@muquit.com Apr-01-2014 
require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')
require 'pp'

class TestRadiolist
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
    dialog.clear = true
    dialog.logger = Logger.new(ENV["HOME"] + "/dialog_" + ME + ".log")

  text = <<EOF
This example is taken from dialog/samples/radiolist
shell script.

Hi, this is a radiolist box. You can use this to
present a list of choices which can be turned on or
off. If there are more items than can fit on the
screen, the list will be scrolled. You can use the
UP/DOWN arrow keys, the first letter of the choice as a
hot key, or the number keys 1-9 to choose an option.
Press SPACE to toggle an option on/off.

  Which of the following are fruits?

EOF
      items = []
      radiolist_data = Struct.new(:tag, :item, :select)

      data = radiolist_data.new
      data.tag = "Apple"
      data.item = "It's an applie"
      data.select = false
      items.push(data.to_a)

      data = radiolist_data.new
      data.tag = "Dog"
      data.item = "No it's not my dog"
      data.select = true
      items.push(data.to_a)

      data = radiolist_data.new
      data.tag = "Orange"
      data.item = "Yeah! it is juicy"
      data.select = false
      items.push(data.to_a)

      dialog.title = "RADIOLIST"
      selected_item = dialog.radiolist(text, items)
      exit_code = dialog.exit_code
      case exit_code
      when dialog.dialog_ok
          puts "OK Pressed"
      when dialog.dialog_cancel
          puts "Cancel Pressed"
      when dialog.dialog_esc
          puts "Escape Pressed"
      end

      puts "Selected item: #{selected_item}"
  end
end

if __FILE__ == $0
  TestRadiolist.new.doit
end

