#!/usr/bin/env ruby

require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')
require 'tempfile'
require 'pp'

# By Claude AI Opus 4
# Oct-18-2025 

dialog = MRDialog.new
dialog.clear = true
dialog.title = "Textbox Examples"

# Create test files with various filenames
test_files = []

# File with spaces in name
file1 = Tempfile.new(['test file with spaces', '.txt'])
file1.write("This is a test file with spaces in its filename.\n")
file1.write("It should display correctly in the textbox.\n")
file1.close
test_files << file1

# File with apostrophe in name
file2 = Tempfile.new(["test's file", '.txt'])
file2.write("This file has an apostrophe in its name.\n")
file2.write("Testing special characters in filenames.\n")
file2.close
test_files << file2

# File with various special characters
file3 = Tempfile.new(['test$file (special)', '.txt'])
file3.write("This file has $ and parentheses in its name.\n")
file3.write("All special characters should work fine.\n")
file3.close
test_files << file3

begin
  # Example 1: Regular textbox
  dialog.msgbox("Let's view some files with special characters in their names", 6, 50)
  
  test_files.each_with_index do |file, index|
    dialog.title = "Textbox Example #{index + 1}"
    result = dialog.textbox(file.path, "text", 15, 60)
    
    if dialog.exit_code == 0
      dialog.msgbox("File displayed successfully!", 5, 40)
    end
  end
  
  # Example 2: Tailbox mode
  dialog.title = "Tailbox Example"
  log_file = Tempfile.new(['app-log', '.log'])
  log_file.write("Initial log entry\n")
  log_file.close
  
  # Show tailbox (you'd normally append to the file from another process)
  dialog.msgbox("Now showing tailbox mode (press OK to continue)", 5, 50)
  dialog.textbox(log_file.path, "tail", 15, 60)
  
ensure
  # Clean up
  test_files.each(&:unlink)
  log_file.unlink if log_file
end
