-- Q1.
   -- a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims. *NPI# 1881634483 | TOTAL CLAIMS: 99,707*


--SELECT npi, SUM(total_claim_count) AS total_claims
--FROM prescription
--GROUP BY npi
--ORDER BY total_claims DESC;


	-- b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims. *BRUCE PENDLEY FAMILY PRACTICE |  TOTAL CLAIMS: 99,707*


--SELECT npi,  prescriber.nppes_provider_first_name || ' ' || prescriber.nppes_provider_last_org_name AS prescriber, prescriber.specialty_description, SUM(total_claim_count) AS total_claims
--FROM prescription INNER JOIN prescriber USING (npi)
--GROUP BY npi, prescriber, specialty_description
--ORDER BY total_claims DESC;

-- Q2.
--		a. Which specialty had the most total number of claims (totaled over all drugs)? *FAMILY PRACTICE | TOTAL CLAIMS: 10,398,706

--SELECT specialty_description, SUM(total_claim_count) AS total_claims
--FROM prescriber INNER JOIN prescription USING (npi)
--				INNER JOIN drug USING (drug_name)
--				WHERE opioid_drug_flag = 'Y'
--GROUP BY specialty_description
--ORDER BY total_claims DESC;

--  	b. Which specialty had the most total number of claims for opioids? *NURSE PRACTITIONER | TOTAL CLAIMS: 900,845

--SELECT specialty_description, SUM(total_claim_count) AS total_claims
--FROM prescriber INNER JOIN prescription USING (npi)
--				INNER JOIN drug USING (drug_name)
--				WHERE opioid_drug_flag = 'Y'
--GROUP BY specialty_description
--ORDER BY total_claims DESC;


-- 		c. Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table? 15 DISTINCT SPECIALTIES 

--SELECT specialty_description, SUM(total_claim_count)
--FROM prescriber LEFT JOIN prescription USING (npi)
--GROUP BY specialty_description
--HAVING SUM(total_claim_count) IS NULL;

-- 		d. Do not attempt until you have solved all other problems! *For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids? *Case Manager: 75% | Orthopaedic Surgery: 68.98% | Interventional Pain Mangement: 59.47% | Anesthesiology: 58.52% | Pain Mangement: 58.08%

--SELECT *
--FROM prescriber INNER JOIN prescription USING (npi)
--				INNER JOIN drug USING (drug_name);

--SELECT SUM(total_claim_count)
--FROM prescription INNERE JOIN drug USING (drug_name);

--WITH drug_update AS (SELECT DISTINCT drug_name FROM drug)

--SELECT SUM(total_claim_count) 
--FROM prescription INNER JOIN drug_update USING (drug_name);

--SELECT specialty_description,
--ROUND(SUM(CASE WHEN opioid_drug_flag ='Y' THEN total_claim_count END)/SUM(total_claim_count) * 100, 2) AS percent_opioid_claims
--FROM prescriber 
--		INNER JOIN prescription USING (npi)
--		INNER JOIN drug USING (drug_name)
--GROUP BY specialty_description
--ORDER BY percent_opioid_claims DESC NULLS LAST;

-- Q3.
--		a. Which drug (generic_name) had the highest total drug cost? INSULIN $104,264,066.35

--SELECT generic_name, SUM(total_drug_cost::MONEY) AS total_cost
--FROM drug INNER JOIN prescription USING (drug_name)
--GROUP BY generic_name
--ORDER BY total_cost DESC;

-- 		b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.** *C1 ESTERASE INHIBITOR $3,495.22*

--SELECT generic_name, ROUND(SUM(total_drug_cost)/NULLIF(SUM(total_day_supply),0),2) AS avg_daily_cost
--FROM drug INNER JOIN prescription USING (drug_name)
--GROUP BY generic_name
--ORDER BY avg_daily_cost DESC;


-- Q4.
--  	a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs

