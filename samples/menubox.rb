#!/usr/bin/env ruby

# muquit@muquit.com Apr-01-2014 
require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')
begin
  ME = File.basename($0)
  dialog = MRDialog.new
  dialog.logger = Logger.new(ENV["HOME"] + "/dialog_" + ME + ".log")
  dialog.clear = true
  dialog.title = "MENU BOX"

  text = <<EOF
This example is taken from dialog/samples/menubox1

Hi, this is a menu box. You can use this to
present a list of choices for the user to
choose. If there are more items than can fit
on the screen, the menu will be scrolled.
You can use the UP/DOWN arrow keys, the first
letter of the choice as a hot key, or the
number keys 1-9 to choose an option.
Try it now!

Choose the OS you like:

EOF
  items = []
  menu_data = Struct.new(:tag, :item)
  data = menu_data.new
  data.tag = "Linux"
  data.item = "The Great Unix Clone for 386/486"
  items.push(data.to_a)

  data = menu_data.new
  data.tag = "NetBSD"
  data.item = "Another free Unix Clone for 386/486"
  items.push(data.to_a)

  data = menu_data.new
  data.tag = "OS/2"
  data.item = "IBM OS/2"
  items.push(data.to_a)

  data = menu_data.new
  data.tag = "WIN NT" 
  data.item = "Microsoft Windows NT"
  items.push(data.to_a)

  data = menu_data.new
  data.tag = "PCDOS"
  data.item = "IBM PC DOS"
  items.push(data.to_a)

  data = menu_data.new
  data.tag = "MSDOS"  
  data.item = "Microsoft DOS"
  items.push(data.to_a)


  height = 0
  width = 0
  menu_height = 4
  
  selected_item = dialog.menu(text, items, height, width, menu_height)

  puts "Selected item: #{selected_item}"

rescue => e
  puts "#{$!}"
  t = e.backtrace.join("\n\t")
  puts "Error: #{t}"
end
