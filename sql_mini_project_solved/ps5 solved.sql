/*Problem Statement 1: 
Johansson is trying to prepare a report on patients who have gone through treatments more than once. Help Johansson prepare a report 
that shows the patient's name, the number of treatments they have undergone, and their age, Sort the data in a way that the patients
 who have undergone more treatments appear on top.*/
 with treatments_count as (select patientid,count(treatmentid) as no_of_treatments from patient join treatment using(patientid) 
 group by patientid)
 select patientid,personName,
 year(tr.date)-year(pt.dob) as age,
 tc.no_of_treatments
 from patient pt join person p on pt.patientid=p.personid join treatment tr using(patientid) join treatments_count tc using(patientid)
 order by tc.no_of_treatments desc;
 
/*Problem Statement 2:  
Bharat is researching the impact of gender on different diseases, He wants to analyze if a certain disease is more likely to infect a 
certain gender or not.Help Bharat analyze this by creating a report showing for every disease how many males and females underwent 
treatment for each in the year 2021. It would also be helpful for Bharat if the male-to-female ratio is also shown.*/
select d.diseaseName,p.gender,count(tr.treatmentid) as no_of_treatments
from person p join patient pt on p.personid=pt.patientid join treatment tr using(patientid) join disease d using(diseaseid)
where year(tr.date)='2021'
group by d.diseaseName,p.gender order by d.diseaseName; 

/*Problem Statement 3:  
Kelly, from the Fortis Hospital management, has requested a report that shows for each disease, the top 3 cities that had the most
 number treatment for that disease.
Generate a report for Kelly’s requirement.*/
select diseaseName,city from (select diseaseName,city,count(tr.treatmentID) ,
rank() over (partition by diseaseName order by count(tr.treatmentID) desc ) as ranked
from address ad join person p using(addressid) join patient pt on p.personid=pt.patientid
join treatment tr using(patientid) join disease d using(diseaseid) 
group by d.diseaseName,ad.city) a where ranked<4; 

/*Problem Statement 4: 
Brooke is trying to figure out if patients with a particular disease are preferring some pharmacies over others or not,
 For this purpose, she has requested a detailed pharmacy report that shows each pharmacy name, and how many prescriptions 
 they have prescribed for each disease in 2021 and 2022, She expects the number of prescriptions prescribed in 2021 and 2022
 be displayed in two separate columns.
Write a query for Brooke’s requirement.*/
select pharmacyName,d.diseaseName,
sum(case when year(tr.date)='2021' then 1 else 0 end) as treatments_2021,
sum(case when year(tr.date)='2022' then 1 else 0 end) as treatments_2022
from pharmacy ph join prescription pr using(pharmacyid) join treatment tr 
using(treatmentid) join disease d using(diseaseid)
group by pharmacyName,d.diseaseName order by pharmacyName;


/*Problem Statement 5:  
Walde, from Rock tower insurance, has sent a requirement for a report that presents which insurance company is targeting the patients 
of which state the most. Write a query for Walde that fulfills the requirement of Walde.
Note: We can assume that the insurance company is targeting a region more if the patients of that region are claiming more 
insurance of that company.*/
select  ic.companyName,ad.state,count(claimid)
from insurancecompany ic join address ad using(addressid) join insuranceplan ip using(companyid) join claim c using(uin)
group by ic.companyName,ad.state order by CompanyName;