--SELECT drug_name,
       --CASE 
       --WHEN antibiotic_drug_flag = 'Y' THEN 'Antibiotic'
       --ELSE 'Neither'
       --END AS drug_type
--FROM drug;


--      b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. *OPIOID $105,080,626.37 | ANTIBIOTIC $38,435,121.26*

--WITH drug_type AS
--(SELECT drug_name,
--		CASE WHEN opioid_drug_flag = 'Y' THEN 'Opioid' 
--			 WHEN antibiotic_drug_flag = 'Y' THEN 'Antibiotic'
-- 			 ELSE 'Neither'
--		     END AS drug_type
--FROM drug)

--SELECT drug_type, SUM(total_drug_cost)::MONEY AS total_cost
--FROM prescription INNER JOIN drug_type USING(drug_name)
--GROUP BY drug_type;


-- Q5.
--		a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee. *10 in TN*

--SELECT COUNT(DISTINCT cbsa)
--FROM cbsa INNER JOIN fips_county USING (fipscounty)
--WHERE state = 'TN';

--		b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population. NASHVILLE: LARGEST POP: 1,830,410 | MORRISTOWN: SMALLEST POP: 116,352


--SELECT cbsaname, SUM(population) AS total_pop
--FROM cbsa INNER JOIN population USING (fipscounty)
--GROUP BY cbsaname
--ORDER BY total_pop DESC;


--     c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population. SEVIER POP: 95,523

--SELECT county, population
--FROM fips_county INNER JOIN population USING (fipscounty)
--WHERE fipscounty NOT IN (SELECT fipscounty FROM cbsa)
--ORDER BY population DESC;


--Q6.
--		a.Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

--SELECT drug_name, total_claim_count
--FROM prescription
--WHERE total_claim_count >= 3000;

--		b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.

--SELECT total_claim_count, drug_name,
--CASE 
 	-- WHEN opioid_drug_flag = 'Y' THEN 'Opioid'
 	-- ELSE 'Not Opioid'
	-- END AS opioid_flag
--FROM prescription
--INNER JOIN drug USING (drug_name)
--WHERE total_claim_count >= 3000;


--		c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.

-- SELECT  nppes_provider_first_name || ' ' || prescriber.nppes_provider_last_org_name AS provider, drug.drug_name, prescription.total_claim_count,
-- CASE 
-- 	 WHEN drug.opioid_drug_flag = 'Y' THEN 'Opioid'
-- 	 ELSE 'Not Opioid'
-- 	 END AS opioid_flag
-- FROM prescription
-- INNER JOIN drug ON drug.drug_name = prescription.drug_name
-- INNER JOIN prescriber USING (npi)
-- WHERE total_claim_count >= 3000
-- ORDER BY total_claim_count DESC;

-- Q7
--		a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). **Warning:** Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

--SELECT *
--FROM prescriber CROSS JOIN drug
--WHERE specialty_description = 'Pain Management' AND nppes_provider_city = 'NASHVILLE' AND opioid_drug_flag = 'Y';

--		b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).

-- SELECT npi, drug_name, COALESCE (total_claim_count, 0) AS total_claims
-- FROM prescriber CROSS JOIN drug
-- 				LEFT JOIN prescription USING (npi, drug_name)
-- WHERE specialty_description = 'Pain Management' AND nppes_provider_city = 'NASHVILLE' AND opioid_drug_flag = 'Y';
					

--		c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.

-- SELECT drug.drug_name, npi, 
-- 	COALESCE(SUM (total_claim_count), 0) AS sum_total_claims
-- 		FROM prescriber
-- 			CROSS JOIN drug
-- 			INNER JOIN prescription USING (npi)
-- 				WHERE specialty_description = 'Pain Management' 
-- 				AND nppes_provider_city = 'NASHVILLE'
-- 				AND opioid_drug_flag = 'Y'
-- 				GROUP BY npi, drug.drug_name
-- 				ORDER BY sum_total_claims DESC;
		