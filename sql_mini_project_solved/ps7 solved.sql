use healthcare;
/*Problem Statement 1: 
Insurance companies want to know if a disease is claimed higher or lower than average.  Write a stored procedure that returns “claimed 
higher than average” or “claimed lower than average” when the diseaseID is passed to it. 
Hint: Find average number of insurance claims for all the diseases.  If the number of claims for the passed disease is higher 
than the average return “claimed higher than average” otherwise “claimed lower than average”.*/
delimiter $$
drop procedure claim_category$$
CREATE PROCEDURE claim_category(
in d_id varchar(50),
out category varchar(100)
)
begin
set category=(with 
disease_count as 
(select diseaseid,count(claimid) claims_count from disease d join treatment tr using(diseaseid) group by diseaseid),
Avg_count as (select d_id as diseaseid,avg(claims_count) as Average_claim_count from disease_count)
select
case when dc.claims_count>Average_claim_count 
then 'claimed higher than average'
else 'claimed lower than average' end as category
 from Avg_count ac join disease_count dc using(diseaseid));
end $$
delimiter ;
call claim_category(27,@category);
select @category;

/*Problem Statement 2:  
Joseph from Healthcare department has requested for an application which helps him get genderwise report for any disease. 
Write a stored procedure when passed a disease_id returns 4 columns,
disease_name, number_of_male_treated, number_of_female_treated, more_treated_gender
Where, more_treated_gender is either ‘male’ or ‘female’ based on which gender underwent more often for the disease, if the number 
is same for both the genders, the value should be ‘same’.*/
delimiter $$
drop procedure disease_genderReport $$
create procedure disease_genderReport(
in d_id int
)
begin
select *,
case when Male_count>Female_count then 'Male' else 'Female' end as Most_treated
from(select diseaseName,
sum(case when p.gender='male' then 1 else 0 end) as Male_count,
sum(case when p.gender='female' then 1 else 0 end) as Female_count
from disease d join treatment tr using(diseaseid) join patient pt using(patientid) join person p
on pt.patientid=p.personid where diseaseid=d_id group by diseaseid) gender_stats;
end $$
delimiter ;
call disease_genderReport(6);



/*Problem Statement 3:  
The insurance companies want a report on the claims of different insurance plans. 
Write a query that finds the top 3 most and top 3 least claimed insurance plans.
The query is expected to return the insurance plan name, the insurance company name which has that plan, and whether the 
plan is the most claimed or least claimed. */
delimiter $$
create procedure company_claims()
begin
select 'hello';
select 'heyy';
end $$
delimiter ;
call company_claims();


/*Problem Statement 4: 
The healthcare department wants to know which category of patients is being affected the most by each disease.
Assist the department in creating a report regarding this.
Provided the healthcare department has categorized the patients into the following category.
YoungMale: Born on or after 1st Jan  2005  and gender male.
YoungFemale: Born on or after 1st Jan  2005  and gender female.
AdultMale: Born before 1st Jan 2005 but on or after 1st Jan 1985 and gender male.
AdultFemale: Born before 1st Jan 2005 but on or after 1st Jan 1985 and gender female.
MidAgeMale: Born before 1st Jan 1985 but on or after 1st Jan 1970 and gender male.
MidAgeFemale: Born before 1st Jan 1985 but on or after 1st Jan 1970 and gender female.
ElderMale: Born before 1st Jan 1970, and gender male.
ElderFemale: Born before 1st Jan 1970, and gender female.*/
with age_stats as 
(select pt.patientid,
case
when pt.dob>='2005-01-01' then
	case when gender='male' then 'YoungMale' else 'YoungFemale' end
when pt.dob<'2005-01-01' and pt.dob>='1985-01-01' then
	case when gender='male' then 'AdultMale' else 'AdultFemale' end
when pt.dob<='1985-01-01' and pt.dob>='1970-01-01' then
	case when gender='male' then 'MidAgeMale' else 'MidAgeFemale' end
when pt.dob<'1970-01-01' then
	case when gender='male' then 'ElderMale' else 'ElderFemale' end 
end as Age_category
from patient pt join person p on p.personid=pt.patientid),
category_count as 
(select diseaseName,Age_category,count(patientid) as patient_count,
rank() over (partition by diseaseName order by count(patientid) desc) as category_rank
 from age_stats ac join treatment tr using(patientid) join disease d using(diseaseid) 
group by diseaseName,Age_category)
select diseaseName,Age_category as Most_Affected_Category from category_count where category_rank=1;

/*Problem Statement 5:  
Anna wants a report on the pricing of the medicine. She wants a list of the most expensive and most affordable medicines only. 
Assist anna by creating a report of all the medicines which are pricey and affordable, listing the companyName, productName, description,
 maxPrice, and the price category of each. Sort the list in descending order of the maxPrice.
Note: A medicine is considered to be “pricey” if the max price exceeds 1000 and “affordable” if the price is under 
*/
select companyName,productName,description,maxPrice,
case 
when maxprice>1000 then 'Pricey' 
when maxPrice<5 then 'affordable'
end as price_category from medicine where (maxPrice<5 or maxPrice>1000);


