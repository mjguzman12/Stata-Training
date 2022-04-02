***************************************************
***************************************************
*****STATA LESSON 5 - GRAPHICS AND REGRESSIONS*****
***************************************************
***************************************************

clear
set more off
set excelxlsxlargefile on

global path = "[PATH]"
global raw = "$path/RawData"
global intermed = "$path/IntermediateData"
global createdate = "20220402"

***********
***INTRO***
***********
*Congratulations on making it this far in the Stata Training! This last one
*reviews some of the more fun aspects of Stata: graphics and regressions.

*Before we go on, it is important to pause and consider what are the relative
*strengths of Stata. Stata is widely used in many areas of applied statistics
*from economics to biology. Stata has largely cornered the market with
*intuitive syntax, well-written documentation, and compatability across systems.
*That being said, Stata is notoriously slow, cannot work with large datasets
*easily, and can only work with one dataset at a time (although a new frames
*feature was recently released). If you've never used a programming language
*before, Stata is an excellent place to start, but it's just the tip of the
*iceberg as far as data science is concerned.

*The place where Stata really excels is in terms of regressions. Stata probably
*has the most robust regression syntax of any data science tool available.
*As you'll see below, the syntax is so simple, the documentation is so strong,
*and the wide range of regression models that you can run from instrumental
*variables to large fixed-effect models is incredible. It is always possible
*to code these regression models yourself in another language, but these tools
*are largely not as developed as they are in Stata. Furthermore, the math behind
*regression computations is sometimes opaque in documentation. For that reason,
*if you are running many regressions, Stata will often be the best tool for
*the job. With that, let's dive in!


**************
***GRAPHICS***
**************
/*BAR GRAPH*/
*First, we will make a simple bar graph that represents the count of universities
*in each year. To provide some theoretical context, this graphic could help to answer
*or inform the question of whether higher ed has expanded in the U.S. since 2003.
*First, use the cleaned IPEDS data:
use "$intermed/IPEDS Cleaned Data.dta", clear

*Now, aggregate the data by academic year taking the count of unique instititions:
collapse (count) unitid, by(academic_year)

*Now, make a simple bar graph. This uses "graph bar" syntax which requires that
*you specify the bar height statistic which we want "as is", the y axis variable,
*and the variable over which we're graphing on the x-axis:
graph bar (asis) unitid, over(academic_year)

*This is a relatively boring graph. Now, let's add an angle to the x-axis graph labels:
graph bar (asis) unitid, over(academic_year, label(angle(45)))

*Here, we just added the "label" specification into the "over" command. Now, let's
*fix the y-axis to be more attractive. Since all of the bars are relatively high,
*It makes sense to exclude 0 from the graph and rescale the y-axis:
graph bar (asis) unitid, over(academic_year, label(angle(45))) ///
	exclude0 ///
	yscale(range(1500 1700)) ///
	ylabel(1500(50)1700)
	
*Here, we have just added three specifications: exclude0, yscale, and ylabel. As you
*may have intuited, exclude0 removes 0 from the y-axis, yscale controls the scaling
*of the y-axis, and ylabel controls the labels on the y-axis. Here, the scaling in 
*yscale is  indicated by a range of numbers, and we have input the range 1500 to 1700.
*In addition, we have specified the y-labels to be in the range of 1500 to 1700
*in increments of 50 in the ylabel command. 

*Note that customarily, Stata graph commands use the three slashes comment structure
*to comment out the end of lines. This is because as you add specifications, it can
*become very difficult to read everything on one line. As a refresher, three slashes
*simply comment out the end of the line, including the line break. This allows Stata
*to read on to the next line.

*Now that our graph looks pretty good, let's add some titles to make it really clear:
graph bar (asis) unitid, over(academic_year, label(angle(45))) ///
	exclude0 ///
	yscale(range(1500 1700)) ///
	ylabel(1500(50)1700) ///
	ytitle("Count of Universities") ///
	title("Total US Universities Over Time")

