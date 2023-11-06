use healthcare;
/*Problem Statement 1:
Patients are complaining that it is often difficult to find some medicines. They move from pharmacy to pharmacy to get the 
required medicine. A system is required that finds the pharmacies and their contact number that have the required medicine in 
their inventory. So that the patients can contact the pharmacy and order the required medicine.
Create a stored procedure that can fix the issue.*/
drop procedure get_pharmacy_info;
delimiter $$
create procedure get_pharmacy_info(medicineName varchar(30))
begin
select ph.pharmacyName,ph.phone from pharmacy ph join keep k using(pharmacyid) 
join medicine m using(medicineid) where productName=medicineName;
end $$
delimiter ;
call get_pharmacy_info('OSTENAN');

/*Problem Statement 2:
The pharmacies are trying to estimate the average cost of all the prescribed medicines per prescription, 
for all the prescriptions they have prescribed in a particular year. Create a stored function that will return the required value 
when the pharmacyID and year are passed to it. Test the function with multiple values.*/
drop function get_avg_cost;
delimiter $$
create function get_avg_cost(p_id int,p_year varchar(4))
returns decimal deterministic
begin
declare result decimal;
select round(avg(c.quantity*m.maxprice),2) into result from pharmacy ph join prescription pr using(pharmacyid)
join contain c using(prescriptionid) join medicine m using(medicineid)
join treatment tr using(treatmentid)
where year(tr.date)=p_year and ph.pharmacyid=p_id;
return result;
end $$
delimiter ;
select get_avg_cost(1008,'2022');

/*Problem Statement 3:
The healthcare department has requested an application that finds out the disease that was spread the most in a state for a given year.
 So that they can use the information to compare the historical data and gain some insight.
Create a stored function that returns the name of the disease for which the patients from a particular state had the most number 
of treatments for a particular year. Provided the name of the state and year is passed to the stored function.*/
drop function most_diseased;
delimiter $$
create function most_diseased(stateName varchar(20),d_year varchar(4))
returns varchar(50) DETERMINISTIC
begin
declare d_name varchar(50);
with cte as (select d.diseaseName,
dense_rank() over (order by count(pt.patientid) desc) as ranked
from address ad
join person p using(addressid) join patient pt on p.personid=pt.patientid
join treatment tr using(patientid) join disease d using(diseaseid)
where ad.state=stateName and year(date)=d_year 
group by d.diseaseName)
select group_concat(diseaseName) into d_name from cte where ranked=1;
return d_name;
end $$
delimiter ;
select most_diseased('GA','2021');


/*Problem Statement 4:
The representative of the pharma union, Aubrey, has requested a system that she can use to find how many people in a specific city 
have been treated for a specific disease in a specific year.
Create a stored function for this purpose.*/
delimiter $$
create function no_of_treatments(city_name varchar(20),d_name varchar(20),d_year varchar(4))
returns int DETERMINISTIC
begin
DECLARE result int;
select count(tr.treatmentid) into result from address ad join person p using(addressid)
join patient pt on p.personid=pt.patientid
join treatment tr using(patientid) join disease d using(diseaseid)
where ad.city=city_name and d.diseaseName=d_name and year(tr.date)=d_year;
return result;
end $$
delimiter ;
select no_of_treatments('Savannah','Lupus','2021');

/*Problem Statement 5:
The representative of the pharma union, Aubrey, is trying to audit different aspects of the pharmacies. She has requested a system 
that can be used to find the average balance for claims submitted by a specific insurance company in the year 2022. 
Create a stored function that can be used in the requested application. */
delimiter $$
create function average_balance_of_claims(c_name varchar(50),c_year varchar(4))
returns decimal DETERMINISTIC
begin
declare result decimal;
select avg(c.balance) into result from insurancecompany ic join insuranceplan ip using(companyid)
join claim c using(uin) join treatment tr using(claimid)
where ic.companyName=c_name and year(tr.date)=c_year;
return result;
end $$
delimiter ;
select average_balance_of_claims('Niva Bupa Health Insurance Co. Ltd.','2022');

