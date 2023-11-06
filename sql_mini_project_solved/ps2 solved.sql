use healthcare;
/*Problem Statement 1: A company needs to set up 3 new pharmacies, they have come up with an idea that the pharmacy can be set up in cities
 where the pharmacy-to-prescription ratio is the lowest and the number of prescriptions should exceed 100.
 Assist the company to identify those cities where the pharmacy can be set up.*/
select ad.city,count(distinct ph.pharmacyid)/count(distinct pr.prescriptionid)as pharmacy_to_prescription_ratio from address ad left join pharmacy ph using(addressid)
left join prescription pr on ph.pharmacyid=pr.pharmacyid group by ad.city having count(pr.prescriptionid)>100 order by pharmacy_to_prescription_ratio limit 3; 

/*
Problem Statement 2: The State of Alabama (AL) is trying to manage its healthcare resources more efficiently. 
For each city in their state, they need to identify the disease for which the maximum number of patients have gone for treatment. 
Assist the state for this purpose.
Note: The state of Alabama is represented as AL in Address Table.*/

with patients_stats as 
(select distinct ad.city,d.diseaseName,count(tr.treatmentid) as 'no_of_patients' from address ad join person p using(addressid) join patient pt on p.personid=pt.patientid join treatment tr
using(patientid) join disease d using(diseaseid) where ad.state='AL' group by ad.city,d.diseaseName)
select * from patients_stats where (city,no_of_patients) in (select city,max(no_of_patients) from patients_stats group by city);


/*Problem Statement 3: The healthcare department needs a report about insurance plans. 
The report is required to include the insurance plan, which was claimed the most and least for each disease.  
Assist to create such a report.*/

with 
claim_report as 
(select d.diseaseName,ip.planName,count(ip.uin) as claim_count from insuranceplan ip join claim c on ip.uin=c.uin
join treatment tr on c.claimid=tr.claimid join disease d on d.diseaseid=tr.diseaseid
group by ip.planName,d.diseaseName),
max_claims as (select diseaseName,planName as 'Insurance Plan with Max claims ',claim_count as 'max_claims' from claim_report 
where (diseasename,claim_count) in (select  diseasename,max(claim_count) from claim_report group by diseaseName)),
min_claims as (select diseaseName,planName as 'Insurance Plan with Min claims ',claim_count as 'min_claims' from claim_report 
where (diseasename,claim_count) in (select  diseasename,min(claim_count) from claim_report group by diseaseName))
select * from max_claims join min_claims using(diseasename);


/* Problem Statement 4: The Healthcare department wants to know which disease is most likely to infect multiple people in the same 
household. For each disease find the number of households that has more than one patient with the same disease. */
select ad.addressid,d.diseaseName,count(p.personid) as 'Total househlds',count(distinct pt.patientid)
as 'count of households infected' from person p join address ad using(addressid) left join patient pt on p.personid=pt.patientid 
left join treatment using(patientid) left join disease d using(diseaseid) group by ad.addressid,d.diseaseName
 having count(distinct pt.patientid)>1 order by ad.addressid;
 
 /*Problem Statement 5:  An Insurance company wants a state wise report of the treatments to claim ratio 
 between 1st April 2021 and 31st March 2022 (days both included).
 Assist them to create such a report.*/

select ad.state,count(tr.treatmentid)/count(tr.claimid) as Treatments_to_claim_ratio from address ad
join person p on p.addressid=ad.addressid join patient pt on p.personid=pt.patientid join treatment tr on tr.patientid=pt.patientid 
where (tr.date between '2021-04-01' and '2022-03-31')  group by ad.state;

 
