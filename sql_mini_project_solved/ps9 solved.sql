use healthcare;
/*Problem Statement 1: 
Brian, the healthcare department, has requested for a report that shows for each state how many people underwent treatment for the 
disease “Autism”.  He expects the report to show the data for each state as well as each gender and for each state and gender combination. 
Prepare a report for Brian for his requirement.*/
select ad.state,p.gender,count(tr.treatmentid) from address ad join person p using(addressid)
join patient pt on p.personid=pt.patientid join treatment tr using(patientid)
 join disease d using(diseaseid)
where d.diseaseName='Autism'
group by p.gender,ad.state with rollup;
/*union*/
select ad.state,p.gender,count(tr.treatmentid) from address ad join person p using(addressid)
join patient pt on p.personid=pt.patientid join treatment tr using(patientid)
 join disease d using(diseaseid)
where d.diseaseName='Autism'
group by ad.state,p.gender with rollup;

/*Problem Statement 2:  
Insurance companies want to evaluate the performance of different insurance plans they offer. 
Generate a report that shows each insurance plan, the company that issues the plan, and the number of treatments the plan was claimed for. 
The report would be more relevant if the data compares the performance for different years(2020, 2021 and 2022) and if the report also 
includes the total number of claims in the different years, as well as the total number of claims for each plan in all 3 years combined.*/
select ic.companyName,ip.planName,year(tr.date),count(c.claimid) from insuranceCompany ic
join insuranceplan ip using(companyid) join claim c using(uin)
join treatment tr using(claimid) 
where year(tr.date) in ('2020','2021','2022')
group by 1,2,year(tr.date) with rollup;

/*Problem Statement 3:  
Sarah, from the healthcare department, is trying to understand if some diseases are spreading in a particular region. 
Assist Sarah by creating a report which shows each state the number of the most and least treated diseases by the patients of 
that state in the year 2022. It would be helpful for Sarah if the aggregation for the different combinations is found as well.
 Assist Sarah to create this report. */
 

/*Problem Statement 4: 
Jackson has requested a detailed pharmacy report that shows each pharmacy name, and how many prescriptions they have prescribed 
for each disease in the year 2022, along with this Jackson also needs to view how many prescriptions were prescribed by each pharmacy,
 and the total number prescriptions were prescribed for each disease.
Assist Jackson to create this report. */
select coalesce(ph.pharmacyName,'Total') as pharmacyName,coalesce(d.diseaseName,'Total'),count(pr.prescriptionid) as no_of_prescriptions 
from pharmacy ph
join prescription pr using(pharmacyid) join treatment tr using(treatmentid) 
join disease d using(diseaseid)
where year(tr.date)='2022'
group by ph.pharmacyName,d.diseaseName with rollup
union
select 'Total' as pharmacyName,coalesce(d.diseaseName,'Total') as diseaseName,count(pr.prescriptionid) as no_of_prescriptions 
from pharmacy ph
join prescription pr using(pharmacyid) join treatment tr using(treatmentid) 
join disease d using(diseaseid)
where year(tr.date)='2022'
group by d.diseaseName with rollup;

/*Problem Statement 5:  
Praveen has requested for a report that finds for every disease how many males and females underwent treatment for each in the year 2022.
 It would be helpful for Praveen if the aggregation for the different combinations is found as well.
Assist Praveen to create this report. */
select 'Total' as diseaseName,coalesce(p.gender,'Total'),count(tr.treatmentid) from person p join patient pt on p.personid=pt.patientid
join treatment tr using(patientid) join disease d using(diseaseid)
group by p.gender with rollup
union
select coalesce(d.diseaseName,'Total'),coalesce(p.gender,'Total'),count(tr.treatmentid) from person p join patient pt on p.personid=pt.patientid
join treatment tr using(patientid) join disease d using(diseaseid)
group by d.diseaseName,p.gender with rollup;
