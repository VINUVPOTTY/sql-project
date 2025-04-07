create database projects;
use projects;
show tables;
select * from water_pollution_disease;
-- 1.Countries with highest average contaminant levels
SELECT Country, AVG(`ContaminantLevel(ppm)`) AS Avg_Contaminant_Level 
FROM water_pollution_disease 
GROUP BY Country 
ORDER BY Avg_Contaminant_Level DESC;

-- 2.What is the average pH level by region, ordered from most acidic to most alkaline?
SELECT Region, AVG(`ph_level`) AS Avg_pH_Level
FROM water_pollution_disease
GROUP BY Region
ORDER BY Avg_pH_Level ASC;

-- 3.How many distinct water treatment methods are recorded in the dataset?
SELECT COUNT(DISTINCT `WaterSourceType`) AS Distinct_Water_Treatment_Methods
FROM water_pollution_disease;

-- 4.Which water source types (lake, river, well, etc.) are associated with the highest bacteria counts on average?
SELECT 
    WaterSourceType,
    AVG(`BacteriaCount(CFU/mL)`) AS Avg_Bacteria_Count
FROM 
    water_pollution_disease
GROUP BY 
    WaterSourceType
ORDER BY 
    Avg_Bacteria_Count DESC;
    
    
    
-- 5.How does access to clean water percentage relate to infant mortality rates across different countries?
SELECT Country,AVG(`AccesstoCleanWater(%ofPopulation)`) AS Avg_Access_To_Clean_Water,
AVG(`InfantMortalityRate(per1,000livebirths)`) AS Avg_Infant_Mortality
FROM water_pollution_disease GROUP BY Country ORDER BY Avg_Access_To_Clean_Water ASC;




-- 6.How have cholera cases per 100,000 people changed over the years in each country?
SELECT Country,Year,AVG(`CholeraCasesper100,000people`) AS Avg_Cholera_Cases
FROM water_pollution_disease
GROUP BY Country, Year
ORDER BY Country ASC,Year ASC;


-- 7.Is there a trend in water treatment methods used over time (comparing earlier vs. more recent years)?
SELECT `WaterTreatmentMethod`, Year, COUNT(*) AS Method_Usage_Count
FROM water_pollution_disease GROUP BY `WaterTreatmentMethod`, Year ORDER BY Year ASC;


-- 8.Compare the average nitrate levels between countries with high vs. low GDP per capita (define your own thresholds).
SELECT 
    CASE WHEN `GDPperCapita(USD)` > 20000 THEN 'High GDP' ELSE 'Low GDP' END AS GDP_Group,
    AVG(`NitrateLevel(mg/L)`) AS Avg_Nitrate_Level
FROM water_pollution_disease
GROUP BY GDP_Group;


-- 9.Which countries have both high turbidity (NTU) and high lead concentration in their water?
SELECT Country, `Turbidity(NTU)`, `LeadConcentration(Âµg/L)`
FROM water_pollution_disease
ORDER BY `Turbidity(NTU)` DESC;


-- 10. Create a ranking of countries by their overall water quality (consider multiple factors like contaminant level, pH, turbidity, etc.).
SELECT Country, (`BacteriaCount(CFU/mL)` + `NitrateLevel(mg/L)` + `LeadConcentration(Âµg/L)` + `Turbidity(NTU)`) - ABS(`ph_level` - 7)
AS Water_Quality_Score
FROM water_pollution_disease
ORDER BY Water_Quality_Score ASC;


-- 11.Identify regions where water treatment methods don't seem to be effectively reducing disease cases.
SELECT Region, AVG(`DiarrhealCasesper100,000people`) AS Avg_Diarrheal_Cases
FROM water_pollution_disease
WHERE `WaterTreatmentMethod` IS NOT NULL
GROUP BY Region
ORDER BY Avg_Diarrheal_Cases DESC;

-- 12.Are there any records with impossible or highly unlikely values (e.g., pH outside 0-14 range)?
SELECT *  FROM water_pollution_disease WHERE `pH_level` < 0 OR `pH_level`> 14;

-- 13.How complete is the data for each country (percentage of null values per country)?
SELECT 
  Country,(SUM((`pH_level` IS NULL) + (`DissolvedOxygen(mg/L)` IS NULL) + (`Turbidity(NTU)` IS NULL)
  + (`LeadConcentration(Âµg/L)` IS NULL) + (`AccesstoCleanWater(%ofPopulation)` IS NULL)
    + (`DiarrhealCasesper100,000people` IS NULL) + (`TyphoidCasesper100,000people` IS NULL)
    + (`CholeraCasesper100,000people` IS NULL)) / (COUNT(*) * 8)) * 100 AS Null_Percentage
FROM water_pollution_disease
GROUP BY Country
ORDER BY Null_Percentage DESC;

-- 14.What would be the most insightful way to visualize the relationship between sanitation coverage and waterborne diseases?
SELECT Country,
    `SanitationCoverage(%ofPopulation)` AS Sanitation_Coverage,
    `DiarrhealCasesper100,000people` AS Diarrheal_Cases FROM water_pollution_disease
WHERE `SanitationCoverage(%ofPopulation)` IS NOT NULL 
    AND `DiarrhealCasesper100,000people` IS NOT NULL;
    
    
-- 15.How could you present the geographical distribution of water quality issues using this data?
SELECT Country,Region,
    AVG(`ContaminantLevel(ppm)`) AS Avg_Contaminant_Level,
    AVG(`Turbidity(NTU)`) AS Avg_Turbidity,
    AVG(`LeadConcentration(Âµg/L)`) AS Avg_Lead,
    AVG(`pH_level`) AS Avg_pH
FROM water_pollution_disease GROUP BY Country, Region ORDER BY Region, Avg_Contaminant_Level DESC;
