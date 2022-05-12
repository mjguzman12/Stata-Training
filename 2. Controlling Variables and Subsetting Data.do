**********************************************************************
**********************************************************************
*****STATA TRAINING 2 - CONTROLLING VARIABLES AND SUBSETTING DATA*****
**********************************************************************
**********************************************************************

*Welcome to Stata Training 2 - Controlling Variables and Subsetting Data! In
*this lesson, we will dive in to how to subset columns, create variables,
*edit variables, and subset observations. Let's get started!


**************************
***SUBSETTING VARIABLES***
**************************
*As before, we need to import some data before we get started. Here, we'll use
*the delimited data that we imported in Lesson 1:
import delimited "[PATH]/RawData/IPEDS Combined Data.csv", varnames(1) case(lower) clear

*Recall that this command imports the data, uses the first row of the data as
*the variable names, ensure that the case of these variables is lower, and
*clears data that we had used previously.

*Now, the first thing that most analysts want to do after importing data is to
*subset the data to the parts that they care about. This is a strategy to
*cut down the amount of data you need to view, process, and edit for your
*project. 

*In order to subset to only particular variables that you need, you can use
*either the "keep" command to keep specific variables in the data, or you can
*use the "drop" command to remove specific variables. Here, we subset to the
*following seven variables:
keep unitid instnm roomamt boardamt school_type instruction_expenses research_expenses

*If you browse the data or look at the data pane in the main console, you will
*see that only these seven variables remain in the data. Note that you have
*not deleted data, just removed the data from Stata's working memory. The
*original data won't be changed until you save over the file.

*Now, we will remove other variables using a "drop" command:
drop school_type instruction_expenses research_expenses

*As before, you will note in the data pane and if you browse the data that
*these variables are no longer contained in the working dataset.


************************
***CREATING VARIABLES***
************************
*Oftentimes when analyzing data, we will want to create new variables. These
*will often represent something based on other variables, or we will create
*them as helpers for certain steps in our analysis. Creating variables is
*thankfully just as intuitive as removing them. This uses the "generate"
*command:
generate example1 = 1

*In the command above, we created an variable entitled "example_variable"
*equal to 1 for all observations. Note that there are some restrictions on this
*variable name. It can't include spaces, hyphens, or other special characters,
*and it can't also be the name of another variable. Also, the "generate"
*command is typically abbreviated for ease, so you will typically see this
*command written as:
gen example2 = 2

*This is a good place to introduce the concept of variable "types". If you've
*ever worked with data in Excel, you might have noticed that cells that only
*contain numbers are right-justified by default and cells that contain text are
*left-justified by default. Here, Excel is sensing that these cells contain
*different types of information: one contains numeric information, and the other
*contains text information. In Excel, any cell can contain a number or text, but
*Stata is much more strict about this. Every column or variable in Stata has
*one type, and every observation in that column has that type. This implies
*that you cannot have numeric and text data in the same column - it must all
*be one type or the other.

*To illustrate this, the variables that we created above were both numeric
*variables - every observation was a number. As they are both numbers, we
*can do things like add and subtract them. In the following command, we
*create another new variable equal to example2 minus example1:
gen addition_example = example2 + example1

*If you browse the data, you will see that the "addition_example" variable is
*equal to 3.

*Now, let's create a text variable, also known as a "string" variable:
gen string_example1 = "Example text"

*This variable contains the text "Example text" for every observation. See what
*happens if you attempt to add the string example to the example1 variable:
gen test = string_example1 + example1

*Here, Stata gives a "type mismatch" error. This is to say that the two
*variables are different types and you cannot combine them in that way.
*One note is that numbers CAN be treated as text or strings if you specify them
*that way. The following example variable is a string, but it is composed
*entirely of numbers:
gen string_example2 = "12345"

*All of the characters are numbers, but Stata is treating the variable as text.
*Note that we ARE allowed to add two string variables - this will simply
*concatenate the two:
gen string_example3 = string_example1 + string_example2

*If you browse the data, you will find that string_example3 is comprised
*entirely of the value "Example text12345"

*Now, let's cleanup to ensure that our dataset doesn't become unwieldy:
drop example1 example2 addition_example string_example1 string_example2 string_example3


