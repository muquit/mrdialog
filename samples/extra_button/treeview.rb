#!/usr/bin/env ruby

# muquit@muquit.com Apr-20-2014 
require [File.expand_path(File.dirname(__FILE__)), '../..', 'lib', 'mrdialog'].join('/')
require 'pp'

begin
    ME = File.basename($0)
    if ENV['CHANGE_TITLE']
      if ME =~ /(.+)\.rb$/
        base = $1
        puts "\033]0;mrdialog - #{base}\007"
      end
    end

    text = <<-EOF
This example is taken from dialog/samples/treeview1
shell script.

EOF
    items = []
    Struct.new("TreeviewData", :tag, :item, :status, :depth)
    data = Struct::TreeviewData.new

    data.tag = "tag1"
    data.item = "Item number 1"
    data.status = false
    data.depth = 0
    items.push(data.to_a)

    data = Struct::TreeviewData.new
    data.tag = "tag2"
    data.item = "Item number 2"
    data.status = false
    data.depth = 1
    items.push(data.to_a)

    data = Struct::TreeviewData.new
    data.tag = "tag3"
    data.item = "Item number 3"
    data.status = true
    data.depth = 2
    items.push(data.to_a)

    data = Struct::TreeviewData.new
    data.tag = "tag4"
    data.item = "Item number 4"
    data.status = false
    data.depth = 1
    items.push(data.to_a)

    data = Struct::TreeviewData.new
    data.tag = "tag5"
    data.item = "Item number 5"
    data.status = false
    data.depth = 2
    items.push(data.to_a)

    data = Struct::TreeviewData.new
    data.tag = "tag6"
    data.item = "Item number 6"
    data.status = false
    data.depth = 3
    items.push(data.to_a)

    data = Struct::TreeviewData.new
    data.tag = "tag7"
    data.item = "Item number 7"
    data.status = false
    data.depth = 3
    items.push(data.to_a)

    data = Struct::TreeviewData.new
    data.tag = "tag8"
    data.item = "Item number 8"
    data.status = false
    data.depth = 4
    items.push(data.to_a)

    data = Struct::TreeviewData.new
    data.tag = "tag9"
    data.item = "Item number 9"
    data.status = false
    data.depth = 1
    items.push(data.to_a)

    dialog = MRDialog.new
    dialog.clear = true
    dialog.title = "TREEVIEW"
    dialog.logger = Logger.new(ENV["HOME"] + "/dialog_" + ME + ".log")
    dialog.extra_button = true
    dialog.ok_label = "Edit"
    dialog.extra_label = "Delete"
    dialog.cancel_label = "Quit"


    height = 0
    width = 0
    listheight = 0

    selected_tag = dialog.treeview(text, items, height, width, listheight)
    exit_code = dialog.exit_code
    puts "Exit code: #{exit_code}"
    if exit_code != 1
      puts "Selected tag: #{selected_tag}"
    end

rescue => e
    puts "#{$!}"
    t = e.backtrace.join("\n\t")
    puts "Error: #{t}"
end
