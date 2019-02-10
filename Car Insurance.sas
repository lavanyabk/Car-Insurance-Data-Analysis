/*What is the distribution of gender, vehicle size, and vehicle class?*/
PROC IMPORT OUT= WORK.CI
        	DATAFILE= "H:\data\car_insurance_19.csv"
        	DBMS=CSV REPLACE;
 	GETNAMES=YES;
 	DATAROW=2;
RUN;
 
PROC CONTENTS; RUN;
TITLE 'Distribution of Gender';
PROC FREQ DATA = WORK.CI;
TABLES Gender; RUN;
PROC GCHART DATA = WORK.CI; HBAR Gender; RUN;
 
 
TITLE 'Distribution of Vehicle Size';
PROC FREQ DATA = WORK.CI;
TABLES Vehicle_Size; RUN;
PROC GCHART DATA = WORK.CI; HBAR Vehicle_Size; RUN;
 
TITLE 'Distribution of Vehicle Class';
PROC FREQ DATA = WORK.CI;
TABLES Vehicle_Class; RUN;
PROC GCHART DATA = WORK.CI; HBAR Vehicle_Class; RUN;

/*What is the average customer life time value of each level of gender, vehicle size, and vehicle class?*/
TITLE 'Average Customer Lifetime Value of each Gender';
PROC MEANS; VAR Customer_Lifetime_Value; CLASS Gender; RUN;
 
TITLE 'Average Customer Lifetime Value for different Vehicle Sizes';
PROC MEANS; VAR Customer_Lifetime_Value; CLASS Vehicle_Size; RUN;
 
TITLE 'Average Customer Lifetime Value for different Vehicle Classes';
PROC MEANS; VAR Customer_Lifetime_Value; CLASS Vehicle_Class; RUN;

/*Do Large cars have a higher lifetime value than medsize cars. Do a ttest and report on your findings.*/
Q3 data a2;set CI;
if Vehicle_Size='Large' or Vehicle_Size='Medsize';
proc ttest; var Customer_Lifetime_Value;class Vehicle_Size;run;

/*Is there a significant difference between men and women in customer life time value?*/
PROC ttest; VAR Customer_Lifetime_Value;CLASS Gender;run;



/*Use ANOVA to test whether there is difference in customer lifetime value across different sales channels. Which sales channel generates the highest lifetime value?*/
PROC SORT DATA = WORK.CI;BY Sales_Channel; run;
PROC ANOVA; CLASS Sales_Channel;
MODEL Customer_Lifetime_Value = Sales_Channel; run;
PROC MEANS; VAR Customer_Lifetime_Value; BY Sales_Channel; run;
/*Is there a relationship between renew_offer_type and response (use Chi-sq test)? Which offer type generates the highest response rate?*/
ods graphics on;
proc freq data = WORK.CI;
tables (Renew_Offer_Type)*(Response) /chisq
		plots=(freqplot(twoway=grouphorizontal
 		scale=percent));
run;
ods graphics off;

/*Do different renew_offer_types have different lifetime values? Which offer type is the best?*/
TITLE 'Renew offer types and corresponding Customer Lifetime';
PROC ANOVA; CLASS Renew_Offer_Type;
MODEL Customer_Lifetime_Value = Renew_Offer_Type; RUN;

PROC MEANS; VAR Customer_Lifetime_Value; CLASS Renew_Offer_Type; RUN;

/*Is the effectiveness of renew_offer_type different across different states with respect to lifetime value?*/
PROC MEANS; VAR Customer_Lifetime_Value; CLASS State Renew_Offer_Type; RUN;