***********************
***EDITING VARIABLES***
***********************
*Now that you're comfortable we creating new variables, let's learn about how
*to edit existing ones. The most basic example of this is complete changing one
*variable to another. Here, we will create a new variable equal to 1, then
*convert it to a variable equal to 10:
gen new_example = 1

replace new_example = 10

*To change the "new_example" variable, we used the "replace" command. The
*syntax for this command is just like "generate" - you simple write the
*variable name followed by equals whatever value you want. Note that you
*cannot change types in this command. The variable must remain either
*a string or a numeric.

*Now, what if you only want to edit some values of a variable? For example,
*say that we only want to change the first 100 values of new_example to 100.
*In this case, we could use the "in" syntax to specify the row or rows in which
*we want to make a change. The first command changes the 10th observation of
*new_example to equal 100, and the second command changes all observations
*between 1 and 100 to equal 100:
replace new_example = 100 in 10

replace new_example = 100 in 1/100

*Note that Stata reports in the console how many observations each of these
*commands edits.

*Going one step further, what if you want to edit variables based on the value
*of another variable? This is called "conditionally editing variables", and
*Stata makes this easy using the "if" syntax. In the next line, we will edit 
*the "roomamt" variable to be blank if it equals the text "NA". This will only 
*affect cells that only contain the text "NA":
replace roomamt = "" if roomamt == "NA"

*Let's break down the second part of this command. Here, we edited the "roomamt"
*variable by changing it to "" or a blank string if it equalled "NA". Following
*the regular "replace" command, we used "if" variable name == value. The key
*here is that we used a double equals sign. This means that we are EVALUATING
*whether this statement is true, that is, whether roomamt is in fact equal to
*"NA". The "if" part of the command requires something that can be evaluated,
*that is, something that is either true or false.

*If you browse the data before and after you run the command above, you will be
*able to see the different in the "roomamt" variable. It used to contain some
*values of "NA", but now these are blank. As this variable now only contains
*numbers stored as text, we can now CONVERT its type using the destring command.
*This command will check whether all characters in the variable are numbers,
*and then it will change the type of the variable to numeric:
destring roomamt, replace

*Note that roomamt is now a numeric variable. Additionally, we needed
*to specify "replace" in the command above. As with importing data, this
*specification is required like "clear" to ensure that we don't accidentally
*overwrite data.

*Now that we have edited and changed the type of roomamt, let's do the same
*manipulation for the "boardamt" variable:
replace boardamt = "" if boardamt == "NA"
destring boardamt, replace

*At this point, we have now edited roomamt and boardamt such that they are
*both numeric variables, and we can now add them in the generate command
*below:
gen room_board_cost = roomamt + boardamt

*Note that the main console provides a note that 7,350 observations were filled
*with missing values. This is because one or both of the constituent variables
*were "missing", or blank.

*cleanup
drop new_example


*********************
***SUBSETTING DATA***
*********************
*The final part of this lesson will be how to subset data. This uses much of
*this same keep/drop syntax that you have used up to this point, and we will
*pepper in some of the "if" syntax that you developed in the last section.

*To subset to specific observations, we can either use the "keep" syntax:
keep if room_board_cost != .

*Here, we are instructing Stata to keep all observations for which the 
*"room_board_cost" variable is NOT EQUAL to missing. Note the use of the
*exclamation point followed by the equals sign to say not equal, and the use
*of a period to symbolize a missing observation.

*An alternative way to subset observations is by using the "drop" syntax:
drop if room_board_cost < 500

*This command removes any observation for which the room_board_cost variable
*is less than 500.

*Finally, note that you can also keep and drop observations for particular
*ranges. This relies on the "in" syntax that we introduced above. The following
*command subsets to the first 100 observations in the data:
keep in 1/100


*******************
***KEY TAKEAWAYS***
*******************
*1) We can select variables using the "keep" and "drop" commands
drop room_board_cost
*2) We can create new variables use the "gen" syntax
gen new_new_example = "This is an example"
*3) Variables in Stata must be either string or numeric types - no mixing and matching
*4) We can edit variables using the "replace" syntax, and this is often used with "if"
replace new_new_example = "This is another example" in 1/50
*5) We can also subset observations using the "keep" and "drop" commands
drop in 1/10



