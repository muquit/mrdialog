#!/usr/bin/env ruby

require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')
require 'pp'

begin
    ME = File.basename($0)
    if ENV['CHANGE_TITLE']
      if ME =~ /(.+)\.rb$/
        base = $1
        puts "\033]0;mrdialog - #{base}\007"
      end
    end
    text = <<EOF
This example is taken from dialog/samples/menulist
shell script.

Hi, this is a buildlist dialog. The list on the left
shows the unselected items. The list on the right shows
the selected  items.  Use SPACE bar to select/unselect 
items. Shadow is set to false.

EOF
    items = []
    Struct.new("BuildListData", :tag, :item, :status)
    data = Struct::BuildListData.new

    data.tag = "1"
    data.item = "Item number 1"
    data.status = true
    items.push(data.to_a)

    data = Struct::BuildListData.new
    data.tag = "2"
    data.item = "Item number 2"
    data.status = false
    items.push(data.to_a)

    data = Struct::BuildListData.new
    data.tag = "3"
    data.item = "Item number 3"
    data.status = false
    items.push(data.to_a)

    data = Struct::BuildListData.new
    data.tag = "4"
    data.item = "Item number 4"
    data.status = true
    items.push(data.to_a)

    data = Struct::BuildListData.new
    data.tag = "5"
    data.item = "Item number 5"
    data.status = false
    items.push(data.to_a)

    data = Struct::BuildListData.new
    data.tag = "6"
    data.item = "Item number 6"
    data.status = true
    items.push(data.to_a)

    dialog = MRDialog.new
    dialog.clear = true
    dialog.shadow = false
    dialog.title = "BUILDLIST"
    dialog.logger = Logger.new(ENV["HOME"] + "/dialog_" + ME + ".log")

    height = 0
    width = 0
    listheight = 0

    selected_items = dialog.buildlist(text, items, height, width, listheight)
    exit_code = dialog.exit_code
    puts "Exit code: #{exit_code}"
    puts "Selecetd tags:"
    selected_items.each do |item|
      puts " '#{item}'"
    end

rescue => e
    puts "#{$!}"
    t = e.backtrace.join("\n\t")
    puts "Error: #{t}"
end
