// Script is prepared fro Coding for econ course.

pwd
cd "C:\Users\Gohar_Ramazan\Downloads\salary_avr_MN"

*Load the data
import delimited "data/average_salary.csv", clear 


* General summary and information
list in 1/10
describe
summarize

* Check the variables! 
describe

* Variables names changed 
drop in 1 
rename v1 province
rename v2 gndr


* loop to change year var names. 
local val 2019
forvalues i = 3/6 {
    local val = `val' + 1 
	rename v`i' y`val'  
}

* gndr as 0 1, and all
replace gndr = "0" if gndr == "Эрэгтэй"
replace gndr = "1" if gndr == "Эмэгтэй"
replace gndr = "all" if gndr == "Бүгд"

* generate a numeric version of gndr
gen gndr_num = .
replace gndr_num = 0 if gndr == "0"
replace gndr_num = 1 if gndr == "1"


* Convert y2020 and y2023 from string to numeric.

forvalues year = 2020/2023 { 
   replace y`year' = subinstr(y`year', ",", "", .)
   destring y`year', replace
}


* check for missing values. 

misstable summarize


* Some more translations, I will compare capital to country and disregard the provinces. 
replace province = "country" if province == "Улсын дүн"
replace province = "capital" if province == "Улаанбаатар"

* Check the unique values in the province variable
tabulate province

*lets save the data 
export delimited "data/avr_salary_cleaner.csv", replace



* Reshape data to long format
reshape long y, i(province gndr) j(year)


* Compare trends between country and capital
twoway (line y year if province == "capital" & gndr_num == 0, lcolor(blue) lwidth(medium)) ///
       (line y year if province == "capital" & gndr_num == 1, lcolor(red) lwidth(medium)) ///
       (line y year if province == "country" & gndr_num == 0, lcolor(blue) lwidth(medium) lpattern(dash)) ///
       (line y year if province == "country" & gndr_num == 1, lcolor(red) lwidth(medium) lpattern(dash)), ///
    title("Trends for Capital vs. Country by Gender") ///
    legend(label(1 "Female (Capital)") label(2 "Male (Capital)") label(3 "Female (Country)") label(4 "Male (Country)")) ///
    xlabel(2020(1)2023) ylabel(, angle(horizontal))

graph export "outputs\Stata_Trends for Capital vs. Country by Gender.png", replace










