## 1.0.7
* If any text had single quote in it e.g. "don't", "It's", the dialog 
command was failing with syntax error. In previsous version, the dialog 
command was wrapped with single quotes but now shell escape the values. 
Note: this is a parsing bug fix, not a security issue. Thanks to Carl for 
finding this bug.

(Oct-18-2025)

* If no item was selected in a checklist, an EOF exception was thrown. Now
return false in that case.

* Update checklist example to get selected item in an array. Before the items
were in an array with 1 element.

(Jan-23-2024)

## 1.0.6
* Ruby 3.2.0 removed File.exists? method. Change to File.exist?

## 1.0.5
* Wrap values inside single quotes indead of double quotes. If saved values
are reloaded in a form, special shell characters could get expanded and
corrupt data.  Please update to v1.0.5.
(Mar-15-2023)

## 1.0.4
* Previously only the OK/Yes button read input from forms, menus and lists.
If an extra button is used, it was treated the same as the Cancel/No 
button, and no output from the form/menu/list was returned to the caller.

This PR changes the various user input dialogs to treat the Extra button 
the same way as the OK/Yes button, and to return the dialog's input to the 
caller.

Thanks to https://github.com/OtherJohnGray for pull request.

(Jun-22-2022)


## 1.0.3
* Added accessor `rc_file`. It specifies the DIALOGRC file to use.  Default is $HOME/.dialogrc
* Added accessor `cancel_label`. It specifies the label to use for the 'Cancel' button. 
* Added accessor `yes_label`. It specifies the label to use for the 'Yes' button.
* Added accessor `no_label`. It specifies the label to use for the 'No' button.
* Added accessor `help_button`. It specifies that a help button should be added to the dialog.
* Added accessor `help_label`. It specifies the label to use for the 'Help' button.
* Added accessor `extra_button`. It specifies that an extra button should be added to the dialog. 
* Added accessor `extra_label`. It specifies the label to use for the 'Extra' button.
* Fully implemented @exit_code. The @exit_code variable wasn't being set on all dialog styles.

## 1.0.2

* Added accessor `notags`. It can be used with checklist for example. The default value is false.

 ```
 dialog = MRDialog.new()
 dialog.notags = true
 ```
* Added accessor `dialog_options`. It can be used to pass any valid dialog option. `man dialog` and look at the **OPTIONS** section. It is the caller's responsibily to specify correct options, no validation will be done. Example:

```
dialog = MRDialog.new()
dialog.dialog_options = "--no-tags"
```
This ia exactly same as `dialog.notags = true`

(Apr-16-2016 )

## 1.0.1

* Juwelier support for making the gem.

Implemented methods for: 

*  'buildlist' (--buildlist)
*  'editbox' (--editbox)
*  'form' (--form)
*  'gauge' (--gauge). Thanks to Mike Morgan.
*  'mixedform' (--mixedform)
*  'passwordform' (--mixedform)
*  'pause' (--pasue)
*  'prgbox' (--prgbox)
*  'progressbox' (--progressbox)
*  'progambox' (--programbox)
*  'treeview' (--treeview)

* Added accessors:
    "logger", "clear", "ok_label <label>", "insecure", "ascii_lines"
* Added methods to check dialog's exit code
    dialog_ok, dialog_cancel, dialog_help, dialog_extra,
    dialog_item_help, dialog_esc

Implemented examples for:

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
* pause
* prgbox
* progressbox
* programbox
* radiolist
* timebox
* treeview
* yesno

Note: The examples use Struct class, making the examples clean and 
easy to understand. 


# bug fixes:

* raise exception if 'dialog' program is not found.
* title in the option string was not quoted
* timebox syntax is different now.
etc..

-- muquit@muquit.com , Apr-05-2014, first cut

## 0.5.0

* original base code