*Here, we added three specifications: ytitle and title. As you might have
*guessed, these related to the y-axis title and the overall graph title.

*Note that this structure is common for Stata graphs. The initial command is usually
*very simple, but additional specifications are often necessary to get the graph to
*really be presentation-ready. This is a common trend with Stata graphs: as you get
*more customization, you need to add more specifications.
	
/*SCATTERPLOT*/
*Now, let's make a scatterplot of the average graduation rate vs. the average
*higher ed instruction expenditures in each state in 2012. This could theoretically
*inform the question of how spending impacts graduation rates. As before, start by
*using the cleaned IPEDS data:
use "$intermed/IPEDS Cleaned Data.dta", clear

*Now, per our question, keep observations in academic year 2012
keep if academic_year == 2012

*Now, aggregate taking the mean of the instruction expenditures by state
collapse (mean) instruction_expenses grad_rate_150, by(stabbr)

*As before, we can create a simple scatter plot with a very intuitive "scatter"
*command. Here, the first variable is the y-axis variable and the second variable
*is the x-axis variable:
scatter grad_rate_150 instruction_expenses

*However, if we want to make this graph a little more attractive, we need to add
*specifications:
scatter grad_rate_150 instruction_expenses, ///
	yscale(r(0 0.8)) ///
	ylabel(0 "0" 0.2 "20%" 0.4 "40%" 0.6 "60%" 0.8 "80%") ///
	xlabel(25000000 "$25M" 75000000 "$75M" 125000000 "$125M" 175000000 "$175M") ///
	ytitle("6-Year Graduation Rate") ///
	xtitle("Instruction Expenditures") ///
	title("2016 Graduation Rate vs. Instruction Expenditures")

*These specifications are very similar to those of the bar graph. yscale,
*ylabel, and title all perform the same function. Note that we are now using named
*incremements in the ylabel rather than a range. This take the form of the number
*where we want the increment and then the string label that we want at that point.
*In addition, we have now also added similar xlabel and xtitle commands to control
*the look of the x-axis.

*Note the organization of these commands. While this order doesn't techinically matter,
*Best practice is to group your commands into chunks, going in order from "data-centric" to
*"aesthetic" edits. The basic graph command is followed by y-axis options, then x-axis
*options, then title options. Following this structure will make it easier to edit
*graphing commands further down the line.

/*TWOWAY LINE*/
*Finally, let's make a connected line graph of average 6-year graduation rates by
*year. As before, import the cleaned IPEDS data and aggregate to the academic year
*level:
use "$intermed/IPEDS Cleaned Data.dta", clear

collapse (mean) grad_rate_150, by(academic_year)

*remove observations that have a missing 6-year graduation rate:
drop if grad_rate_150 == .

*Now, we're going to graph using a "twoway connected" command:
twoway connected grad_rate_150 academic_year

*This follows similar syntax to the scatter command, and it creates a line of connected
*points. As before, we can make this a more attractive graph by adding the following
*specifications:
twoway connected grad_rate_150 academic_year, ///
	yscale(r(0 0.65)) ///
	ylabel(0(0.10)0.65) ///
	xlabel(2003(1)2014, angle(45)) ///
	ytitle("6-Year Graduation Rate") ///
	xtitle("") ///
	title("Average 6-Year Graduation Rate by Year")

*You may have picked up on some patterns here: all of the specifications are
*the same as before. yscale controls the scaling on the y-axis, ylabel controls
*the y-axis labels, ytitle controls the y-axis titles, xtitle controls the x-axis
*titles, and title controls the graph title. In this way, graphing in Stata is 
*relatively easy to replicate.

*One note is that this was a very brief introduction to "twoway" graphs. Twoway graphs
*are more advanced Stata graphs, and you can do things like add multiple types
*of graphs on top of each other, create multiple axes, and control very minute things
*about the visual in this graphing command.
	
