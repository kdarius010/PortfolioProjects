SELECT *
FROM layoffs_raw;


-- 1. CREATE duplicate raw table
CREATE TABLE layoffs_staging
LIKE layoffs_raw;

INSERT layoffs_staging
SELECT *
FROM layoffs_raw;

SELECT *
FROM layoffs_staging; 

-- 2. Remove Duplicates
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;

WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) as row_num
FROM layoffs_staging
)

SELECT *
FROM layoffs_staging
WHERE company = 'Casper';



CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2; 

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;

DELETE
FROM layoffs_staging2
WHERE row_num > 1; 

-- 3. Standardize Data


/* TRIM whitespace */
SELECT DISTINCT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

UPDATE layoffs_staging2
SET location = TRIM(location),
industry = TRIM(industry),
total_laid_off = TRIM(total_laid_off),
percentage_laid_off = TRIM(percentage_laid_off),
`date` = TRIM(`date`);

/* Remove . at end of 'United States */
SELECT *
FROM layoffs_staging2; 

SELECT  DISTINCT country, TRIM(Trailing '.' FROM country)
FROM layoffs_staging2;

UPDATE  layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET country = TRIM(Trailing '.' FROM country)
WHERE country LIKE 'United States%';

/* Convert date from text to date type */

SELECT date
FROM layoffs_staging2;

SELECT date
FROM layoffs_staging2
WHERE str_to_date(`date`, '%m/%d/%Y') IS NULL;


UPDATE layoffs_staging2
SET `date` = 
CASE WHEN `date` IS NOT NULL AND `date` <> 'None' THEN STR_TO_DATE(`date`, '%m/%d/%Y')
ELSE NULL END;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- -- 3. Check for Null values or blank values

SELECT *
FROM layoffs_staging2
WHERE company IS NULL
OR location IS NULL
OR industry IS NULL
OR total_laid_off IS NULL
OR percentage_laid_off IS NULL
OR `date` IS NULL
OR stage IS NULL
OR country IS NULL
OR funds_raised_millions IS NULL;

SELECT *
FROM layoffs_staging2
WHERE company = ''
OR location = ''
OR industry = ''
OR total_laid_off = ''
OR percentage_laid_off = ''
OR stage = ''
OR country = ''
OR funds_raised_millions = '';

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb' OR company = 'Carvana' OR company = 'Juul';



UPDATE layoffs_staging2
SET industry = 'Travel'
WHERE company = "Airbnb";

UPDATE layoffs_staging2
SET industry = 'Transportation'
WHERE company = "Carvana";

UPDATE layoffs_staging2
SET industry = 'Consumer'
WHERE company = "Juul";

SELECT *
FROM layoffs_staging2
WHERE company = 'None'
OR location = 'None'
OR industry = 'None'
OR total_laid_off = 'None'
OR percentage_laid_off = 'None'
OR stage = 'None'
OR country = 'None'
OR funds_raised_millions = 'None';

-- 4. Remove Ineffective Columns

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 'None' AND total_laid_off = 'None';

DELETE
FROM layoffs_staging2
WHERE percentage_laid_off = 'None' AND total_laid_off = 'None';

SELECT *
FROM layoffs_staging2;

ALTER TABLE  layoffs_staging2
DROP COLUMN row_num; 







            


