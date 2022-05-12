*************************************************
*************************************************
*****STATA LESSON 3 - ADVANCED MANIPULATIONS*****
*************************************************
*************************************************

*Welcome to Stata Lesson 3! In this lesson, we will review appending, merging,
*reshaping,  and aggregating data. In addition, we will introduce a standard
*Stata header.


************
***HEADER***
************
*Before we get into the weeds on this lesson, let's walk through a standard
*Stata header. Most programming languages have what are called "headers" which
*are standard lines of code that you include at the beginning of each script.
*These typically set up options for your code session that you want to apply
*universally, and they also usually set up file directories. In Stata, a
*standard header looks like this:

clear
set more off
set excelxlsxlargefile on

global path = "[PATH]"
global raw = "$path/RawData"
global intermed = "$path/IntermediateData"
global createdate = "20220511"

*While this might look like a lot of code, it is actually very straightforward.
*The first three lines in order complete the following tasks:
*****1) clear: remove any data from working memory
*****2) set more off: the "more" option controls what Stata does when it has
	*too much information to display in the window. The default action when the
	*window fills up is to stop and wait for you to clear the window. This
	*option changes this behavior such that Stata will automatically clear the
	*console if it fills up
*****3) set excelxlsxlargefile on: instruct Stata to import excel files of any
	*size, even if they are over the default limit of 40 mbs
	
*These three specifications are very standard, and you can include them at the
*top of each .do file without any issues.

*Following these three lines, you will notice four lines that begin with the
*command "global". This is instructing Stata to create a value that you
*can reference throughout the .do file, or reference "globally". These commands
*are simply setting up the raw and intermediate data paths so that you can
*reference them more easily. Finally, the fourth line sets up the "createdate"
*global variable so that the date can also be easily referenced.

*Notably, an alternative header uses the "cd" syntax which changes your working
*directory. It is really user preference whether you create path variables or
*change the working directory in the header. So you have it, the syntax to
*change your working directory is as follows:
cd "[PATH]"


********************
***APPENDING DATA***
********************
*Now that you have the header out of the way, lets turn to appending data in 
*Stata. Of all data manipulations, this is generally one of the most intuitive
*for students. Appending data is simply to combining the rows of of multiple
*data sets, taking care to match columns together. Think copying and pasting
*data to the bottom of a dataset in Excel. To demonstrate this, let's import
*some data:
use "$intermed/IPEDS Cleaned Data 2003-2018.dta", clear

*Notice that in the command above we did two things differently than in the past.
*We used a "use" command as we are not importing raw data, but rather "using"
*data that has already been imported into Stata. This is a Stata dataset, and
*the file extension is ".dta". In addition to this, we also used "$intermed"
*to shorthand the file path.

*Now, we can append using another Stata dataset. This syntax for this command
*is very straightforward:
append using "$intermed/IPEDS Cleaned Data 2019.dta"

*This command adds the 2019 data onto the end of our dataset. Notably, this relies
*on the "append" command and then the word using to specify the dataset. In addition,
*this command needs to be run with a Stata dataset as Stata will use the variable
*names from the new dataset to combine the datasets. This is so that even if the
*variables are in different orders, they will still append cleanly.


**********************
***AGGREGATING DATA***
**********************
*Now, if you browse these data, you will note that they descibe U.S.
*universities in different years. Say that we wanted to know how many
*universities there were in each state in over time. We could compute this by
*aggregating the number of universities to the state level.

*First, let's make things a little easier by identifying the variables we will
*need for this task. Scanning the data, we will need the "academic_year" and
*the "stabbr", or state abbreviation. Before we actually conduct our analysis,
*let's rename the stabbr variable to something more intuitive, like "state":
rename stabbr state

*Looking at the command above, you will note that it is pretty straightforward.
*The syntax simply requires the variable you want to rename followed by the new
*name.

*Now that we've made our data a little more clear, let's aggregate to the 
*state-year level. "Aggregating" data is to say combining observations
*that have similar features. To do this, we need to answer two questions. First,
*how do we want to combine the observations? To combine numbers, we could take
*the average, or the sum, or even the max of observations among other
*statistical operations. Second, what information do we want to use to group
*observations? Do we want to know the average or sum over all observations, or
*is there some clear grouping by which we want to group that is more granular
*than all observations?

*Stata makes this type of analysis fairly easy. First, let's create a 
*"uni_count" variable equal to 1 for all observations. This is simply to say
*that each university counts as 1, as we will sum this variable to the state
*level in the next step.
gen uni_count = 1

*By aggregating this variable to the state-year level, we will identify the
*count of how many universities exist in each state by year.

*Now, aggregate the data. This relies on the "collapse" command below:
collapse (sum) uni_count, by(state academic_year)

*Let's break this down. This command is aggregating your observations, and we
*read it in two parts. The first part before the comma is specifying which
*variable we want to aggregate and how we want to combine observations. This
*relies on the (sum) specification, and you could also use (mean), (max) or a
*different statistical operation to aggregate the observations. 

*The second part of the collapse command comes after the comma and uses the by()
*syntax. This syntax identifies the information by which you are grouping
*observations. As we decided earlier, we want to know how many universities are
*in each state in each year, so our grouping variables in this case are state
*and academic_year.

*Go ahead and browse the data to get a sense for what it looks like. Each row
*now represents a state-year combination. Note that any variables not listed
*in the by() command were dropped. If you think about it, this makes sense as
*aggregating data removes granularity from each observation.


