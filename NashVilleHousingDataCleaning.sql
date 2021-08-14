/* 
   cleaning data using sql queries

*/

SELECT *
FROM [PortfolioProject].[dbo].[NashvilleHousing]


-- Standardize Date Format

SELECT SaleDate
FROM [PortfolioProject].[dbo].[NashvilleHousing]

Select SaleDate, CONVERT(Date,SaleDate)
From [PortfolioProject].[dbo].[NashvilleHousing]

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

 --IF Update didn't work, use Alter

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted, CONVERT(Date,SaleDate)
From [PortfolioProject].[dbo].[NashvilleHousing]

----------------------------------------------------------------------------------------------------------------------------------------------------------------------


----------------Populate Property Address Data-----------------------

SELECT *
From [PortfolioProject].[dbo].[NashvilleHousing]
--WHERE PropertyAddress is NULL
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From [PortfolioProject].[dbo].[NashvilleHousing] a
JOIN [PortfolioProject].[dbo].[NashvilleHousing] b
     ON a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From [PortfolioProject].[dbo].[NashvilleHousing] a
JOIN [PortfolioProject].[dbo].[NashvilleHousing] b
     ON a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

------------------------------------------------------------------------------------------------------------------------------------------------------------------





-------------------------------- Breaking out Address into Individual Columns (Address, City, State)




SELECT PropertyAddress
FROM  [PortfolioProject].[dbo].[NashvilleHousing] 


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City
From [PortfolioProject].[dbo].[NashvilleHousing]



ALTER TABLE [PortfolioProject].[dbo].[NashvilleHousing]
Add PropertySplitAddress Nvarchar(255);

UPDATE [PortfolioProject].[dbo].[NashvilleHousing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [PortfolioProject].[dbo].[NashvilleHousing]
Add PropertySplitCity Nvarchar(255);

UPDATE [PortfolioProject].[dbo].[NashvilleHousing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


SELECT *
From [PortfolioProject].[dbo].[NashvilleHousing]





SELECT OwnerAddress
From [PortfolioProject].[dbo].[NashvilleHousing]



SELECT 
PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 1)
From [PortfolioProject].[dbo].[NashvilleHousing]


ALTER TABLE [PortfolioProject].[dbo].[NashvilleHousing]
Add OwnerSplitAddress Nvarchar(255);

UPDATE [PortfolioProject].[dbo].[NashvilleHousing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 3)



ALTER TABLE [PortfolioProject].[dbo].[NashvilleHousing]
Add OwnerSplitCity Nvarchar(255);

UPDATE [PortfolioProject].[dbo].[NashvilleHousing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 2)



ALTER TABLE [PortfolioProject].[dbo].[NashvilleHousing]
Add OwnerSplitState Nvarchar(255);

UPDATE [PortfolioProject].[dbo].[NashvilleHousing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 1)



Select *
From [PortfolioProject].[dbo].[NashvilleHousing]




---------------------------------------------------------------------------------------------------------------------------------------------------------------------






----------------------------------------------------Change Y and N to Yes and No in "Sold as Vacant" field


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
From [PortfolioProject].[dbo].[NashvilleHousing]
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
From [PortfolioProject].[dbo].[NashvilleHousing]

UPDATE [PortfolioProject]..[NashvilleHousing]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

	   
SELECT *
From [PortfolioProject].[dbo].[NashvilleHousing]



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------







---------------------------------------------------------Remove Duplicates


WITH RowNumCTE AS(
SELECT *,
      ROW_NUMBER() OVER(
	  PARTITION BY ParcelID,
	               PropertyAddress,
				   SaleDate,
				   SalePrice,
				   LegalReference
				   ORDER BY
				     UniqueID
					 ) row_num
FROM [PortfolioProject].[dbo].[NashvilleHousing]
--ORDER BY ParcelID
)
SELECT *
From RowNumCTE
WHERE row_num >1
ORDER BY PropertyAddress

DELETE
FROM RowNumCTE
WHERE row_num >1

-------------------------------------------------------------------------------------------------------------------------------------------------------------------



-------------------------------------------DELETE UNUSED COLUMNS



Select *
From [PortfolioProject].[dbo].[NashvilleHousing]


ALTER TABLE [PortfolioProject].[dbo].[NashvilleHousing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate