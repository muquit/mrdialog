#!/usr/bin/env ruby

# muquit@muquit.com Apr-01-2014 
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

    user = ''
    uid = ''
    gid = ''
    home = ENV["HOME"]

    id = `id`.chomp
    if id =~ /^uid=(\d+)\((.+)\)\sgid=(\d+)\(.*$/
        uid = $1
        user = $2
        gid = $3
    end

    dialog = MRDialog.new
    dialog.clear = true
    dialog.logger = Logger.new(ENV["HOME"] + "/dialog_" + ME + ".log")

    text = <<EOF
Here is a possible piece of a configuration program.
EOF
    items = []
    form_data = Struct.new(:label, :ly, :lx, :item, :iy, :ix, :flen, :ilen)

    data = form_data.new
    data.label = "Username:"
    data.ly = 1
    data.lx = 1
    data.item = user
    data.iy = 1
    data.ix = 10
    data.flen = user.length + 10
    data.ilen = 0
    items.push(data.to_a)

    data = form_data.new
    data.label = "UID:"
    data.ly = 2 
    data.lx = 1
    data.item = uid.to_s
    data.iy = 2
    data.ix = 10
    data.flen = uid.length + 10
    data.ilen = 0
    items.push(data.to_a)

    data = form_data.new
    data.label = "GID:"
    data.ly = 3
    data.lx = 1
    data.item = gid.to_s
    data.iy =3 
    data.ix = 10
    data.flen = gid.length + 2
    data.ilen = 0
    items.push(data.to_a)

    data = form_data.new
    data.label = "HOME:"
    data.ly = 4
    data.lx = 1
    data.item = home
    data.iy = 4
    data.ix = 10
    data.flen = home.length + 40
    data.ilen = 0
    items.push(data.to_a)

    dialog.title = "FORM"
    dialog.extra_button = true
    dialog.ok_label = "Save"
    dialog.extra_label = "Submit"
    dialog.cancel_label = "Quit"

    result_hash = dialog.form(text, items, 20, 50, 0)
    if result_hash
        puts "Resulting data:"
        result_hash.each do |key, val|
            puts "   #{key} = #{val}"
        end
    end


rescue => e
    puts "#{$!}"
    t = e.backtrace.join("\n\t")
    puts "Error: #{t}"
end
