### MRDialog

mrdialog is a pure ruby library for the ncurses dialog program. dialog is
a command line tool that can present questions, messages, forms using 
dialog boxes from a shell script. However, it is painful to program dialog
from shell scripts due to lack of data structure etc. You constantly have
to watch if the correct number of items are specified, if the arguments 
are in correct order for example. 

MRDialog is based on the rdialog ruby gem http://rdialog.rubyforge.org/ by
Aleks Clark.



I added support for all of the missing widgets, fixed bugs, implemented 
the examples for all the widgets.  Please look at the ChangeLog.md file 
for details.

**For now, please look at the examples in the "samples" directory to see 
how the API works.**

**TODO** write the API document here

### Requirements

* dialog must be installed. dialog home is: http://invisible-island.net/dialog/dialog.html. Note: the dialog program that is available in ubuntu is little old.

### To install

    # gem install mrdialog
    or
    $ sudo gem install mrdialog
   
### Sample apps
Find out where the mrdialog gem is installed. Go to the directory samples and run the apps.
Example:

    $ gem which mrdialog
    /Library/Ruby/Gems/2.0.0/gems/mrdialog-1.0.1/lib/mrdialog.rb
    $ cd /Library/Ruby/Gems/2.0.0/gems/mrdialog-1.0.1/samples
    $ ./msgbox.rb

### Screenshots
Please look at the [screenshots](screenshots/) directory. There are individual screenshots for each of the widget. Also the animated GIF file [all.gif](screenshots/all.gif) contains all the widgets.

### How to use
For now please look at the apps in [samples](samples/) directory. I will document the API here as time permists.

### For Developers
- To build
    $ rake build

Will create the gem inside the pkg directory

- To install the built gem
    
    $ sudo gem install --local pkg/mrdialog-1.0.1.gem

- To install using rake
  
    ```$ sudo rake install```

- To install the gem to a specific directory:
 
    $ GEM_HOME=/tmp gem install --local pkg/mrdialog-1.0.1.gem

The gem will be installed in /tmp/gems directory

### Copyright
mrdialog is based on rdialog ruby gem. The original license or rdialog is MIT and my code is also free to use under the
terms of the MIT license. Please look at the [LICENSE.txt](LICENSE.txt) file for details.
