--Cleaning Data in SQL Querie

Select*
from PortfolioProject..NashvilleHousing

-----------------------------------------------------------------------------------------------------

--Standardize Date Format

Select SaleDate2,convert(Date,SaleDate)
from PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SaleDate=convert(Date,SaleDate)

Alter Table NashvilleHousing
Add SaleDate2 Date;

Update NashvilleHousing
Set SaleDate2=convert(Date,SaleDate)

-------------------------------------------------------------------------------------------------------------------

--Populate Property Address Data

select*
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
Order by ParcelID


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
     On a.ParcelID = b.ParcelID
	 And a.[UniqueID ] <> b.[UniqueID ]
	 where a.PropertyAddress is Null

	 Update a
	 Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
	 from PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
     On a.ParcelID = b.ParcelID
	 And a.[UniqueID ] <> b.[UniqueID ]
	 where a.PropertyAddress is Null

	 -------------------------------------------------------------------------------------------------------------------

	 --Breaking out Address into Individual Columns (Address, City, State)

	 
select PropertyAddress
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
--Order by ParcelID

Select SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
from PortfolioProject..NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) 


Alter Table NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


select *
from PortfolioProject..NashvilleHousing



Select OwnerAddress
from PortfolioProject..NashvilleHousing


select 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
from PortfolioProject..NashvilleHousing



Alter Table NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)


Alter Table NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)


Alter Table NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)


select *
from PortfolioProject..NashvilleHousing

-----------------------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" Field

select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
from PortfolioProject..NashvilleHousing
Group by (SoldAsVacant)
order by 2


select SoldAsVacant
,  Case when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
		from PortfolioProject..NashvilleHousing
		

		Update NashvilleHousing
		Set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
		from PortfolioProject..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------

--Remove Duplicate
With RowNumCTE as(
              Select *,
			  ROW_NUMBER() Over(
			  Partition by ParcelID,
			  PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  Order by 
			  UniqueID
			  )row_num
From PortfolioProject..NashvilleHousing
--Order by ParcelID
)
Select*
From RowNumCTE
Where row_num>1
--Order by PropertyAddress


select *
from PortfolioProject..NashvilleHousing

-----------------------------------------------------------------------------------------------------

--Delete Unused Columns


select *
from PortfolioProject..NashvilleHousing


Alter Table  PortfolioProject..NashvilleHousing
Drop Column OwnerAddress,TaxDistrict,PropertyAddress


Alter Table  PortfolioProject..NashvilleHousing
Drop Column SaleDate