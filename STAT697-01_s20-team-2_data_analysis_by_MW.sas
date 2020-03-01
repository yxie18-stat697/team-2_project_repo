*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

/* load external file that will generate final analytic file */
%include './STAT697-01_s20-team-2_data_preparation.sas';


*******************************************************************************;
* Research Question 1 Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Question 1 of 3: Which 5 counties experienced the biggest decrease in UC/CSU eligible California graduates between AY2015-16 and AY2016-17?'
;

title2 justify=left
'Rationale: This can help identify counties to consider for additional college-bound outreach based on depleting rate of meeting university requirements.'
;

footnote1 justify=left
"Of the five counties with the biggest decrease in percent eligibility formeeting UC/CSU requirements between AY2015-16 and AY2016-17, the percentage point decreases from about __% to about __%."
;

footnote2 justify=left
"These are significant demographic shifts for a community to experience, so further investiation should be performed to ensure no data errors are involved."
;

footnote3 justify=left
"However, assuming there are no data issues underlying this analysis, possible explanations for such large increases include changing CA demographics and the ratification of Every Student Succeeds Act of 2015 (ESSA) to replace the No Child Left Behind Act of 2002 (NCLB)."
;

/*
Note: This compares the column "Total" from gradaf16 to the column of the
column of the same name from gradaf17 to the column of the same name from 
gradaf16.

Limitations: Values of Total equal to zero should be excluded from this 
analysis, since they are potentially missing data values.

Methodology: Use proc sort to create a temporary sorted table in descending 
order by analytic_file_raw_checked data, with ties broken by County. The use
proc report to print the first five rows of the sorted dataset.

Followup Steps: More carefully clean values in order to filter out any possible
illegal values, and better handling missing data, e.g., by using a previous
year's data or a rolling average of previous years' data as a proxy.
*/

/* sort by increase in analytic_file_raw_checked Eligbility Rate, removing all 
missing and invalid County values from analytic_file_raw_checked UC/CSU 
Eligibility Rates in AY2015-16 and AY2016-17 */
proc sort
        data=analytic_file_raw_checked
        out=analytic_file_by_GRADAF_Decr
    ;
    by
        descending GRADAF_Total_Decrease
        County
    ;
    where    /* gradaf17_clean.Total as County_Total, and sum of Total 
    in AY2015-16 and AY2016-17 as gradaf1617.County_Total */ 
        County_Total > 0
        and
        gradaf1617.County_Total > 0
    ;
run;

/* output first five rows of resulting sorted data, addressing research Q */
proc report data=analytic_file_by_GRADAF_Decr(obs=5);
    columns
        County
        County_Total
        gradaf1617.County_Total
        GRADAF_Total_Decrease
    ;
run;
	
/* clear titles/footnotes */
title;
footnote;


*******************************************************************************;
* Research Question 2 Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Research Question 2 of 3: Can Free/Reduced-Price Meal Eligibility Rates be used to predict the proportion of high school graduates earning a combined score of at least 1500 on the SAT in AY2014 at California public K-12 schools?'
;

title2 justify=left
'Rationale: This would help inform whether child-poverty levels are associated with college-preparedness rates, providing a strong indicator for the types of schools most in need of college-preparation outreach.'
;

/*
Note: This compares the column "Percent (%) Eligible Free (K-12)" from frpm1415
to the column PCTGE1500 from sat15.

Limitations: Values of "Percent (%) Eligible Free (K-12)" equal to zero should
be excluded from this analysis, since they are potentially missing data values,
and missing values of PCTGE1500 should also be excluded

Methodology: Use proc corr to perform a correlation analysis, and then use proc
sgplot to output a scatterplot, illustrating the correlation present

Followup Steps: A possible follow-up to this approach could use a more formal
inferential technique like linear regression, which could be used to determine
more than the existence of a linear relationship.
*/


title3 justify=left
'Correlation analysis for Percent_Eligible_FRPM_K12_1415 and Percent_with_SAT_above_1500'
;

