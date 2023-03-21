
#                                vim:ts=4:sw=4:
# = rdialog - A dialog gem for Ruby
#
# Homepage::  http://built-it.net/ruby/rdialog/
# Author::    Aleks Clark (http://built-it.net)
# Copyright:: (cc) 2004 Aleks Clark
# License::   BSD
#
# class RDialog::Dialog.new( array, str, array)
#

#=================================================
# I did the following:
#   - renamed the class to MRDialog
#   - removed tabs
#   - added support for the follwoing:
#     - form
#     - 
#
# muquit@muquit.com, Apr-05-2014
#=================================================

require 'logger'
require 'tempfile'
require 'date'
require 'time'
require 'shellwords'
class MRDialog 
           DIALOG_OK = 0
       DIALOG_CANCEL = 1
         DIALOG_HELP = 2
        DIALOG_EXTRA = 3
    DIALOG_ITEM_HELP = 4
          DIALOG_ESC = 255
    #MRDialog - Interface to ncurses dialog program

    #
    # All accessors are boolean unless otherwise noted.
    #

	# Specify the rc file to use for dialog.  Default is $HOME/.dialogrc
    attr_accessor :rc_file

    #
    # This gives you some control over the box dimensions when 
    # using auto sizing (specifying 0 for height and width). 
    # It represents width / height. The default is 9, 
    # which means 9 characters wide to every 1 line high.
    #
    attr_accessor :aspect

    #
    # Specifies a backtitle string to be displayed on the backdrop, 
    # at the top of the screen.
    #
    attr_accessor :backtitle

    #
    # Sound the audible alarm each time the screen is refreshed.
    #
    attr_accessor :beep

    #
    # Specify the position of the upper left corner of a dialog box
    # on the screen, as an array containing two integers.
    #
    attr_accessor :begin

    #
    # Interpret embedded newlines in the dialog text as a newline 
    # on the screen. Otherwise, dialog will only wrap lines where 
    # needed to fit inside the text box. Even though you can control 
    # line breaks with this, dialog will still wrap any lines that are 
    # too long for the width of the box. Without cr-wrap, the layout
    # of your text may be formatted to look nice in the source code of 
    # your script without affecting the way it will look in the dialog.
    #
    attr_accessor :crwrap

    #
    # Interpret the tags data for checklist, radiolist and menuboxes 
    # adding a column which is displayed in the bottom line of the 
    # screen, for the currently selected item.
    #
    attr_accessor :itemhelp

    #
    # Suppress the "Cancel" button in checklist, inputbox and menubox 
    # modes. A script can still test if the user pressed the ESC key to 
    # cancel to quit.
    #
    attr_accessor :nocancel

    #
    # Draw a shadow to the right and bottom of each dialog box.
    # 
    attr_accessor :shadow

    # MMM
    attr_accessor :notags

    #
    # Sleep (delay) for the given integer of seconds after processing 
    # a dialog box.
    #
    attr_accessor :sleep

    #
    # Convert each tab character to one or more spaces. 
    # Otherwise, tabs are rendered according to the curses library's 
    # interpretation.
    #
    attr_accessor :tabcorrect

    #
    # Specify the number(int) of spaces that a tab character occupies 
    # if the tabcorrect option is set true. The default is 8.
    #
    attr_accessor :tablen

    #
    # Title string to be displayed at the top of the dialog box.
    #
    attr_accessor :title

    #
    # Alternate path to dialog. If this is not set, environment path
    # is used.
    attr_accessor :path_to_dialog

    # -- muquit@muquit.com mod starts---
    
  # exit codes
  attr_accessor :dialog_ok
  attr_accessor :dialog_cancel
  attr_accessor :dialog_help
  attr_accessor :dialog_item_help
  attr_accessor :dialog_esc
  attr_accessor :dialog_extra

  # pass dialog's option exactly
  attr_accessor :dialog_options

  #
  # ruby logger
  attr_accessor :logger

  # Override the label used for "OK" buttons
  attr_accessor :ok_label

  # Override the label used for "Cancel" buttons
  attr_accessor :cancel_label

  # Override the label used for "Yes" buttons
  attr_accessor :yes_label

  # Override the label used for "No" buttons
  attr_accessor :no_label

  # Add a "Help" button
  attr_accessor :help_button

  # Override the label used for the "Help" button
  attr_accessor :help_label

  # Add an "Extra" button
  attr_accessor :extra_button

  # Override the label used for the "Extra" button
  attr_accessor :extra_label

  # clear screen
  attr_accessor :clear

  # make the password widget friendlier but less secure, by echoing
  # asterisks for each character.
  attr_accessor :insecure

  # rather than draw graphics lines around boxes, draw ASCII + and -
  attr_accessor :ascii_lines

  attr_accessor :separator

  # set it to true for passwordform.
  attr_accessor :password_form

  # For  widgets  holding a scrollable set of data, draw a scrollbar
  # on its right-margin.  This does not respond to the mouse.
  attr_accessor :scrollbar

  # Normally  dialog  converts  tabs  to spaces and reduces multiple 
  # spaces to a single space for text which is displayed 
  # # in a message boxes, etc.  Use this option to disable that feature.  
  # Note that dialog will  still  wrap  text,  subject  to  the "--cr-wrap" 
  # and "--trim" options. #7
  attr_accessor :no_collapse
  # -- muquit@muquit.com mod ends---

  # Returns a new RDialog Object

    def initialize
        # muquit@muquit.com mod starts--
        $stdout.sync = true
        $stderr.sync = true
