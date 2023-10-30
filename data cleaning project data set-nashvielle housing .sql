/*
cleaning data in sql queries
*/

select * 
from datacleaning.dbo.Sheet1$

--standardize date format

select saledateconverted , convert(date,SaleDate)
from datacleaning.dbo.Sheet1$

update Sheet1$
set saledate=convert(date,saledate)


alter table sheet1$
add saledateconverted date;


update Sheet1$
set saledateconverted =convert(date,SaleDate)




--populate property address data

select * 
from datacleaning.dbo.Sheet1$
order by ParcelID





select a.ParcelID,b.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.propertyaddress,b.PropertyAddress) 
from datacleaning.dbo.Sheet1$ a
join datacleaning.dbo.Sheet1$ b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=ISNULL(a.propertyaddress,b.PropertyAddress) 
from datacleaning.dbo.Sheet1$ a
join datacleaning.dbo.Sheet1$ b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


select * from datacleaning.dbo.Sheet1$



--breaking out address int indiviual columns(address,city,state)


select PropertyAddress
from datacleaning.dbo.Sheet1$
order by ParcelID

select 
SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1) as address
,SUBSTRING(PropertyAddress,charindex(',',propertyaddress)+1,LEN(propertyaddress))as city
from datacleaning.dbo.Sheet1$



alter table datacleaning.dbo.sheet1$
add propertysplitaddress nvarchar(255);


update  datacleaning.dbo.Sheet1$
set propertysplitaddress =SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1)


alter table datacleaning.dbo.sheet1$
add propertysplitcity nvarchar(255);


update datacleaning.dbo.Sheet1$
set propertysplitcity=substring(PropertyAddress,charindex(',',propertyaddress)+1,LEN(propertyaddress))

select * from
datacleaning.dbo.Sheet1$


select
PARSENAME(replace(owneraddress,',','.'),3)
,PARSENAME(replace(owneraddress,',','.'),2)
,PARSENAME(replace(owneraddress,',','.'),1)
from datacleaning.dbo.sheet1$

alter table datacleaning.dbo.sheet1$
add ownersplitaddress nvarchar(255);


update  datacleaning.dbo.Sheet1$
set ownersplitaddress =PARSENAME(replace(owneraddress,',','.'),3)


alter table datacleaning.dbo.sheet1$
add ownersplitcity nvarchar(255);


update datacleaning.dbo.Sheet1$
set ownersplitcity=PARSENAME(replace(owneraddress,',','.'),2)

alter table datacleaning.dbo.sheet1$
add ownersplitstate nvarchar(255);


update datacleaning.dbo.Sheet1$
set ownersplitstate=PARSENAME(replace(owneraddress,',','.'),1)

select * 
from datacleaning.dbo.Sheet1$




--change y and n to yes and no in "sold as vacant" field


select distinct(soldasvacant),count(soldasvacant)
from datacleaning.dbo.Sheet1$
group by  SoldAsVacant
order by 2



select SoldAsVacant
,case when SoldAsVacant='Y' then 'Yes'
	  when SoldAsVacant='N' then 'No'
	  else SoldAsVacant
	  end
from datacleaning.dbo.Sheet1$


update datacleaning.dbo.Sheet1$
set SoldAsVacant = case when SoldAsVacant='Y' then 'Yes'
	  when SoldAsVacant='N' then 'No'
	  else SoldAsVacant
	  end

--removing duplicates


with rownum as(
select *,
	ROW_NUMBER() over(
	partition by parcelid,
				 propertyaddress,
				 saleprice,
				 saledate,
				 legalreference
				 order by
					uniqueid
					)row_num
from datacleaning.dbo.Sheet1$
--order by ParcelID
)
select *
from rownum
where row_num>1
--order by PropertyAddress

--delete unused columns

select * 
from datacleaning.dbo.Sheet1$

alter table datacleaning.dbo.sheet1$
drop column owneraddress,taxdistrict,propertyaddress
