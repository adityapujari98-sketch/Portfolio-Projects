-- Exploratory data analysis

Select *
From layoffs_staging3;

Select Max(total_laid_off) , Max(percentage_laid_off)
From layoffs_staging3;

Select *
From layoffs_staging3
where percentage_laid_off = 1 
order by funds_raised_millions Desc;


Select Company , Sum(total_laid_off)
From layoffs_staging3
group by company
Order by 2 Desc;

Select Min(`date`) , Max(`date`)
From layoffs_staging3;

Select Year(`date`) , Sum(total_laid_off)
From layoffs_staging3
group by Year(`date`)	
Order by 1 Desc;


Select substring(`date`,1,7) as `month`, sum(total_laid_off)
from layoffs_staging3
Group by substring(`date`,1,7) 
order by 1 asc;

With rolling_total as 
( Select substring(`date`,1,7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging3
Group by substring(`date`,1,7) 
order by 1 asc
)
Select `month`, total_off ,
 Sum(total_off) over(order by `month`)
from rolling_total;

Select Company , Sum(total_laid_off)
From layoffs_staging3
group by company
Order by 2 Desc;

Select Company , year(`date`), Sum(total_laid_off)
From layoffs_staging3
group by company, Year(`date`)
order by 3 desc; 


With company_year (company, years ,total_laid_off)  as
(
Select Company , year(`date`), Sum(total_laid_off)
From layoffs_staging3
group by company, Year(`date`)
), company_year_rank as 
(
Select *, Dense_rank() over(partition by  years order by total_laid_off Desc) as ranking
from company_year
where years is not null
)
select*
from company_year_rank
where ranking <= 5
;