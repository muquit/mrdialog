#!/usr/bin/env ruby

########################################################################
# Same as form1 but dialog will not go away unless all the fields are
# specified
# muquit@muquit.com 
########################################################################
require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')

class TestForm2
    ME = File.basename($0)
    if ENV['CHANGE_TITLE']
      if ME =~ /(.+)\.rb$/
        base = $1
        puts "\033]0;mrdialog - #{base}\007"
      end
    end
    def initialize
        @hsh = {}
    end


    def show_warning
        msg = ''
        label = 'Username:'
        if @hsh[label].length == 0
            msg << "#{label} field is empty"
        end
        label = 'UID:'
        if @hsh[label].length == 0
            msg << "\n"
            msg << "#{label} field is empty"
        end
        label = 'GID:'
        if @hsh[label].length == 0
            msg << "\n"
            msg << "#{label} field is empty"
        end
        label = 'HOME:'
        if @hsh[label].length == 0
            msg << "\n"
            msg << "#{label} field is empty"
        end
        dialog = MRDialog.new
        dialog.title = "ERROR"
        dialog.clear = true
        dialog.msgbox(msg, 10, 41)
    end

    def form_filled?
        if @hsh['Username:'].length > 0 && 
           @hsh['UID:'].length > 0 &&
           @hsh['GID:'].length > 0  &&
           @hsh['HOME:'].length > 0
            return true
        end
        return false
    end

    def doit
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
In this example of form, if any field is empty a dialog
will POP show an error. The form will exit if Cancel
button is selectged or Esc key is pressed twice.
EOF

        @hsh['Username:'] = user 
        @hsh['UID:'] = uid.to_s
        @hsh['GID:'] = gid.to_s
        @hsh['HOME:'] = home

        flen = 60
        form_data = Struct.new(:label, :ly, :lx, :item, :iy, :ix, :flen, :ilen)

        # infinite loop. break out 
        # - if all the values of the form are filled in when OK button is pressed
        # - if Esc button is pressed twice
        loop do
            items = []
            label = "Username:"
            data = form_data.new
            data.label = label
            data.ly = 1
            data.lx = 1
            data.item = @hsh[label]
            data.iy = 1
            data.ix = 10
            data.flen = flen
            data.ilen = 0
            items.push(data.to_a)

            data = form_data.new
            label = "UID:"
            data.label = label
            data.ly = 2 
            data.lx = 1
            data.item = @hsh[label]
            data.iy = 2
            data.ix = 10
            data.flen = flen
            data.ilen = 0
            items.push(data.to_a)

            data = form_data.new
            label = "GID:"
            data.label = label
            data.ly = 3
            data.lx = 1
            data.item = @hsh[label]
            data.iy =3 
            data.ix = 10
            data.flen = flen
            data.ilen = 0
            items.push(data.to_a)

            data = form_data.new
            label = "HOME:"
            data.label = label
            data.ly = 4
            data.lx = 1
            data.item = @hsh[label]
            data.iy = 4
            data.ix = 10
            data.flen = flen
            data.ilen = 0
            items.push(data.to_a)

            dialog.title = "FORM"
            @hsh = dialog.form(text, items, 20, 60, 0)
            exit_code = dialog.exit_code
                @hsh.each do |key, val|
                    puts "'#{key}' = #{val}"
                end

            puts "Exit code: #{exit_code}"
            case exit_code
                when dialog.dialog_cancel
                    puts "Username: #{@hsh["Username:"]}"
                    puts "CANCEL"
                    break
                when dialog.dialog_esc
                    puts "Username: #{@hsh["Username:"]}"
                    puts "Escape.. exiting"
                    break
            end
            if !form_filled?
                show_warning
            else
                puts "Resulting data:"
                @hsh.each do |key, val|
                    puts "'#{key}' = #{val}"
                end
                break
            end
        end
    end
end

if __FILE__ == $0
    TestForm2.new.doit
end
