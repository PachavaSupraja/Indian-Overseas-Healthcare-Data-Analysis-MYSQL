/*Problem Statement 1: 
The healthcare department wants a pharmacy report on the percentage of hospital-exclusive medicine prescribed in the year 2022.
Assist the healthcare department to view for each pharmacy, the pharmacy id, pharmacy name, total quantity of medicine prescribed in 2022,
total quantity of hospital-exclusive medicine prescribed by the pharmacy in 2022, and the percentage of hospital-exclusive medicine to 
the total medicine prescribed in 2022.Order the result in descending order of the percentage found. */
select pharmacyid,pharmacyName,sum(c.quantity) as 'Total quantity of medicine prescribed in 2022',
sum(case when hospitalExclusive='S' then quantity end) as 'Total quantity of hospital exclusive medicine prescribed'
from pharmacy ph join prescription pr using(pharmacyid) 
join contain c on c.prescriptionid=pr.prescriptionid
join medicine using(medicineid) join treatment tr using(treatmentid) where year(date)='2022'
group by pharmacyid,pharmacyName;
 

/*Problem Statement 2:  
Sarah, from the healthcare department, has noticed many people do not claim insurance for their treatment. 
She has requested a state-wise report of the percentage of treatments that took place without claiming insurance.
 Assist Sarah by creating a report as per her requirement.*/
with 
claim_stats as (select state,
sum(case when claimid is null then 1 else 0 end ) as no_claims_count,
count(tr.treatmentid) as Total_treatments
from address ad join person p using(addressid) 
join patient pt on p.personid=pt.patientid join treatment tr using(patientid) group by state)
select state,no_claims_count,Total_treatments,no_claims_count/Total_treatments*100 as 'percentage of treatments with no claims' 
from claim_stats ;



/*Problem Statement 3:  
Sarah, from the healthcare department, is trying to understand if some diseases are spreading in a particular region. 
Assist Sarah by creating a report which shows for each state, the number of the most and least treated diseases by the 
patients of that state in the year 2022. */
with treatment_counts as 
(select state,d.diseaseName,count(tr.treatmentid) as no_of_treatments
from address ad join person p using(addressid)
join patient pt on p.personid=pt.patientid join treatment tr using(patientid) join disease d using(diseaseid) 
group by state,diseaseName order by state),
most_treated as (select state,diseaseName as 'Most treated disease' from treatment_counts where (state,no_of_treatments) in (select state,max(no_of_treatments) from treatment_counts group by state)),
least_treated as (select state,diseaseName as 'least treated disease' from treatment_counts where (state,no_of_treatments) in (select state,min(no_of_treatments) from treatment_counts group by state))
select * from most_treated join least_treated using(state);




/*Problem Statement 4: 
Manish, from the healthcare department, wants to know how many registered people are registered as patients as well, in each city. 
Generate a report that shows each city that has 10 or more registered people belonging to it and the number of patients from that 
city as well as the percentage of the patient with respect to the registered people.*/
select  city,count(p.personid) as 'Total registered people',count(pt.patientid) as 'Total patients',
round(count(pt.patientid)/count(p.personid)*100,2) as 'percentage of patient with respect to the registered people'
from address ad join person p using(addressid) 
left join patient pt on p.personid=pt.patientid group by city having count(p.personid)>10; 


/*Problem Statement 5:  
It is suspected by healthcare research department that the substance “ranitidine” might be causing some side effects. 
Find the top 3 companies using the substance in their medicine so that they can be informed about it.*/
select abc.companyName from (select companyName,count(medicineid),
dense_rank() over (order by count(medicineid) desc) as company_rank from medicine where substanceName='ranitidina' 
group by companyName) abc where abc.company_rank<4; 