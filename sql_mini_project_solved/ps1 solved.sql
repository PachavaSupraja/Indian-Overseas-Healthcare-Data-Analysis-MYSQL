use healthcare;
/*
Problem Statement 1:  Jimmy, from the healthcare department, has requested a report that shows how the number of treatments each age category of patients has gone through in the year 2022. 
The age category is as follows, Children (00-14 years), Youth (15-24 years), Adults (25-64 years), and Seniors (65 years and over).
Assist Jimmy in generating the report. 
*/
with AgeCategory_table as (select patientid,age,
case 
	when age>=0 and age<=14 then 'Children'
    when age>=15 and age<=24 then 'Youth'
    when age>=25 and age<=64 then 'Adults'
    else 'Seniors'
end as AgeCategory
from (select p.patientid,year(current_date())-year(p.dob) as age from patient p) age_table)
select at.AgeCategory,count(distinct t.treatmentid) as 'count of treatments' from treatment t join AgeCategory_table at on t.patientid=at.patientid
group by AgeCategory
; 

-- problem statement 2
/*
Problem Statement 2:  Jimmy, from the healthcare department, wants to know which disease is infecting people 
of which gender more often.
Assist Jimmy with this purpose by generating a report that shows for each disease the male-to-female ratio.
 Sort the data in a way that is helpful for Jimmy.*/
 
 with 
 gender_stats as (select p.gender,d.diseaseid,d.diseaseName,count(t.patientid) as patient_count from treatment t join person p 
 on t.patientid=p.personid join disease d on t.diseaseid=d.diseaseid group by d.diseaseid)
 
select * from (select * from gender_stats gs where gs.gender='Female') fs natural join 
(select * from gender_stats gs where gs.gender='Male') ms  ;
 
 

 
 /*Problem Statement 3: Jacob, from insurance management, has noticed that insurance claims are not made for all the treatments. 
 He also wants to figure out if the gender of the patient has any impact on the insurance claim. 
 Assist Jacob in this situation by generating a report that finds for each gender the number of treatments, number of claims, 
 and treatment-to-claim ratio. And notice if there is a significant difference between the treatment-to-claim ratio of male and 
 female patients.*/
 select p.gender,count(treatmentid) as 'no of treatments',count(claimid) as 'no of claims',
 (count(treatmentid)/count(claimid)) as 'treatment-to-claim-ratio' from person p join patient pt on p.personid=pt.patientid
 join treatment t on t.patientid=pt.patientid group by p.gender;
 
/*
Problem Statement 4: The Healthcare department wants a report about the inventory of pharmacies. 
Generate a report on their behalf that shows how many units of medicine each pharmacy has in their inventory, 
the total maximum retail price of those medicines, and the total price of all the medicines after discount. 
Note: discount field in keep signifies the percentage of discount on the maximum price.
*/
select ph.pharmacyid,sum(k.quantity) as 'Total units of medicine',sum(m.maxPrice*k.quantity) as 'Max retail price',
sum(m.maxprice*k.quantity-(k.discount/100*(m.maxprice*k.quantity))) as 'Total price after discount' from pharmacy ph 
join keep k on ph.pharmacyid=k.pharmacyid join medicine m on k.medicineid=m.medicineid group by ph.pharmacyid; 

/*
Problem Statement 5:  The healthcare department suspects that some pharmacies prescribe more medicines than others 
in a single prescription, for them, generate a report that finds for each pharmacy the maximum, minimum and average number of medicines
 prescribed in their prescriptions. 
*/
with medicine_count as (select p.pharmacyid,ps.prescriptionid,count(c.medicineid) as no_of_medicines from pharmacy p join prescription ps on p.pharmacyid=ps.pharmacyid join contain c on 
ps.prescriptionid=c.prescriptionid group by p.pharmacyid,ps.prescriptionid)
select pharmacyid,max(no_of_medicines) as 'Max medicines prescribed',
min(no_of_medicines) as 'Min medicines prescribed',
round(avg(no_of_medicines)) as 'Avg medicines prescribed' from medicine_count group by pharmacyid order by pharmacyid;

