#!/usr/bin/env ruby
########################################################################
# Calculate the max length of key as the x for the item
########################################################################
require [File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'mrdialog'].join('/')
require 'pp'

class TestForm
  ME = File.basename($0)
  HIDDEN  = 1 
  READ_ONLY = 2
  
  if ENV['CHANGE_TITLE']
    if ME =~ /(.+)\.rb$/
      base = $1
      puts "\033]0;mrdialog - #{base}\007"
    end
  end
  
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
    ix = max_key_len + 2  # Add some padding
    flen = 40  # More reasonable field length
    
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

Try entering special characters in the password field:
Examples: p@ss'word, test"123, my$pass`word, etc.
EOF
    
    height = 20
    width = 70
    result_hash = dialog.mixedform(text, items, height, width, 0)
    
    # Return the result_hash so doit can use it
    return result_hash
  end
  
  def doit
    populate_data               
    result_hash = show_form
    
    # Display the results
    if result_hash
      puts "\nForm Results:"
      puts "=" * 50
      result_hash.each do |key, value|
        puts "#{key} => #{value}"
      end
      
      # Check if password contains special characters
      password_key = @a.find { |k| k =~ /password/i }
      if password_key && result_hash[password_key]
        password = result_hash[password_key]
        puts "\n" + "=" * 50
        puts "Password Analysis (for testing only!):"
        puts "Password entered: '#{password}'"
        puts "Length: #{password.length}"
        
        special_chars = password.scan(/[^a-zA-Z0-9]/)
        if special_chars.any?
          puts "Special characters found: #{special_chars.uniq.join(', ')}"
        else
          puts "No special characters found"
        end
        
        # Test for problematic characters
        if password.include?("'")
          puts "✓ Contains apostrophe - testing quote handling"
        end
        if password.include?('"')
          puts "✓ Contains double quote - testing quote handling"  
        end
        if password.include?('$')
          puts "✓ Contains dollar sign - testing variable expansion prevention"
        end
        if password.include?('`')
          puts "✓ Contains backtick - testing command substitution prevention"
        end
      end
    else
      puts "\nForm was cancelled"
    end
  end
end

if __FILE__ == $0
  TestForm.new.doit
end