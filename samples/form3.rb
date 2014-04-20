#!/usr/bin/env ruby

########################################################################
# Culculate the max length of key as the x for the item
########################################################################
require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')
require 'pp'

class TestForm
           ME = File.basename($0)
      HIDDEN  = 1 
    READ_ONLY = 2
  def initialize
    @a = []
    @h = {}
  end

  def populate_data
    @a << "Base DN: "
    @a << "LDAP URI: "
    @a << "LDAP Version: "
    @a << "LDAP Bind DN: "
    @a << "LDAP Bind Password: "
    @a << "Login Attribute: "

    @h[@a[0]] = "dc=example,dc=com"
    @h[@a[1]] = "ldap://192.168.1.1:389"
    @h[@a[2]] = "3"
    @h[@a[3]] = "cn=Mary Jane, cn=Users, dc=example, dc=com"
    @h[@a[4]] = "secret"
    @h[@a[5]] = "sAMAccountName"
  end

  def max_key_len
    len = 0
    @a.each do |v|
      if v.length > len
        len = v.length
      end
    end
    return len
  end

  def show_form
    items = []
    form_data = Struct.new(:label, :ly, :lx, :item, :iy, :ix, :flen, :ilen, :attr)

    ly = 1
    lx = 1
    iy = 1
    ix = max_key_len
    flen = 1024
    @a.each do |key|
      data = form_data.new
      data.label = key
      data.ly = ly
      data.lx = lx
      data.item = @h[key]
      data.iy = ly
      data.ix = ix
      data.flen = flen
      data.ilen = 0
      if key =~ /password/i
        data.attr = HIDDEN
      else
        data.attr = 0
      end
      items.push(data.to_a)
      ly = ly + 1
    end

    dialog = MRDialog.new
    dialog.logger = Logger.new(ENV["HOME"] + "/dialog_" + ME + ".log")
    dialog.clear = true
    dialog.insecure = true
    dialog.title = "MIXEDFORM"

    text = <<EOF
In this example of mixedform, the x co-ordinate of the items
are calculated dynamically. The longest value among the keys
is the x value for the items.
EOF
    height = 20
    width = 70
    result_hash = dialog.mixedform(text, items, height, width, 0)
  end

  def doit
    populate_data               
    show_form
  end
end

if __FILE__ == $0
    TestForm.new.doit
end