*To wrap up Stata graphics, here are some final pros and cons. The pros of Stata graphics
*include the fact that they use relatively simple syntax, can be created directly after
*cleaning a dataset, and they are easily replicable. The cons are simple: Stata graphs
*have a distinct "Stata" look. The Stata font and default color schemes  are notoriously
*ugly, and changing the look to be customized and unique can be challenging. That being
*said, really impressive graphics are often very unique and memorable, so taking the time
*to learn some designs and figure out your own Stata visualization preferences will pay
*large dividends for you and your audience.


*****************
***REGRESSIONS***
*****************
*As we alluded to above, Stata has largely cornered the market on regression syntax.
*Regressions are extremely easy to run in Stata, and many complex models can be run
*right out of the box in Stata. To demonstrate this, we will (again) use our cleaned
*IPEDS data:
use "$intermed/IPEDS Cleaned Data.dta", clear

*Now, let's run some regressions to understand the effect of auxiliary services (think
*dorms) and student services (think student groups) on higher ed graduation rates. To
*start, create new variables for the log of auxiliary and student services expenditures:
gen log_aux_exp = ln(auxiliary_expenses)
gen log_stu_exp = ln(student_services_expenses)

*Now, we are ready to run a regression. The syntax is "regress" followed by the dependent
*variable followed by all independent variables:
regress grad_rate_150 log_aux_exp log_stu_exp

*After running this, Stata prints a very nice output with all of the relevant features of
*your regression including the coefficients, p-values, sums of squares, and the r-squared
*of the model. Now, say we wanted to add instruction expenditures to this regression.
*We could again create the log of instruction expenditures and simply add this to the
*regression command:
gen log_inst_exp = ln(instruction_expenses)

regress grad_rate_150 log_aux_exp log_stu_exp log_inst_exp

*Now, say that we want to run this regression with robust standard errors. This is
*accomplished via the "robust" specification:
regress grad_rate_150 log_aux_exp log_stu_exp log_inst_exp, robust

*Now, say that we want to run a model with acadmeic year fixed effects. We could
*manually create dummies for each academic year and include them in the regression,
*but Stata provides syntax for this as well. Adding the prefix "i." to a variable
*creates dummies for categorical variables:
regress grad_rate_150 log_aux_exp log_stu_exp log_inst_exp i.academic_year, robust

*This is just a taste of the many different regression models that you can run in
*Stata, but this demonstrates that almost all of this regression syntax is very
*straightforward. In addition, the documentation for these commands is very strong,
*so if you really want to get under the hood about how these coefficients are
*computed, you absolutely can.


**********
***MATA***
**********
*Congratulations on completing the Stata Training! You now have all of the tools necessary
*to take on a data cleaning project. This doesn't comprise every tool that you will ever
*use in Stata, and there are many tricks that you will pick up along the way. That
*being said, this should give you enough of a foundation to dive in and learn anything
*extra. In addition, Stata provides an excellent introduction to higher level data science.
*Many of the skills you've developed here are highly transferable to other data science
*tools such as R, Python Pandas, and SAS among others.

*One final plug is to consider taking your Stata knowledge one step further with the
*affectionately named "Mata". Pronounced "may-tah", Mata is the programming language
*behind Stata. Rather than using datasets, Mata is built on matrices and uses primarily
*matrix algebra. Programming is Mata is more complicated than Stata, but it is significantly
*faster. In addition, you will find that Stata is notorious for having certain data
*science "rules" that it won't allow you to break. These are often good suggestions, but
*Mata will allow you to do truly anything you want. This flexibility can allow you to
*break out of the strict environments that Stata creates and do some really impressive
*and dynamic analyses.

*If you're interested, take on the Mata training! We would recommend that you spend at
*least a few weeks working with Stata before going on to Mata as the syntax is more
*complicated, but Mata is ready whenever you are. For now, we will briefly tease Mata.
*You can enter mata by simply typing mata in the command line. Once you enter mata, you
*can conduct simple computations like a calculator. Go ahead and type 2 + 2! To exit mata,
*type "end" and return to the regular Stata prompt:
mata
	2 + 2
end


