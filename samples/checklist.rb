#!/usr/bin/env ruby

require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')
require 'pp'

begin
    ME = File.basename($0)
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
    checklist_data = Struct.new(:tag, :item, :select)

    data = checklist_data.new
    data.tag = "Apple"
    data.item = "It's an applie"
    data.select = false
    items.push(data.to_a)

    data = checklist_data.new
    data.tag = "Dog"
    data.item = "No it's not my dog"
    data.select = true
    items.push(data.to_a)

    data = checklist_data.new
    data.tag = "Orange"
    data.item = "Yeah! it is juicy"
    data.select = false
    items.push(data.to_a)

    data = checklist_data.new
    data.tag = "Chicken"
    data.item = "Normally not a pet"
    data.select = true
    items.push(data.to_a)

    dialog = MRDialog.new
    dialog.clear = true
    dialog.logger = Logger.new(ENV["HOME"] + "/dialog_" + ME + ".log")

    selected_items = dialog.checklist(text, items)
    exit_code = dialog.exit_code
    puts selected_items.class
    puts "Exit code: #{exit_code}"
    puts "Selected Items:"
    selected_items.each do |item|
      puts "  '#{item}'"
    end

rescue => e
    puts "#{$!}"
    t = e.backtrace.join("\n\t")
    puts "Error: #{t}"
end
