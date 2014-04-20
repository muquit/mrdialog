#!/usr/bin/env ruby

# muquit@muquit.com Apr-20-2014 
require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')
require 'pp'

begin
    ME = File.basename($0)
    text = <<-EOF
This example is taken from dialog/samples/treeview2
shell script.

EOF
    items = []
    item_list = ''
    input = []
    input << "tag1:one:off:0"
    input << "tag2:two:off:1"
    input << "tag3:three:on:2"
    input << "tag4:four:off:1"
    input << "tag5:five:off:2"
    input << "tag6:six:off:3"
    input << "tag7:seven:off:3"
    input << "tag8:eight:off:4"
    input << "tag11:1one:off:0"
    input << "tag12:1two:off:1"
    input << "tag13:1three:on:2"
    input << "tag14:1four:off:1"
    input << "tag15:1five:off:2"
    input << "tag16:1six:off:3"
    input << "tag17:1seven:off:3"
    input << "tag18:1eight:off:4"
    input << "tag21:2one:off:0"
    input << "tag22:2two:off:1"
    input << "tag23:2three:on:2"
    input << "tag24:2four:off:1"
    input << "tag25:2five:off:2"
    input << "tag26:2six:off:3"
    input << "tag27:2seven:off:3"
    input << "tag28:2eight:off:4"
    input << "tag9:nine:off:1"


    Struct.new("TreeviewData", :tag, :item, :status, :depth)
    input.each do |ii|
      data = Struct::TreeviewData.new
      a = ii.split(/:/)
      data.tag = a[0]
      data.item = a[1]
      if a[2] == 'on'
        data.status = true
      else
        data.status = false
      end
      data.depth = a[3]
      items.push(data.to_a)
    end

    dialog = MRDialog.new
    dialog.clear = true
    dialog.scrollbar = true
    dialog.title = "TREEVIEW"
    dialog.logger = Logger.new(ENV["HOME"] + "/dialog_" + ME + ".log")

    height = 0
    width = 0
    listheight = 10

    selected_tag = dialog.treeview(text, items, height, width, listheight)
    exit_code = dialog.exit_code
    puts "Exit code: #{exit_code}"
    if exit_code == 0
      puts "Selecetd tag: #{selected_tag}"
    end

rescue => e
    puts "#{$!}"
    t = e.backtrace.join("\n\t")
    puts "Error: #{t}"
end
