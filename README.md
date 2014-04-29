### MRDialog

mrdialog is a pure 
[ruby](https://www.ruby-lang.org/) library for the ncurses 
[dialog](http://invisible-island.net/dialog/dialog.html) program. 
[dialog](http://invisible-island.net/dialog/dialog.html) is
a command line tool that can present questions, messages, forms using 
dialog boxes from a shell script. If you compiled linux kernel and typed 'make
menuconfig, configured Linux from command line with various configuration
managers, you have used 'dialog' like programs.

However, it is painful to program dialog from shell scripts due to lack of 
data structure. You constantly have to watch if the correct number of 
items are specified, if the arguments are in correct order for example. It is
a lot of fun to program dialog from an object oriented scripting language like 
[ruby](https://www.ruby-lang.org/). Compare the sample shell scripts of dialog program with
the sample ruby scripts of mrdialog in the [samples](samples/) directory, I think you will
agree.

MRDialog is based on the rdialog ruby gem http://rdialog.rubyforge.org/ by
Aleks Clark.

I did the following:

* Added features and support for all of the missing widgets.
* Fixed the bugs I found.
* Implemented the examples for all the widgets.  
* I am in the process of documenting the APIs here.

Please look at the [ChangeLog.md](ChangeLog.md) file for details. Please look at he [screenshots](screenshots/) to see how the widgets look like.

If you have bug reports, questions, requests or  suggestions, please enter it in the [Issues](https://github.com/muquit/mrdialog/issues) with an appropriate label.

### Screenshots
Please look at the [screenshots](screenshots/) directory. There are individual screenshots for each of the widgets. Also the animated GIF file [all.gif](screenshots/all.gif) contains screenshot of  all the widgets. 


### Requirements
The [dialog](http://invisible-island.net/dialog/dialog.html) program must be installed. d Note: the dialog program that is available in ubuntu is little old. Check the dialog version by typing ```dialog --version```

I tested with ```dialog Version: 1.2-20130928```

dialog HOME: http://invisible-island.net/dialog/dialog.html.

### To install

```# gem install mrdialog```
or
```$ sudo gem install mrdialog```
### To uninstall
```# gem uninstall mrdialog``` or ```$ sudo gem uninstall mrdialog```
   
### Run the sample apps
Find out where the mrdialog gem is installed. Example:

    $ gem which mrdialog
    /Library/Ruby/Gems/2.0.0/gems/mrdialog-1.0.1/lib/mrdialog.rb

```cd``` to the ```samples``` directory and run the apps.
Example:

    $ cd /Library/Ruby/Gems/2.0.0/gems/mrdialog-1.0.1/samples
    $ ./msgbox.rb


### How to use the API
For now, please look at the apps in [samples](samples/) directory to see how the API works. I will document the APIs here as time permits.

    require 'mrdialog'
    dialog = MRDialog.new

#### Properties
The various properties of the dialog (shadow, title etc.) can be set by calling the appropriate setters. The supported propertes are shown below:

|Property|Example|Description|Default|
|--------|-------|-----------|-------|
|shadow|```dialog.shadow = false``` | Draw a shadow to the right and bottom of each dialog box.| true|
|title|```dialog.title = 'foo'```|Specifies a title string to be displayed at the top of the  dialog box|N/A|
|logger|```dialog.logger = Logger.new("dialog.log")```|Debug messages will be logged to the specified ruby Logger|N/A|
|clear|```dialog.clear = true```|Clears the widget screen, keeping only the screen_color background.|false|
|insecure|```dialog.insecure = true```|Makes the password widget friendlier but less secure, by echoing asterisks for each character.|false|
|ascii_lines|```dialog.ascii_lines = true```|Rather than draw graphics lines around boxes, draw ASCII "+" and "-" in the same place.  See also "--no-lines".|false|
|...|...|...|...|

#### Widgets
The following dialog widgets are supported:

* buildlist
* calendar
* checklist
* editbox
* form
* fselect
* gauge
* infobox
* inputbox
* menu
* msgbox
* passwordbox
* passwordform
* pause
* prgbox
* progressbox
* programbox
* radiolist
* timebox
* treeview
* yesno
    
##### buildlist
A  buildlist  dialog displays two lists, side-by-side.  The list on the left shows unselected items.  The list on the right shows selected  items.  As items are selected or unselected, they move between the lists. The SPACE bar is used to
select or unselect an item.

Use a carriage return or the "OK" button to accept  the  current value  in the selected-window and exit.  The results are written using the order displayed in the selected-window. The caller is responsible to create the items properly. Please look at [buildlist.rb](samples/buildlist.rb) for an example.

returns an array of selected tags

    result_array = dialog.buildlist(text="Text Goes Here", items, height=0, width=0, listheight=0)
   
#### calendar
Please look at [calendar.rb](samples/calendar.rb) for an example.
#### checklist
Please look at [checklist.rb](samples/checklist.rb) for an example.
#### editbox
Please look at [editbox.rb](samples/editbox.rb) for an example.
#### form
Please look at 
[form1.rb](samples/form1.rb), [form2.rb](samples/form2.rb), [form3.rb](samples/form3.rb) 
for examples.
#### fselect
Please look at [fselect.rb](samples/fselect.rb) for an example.
#### gauge
Please look at [gauge.rb](samples/gauge.rb) for an example.
#### infobox
Please look at [infobox.rb](samples/infobox.rb) for an example.
#### inputbox
Please look at [inputbox.rb](samples/inputbox.rb) for an example.
#### menu
Please look at [menubox.rb](samples/menubox.rb) for an example.
#### msgbox
Please look at [msgbox.rb](samples/msgbox.rb) for an example.
#### passwordbox
Please look at [password.rb](samples/password.rb), [password2.rb](samples/password2.rb)
for examples.
#### passwordform
Please look at [passwordform.rb](samples/passwordform.rb) for an example.
#### pause
Please look at [pause.rb](samples/pause.rb) for an example.
#### prgbox
Please look at [prgbox.rb](samples/prgbox.rb) for an example.
#### progressbox
Please look at [progressbox.rb](samples/progressbox.rb) for an example.
#### programbox
Please look at [programbox.rb](samples/programbox.rb) for an example.
#### radiolist
Please look at [radiolist.rb](samples/radiolist.rb) for an example.
#### timebox
Please look at [timebox.rb](samples/timebox.rb) for an example.
#### treeview
Please look at [treeview.rb](samples/treeview.rb) for an example.
#### yesno
Please look at [yesno.rb](samples/yesno.rb) for an example.

### For Developers
- To build: ```$ rake build```

Will create the gem inside the pkg directory

- To install the built gem: ```$ sudo gem install --local pkg/mrdialog-1.0.1.gem```

- To install using rake: ```$ sudo rake install```

- To install the gem to a specific directory: ```$ GEM_HOME=/tmp gem install --local pkg/mrdialog-1.0.1.gem```

The gem will be installed in /tmp/gems directory

### Copyright
Lincense is MIT. Please look at the [LICENSE.txt](LICENSE.txt) file for details.
