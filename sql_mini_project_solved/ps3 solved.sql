use healthcare;
/* Problem Statement 1:  Some complaints have been lodged by patients that they have been prescribed hospital-exclusive medicine 
that they can’t find elsewhere and facing problems due to that. Joshua, from the pharmacy management, 
wants to get a report of which pharmacies have prescribed hospital-exclusive medicines the most in the years 2021 and 2022.
 Assist Joshua to generate the report so that the pharmacies who prescribe hospital-exclusive medicine more often are advised 
 to avoid such practice if possible.   */
 select 
 ph.pharmacyName,count(m.medicineid) as Medicines_count
 from pharmacy ph join prescription pr using(pharmacyid) join contain c on c.prescriptionid=pr.prescriptionid
 left join medicine m on m.medicineid=c.medicineid join treatment tr on pr.treatmentid=tr.treatmentid 
 where year(tr.date) in ('2021','2022') and m.hospitalExclusive='S' group by ph.pharmacyName order by Medicines_count desc;
 

/* Problem Statement 2: Insurance companies want to assess the performance of their insurance plans. Generate a report that shows each 
insurance plan, the company that issues the plan, and the number of treatments the plan was claimed for.*/
select ip.planName,ic.companyName,count(c.claimid) as No_of_treatments from insurancecompany ic join insuranceplan ip using(companyid)
join claim c using(uin) join treatment tr using(claimid) group by ip.planName,ic.companyName;
 
 /*Problem Statement 3: Insurance companies want to assess the performance of their insurance plans. 
 Generate a report that shows each insurance company's name with their most and least claimed insurance plans.*/
 with 
 performance_report as (select ic.CompanyName,ip.planName,count(tr.claimid) as claim_count from insurancecompany ic join insuranceplan ip using(companyid) join claim c using(uin) join treatment tr using(claimid) 
 group by ic.CompanyName,ip.planName order by ic.companyName),
 most_claimed as ( select CompanyName,planName as 'Most claimed plan',claim_count from performance_report where (CompanyName,claim_count) 
 in (select CompanyName,max(claim_count) as claim_count from performance_report group by CompanyName)),
 least_claimed as ( select CompanyName,planName as 'least claimed plan',claim_count from performance_report where (CompanyName,claim_count) 
 in (select CompanyName,min(claim_count) as claim_count from performance_report group by CompanyName))
select * from least_claimed join most_claimed using(companyName);

/*Problem Statement 4:  The healthcare department wants a state-wise health report to assess which state requires more attention 
in the healthcare sector. Generate a report for them that shows the state name, number of registered people in the state,
 number of registered patients in the state, and the people-to-patient ratio. sort the data by people-to-patient ratio.*/
 with
 registered_people as (select state,count(p.personid) as people from address ad join person p using(addressid) group by state),
 registered_patients as (select state,count(pt.patientid) as patients  from address ad join person p using(addressid) join patient pt 
 on p.personid=pt.patientid group by state)
 select state,people,patients,round(people/patients,2) as people_to_patient_ratio from registered_people join  registered_patients using(state) 
 order by people_to_patient_ratio ;
 

/*Problem Statement 5:  Jhonny, from the finance department of Arizona(AZ), has requested a report that lists the total quantity 
of medicine each pharmacy in his state has prescribed that falls under Tax criteria I for treatments that took place in 2021. 
Assist them to create such a report.*/
select ph.pharmacyName,sum(c.quantity) as 'Total quantity of medicine' from pharmacy ph join prescription pr using(pharmacyid) join contain c using(prescriptionid)
 join medicine m using(medicineid)
join address ad using(addressid) join treatment tr using(treatmentid) where ad.state='AZ' and m.taxcriteria='I' 
and year(tr.date)='2021'
group by ph.pharmacyName;


 