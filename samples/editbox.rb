#!/usr/bin/env ruby

require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')
require 'pp'
require 'tempfile'

begin
    ME = File.basename($0)

    tmp = Tempfile.new('editbox')
    tmp.puts <<-EOF
Hi, this is an edit box. It can be used to edit text from a file.

It's like a simple text editor, with these keys implemented:

PGDN    - Move down one page
PGUP    - Move up one page
DOWN    - Move down one line
UP  - Move up one line
DELETE  - Delete the current character
BACKSPC - Delete the previous character

Unlike Xdialog, it does not do these:

CTRL C  - Copy text
CTRL V  - Paste text

Because dialog normally uses TAB for moving between fields,
this editbox uses CTRL/V as a literal-next character.  You
can enter TAB characters by first pressing CTRL/V.  This
example contains a few tab characters.

It supports the mouse - but only for positioning in the editbox,
or for clicking on buttons.  Your terminal (emulator) may support
cut/paste.

Try to input some text below:

EOF
    tmp.close

    height = 0
    width = 0

    dialog = MRDialog.new
    dialog.clear = true
    dialog.shadow = false
    dialog.logger = Logger.new(ENV["HOME"] + "/dialog_" + ME + ".log")

    output = dialog.editbox(tmp.path, height, width)
    exit_code = dialog.exit_code
    puts "Exit code: #{exit_code}"
    if exit_code == 0
      puts "Output: #{output}"
    end
rescue => e
    puts "#{$!}"
    t = e.backtrace.join("\n\t")
    puts "Error: #{t}"
end
