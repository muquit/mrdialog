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


### Requirements

* dialog must be installed. dialog home is: http://invisible-island.net/dialog/dialog.html. Note: the dialog program that is available in ubuntu is little old.

### To install

    ```# gem install mrdialog```
    or
    ```$ sudo gem install mrdialog```
   
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
For now, please look at the apps in [samples](samples/) directory to see how the API works. I will document the API here as time permists.

    require 'mrdialog'
    dialog = MRDialog.new

#### Properties
The various properties of the dialog (shadow, title etc.) can be set by calling the appropriate setters.

TODO

#### Widgets
    
##### buildlist
A  buildlist  dialog displays two lists, side-by-side.  The list on the left shows unselected items.  The list on the right shows selected  items.  As items are selected or unselected, they move between the lists. SPACE bar is used to
select or unselect an item.

Use a carriage return or the "OK" button to accept  the  current value  in the selected-window and exit.  The results are written using the order displayed in the selected-window. The caller is responsile to create the items properly. Please look at [buildlist.rb](samples/buildlist.rb) for an example.

returns an array of selected tags

    result_array = dialog.buildlist(text="Text Goes Here", items, height=0, width=0, listheight=0)
   
#### calendar
TODO
#### checklist
TODO
#### editbox
TODO
#### form
TODO
#### fselect
TODO
#### gauge
TODO
#### infobox
TODO
#### inputbox
TODO
#### menu
TODO
#### msgbox
TODO
#### passwordbox
TODO
#### pause
TODO
#### prgbox
TODO
#### progressbox
TODO
#### programbox
TODO
#### radiolist
TODO
#### timebox
TODO
#### treeview
TODO
#### yesno
TODO
### For Developers
- To build
    ```$ rake build```

Will create the gem inside the pkg directory

- To install the built gem
    
    ```$ sudo gem install --local pkg/mrdialog-1.0.1.gem```

- To install using rake
  
    ```$ sudo rake install```

- To install the gem to a specific directory:
 
    ```$ GEM_HOME=/tmp gem install --local pkg/mrdialog-1.0.1.gem```

The gem will be installed in /tmp/gems directory

### Copyright
mrdialog is based on rdialog ruby gem. The original license or rdialog is MIT and my code is also free to use under the
terms of the MIT license. Please look at the [LICENSE.txt](LICENSE.txt) file for details.
