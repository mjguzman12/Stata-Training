************************************************************
************************************************************
*****STATA TRAINING 1 - BASIC SYNTAX AND IMPORTING DATA*****
************************************************************
************************************************************

*Welcome to Stata! Stata is a statistical software package that is used to
*analyze data. Stata was created in 1985 to compete with other statistical
*programs, and it has developed since then to become a full-fledged data
*analysis tool.

*Stata is used in many field including biomedicine, epidemiology, and
*economics. Without waxing too much poetic, Stata is possibly the strongest
*regression and statistical modelling software available. That being said,
*Stata can be used for many other purposes including data cleaning and
*descriptive analysis. These trainings will introduce you to the syntax, basic
*commands, and some not-so-basic commands that you will need to interface with
*Stata, and there is a wide variety of other content online that you can us to
*augment your understanding as well. With that, let's get started!


**********************
***GETTING ORIENTED***
**********************
*When using Stata, you will generally need to rely on two windows. The first
*window is the main console. This is the window that opens first when you
*open Stata. In the center, this window contains the console that provides
*the results of the commands you give to Stata. Just below this is the
*command line from which you can feed commands directly into the console. We'll
*work with this more later, but for now, just know that you can run short bits
*of code directly in that box.

*To the left, you will see the history pane. This provides a record of all
*commands that you have run during this session (note that it is blank if you
*haven't run any commands yet). Additionally, to the right is the data pane.
*This provides a list of the variables in the dataset you have open, and at the
*bottom, it provides some information about the dataset as well.

*Finally, we come to the window in which you're reading this text. This is a
*.do file. Stata code is written in .do files, whih is intended to be an
*intuitive name for code files (get it? This is what you want the computer to
*do). You will write most of your Stata code in windows like this.

*Notably, Stata only processes commands, and you are reading what is called
*a comment. A comment is text that the computer will ignore when running the
*commands in the .do file. You can invoke comments in Stata either by beginning
*a line with an asterisk * as is the case in this line, or,

/*you can create a multi-line comment using a forward slash followed by an
asterisk. Stata will interpret everything after this pattern as a comment
until it reaches the reverse pattern, an asterisk followed by a forward
slash: */

*In addition, you can also tell Stata to ignore a part of a line. This is accomplished
*by using three forward slashes ///. This will cause Stata to ignore the rest of the
*line including line breaks.


*****************
***FIRST STEPS***
*****************
*Everything not written in a comment is interpreted as a command in Stata.
*The first command we'll learn is the easiest: display. This simply displays
*whatever text you supply in the console. To run this, either highlight the
*line with your mouse and then press the "Do" button in the top right
*corner, or copy the text into the command line box in the main console:
display "Hello world!"

*If you just ran this command, then you should see the command in the console
*followed by the bold text "Hello world!"

*Two shortcut keys might be useful here. First is "ctrl-L": pressing these two
*keys will select the entire line, and this is quite useful when you're trying
*to run one line at a time. In addition, windows users can use "ctrl-D" to
*run one line without highlighting.


******************************
***IMPORTING DELIMITED DATA***
******************************
*Unlike other data science tools, Stata is really built to work with data right
*out of the box. Stata syntax emphasizes human readability and inutition. With
*that, importing data is truly as easy as the command "import". In the
*following line, we will import a "delimited" dataset:
import delimited "[PATH]/RawData/IPEDS Combined Data.csv"

*Let's break this down. Here, we used "import" followed by the word "delimited".
*Delimited specifies the type of file that we are importing, in this case, a
*CSV file. After this, we specified the file path of the file that we wanted
*to import.

*Once you run the line above, you should see the results in the console. As
*with the display command that we used before, Stata prints the command in the
*console. Note that this particular command doesn't create any output, although
*Stata will print helpful notes about the command in the console as well.

*Now that the dataset is imported, you can view it and edit it in many different
*ways. First, take a look at the data pane in the main console. While this was
*originally blank, this now contains a list of the variables in your data. Stata
*intuited these from the first row of the file that you just imported. To
*see the actual data that these variables comprise, type "browse":
browse

*With this command, a simple data viewer will appear and show you the raw data.
*Nothing fancy here - this is just the data that you imported. Much like
*Microsoft Excel or Google Sheets, you can scroll to view all of the columns
*and rows in the data.

*Now that you have a handle on importing data, let's introduce a little more
*import syntax. While the command above works, you will generally want to add
*a few more specifications to the command to ensure that Stata imports as you
*directed. Here is another import command that does virtually the same thing,
*albeit with a little more specificity:
import delimited "[PATH]/RawData/IPEDS Combined Data.csv", varnames(1) case(lower) clear

*Here, we added the following 3 specifications:
*****varnames: this specification tells Stata from which row to read the
	*variable names. Stata defaults to using the first row, but this could be
	*the second or third row depending on your data.
	
*****case: this specification indicates the case that you want your variables
	*to have, either upper or lower. This is a nice specification because you
	*won't need to worry about your variable names later on, although it is
	*is a preference which case you choose
	
*****clear: this specification tells Stata to clear any existing data from
	*memory. Note that we always need to use this specification if we have
	*data in working memory.

*While the varnames and case specifications are optional in this example, the
*clear specification is required. Let's see what happens if you run exactly the
*same command without clear:
import delimited "[PATH]/RawData/IPEDS Combined Data.csv", varnames(1) case(lower)

*In this case, Stata does not run the command and provides an error: "no; data
*in memory would be lost." This is to prevent an analyst from accidentally
*erasing data from memory.

*Notably, this represents an important distinction between Stata and other data
*science tools. Unlike other tools such as R and SAS, if a command doesn't work,
*Stata will stop immediately and provide an error message. Other tools will
*continue to run code, but Stata won't run anything after the errant line if
*it identifies an issue.


**************************
***IMPORTING EXCEL DATA***
**************************
*Now that you have delimited data down, let's move on to Excel data. This is in
*fact just as easy as importing delimited data:
import excel "[PATH]/RawData/fy2021_safmrs_revised.xlsx", clear

*Here, we just changed "delimited" to "excel" and then used the file path of an
*Excel file. If you look at the data viewer, you'll note that the variable
*names didn't read in properly. Using a few more specifications, we can ensure
*that these are read in cleanly:
import excel "[PATH]/RawData/fy2021_safmrs_revised.xlsx", firstrow case(lower) clear

*Note that the "firstrow" specification is slightly different from the
*"varnames" specifcation that we were able to use in the delimited command
*above. Nevertheless, it accomplishes essentially the same thing by simply
*specifying that the first row should be used as the variable names.

*Congratulations on finishing your first Stata training! Go on to the next
*lesson to learn more about variables and data manipulation.


***************
***TAKEAWAYS***
***************
*1) Comments bit of text that are not interpretted by the computer
*2) We can import text-delimited data using the import command:
import delimited "[PATH]/RawData/IPEDS Combined Data.csv", varnames(1) case(lower)

*3) We can also import Excel data using the import command:
import excel "[PATH]/RawData/fy2021_safmrs_revised.xlsx", firstrow case(lower) clear