footnote1 justify=left
"Assuming the variables Percent_Eligible_FRPM_K12_1415 and Percent_with_SAT_above_1500 are normally distributed, the above inferential analysis shows that there is a fairly strong negative correlation between student poverty and SAT scores in AY2014-15, with lower-poverty schools much more likely to have high proportions of students with combined SAT scores exceeding 1500."
;

footnote2 justify=left
"In particular, there is a statistically significant correlation with high confidence level since the p-value is less than 0.001, and the strength of the relationship between these variables is approximately -85%, on a scale of -100% to +100%."
;

footnote3 justify=left
"Possible explanations for this correlation include child-poverty rates tending to be higher at schools with lower overall academic performance and quality of instruction. In addition, students in non-impoverished conditions are more likely to have parents able to pay for SAT preparation, confirming that outreach would be most effective at high-needs schools."
;

proc corr
        data=cde_analytic_file
        nosimple
    ;
    var
        Percent_Eligible_FRPM_K12_1415
        Percent_with_SAT_above_1500
    ;
    where
        not(missing(Percent_Eligible_FRPM_K12_1415))
        and
        not(missing(Percent_with_SAT_above_1500))
    ;
run;
	
/* clear titles/footnotes */
title;
footnote;


title1
'Plot illustrating the negative correlation between Percent_Eligible_FRPM_K12_1415 and Percent_with_SAT_above_1500'
;

footnote1
"In the above plot, we can see how values of Percent_with_SAT_above_1500 tend to decrease as values of Percent_Eligible_FRPM_K12_1415 increase."
;

proc sgplot data=cde_analytic_file;
    scatter
        x=Percent_Eligible_FRPM_K12_1415
        y=Percent_with_SAT_above_1500
    ;
run;
	
/* clear titles/footnotes */
title;
footnote;


*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Research Question 3 of 3: What are the top ten California public K-12 schools were the number of high school graduates taking the SAT exceeds the number of high school graduates completing UC/CSU entrance requirements?'
;

title2 justify=left
"Rationale: This would help identify schools with significant gaps in preparation specific for California's two public university systems, suggesting where focused outreach on UC/CSU college-preparation might have the greatest impact."
;

footnote1 justify=left
"All ten schools listed appear to have extremely large numbers of 12th-graders graduating who have completed the SAT but not the coursework needed to apply for the UC/CSU system, with differences ranging from 147 to 282."
;

footnote2 justify=left
"These are significant gaps in college-preparation, with some of the percentages suggesting that schools have a college-going culture not aligned with UC/CSU-going. Given the magnitude of these numbers, further investigation should be performed to ensure no data errors are involved."
;

footnote3 justify=left
"However, assuming there are no data issues underlying this analysis, possible explanations for such large numbers of 12th-graders completing only the SAT include lack of access to UC/CSU-preparatory coursework, as well as lack of proper counseling for students early enough in high school to complete all necessary coursework. This again confirms that outreach would be most effective at high-needs schools."
;

/*
Note: This compares the column NUMTSTTAKR from sat15 to the column TOTAL from
gradaf15.

Limitations: Values of NUMTSTTAKR and TOTAL equal to zero should be excluded
from this analysis, since they are potentially missing data values

Methodology: Use proc sort to create a temporary sorted table in descending
order by Course_Completers_Gap_Count, with ties broken by school name. Then
use proc report to print the first ten rows of the sorted dataset.

Followup Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data or a rolling average of previous years' data as a proxy.
*/


/* sort by difference between number of SAT takers and number of course
completers, removing all schools with missing or invalid values for each */
proc sort
        data=cde_analytic_file
        out=cde_analytic_file_by_Gap_Count
    ;
    by
        descending Course_Completers_Gap_Count
        School
    ;
    where
        Number_of_SAT_Takers > 0
        and
        Number_of_Course_Completers > 0
    ;
run;

/* output first ten rows of resulting sorted data, addressing research question */
proc report data=cde_analytic_file_by_Gap_Count(obs=10);
    columns
        School
        District
        Number_of_SAT_Takers /* NUMTSTTAKR from sat15 */
        Number_of_Course_Completers /* TOTAL from gradaf15 */
        Course_Completers_Gap_Percent
        Course_Completers_Gap_Count
    ;
run;
	
/* clear titles/footnotes */
title;
footnote;