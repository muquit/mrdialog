#!/usr/local/bin/macruby

########################################################################
# This script runs on mac....
#
# A tiny ruby script for myself to take screenshots of the sample apps
# terminal window automatically. I run run_all.rb script from the samples 
# directory and then run this script. This script find out the window by 
# the title and take a screenthot and kill the dialog for the next app.
#
# muquit@muquit.com Apr-26-2014 
########################################################################

framework 'Foundation'
framework 'ScriptingBridge'

class TakeScreenShots
  def initialze
    $stderr.sync = true
    $stdout.sync = true
    @app_name = ''
    @window_id = ''
  end

  def log(msg)
    d = Time.new
    puts "[#{d}]: #{msg}"
  end

  #------------------------------------------------- 
  # check if any mrdialog app is running, if so
  # populate @window_id and @app_name. They will be
  # used to capture the window.
  #------------------------------------------------- 
  def find_app
    terminal = SBApplication.applicationWithBundleIdentifier("com.apple.Terminal")
    terminal.windows.each do |window|
      title = window.name
      id = window.id
      encoding_options = 
      {
        :invalid           => :replace,
        :undef             => :replace,
        :replace           => '',
        :universal_newline => true
      }
      title = title.encode(Encoding.find('ASCII'),encoding_options)
      if title =~ /samples\s+mrdialog - (.+)\s+dialog.*$/i
        @app_name =  $1
        @app_name = @app_name.gsub(/\s/,'')
        @window_id = id
        return true
        break
      end
    end
    return false
  end

  def doit
    loop do
      rc = false
      @window_id = ''
      @app_name = ''
      log "\n***Checking if any mrdialog app is runing..."
      mx = 10
      0.upto(mx) do |t|
        @window_id = ''
        @app_name = ''
        log " Try: #{t}/#{mx}"
        rc = find_app
        break if rc
        sleep 2
      end
      if !rc
        log "Error: Could not find any mrdiag sample app..."
        exit 1
      end
      log "Found app: #{@app_name}"
      log "Window id: #{@window_id}"
      c = 0
      pid = ''
      # kill the program after taking the screenshot
      log "Trying to find the PID of dialog.."
      loop do
        c = c + 1
        pid=`pidof dialog`
        if pid.length == 0
          print "c: #{c}"
          exit if c >= 5
          print "#"
          sleep 2
        end
        break if pid.length > 0
      end #end loop
      log "Found PID: #{pid}"
      next if pid.length == 0
      log "Taking screenshot of widget: #{@app_name}"
      cmd = "screencapture -o -l #{@window_id} #{@app_name}.png"
      log "Command: #{cmd}" 
      system(cmd)
      log "Kill dialog with PID: #{pid}"
      system("kill #{pid}")
      log "Sleeping 5 secs"
      sleep 3
    end
  end
end

if __FILE__ == $0
  TakeScreenShots.new.doit
end