#        @tags = true
        @dialog_ok = DIALOG_OK
        @dialog_cancel = DIALOG_CANCEL
        @dialog_help = DIALOG_HELP
        @dialog_extra = DIALOG_EXTRA
        @dialog_item_help = DIALOG_ITEM_HELP
        @dialog_esc = DIALOG_ESC
        @exit_code = 0
        # muquit@muquit.com mod ends--
    end

  ##---- muquit@muquit.com mod starts---
 
    ##--------------------------------------------------- 
    # if @logger is set, log
    ##--------------------------------------------------- 
    def log_debug(msg)
      if @logger
          @logger.debug("#{msg}")
      end
    end

    #  return the exit code of the dialog
    def exit_code
        return @exit_code
    end

    ##---------------------------------------------------
    # return the path of the executable which exists
    # in the PATH env variable
    # return nil otherwise
    # arg is the name of the program without extensin
    # muquit@muquit.com
    ##---------------------------------------------------
    def which(prog)
        path_ext = ENV['PATHEXT']
        exts = ['']
        if path_ext # WINDOW$
            exts = path_ext.split(';')
        end
        path = ENV['PATH']
        path.split(File::PATH_SEPARATOR).each do |dir|
            exts.each do |ext|
              candidate = File.join(dir, "#{prog}#{ext}")
              return candidate if File.executable?(candidate)
            end
        end
        return nil
    end

    
    # A gauge box displays a meter along the bottom of the box.   The  
    # meter  indicates  the percentage.   New percentages are read from 
    # standard input, one integer per line.  The meter is updated to 
    # reflect each new percentage.  If  the  standard  input  reads  the 
    # string  "XXX",  then  the first line following is taken as an 
    # integer percentage, then subsequent lines up to another "XXX" are 
    # used for a new prompt.  The gauge exits  when EOF is reached on 
    # the standard input.
    #
    # The  percent  value  denotes the initial percentage shown in the 
    # meter.  If not speciied, it is zero.
    #
    # On exit, no text is written to dialog's output.  The widget 
    # accepts no input,  so  the exit status is always OK.  
    #
    # The caller will write the text markers to stdout 
    # as described above inside a block and will pass the block to the
    # method. Look at samples/gauge for
    # an example on how the method is called. Thanks to Mike Morgan
    # for the idea to use a block.
    #
    # Author:: muquit@muquit.com Apr-02-2014 
    ##---------------------------------------------------  
    def gauge(text, height=0, width=0, percent=0)
        cmd = ""
        cmd << option_string()
        cmd << " "
        cmd << "--gauge"
        cmd << " "
        cmd << "'"
        cmd << text
        cmd << "'"
        cmd << " "
        cmd << height.to_s
        cmd << " "
        cmd << width.to_s
        cmd << " "
        cmd << percent.to_s

        log_debug "Command:\n#{cmd}"
        IO.popen(cmd, "w") {|fh| yield fh}
    end


  # Progressbox is used to display the piped output of a command.  
  # After  the  command completes,  the  user can press the ENTER key so 
  # that dialog will exit and the calling shell script can continue its operation.
  # If three parameters are given, it displays the text under the title,
  # delineated  from the  scrolling  file's contents.  If only two 
  # parameters are given, this text is omitted.
  # 
  # The caller will write the progress string on stdout in a block
  # and will pass the block to the method. Please look at samples/
  # progress.rb for an example.
  # Author: muquit@muquit.com Apr-02-2014 
  def progressbox(description='', height=0, width=0)
    cmd = ""
    cmd << option_string()
    cmd << " "
    cmd << "--progressbox"
    cmd << " "
    if description.length > 0
        cmd << "'"
        cmd << description
        cmd << "'"
    end
    cmd << " "
    cmd << height.to_s
    cmd << " "
    cmd << width.to_s
    
    log_debug("Command\n#{cmd}")
    IO.popen(cmd, "w") {|fh| yield fh}
  end

  # same as progressbox but displays OK button at the end
  def programbox(description='', height=0, width=0)
    cmd = ""
    cmd << option_string()
    cmd << " "
    cmd << "--programbox"
    cmd << " "
    if description.length > 0
        cmd << "'"
        cmd << description
        cmd << "'"
    end
    cmd << " "
    cmd << height.to_s
    cmd << " "
    cmd << width.to_s
    
    log_debug("Command\n#{cmd}")
    IO.popen(cmd, "w") {|fh| yield fh}
  end

  #
  # A prgbox is very similar to a programbox.
  #
  # This  dialog box is used to display the output of a command that
  # is specified as an argument to prgbox.
  #
  # After the command completes, the user can press the ENTER key so
  # that  dialog will exit and the calling shell script can continue
  # its operation.
  #
  # If three parameters are given, it displays the  text  under  the
  # title,  delineated  from the scrolling file's contents.  If only
  # two parameters are given, this text is omitted.
  #
  def prgbox(command, height=0, width=0, text='')
    cmd = ""
    cmd << option_string()
    cmd << " "
    cmd << "--prgbox"
    cmd << " "
    if text.length > 0
      cmd << "'"
      cmd << text
      cmd << "'"
    end
    cmd << " "
    cmd << "'"
    cmd << command
    cmd << "'"
    cmd << " "
    cmd << height.to_s
    cmd << " "
    cmd << width.to_s
    system(cmd)
    @exit_code = $?.exitstatus
  end

  # 
  # Display data organized as a tree.  Each group of data contains a
  # tag, the text to display for  the  item,  its  status  ("on"  or
  # "off") and the depth of the item in the tree.
  # 
  # Only  one item can be selected (like the radiolist).  The tag is
  # not displayed.
  # 
  # On exit, the tag of the selected item  is  written  to  dialog's
  # output.
  def treeview(text="Text Goes Here", items=nil, height=0, width=0, listheight=0)
    tmp = Tempfile.new('dialog') 
    itemlist = ''
    items.each do |item|
      itemlist << "'" 
      itemlist << item[0].to_s
      itemlist << "'"
      itemlist << " "
      itemlist << "'"
      itemlist << item[1].to_s
      itemlist << "'"
      itemlist << " "
      itemlist << "'"
      if item[2]
        item[2] = "on"
      else
        item[2] = "off"
      end
      itemlist << item[2]
      itemlist << "'"
      itemlist << " "
      itemlist << item[3].to_s
      itemlist << " "
    end
    itemlist << "2>"
    itemlist << tmp.path

    cmd = ""
    cmd << option_string()
    cmd << " "
    cmd << "--treeview"
    cmd << " "
    cmd << "'"
    cmd << " "
    cmd << text
    cmd << "'"
    cmd << " "
    cmd << height.to_s
    cmd << " "
    cmd << width.to_s
    cmd << " "
    cmd << listheight.to_s
    cmd << " "
    cmd << itemlist

    log_debug "Number of items: #{items.size}"
    log_debug "Command:\n#{cmd}"

    system(cmd)
    @exit_code = $?.exitstatus
    log_debug "Exit code: #{exit_code}"
    tag = ''
    if @exit_code != 1
      tag = tmp.read
    end
    return tag
  ensure
    tmp.close!
  end
   
  #
  # A buildlist  dialog displays two lists, side-by-side.  The list
  # on the left shows unselected items. The list on the right shows
  # selected  items.  As items are selected or unselected, they move
  # between the lists. Use SPACE bar to select/unselect an item.
  # 
  # Use a carriage return or the "OK" button to accept  the  current
  # value  in the selected-window and exit.  The results are written
  # using the order displayed in the selected-window.
  #
  # The caller is responsile to create the items properly. Please
  # look at samples/buildlist.rb for an example.
  #
  # return an array of selected tags
  # Author:: muquit@muquit.com 
  def buildlist(text="Text Goes Here", items = nil, height=0, width=0, listheight=0)
    tmp = Tempfile.new('dialog') 
    selected_tags = []
    itemlist = ''

    items.each do |item|
      itemlist << "'" 
      itemlist << item[0].to_s
      itemlist << "'"
      itemlist << " "
      itemlist << "'"
      itemlist << item[1].to_s
      itemlist << "'"
      itemlist << " "
      itemlist << "'"
      if item[2]
        item[2] = "on"
      else
        item[2] = "off"
      end
      itemlist << item[2]
      itemlist << "'"
      itemlist << " "
    end
    itemlist << "2>"
    itemlist << tmp.path

    cmd = ""

    cmd << option_string()
    if !@separator
      @separator = "|"
      cmd << " "
      cmd << "--separator"
      cmd << " "
      cmd << "'"
      cmd << @separator
      cmd << "'"
    end
    cmd << " "
    cmd << "--buildlist"
    cmd << " "
    cmd << "'"
    cmd << " "
    cmd << text
    cmd << "'"
    cmd << " "
    cmd << height.to_s
    cmd << " "
    cmd << width.to_s
    cmd << " "
    cmd << listheight.to_s
    cmd << " "
    cmd << itemlist

    log_debug "Number of items: #{items.size}"
    log_debug "Command:\n#{cmd}"

    system(cmd)
    @exit_code = $?.exitstatus
    log_debug "Exit code: #{exit_code}"
    if @exit_code != 1
      lines = tmp.read
      log_debug "lines: #{lines} #{lines.class}"
      sep = Shellwords.escape(@separator)
      a = lines.split(/#{sep}/)
      a.each do |tag|
        log_debug "tag: '#{tag}'"
        selected_tags << tag if tag.to_s.length > 0
      end
    end
    return selected_tags
  ensure
    tmp.close!
  end

  # A  pause  box displays a meter along the bottom of the box.  The
  # meter indicates how many seconds remain until  the  end  of  the
  # pause. The  pause  exits  when  timeout is reached or the user
  # presses the OK button (status OK) or the user presses the CANCEL
  # button or Esc key.
  def pause(text="Text Goes Here", height=0, width=0, secs=10)
    cmd = ""
    cmd << option_string()
    cmd << " "
    cmd << "--pause"
    cmd << " "
    cmd << "'"
    cmd << text
    cmd << "'"
    cmd << " "
    cmd << height.to_s
    cmd << " "
    cmd << width.to_s
    cmd << " "
    cmd << secs.to_s
    log_debug "Command:\n#{cmd}"

    system(cmd)
    result = ''
    @exit_code = $?.exitstatus
    log_debug "Exit code: #{exit_code}"
  end

  # The edit-box dialog displays a copy of the file.  You  may  edit
  # it using the backspace, delete and cursor keys to correct typing
  # errors.  It also recognizes pageup/pagedown.  Unlike  the  --in-
  # putbox,  you  must  tab to the "OK" or "Cancel" buttons to close
  # the dialog.  Pressing the "Enter" key within the box will  split
  # the corresponding line.
  # 
  # On exit, the contents of the edit window are written to dialog's
  # output.
  def editbox(filepath, height=0, width=0)
    tmp = Tempfile.new('dialog') 

    cmd = ""
    cmd << option_string()
    cmd << " "
    cmd << "--editbox"
    cmd << " "
    cmd << "'"
    cmd << filepath
    cmd << "'"
    cmd << " "
    cmd << height.to_s
    cmd << " "
    cmd << width.to_s
    cmd << " "
    cmd << "2>"
    cmd << tmp.path

    log_debug "Command:\n#{cmd}"

    system(cmd)
    result = ''
    @exit_code = $?.exitstatus
    log_debug "Exit code: #{exit_code}"
    if @exit_code == 0
      result = tmp.read
    end
    return result
  ensure
    tmp.close!
  end

  #
  # form/mixedform dialog
  # A form dialog displays a form consisting of labels and fields, 
  # which are positioned on a scrollable window by coordinates given in 
  # the script.  The field length flen  and input-length ilen tell how 
  # long the field can be.  The former defines the length shown for a 
  # selected field, while the latter defines the permissible length of 
  # the data  entered in the field.  
  # The caller is responsile to create the items properly. Please
  # look at samples/form.rb for an example
  #
  # return a hash. keys are the labels
  # Author:: muquit@muquit.com 
  def form(text, items, height=0, width=0, formheight=0)
    res_hash = {}
    tmp = Tempfile.new('dialog') 
    itemlist = ''
    mixed_form = false
    item_size = items[0].size
    log_debug "Item size:#{item_size}"
    # if there are 9 elements, it's a mixedform
    if item_size == 9
        mixed_form = true
    end
    items.each do |item|
      itemlist << "'"
      itemlist << item[0].to_s
      itemlist << "'"
      itemlist << " "
      itemlist << item[1].to_s
      itemlist << " "
      itemlist << item[2].to_s
      itemlist << " "
      itemlist << "'"
      itemlist << item[3].to_s
      itemlist << "'"
      itemlist << " "
      itemlist << item[4].to_s
      itemlist << " "
      itemlist << item[5].to_s
      itemlist << " "
      itemlist << item[6].to_s
      itemlist << " "
      itemlist << item[7].to_s
      itemlist << " "
      if mixed_form
          itemlist << item[8].to_s
          itemlist << " "
      end
    end
    itemlist << " "
    itemlist << "2>"
    itemlist << tmp.path

    cmd = ""
    cmd << option_string()
    cmd << " "
    if mixed_form
      cmd << "--mixedform"
    else
      if @password_form
        cmd << "--passwordform"
      else
        cmd << "--form"
      end
    end
    cmd << " "
    cmd << "'"
    cmd << text
    cmd << "'"
    cmd << " "
    cmd << height.to_s
    cmd << " "
    cmd << width.to_s
    cmd << " "
    cmd << formheight.to_s
    cmd << " "
    cmd << itemlist

    log_debug("Number of items: #{items.size}")
    log_debug("Command:\n#{cmd}")
    system(cmd)
    @exit_code = $?.exitstatus
    log_debug "Exit code: #{exit_code}"

    if @exit_code != 1
      lines = tmp.readlines
      lines.each_with_index do |val, idx|
          key = items[idx][0]
          res_hash[key] = val.chomp
      end
    end

    return res_hash
  ensure
    tmp.close!
  end

  #
  # A mixedform dialog displays a form consisting of labels and fields,  
  # much  like  the --form  dialog.   It differs by adding a field-type 
  # parameter to each field's description.  Each bit in the type denotes 
  # an attribute of the field:
  # *     1    hidden, e.g., a password field.
  # *     2    readonly, e.g., a label.#
  # Author:: muquit@muquit.com 
  def mixedform(text, items, height=0, width=0, formheight=0)
      item_size = items[0].size
      log_debug "Item size:#{item_size}"
      if item_size == 9
          return form(text, items, height, width, formheight)
      end
      return nil
  end

  #
  # This is identical to --form except  that  all  text  fields  are
  # treated as password widgets rather than inputbox widgets.
  def passwordform(text, items, height=0, width=0, formheight=0)
    @password_form = true
    return form(text, items, height, width, formheight)
  end

  ##---- muquit@muquit.com mod ends---


  #      A calendar box displays  month,  day  and  year  in  separately
  #      adjustable  windows.   If the values for day, month or year are
  #      missing or negative, the current  date's  corresponding  values
  #      are  used.   You  can increment or decrement any of those using
  #      the left-, up-, right- and down-arrows.  Use vi-style h,  j,  k
  #      and  l for moving around the array of days in a month.  Use tab
  #      or backtab to move between windows.  If the year  is  given  as
  #      zero, the current date is used as an initial value.
  #
  #  Returns a Date object with the selected date

  def calendar(text="Select a Date", height=0, width=0, day=Date.today.mday(), month=Date.today.mon(), year=Date.today.year())

    tmp = Tempfile.new('tmp')

    command = option_string() + "--calendar \"" + text.to_s + 
      "\" " + height.to_i.to_s + " " + width.to_i.to_s + " " + 
      day.to_i.to_s + " " + month.to_i.to_s + " " + year.to_i.to_s + 
      " 2> " + tmp.path
    success = system(command)
    @exit_code = $?.exitstatus
    if @exit_code != 1
      date = Date::civil(*tmp.readline.split('/').collect {|i| i.to_i}.reverse)
      return date
    else
      return success
    end  
  ensure    
    tmp.close!
  end

  # A  checklist  box  is similar to a menu box; there are multiple
  # entries presented in the form of a menu.  Instead  of  choosing
  # one entry among the entries, each entry can be turned on or off
  # by the user.  The initial on/off state of each entry is  speci-
  # fied by status.
  # return an array of selected items
  def checklist(text, items, height=0, width=0, listheight=0)
    
    tmp = Tempfile.new('tmp')

    itemlist = String.new

    for item in items
      if item[2]
        item[2] = "on"
      else
        item[2] = "off"
      end
      itemlist += "\"" + item[0].to_s + "\" \"" + item[1].to_s + 
      "\" " + item[2] + " "

      if @itemhelp
        itemlist += "\"" + item[3].to_s + "\" "
      end
    end

    sep = "|"
    command = option_string() + "--checklist \"" + text.to_s +
                        "\" " + height.to_i.to_s + " " + width.to_i.to_s +
      " " + listheight.to_i.to_s + " " + itemlist + "2> " +
      tmp.path 
      log_debug "Command:\n#{command}"
    success = system(command)
    @exit_code = $?.exitstatus
    selected_array = []
    if @exit_code != 1
      selected_string = tmp.readline
      log_debug "Separator: #{@separator}"

      sep = Shellwords.escape(@separator)
      a = selected_string.split(/#{sep}/)
      a.each do |item|
        log_debug ">> #{item}"
        selected_array << item if item && item.to_s.length > 0
      end
      return selected_array
    else
      return success
    end
  ensure    
    tmp.close!
  end

  #      The file-selection dialog displays a text-entry window in which
  #      you can type a filename (or directory), and above that two win-
  #      dows with directory names and filenames.

  #      Here  filepath  can  be  a  filepath in which case the file and
  #      directory windows will display the contents of the path and the
  #      text-entry window will contain the preselected filename.
  #
  #      Use  tab or arrow keys to move between the windows.  Within the
  #      directory or filename windows, use the up/down  arrow  keys  to
  #      scroll  the  current  selection.  Use the space-bar to copy the
  #      current selection into the text-entry window.
  #
  #      Typing any printable characters switches  focus  to  the  text-
  #      entry  window, entering that character as well as scrolling the
  #      directory and filename windows to the closest match.
  #
  #      Use a carriage return or the "OK" button to accept the  current
  #      value in the text-entry window and exit.

  def fselect(path, height=0, width=0)
    tmp = Tempfile.new('tmp')

    command = option_string() + "--fselect \"" + path.to_s +
              "\" " + height.to_i.to_s + " " + width.to_i.to_s + " "

    command += "2> " + tmp.path

    success = system(command)
    @exit_code = $?.exitstatus

    if @exit_code != 1
      begin
        selected_string = tmp.readline
      rescue EOFError
        selected_string = ""
      end
      return selected_string
    else
      return success
    end
  ensure
    tmp.close!
  end


  #
  # An info box is basically a message box.  However, in this case,
  # dialog  will  exit  immediately after displaying the message to
  # the user.  The screen is not cleared when dialog exits, so that
  # the  message  will remain on the screen until the calling shell
  # script clears it later.  This is useful when you want to inform
  # the  user that some operations are carrying on that may require
  # some time to finish.
  #
  # Returns false if esc was pushed
  def infobox(text, height=0, width=0)
    command = option_string() + "--infobox \"" + text.to_s +
                "\" " + height.to_i.to_s + " " + width.to_i.to_s + " "
    success = system(command)
    @exit_code = $?.exitstatus
    return success
  end

  #      A  radiolist box is similar to a menu box.  The only difference
  #      is that you can indicate which entry is currently selected,  by
  #      setting its status to true.
  def radiolist(text, items, height=0, width=0, listheight=0)

    tmp = Tempfile.new('tmp')

    itemlist = String.new

    for item in items
      if item[2]
        item[2] = "on"
      else
        item[2] = "off"
      end
      itemlist += "\"" + item[0].to_s + "\" \"" + item[1].to_s +
                  "\" " + item[2] + " "

      if @itemhelp
        itemlist += "\"" + item[3].to_s + "\" "
      end
    end

    command = option_string() + "--radiolist \"" + text.to_s +
              "\" " + height.to_i.to_s + " " + width.to_i.to_s +
              " " + listheight.to_i.to_s + " " + itemlist + "2> " +
              tmp.path
    log_debug("Command:\n#{command}")
    success = system(command)
    @exit_code = $?.exitstatus

    if @exit_code != 1
      selected_string = tmp.readline
      return selected_string
    else
      return success
    end
  ensure    
    tmp.close!
  end

        #      As  its  name  suggests, a menu box is a dialog box that can be
        #      used to present a list of choices in the form of a menu for the
        #      user  to  choose.   Choices  are  displayed in the order given.
        #      Each menu entry consists of a tag string and  an  item  string.
        #      The tag gives the entry a name to distinguish it from the other
        #      entries in the menu.  The item is a short  description  of  the
        #      option  that  the  entry represents.  The user can move between
        #      the menu entries by pressing the cursor keys, the first  letter
        #      of  the  tag  as  a  hot-key, or the number keys 1-9. There are
        #      menu-height entries displayed in the menu at one time, but  the
        #      menu will be scrolled if there are more entries than that.
  #
        #      Returns a string containing the tag of the chosen menu entry.

  def menu(text="Text Goes Here", items=nil, height=0, width=0, listheight=0)
    tmp = Tempfile.new('tmp')

    itemlist = String.new

    for item in items
      itemlist += "\"" + item[0].to_s + "\" \"" + item[1].to_s +  "\" "

      if @itemhelp
        itemlist += "\"" + item[2].to_s + "\" "
      end
    end

    command = option_string() + "--menu \"" + text.to_s +
              "\" " + height.to_i.to_s + " " + width.to_i.to_s +
              " " + listheight.to_i.to_s + " " + itemlist + "2> " +
              tmp.path

    log_debug("Command:\n#{command}")
    success = system(command)
    @exit_code = $?.exitstatus

    if @exit_code != 1
      selected_string = tmp.readline
      return selected_string
    else
      return success
    end
  ensure    
    tmp.close!
  end

  #      A message box is very similar to a yes/no box.  The  only  dif-
  #      ference  between  a message box and a yes/no box is that a mes-
  #      sage box has only a single OK button.  You can use this  dialog
  #      box  to  display  any message you like.  After reading the mes-
  #      sage, the user can press the ENTER key so that dialog will exit
  #      and the calling shell script can continue its operation.

  def msgbox(text="Text Goes Here", height=0, width=0)
    command = option_string() + "--msgbox \"" + text.to_s +
                "\" " + height.to_i.to_s + " " + width.to_i.to_s + " "

    log_debug "Command\n#{command}"
    success = system(command)
    @exit_code = $?.exitstatus
    return success
  end

  #      A password box is similar to an input box, except that the text
  #      the user enters is not displayed.  This is useful when  prompt-
  #      ing  for  passwords  or  other sensitive information.  Be aware
  #      that if anything is passed in "init", it will be visible in the
  #      system's  process  table  to casual snoopers.  Also, it is very
  #      confusing to the user to provide them with a  default  password
  #      they  cannot  see.   For  these reasons, using "init" is highly
  #      discouraged.

  def passwordbox(text="Please enter some text", height=0, width=0, init="")
    tmp = Tempfile.new('tmp')
    command = option_string() + "--passwordbox \"" + text.to_s +
              "\" " + height.to_i.to_s + " " + width.to_i.to_s + " "

    unless init.empty?
      command += init.to_s + " "
    end

    command += "2> " + tmp.path
    log_debug(command)
    success = system(command)
    @exit_code = $?.exitstatus

    if @exit_code != 1
      begin
        selected_string = tmp.readline
      rescue EOFError
        selected_string = ""
      end
      return selected_string
    else
      return success
    end
  ensure
    tmp.close!
  end

  #     The textbox method handles three similar dialog functions, textbox,
  #     tailbox, and tailboxbg. They are activated by setting type to
  #     "text", "tail", and "bg" respectively
  #
  #     Textbox mode:
  #  A  text  box  lets you display the contents of a text file in a
  #  dialog box.  It is like a simple text file  viewer.   The  user
  #  can  move  through  the file by using the cursor, PGUP/PGDN and
  #  HOME/END keys available on most keyboards.  If  the  lines  are
  #  too long to be displayed in the box, the LEFT/RIGHT keys can be
  #  used to scroll the text region horizontally.  You may also  use
  #  vi-style  keys h, j, k, l in place of the cursor keys, and B or
  #  N in place of the pageup/pagedown keys.  Scroll  up/down  using
  #  vi-style  'k'  and 'j', or arrow-keys.  Scroll left/right using
  #  vi-style  'h'  and  'l',  or  arrow-keys.   A  '0'  resets  the
  #  left/right  scrolling.   For more convenience, vi-style forward
  #  and backward searching functions are also provided.
  #
  #     Tailbox mode:
  #  Display text from a file in a dialog box, as  in  a  "tail  -f"
  #  command.   Scroll  left/right  using  vi-style  'h' and 'l', or
  #  arrow-keys.  A '0' resets the scrolling.
  #
  #     Tailboxbg mode:
  #  Display text from a file in a dialog box as a background  task,
  #  as  in a "tail -f &" command.  Scroll left/right using vi-style
  #  'h' and 'l', or arrow-keys.  A '0' resets the scrolling.

  def textbox(file, type="text", height=0, width=0)
    case type
      when "text"
        opt = "--textbox"
      when "tail"
        opt = "--tailbox"
      when "bg"
        opt = "--textboxbg"
    end

    command = option_string() + opt +" \"" + file.to_s +
                "\" " + height.to_i.to_s + " " + width.to_i.to_s + " "
    
    success = system(command)
    @exit_code = $?.exitstatus

    return success
  end

  #      A dialog is displayed which allows you to select  hour,  minute
  #      and second.  If the values for hour, minute or second are miss-
  #      ing or negative, the current date's  corresponding  values  are
  #      used.   You  can  increment or decrement any of those using the
  #      left-, up-, right- and down-arrows.  Use tab or backtab to move
  #      between windows.
  #
  #      On  exit, a Time object is returned.

##-    def timebox(file, type="text", height=0, width=0, time=Time.now)
  def timebox(text, height=0, width=0, time=Time.now)
              tmp = Tempfile.new('tmp')

    command = option_string() + "--timebox \"" + text.to_s +
              "\" " + height.to_i.to_s + " " + width.to_i.to_s + " " +
    time.hour.to_s + " " + time.min.to_s + " " + 
    time.sec.to_s + " 2> " + tmp.path
    log_debug("Command:\n#{command}")
    success = system(command)
    @exit_code = $?.exitstatus
    if @exit_code != 1
      time = Time.parse(tmp.readline)
      return time
    else
      return success
    end
  ensure    
    tmp.close!
  end

  #      An input box is useful when you  want  to  ask  questions  that
  #      require  the  user to input a string as the answer.  If init is
  #      supplied it is used  to  initialize  the  input  string.   When
  #      entering  the string, the backspace, delete and cursor keys can
  #      be used to correct typing  errors.   If  the  input  string  is
  #      longer  than can fit in the dialog box, the input field will be
  #      scrolled.
  #
  #      On exit, the input string will be returned.
  def inputbox(text="Please enter some text", height=0, width=0, init="")
    tmp = Tempfile.new('tmp')

    command = option_string() + "--inputbox \"" + text.to_s +
              "\" " + height.to_i.to_s + " " + width.to_i.to_s + " "

    unless init.empty?
      command += init.to_s + " "
    end

    command += "2> " + tmp.path

    log_debug(command)
    success = system(command)
    @exit_code = $?.exitstatus

    if @exit_code != 1
      begin
        selected_string = tmp.readline
      rescue EOFError
        selected_string = ""
      end
      return selected_string
    else
      return success
    end
  ensure
    tmp.close!
  end

  #      A yes/no dialog box of size height rows by width  columns  will
  #      be displayed.  The string specified by text is displayed inside
  #      the dialog box.  If this string is too long to fit in one line,
  #      it  will be automatically divided into multiple lines at appro-
  #      priate places.  The text string can also contain the sub-string
  #      "\n"  or  newline  characters  '\n'  to  control  line breaking
  #      explicitly.  This dialog box is  useful  for  asking  questions
  #      that  require  the user to answer either yes or no.  The dialog
  #      box has a Yes button and a No button, in  which  the  user  can
  #      switch between by pressing the TAB key.

  # changing --inputbox to --yesno
  #  muquit@muquit.com Apr-01-2014 
  def yesno(text="Please enter some text", height=0, width=0)
#    command = option_string() + "--inputbox \"" + text.to_s +
#                "\" " + height.to_i.to_s + " " + width.to_i.to_s

    command = ""
    command << option_string();
    command << " "
    command << "'"
    command << "--yesno"
    command << "'"
    command << " "
    command << "'"
    command << text
    command << "'"
    command << " "
    command << height.to_s
    command << " "
    command << width.to_s


    log_debug("Command:\n#{command}")
    success = system(command)
    @exit_code = $?.exitstatus
    return success
  end

  private  

    def option_string
        # make sure 'dialog' is installed
        # muquit@muquit.com 
        exe_loc = ''
        unless @path_to_dialog
          exe_loc = which("dialog")
          ostring = exe_loc
        else
          exe_loc = @path_to_dialog
          if !File.exists?(exe_loc)
            raise "Specified path of dialog '#{exe_loc}' does not exist"
          end
          if !File.executable?(exe_loc)
            raise "The program #{exe_loc} is not executable"
          end
        end
        raise "'dialog' executable not found in path" unless exe_loc

		# if an rc file was specified, set DIALOGRC to that file
		ENV["DIALOGRC"] = @rc_file if @rc_file

        ostring = exe_loc + " "

        if @aspect
          ostring += "--aspect " + @aspect + " "
        end
        
        if @beep
          ostring += "--beep "
        end
        
        if @boxbegin 
          ostring += "--begin " + @boxbegin[0] + @boxbegin[1] + " "
        end

        if @backtitle
          ostring += "--backtitle \"" + @backtitle + "\" "
        end 

        if @itemhelp
          ostring += "--item-help "
        end

        unless @shadow == nil
          if @shadow == true
            ostring += "--shadow "
          else 
            ostring += "--no-shadow "
          end
        end

        unless @notags == nil
          if @notags == true
            ostring += "--no-tags "
          end
        end

        if @dialog_options
          ostring += " #{@dialog_options} "
        end

        if @sleep
          ostring += "--sleep " + @sleep.to_s + " "
        end

        if @tabcorrect
          ostring += "--tab-correct "
        end

        if @tablen
          ostring += "--tab-len " + @tablen.to_s + " "
        end

        if @title
          #      ostring += "--title " + "\"" + @title.to_s "\"" + " "
          # muquit@muquit.com  Apr-01-2014 
          ostring += "--title \"" + @title.to_s + "\" "
        end

        # muquit@muquit.com mod starts--
        if @clear
            ostring += "--clear "
        end

        if @insecure
            ostring += "--insecure "
        end

        if @ascii_lines
            ostring += "--ascii-lines "
        end

        if @ok_label
            ostring += "--ok-label #{@ok_label} "
        end

        if @cancel_label
            ostring += "--cancel-label #{@cancel_label} "
        end

        if @yes_label
            ostring += "--yes-label #{@yes_label} "
        end

        if @no_label
            ostring += "--no-label #{@no_label} "
        end

        if @extra_button
            ostring += "--extra-button "
        end

        if @extra_label
            ostring += "--extra-label #{@extra_label} "
        end

        if @help_button
            ostring += "--help-button "
        end

        if @help_label
            ostring += "--help-label #{@help_label} "
        end

        if @separator
            ostring += "--separator \"#{@separator}\" "
        end
        if @scrollbar
            ostring += "--scrollbar "
        end
        # muquit@muquit.com mod ends--

        if @nocancel
          ostring += "--nocancel "
        end

        # #7
        if @no_collapse
          ostring += "--no-collapse "
        end

        return ostring
  end
end



#Dir[File.join(File.dirname(__FILE__), 'rdialog/**/*.rb')].sort.each { |lib| require lib }
