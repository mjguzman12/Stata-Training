*****************************************
*****************************************
*****STATA LESSON 4 - ADVANCED STATA*****
*****************************************
*****************************************

clear
set more off
set excelxlsxlargefile on

global path = "/Users/matthew/Desktop/Research/Stata Training/For GitHub"
global raw = "$path/RawData"
global intermed = "$path/IntermediateData"
global createdate = "20220111"


*Welcome to Stata Lesson 4! You're doing great. You now have all of the tools
*to analyze data. This lesson is going to introduce some advanced Stata syntax
*to help you analyze data a little faster. That being said, you already have
*all of the concepts down for this lesson, so this should be a little easier
*than Lesson 3. Here, we're going to learn about global and local macros, loops,
*egen commands, and some string cleaning. As a bonus, we'll throw in some tidbits
*about preserve and restore syntax too!

************
***MACROS***
************
*Let's kick this lesson off with global and local macros. You might recall from
*our discussion of headers that a "global" is a value in Stata that you can reference
*"globally". This is to say that like our file paths, we can shorthand these values
*anywhere in the .do file and Stata will substitute the values. For example, we
*can use the global raw here:
display "$raw"

*In general, you will only need to use global macros for file paths, but if you
*need to use something all the time like a conversion rate or specific multiplier,
*you could consider setting up a global macro for easier reference.

*While global macros can be used anywhere, "local" macros only exist temporarily.
*We create these in a very similar manner to globals: a local macro is created by
*typing "local" and then the name of the macro and the value it is equal to:
local example = "This is an example"
display "`example'"

*Whereas globals are referenced using the "$", locals are referenced using a back 
*quote ` and a straight quote '. With this, these are just values that you can use
*temporarily. This is to say that locals only exist WHILE THE .DO FILE IS RUNNING.
*For example, if you run the code above, you can see the value of the "example"
*local, but if you try the display command without the local, you won't get anything.

*While locals may not seem particularly useful, you will find that they are
*amazingly powerful. For now, keep them in your back pocket - one day you'll want
*to do something temporarily in Stata, and locals will become your best friend.


***********
***LOOPS***
***********
*Let's  get a move on and learn about loops in Stata. In case you're not familiar
*with them, loops are simply bits of code that do the same thing multiple times.
*To illustrate this, let's re-import the IPEDS dataset that we've been using.
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
*Another bit of advanced Stata that we'll review in this lesson is egen. This
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


*********************
***STRING CLEANING***
*********************
*For the last part of this lesson, we will do some light string cleaning. While
*new data analysts often think that data science is about numbers, there is a large
*amount of time, energy, and research dedicated to analyzing text in data. This
*can take many forms such as counting the number of occurences of a word in a
*string, tracking one name or entity over time, or merging datasets based on names.

*String cleaning can range from easy to unimaginably difficult. Say that we wanted
*to merge a dataset into the IPEDS data, but the dataset we have only has univeristy
*names without words like "University" or "College". We could start cleaning university
*names in the following way. First, create a new university name variable:
gen uni_name_cleaned = instnm

*Then, start cleaning university names one at a time:
replace uni_name_cleaned = "Northwestern" if uni_name_cleaned == "Northwestern University"
replace uni_name_cleaned = "Harvard" if uni_name_cleaned == "Harvard University"
replace uni_name_cleaned = "Virginia-Main Campus" if uni_name_cleaned == "University of Virginia-Main Campus"
replace uni_name_cleaned = "Gettysburg" if uni_name_cleaned == "Gettysburg College"
replace uni_name_cleaned = "Johns Hopkins" if uni_name_cleaned == "Johns Hopkins"

*We could keep going, but as you can tell, this would be a tedious way to clean
*a lot of university names. We could speed this up a little using Stata's subinstr
*function. This function "subs" a string into another string:
gen uni_name_cleaned2 = instnm
replace uni_name_cleaned2 = subinstr(uni_name_cleaned2, "University", "", 1)

*If you look at uni_name_cleaned2, you will find that we have now removed all instances
*of "University" from the strings. This doesn't solve our problem entirely as we
*now have a lot of errant spaces and random "ofs", but this gets us closer to clean
*university names.

*Instead of conducting a lot of manual cleaning in this way, we could use what is
*called a  "regular expression". Regular expressions are some of (some would say THE)
*most powerful tools in data science. These are bits of strings that can match many
*different strings. Stata has several different functions for regular expressions,
*and we will review the "regexm" and "regexr" functions.
gen uni_name_cleaned3 = instnm
replace uni_name_cleaned3 = regexr(uni_name_cleaned3, " ?University", "")

*Let's break this down. Here, we have used "regexr" to replace the values of
*uni_name_cleaned3. This function takes 3 arguments. The first is the variable
*containing the strings to replace, the second is the regular expression, and the
*third is the expression that you want to use to replace. Using the question mark,
*this regular expression will match any instance of the word "University" and
*a preceding space if there is one. This function will replace each of these matches
*with "", or a blank string, and this will help clean up multiple versions of the
*same string in one command. Taking this a step further, we can also write a
*regular expression that allows for University or College, and also allows for
*the presence of "Of" as well:
gen uni_name_cleaned4 = instnm
replace uni_name_cleaned4 = regexr(instnm, " ?(University|College)( Of)?", "")

*Scanning through the uni_name_cleaned4 variable, you will now see the cleaned
*string values. Here, we have used a regex to make a lot of string cleaning easier
*based on common patterns in the strings. Notably, this is just the tip of the
*iceberg when it comes to regular expressions. There are MANY other shortcuts
*to writing these, and as you delve deeper into data science, you will become
*more familiar with these functions.

*Congrats on finishing Lesson 4! Lesson 5 is some wrap up and fun stuff -
*regressions and graphics!


*******************
***KEY TAKEAWAYS***
*******************
*1) Global and local macros are variables that you can use elsewhere in a .do file
*2) Loops are bits of code that do the same thing multiple times
*3) foreach loops operate over elements of a list
*4) forvalues loops operate over sequential numbers
*5) egen commands commands create variables that require operations on entire variables
*6) egen commands are extremely useful when paired with bysort commands.
*7) Regular expressions are useful tools to assist in string cleaning
