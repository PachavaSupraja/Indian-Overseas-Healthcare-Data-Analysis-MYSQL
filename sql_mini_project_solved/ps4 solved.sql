use healthcare;
/*
“HealthDirect” pharmacy finds it difficult to deal with the product type of medicine being displayed in numerical form, 
they want the product type in words. Also, they want to filter the medicines based on tax criteria. 
Display only the medicines of product categories 1, 2, and 3 for medicines that come under tax category I 
and medicines of product categories 4, 5, and 6 for medicines that come under tax category II.
Write a SQL query to solve this problem.
ProductType numerical form and ProductType in words are given by
1 - Generic, 
2 - Patent, 
3 - Reference, 
4 - Similar, 
5 - New, 
6 - Specific,
7 - Biological, 
8 – Dinamized
**/
select *,
case 
when producttype=1 then 'Generic'
when producttype=2 then 'Patent'
when producttype=3 then 'Reference'
when producttype=4 then 'Similar'
when producttype=5 then 'New'
when producttype=6 then 'Specific'
when producttype=7 then 'Biological'
else 'Dinamized'
end as product_category from medicine
where (taxcriteria='I' and productType in (1,2,3)) or (taxcriteria='II' and productType in (4,5,6))
;

/*Problem Statement 2:  
'Ally Scripts' pharmacy company wants to find out the quantity of medicine prescribed in each of its prescriptions.
Write a query that finds the sum of the quantity of all the medicines in a prescription and if the total quantity of medicine
 is less than 20 tag it as “low quantity”. If the quantity of medicine is from 20 to 49 (both numbers including) tag 
 it as “medium quantity“ and if the quantity is more than equal to 50 then tag it as “high quantity”.
Show the prescription Id, the Total Quantity of all the medicines in that prescription, and the Quantity tag for all the 
prescriptions issued by 'Ally Scripts'.
3 rows from the resultant table may be as follows:
prescriptionID	totalQuantity	Tag
1147561399		43			Medium Quantity
1222719376		71			High Quantity
1408276190		48			Medium Quantity */
select pr.prescriptionid,sum(quantity) as Total_quantity,
case 
when sum(quantity)<20 then 'low quantity'
when sum(quantity)>=20 and sum(quantity)<=49 then 'Medium quantity'
else 'high quantity'
end as Tag
 from prescription pr join contain c using(prescriptionid)
group by pr.prescriptionid;


/*
Problem Statement 3: 
In the Inventory of a pharmacy 'Spot Rx' the quantity of medicine is considered ‘HIGH QUANTITY’ when the quantity exceeds 7500 
and ‘LOW QUANTITY’ when the quantity falls short of 1000. The discount is considered “HIGH” if the discount rate on a product 
is 30% or higher, and the discount is considered “NONE” when the discount rate on a product is 0%.
 'Spot Rx' needs to find all the Low quantity products with high discounts and all the high-quantity products with no 
 discount so they can adjust the discount rate according to the demand. 
Write a query for the pharmacy listing all the necessary details relevant to the given requirement.
Hint: Inventory is reflected in the Keep table.*/
with
medicine_cat as 
(select medicineid,
case 
when quantity>7500 then 'High quantity'
when quantity<1000 then 'Low Quantity'
end as Quantity_category,
case 
when discount>=30 then 'High'
when discount=0 then 'None'
else 'Low' end as discount_category
from pharmacy ph join keep k  where pharmacyName='Spot Rx')

select * from medicine_cat where
(Quantity_category='High quantity' and discount_category='None') or
(Quantity_category='Low quantity' and discount_category='High');


/* Problem Statement 4: 
Mack, From HealthDirect Pharmacy, wants to get a list of all the affordable and costly, hospital-exclusive medicines in the database.
 Where affordable medicines are the medicines that have a maximum price of less than 50% of the avg maximum price of all the medicines
 in the database, and costly medicines are the medicines that have a maximum price of more than double the avg maximum price of all 
 the medicines in the database.  Mack wants clear text next to each medicine name to be displayed that identifies the medicine as 
 affordable or costly. The medicines that do not fall under either of the two categories need not be displayed.
Write a SQL query for Mack for this requirement.*/
with
medicine_cat as 
(select medicineid,productName,
case 
when maxPrice<(50/100*(select avg(maxPrice) from medicine)) then 'Affordable'
when maxPrice>(2*(select avg(maxPrice) from medicine)) then 'Costly'
else 'None'
end as Medicine_Price_Category
from medicine where hospitalExclusive='S')
select * from medicine_cat where Medicine_Price_Category<>"None";


/*Problem Statement 5:  
The healthcare department wants to categorize the patients into the following category.
YoungMale: Born on or after 1st Jan  2005  and gender male.
YoungFemale: Born on or after 1st Jan  2005  and gender female.
AdultMale: Born before 1st Jan 2005 but on or after 1st Jan 1985 and gender male.
AdultFemale: Born before 1st Jan 2005 but on or after 1st Jan 1985 and gender female.
MidAgeMale: Born before 1st Jan 1985 but on or after 1st Jan 1970 and gender male.
MidAgeFemale: Born before 1st Jan 1985 but on or after 1st Jan 1970 and gender female.
ElderMale: Born before 1st Jan 1970, and gender male.
ElderFemale: Born before 1st Jan 1970, and gender female.
Write a SQL query to list all the patient name, gender, dob, and their category.*/
select pt.dob,p.gender,
case
when pt.dob>='2005-01-01' and gender='male' then 'YoungMale'
when pt.dob>='2005-01-01' and gender='female' then 'YoungFemale'
when pt.dob<='2005-01-01' and gender='male' then 'AdultMale'
when pt.dob<='2005-01-01' and gender='female' then 'AdultFemale'
when pt.dob<='1985-01-01' and pt.dob>='1970-01-01' and gender='male' then 'MidAgeMale'
when pt.dob<='1985-01-01' and pt.dob>='1970-01-01' and gender='female' then 'MidAgeFemale'
when pt.dob<='1970-01-01' and gender='male' then 'ElderMale'
when pt.dob<='1970-01-01' and gender='female' then 'ElderFemale'
end as Age_category
from patient pt join person p on p.personid=pt.patientid;


