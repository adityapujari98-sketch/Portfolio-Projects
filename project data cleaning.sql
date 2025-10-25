-- Data cleaning Project
Select *
from layoffs;
-- 1 remove duplicates
-- 2 standardize the data
-- 3 null/blank values
-- 4 remove any columns 

Create table layoffs_staging	
like layoffs;

Select *
from layoffs_staging;

Insert layoffs_staging
select *
from layoffs;


Select *,
row_number() over(Partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_staging;

with duplicate_cte as 
(
select *,
row_number() over(Partition by company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
Select *
from duplicate_cte
where row_num > 1;

Select *
from layoffs_staging
where company = 'Casper';


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


Select *
from layoffs_staging2
where row_num > 1;

Insert into layoffs_staging2
select *,
row_number() over(Partition by company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;


DELETE
from layoffs_staging2
where row_num > 1;


Select *
from layoffs_staging2;

-- Standardizing data
Select company, TRIM(company)
from layoffs_staging2;
Update layoffs_staging2
Set company = TRIM(company);

Select Distinct industry
from layoffs_staging2;


Update layoffs_staging2
Set industry = 'Crypto'
where industry like 'Crypto%';

Select Distinct country, trim(trailing  '.' from country)
from layoffs_staging2
order by 1;

Update layoffs_staging2
Set country = trim(trailing  '.' from country)
where country like 'United States%';

Select `date`
from layoffs_staging2;

Update layoffs_staging2
Set `date` = str_to_date(`date`, '%m/%d/%Y');

alter table layoffs_staging2
modify column `date` Date;

Select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

update layoffs_staging2 
set industry = null  
where industry = '';	




Select * 
from layoffs_staging2
where industry is null 
or industry = '';

Select * 
from layoffs_staging2
where company like 'Bally%';

Select t1.industry , t2.industry
from layoffs_staging2 as t1
join layoffs_staging2 as t2
	on t1.company = t2.company
    and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null; 

Update  layoffs_staging2 as t1
join layoffs_staging2 as t2
	on t1.company = t2.company
Set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;  


select *
from layoffs_staging2;
alter table layoffs_staging2
drop column row_num; 