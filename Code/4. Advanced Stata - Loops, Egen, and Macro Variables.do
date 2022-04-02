*****************************************
*****************************************
*****STATA LESSON 4 - ADVANCED STATA*****
*****************************************
*****************************************

clear
set more off
set excelxlsxlargefile on

global path = "[PATH]"
global raw = "$path/RawData"
global intermed = "$path/IntermediateData"
global createdate = "20220111"


*Welcome to Stata Lesson 4! You're doing great. You now have all of the tools
*to analyze data. This lesson is going to introduce some advanced Stata syntax
*to help you analyze data a little faster. That being said, you already have
*all of the concepts down for this lesson, so this should be a little easier
*than Lesson 3. Here, we're going to learn about loops, egen commands, and
*global and local macros. As a bonus, we'll throw in some tidbits about
*preserve and restore syntax too!


***********
***LOOPS***
***********
*Let's kick this lesson off by learning about loops in Stata. In case you're
*not familiar with them, loops are simply bits of code that do the same thing
*multiple times. To illustrate this, let's re-import the IPEDS dataset that
*we've been using.
import delimited "$raw/IPEDS Combined Data.csv", varnames(1) case(lower) clear

*Now, take a look at the roomamt, boardamt, and rmbrdamt variables. These three
*variables are saved as character or string variables, but they contain numeric
*information. See what happens when you try to convert these three variables
*from string to numeric:
destring roomamt, replace
destring boardamt, replace
destring rmbrdamt, replace

*If you look in the main console, you will note that Stata provided the
*following message after each of these three commands: "contains nonnumeric
*characters; no replace". Browsing these variables, you will notice that each
*of them contain "NA" as well as numbers. This is a standard challenge in data
*science. Oftentimes, raw datasets will code missing numeric variables as "NA"
*instead of as a missing observation. we can correct this using the replace
*command:
replace roomamt = "" if roomamt == "NA"

*once we make this replace, we can then convert the roomamt variable to a
*numeric variable:
destring roomamt, replace

*All of this is review from Lesson 2. However, you will note that in this case,
*we have three variables for which we want to replace "NA"s and convert to
*numeric variables. Rather than doing these in separate commands, it is a
*better practice to conduct this type of manipulation in a loop.

*There are two types of loops in Stata: foreach and forvalues loops. Let's use
*a foreach loop to edit the remaining two variables:
foreach var in boardamt rmbrdamt {
	replace `var' = "" if `var' == "NA"
	destring `var', replace
}

*Let's break this down. Working from inside to out, you will notice that the
*two commands inside the brackets of this loop are the same as those that we
*ran before with roomamt. In this case though, the variable name is replaced
*with a back quote `, the word "var", and a single straight quote '. This is
*the loop macro variable: this will take on the form of whatever is supplied in
*the outside loop. In this case, we are running the loop over boardamt and
*rmbrdamt, so `var' will become these variables when you run the loop.

*To make the syntax a little more general, a loop is comprised of a foreach
*command that specifies the name of the loop macro variable (var in the example
*above, but it could be anything), the word "in", and a list of what you're
*looping over. Following this, there is an opening bracket { followed by
*the commands that you want to run. At the end of all of these commands, you
*will "close the loop" by typing a closing bracket }

*In addition to foreach loops, there is another type of loop called a forvalues
*loop in Stata. You can think of this as the numeric counterpart to foreach.
*Forvalues loops over numbers in a specific range. We can do a very similar
*manipulation to the one above using a forvalues loop on grtype8 and grtype9.
*Note that these two variables have sequential numbers at the end which
*distinguish them. This quality makes them strong contenders for use in a
*forvalues loop:
forvalues i = 8/9 {
	replace grtype`i' = "" if grtype`i' == "NA"
	destring grtype`i', replace
}

*In this case, the inner part of the loop looks exactly the same as in our
*first example. Nevertheless, the outside of the forvalues loop looks a little
*different. Now, we have a new loop macro variable i that we set EQUAL to 8/9.
*This syntax says values between 8 and 9, and when we supply this macro
*variable to Stata, it reads it as either 8 or 9 to create the variable names
*grtype9 and grtype9.

*As with reshaping and merging, loops take some time to get used to. The syntax
*to use the macro variables isn't super intuitive. That being said, Stata loops
*are known to be extremely powerful. You don't need to just reference variables
*as these examples do. Rather, you can reference anything you want including
*strings and other numbers. Experiment for yourself a bit with this dataset to
*get the hang of this syntax, perhaps using hospital_expenses and other_expenses
*as a bit of practice with a foreach loop.


**************************
***PRESERVE AND RESTORE***
**************************
*As you practice to become a loop wizard in Stata, one tidbit that might be
*helpful is "preserve" and "restore" syntax. This syntax is very unique to
*Stata because it is difficult to use multiple data sources at once. As you
*may have intuited, preserve simply saves your dataset so that you can return
*to that point if you want to undo changes. Note that these commands will only
*work if you run them in the command line. The example below works, but you
*should type "preserve" and "restore" in the command line to really see how
*you can utilize these commands.

*To illustrate the uses of these commands, let's go through an example. If we
*preserve here (type preserve in the command line):
preserve

*and then if we make lots of changes:
keep unitid instnm stabbr zip

replace zip = "0"
drop instnm

*Now we've completely changed the dataset and lost some information. To go back
*to where we were, we can use the restore command (type restore in the command
*line):
restore

*Now we end up with our original dataset. This can be a good tool to make edits
*without worrying that you might make a mistake with the data.


**********
***EGEN***
**********
*The last bit of advanced Stata that we'll review in this lesson is egen. This
*is short for "extended generation", and it refers to the creation of variables
*that require a formula. For example, say that you wanted to create a variable
*equal to the sum of another variable. We kind of did this in Lesson 3 using
*collapse and merge, but there is a much faster way to do this particular type
*of analysis.

*Say that we wanted to find the sum of the total_expenses variable. We could do
*this using the egen command below:
egen sum_total_expenses = sum(total_expenses)

*This should look somewhat familiar. This command has the same syntax as the
*regular gen command, but on the right hand side, you will notice a sum command.
*This is to say that this variable is not equal to a static value - we are
*instructing Stata to compute something and set this variable equal to the
*value of the computation.

*On it's own, this isn't all that different from aggregating the data. However,
*The real power of egen appears when you pair it with a "bysort" command.
*A bysort command instructs Stata to do something for each grouping of
*observations as defined by a set of variables. For example, in the following
*bysort/egen command, we will find the sum of total_expenses by academic year
*and public/private status:

bysort academic_year school_type: egen group_sum_total_expenses = sum(total_expenses)

*If you browse the data, you will see that the new group_sum_total_expenses
*variable now takes on different values in each year and by school type. This
*is extremely useful when you want to create a variable that is a sum or
*average by group.

*Congrats on finishing Lesson 4! Lesson 5 is some wrap up and fun stuff:
*regressions and graphics!