********************
***RESHAPING DATA***
********************
*Now that you've successfully aggregated data, let's move on to reshaping.
*"Reshaping" data is an extremely important concept in data science. This
*action changes the row and column identifiers for your data. For example, in
*this case, our data are at the state-year level. In the reshape below, we will
*convert the data to the state level and create additional columns for each
*year. This implies that we will have 55 observations (50 states plus Guam,
*Washington D.C., Marhsall Islands, Puerto Rico, and the US Virgin Islands) and
*18 columns (1 column for the state and 1 column for each year between 2003 and
*2019, or 17 columns).

*The Stata syntax to reshape data is relatively straightforward. It is:
reshape wide uni_count, i(state) j(academic_year)

*This command will reshape the data so that each row is a state and each column
*is a year. Like the "collapse" command above, this command really has two
*parts. Before the comma, we instruct Stata to reshape "wide" and specify the
*variable that will comprise the values of the new columns, in this case
*uni_count. Here, we are creating new columns, so we are making the data
*"wider", hence the use of the "wide" specifier. In the case that you are doing
*the opposite and creating observations, you would use "long" instead of "wide".

*After the comma, the reshape command requires i() and j() syntax. This is easy
*enough: i() represents the row identifiers and j() represents the column
*identifiers. In this example, i() is state as we want each row to represent a
*state and j() is academic_year as we want each column to be an academic year.

*At this point, pause and look at the data. Now, you will see 55 observations
*and 18 columns. As you look across the columns, you will observe the changes in
*the number of universities in each state over time. For example, look at the
*row for Illinois and see how the count changes over time. Kansas has some
*interesting behavior as well.

*One note is that reshaping is generally not an intuitive concept. This takes 
*a lot of practice, and learning whether you need to reshape wide or long
*takes experience. As you're getting started, you may find it easier to draw
*out how you want your data to look and then figure out what combination of
*aggregation and reshaping you need to arrive at that point. Additionally,
*Stata's help file on reshaping is especially helpful - just type "help reshape"
*in the command bar in the main console.


*****************
***SAVING DATA***
*****************
*Before we move on to the final step in our data manipulation process, let's
*save our data. This is very easy. Any time you save data, you should always
*use the "compress" command. No syntax is required with this command. It will
*simply scan your data to determine whether it is possible to save memory for
*any observations. This will cut down on the memory you use when you save the
*data.
compress

*Then, save the dataset using the "save" command. Note that you need to use the
*"replace" specification if there is already a dataset of that name saved in
*the file path. Additionally, Stata datasets are saved using a .dta extension:
save "$intermed/IPEDS Data Reshaped.dta", replace


******************
***MERGING DATA***
******************
*For the next part of this lesson, we're going to walk through a data merge.
*This is generally an intuitive concept. Here, we will combine two datasets
*based on common information between the observations. To do this, we will
*start by importing our original dataset:
import delimited "$raw/IPEDS Combined Data.csv", varnames(1) case(lower) clear

*Note the use of the "clear" specification in the command above to clear the
*previous dataset. 

*Now, we can merge using a Stata dataset, namely the one that we just saved.
*Here, we will merge using the "state" variable as this is contained in both
*datasets. Notably, the variables need to have the same name, so we will rename
*the state variable in the fresh dataset just as we did before:
rename stabbr state

*Now, we can run the Stata merge command:
merge m:1 state using "$intermed/IPEDS Data Reshaped.dta"

*The syntax for "merge" is also relatively straightforward. It is merge with a
*colon specifier followed by the variable or variables to use to merge (state
*in this case), the word using, and the path to the Stata dataset that we want
*to merge.

*One tricky thing about merging is that you need to specify what type of merge
*you want to perform. This is specified in the colon specifier above. While
*most people think of data merges as "one-to-one" scenarios, we sometimes
*perform what are called "many-to-one" or "one-to-many" merges instead. The
*type of merge relates to how the merge variables identify your data. For
*example, in the "IPEDS Data Reshaped.dta" file that we saved earlier, the
*state variable uniquely identifies each observation. As a result, we would
*specify a "1" in the colon specifier related to this dataset. In contrast, the
*raw dataset has many observations for each state as these observations are at
*the university level. Therefore, the state variable identifies "many"
*observations, so we use an "m" in the colon specifier for this dataset. In
*this way, we are merge a dataset with many observations per state to a
*dataset with one observation per state, hence a many-to-one or "m:1" merge.

*Understanding the differences between these merges is another tricky aspect of
*Stata that takes practice. See the Stata help files for "merge" for more
*examples of 1:1, m:1, and 1:m merges.

*Finally, take a look at your newly merged dataset. Now, every observation has
*all 17 of the additional year columns from the "IPEDS Data Reshaped.dta"
*dataset. You could now use this to look at specific universities to see how
*many universities there were in each their state in each year, or answer
*another question.


*Nice job getting through this lesson. Aggregating, reshaping, and merging
*are finicky concepts if you've never seen them before. Take a little break
*to noodle around the Stata help files for these commands. Just type "help"
*and then the command that you want help with. After that, move on to Lesson 4
*for some advanced Stata commands (like loops!).


*******************
***KEY TAKEAWAYS***
*******************
*1) Stata headers are very easy and you can copy them at the top of all of your .do files
*2) We can append data using the "append" command. This adds observations onto a dataset
*3) We can aggregate data in Stata using the "collapse" command. This combines observations
*4) We can reshape data in Stata using the "reshape" command. This changes row and column identifiers
*5) We can merge data in Stata using the "merge" command. Take note of the 1:1, m:1, and 1:m syntax
*6) We can append data in Stata using the "append" command

