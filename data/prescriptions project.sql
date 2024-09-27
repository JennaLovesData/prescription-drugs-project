Q1.A: TOTAL CLAIMS: 99,707 - NPI:1881634483

-- SELECT SUM(prescription.total_claim_count) AS total_claims, prescriber.npi
-- FROM prescriber
-- LEFT JOIN prescription ON prescriber.npi = prescription.npi
-- WHERE prescription.total_claim_count IS NOT NULL
-- GROUP BY prescriber.npi
-- ORDER BY total_claims DESC;


-- Q1.B: BRUCE PENDLEY FAMILY PRACTICE 99,707 TOTAL CLAIMS

-- SELECT prescriber.nppes_provider_first_name || ' ' || prescriber.nppes_provider_last_org_name AS prescriber, prescriber.specialty_description,  			  	 SUM(prescription.total_claim_count) AS total_claims
-- FROM prescriber
-- LEFT JOIN prescription ON prescriber.npi = prescription.npi
-- WHERE prescription.total_claim_count IS NOT NULL
-- GROUP BY prescriber.nppes_provider_first_name, prescriber.nppes_provider_last_org_name, prescriber.specialty_description, prescriber.npi
-- ORDER BY total_claims DESC;

-- Q2.A: Family Practice Total Claims: 9,752,347

-- SELECT prescriber.specialty_description, SUM(prescription.total_claim_count) AS total_claim_count
-- FROM prescriber
-- INNER JOIN prescription ON prescriber.npi = prescription.npi
-- WHERE prescription.total_claim_count IS NOT NULL
-- GROUP BY prescriber.specialty_description
-- ORDER BY total_claim_count DESC;

-- Q2.B: NURSE PRACTITIONER: 9,551 CLAIMS

-- SELECT specialty_description, SUM(total_claim_count) AS total_claim_count, drug.opioid_drug_flag
-- FROM prescriber
-- LEFT JOIN prescription ON prescriber.npi = prescription.npi
-- LEFT JOIN drug ON prescription.drug_name = drug.drug_name
-- WHERE drug.opioid_drug_flag = 'Y'
-- GROUP BY specialty_description, drug.opioid_drug_flag
-- ORDER BY total_claim_count DESC;

-- Q2.C: 15 Unique NPI's

-- SELECT DISTINCT specialty_description
-- FROM prescriber
-- EXCEPT
-- SELECT DISTINCT specialty_description
-- FROM prescriber
-- WHERE npi IN (SELECT DISTINCT npi FROM prescription);

Q3.A: PIRFENIDONE $2,829,174.30

-- SELECT drug.generic_name, MAX(total_drug_cost::money) AS highest_drug_cost
-- FROM prescription
-- LEFT JOIN drug ON prescription.drug_name = drug.drug_name
-- GROUP BY drug.generic_name
-- ORDER BY highest_drug_cost DESC
-- LIMIT 10;

-- Q3.B: FOLIC ACID $19.59

-- SELECT drug.generic_name, ROUND(SUM(total_day_supply) / NULLIF(SUM(total_drug_cost),0),2) AS cost_per_day
-- FROM prescription
-- INNER JOIN drug ON prescription.drug_name = drug.drug_name
-- GROUP BY drug.generic_name
-- ORDER BY cost_per_day DESC;


-- Q4.A: 

-- SELECT drug_name,
-- CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid' 
-- WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
-- ELSE 'neither'
-- END AS drug_type
-- FROM drug;

-- Q4.B OPIOID $105,080,626.37 ANTIBIOTIC $38,435,121.26

-- SELECT drug_type,
-- 	SUM(total_drug_cost)::MONEY AS sum_total_drug_cost
-- 	FROM	
-- 	(SELECT drug.drug_name,
-- 	 CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
-- 		WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
-- 		ELSE 'neither' END AS drug_type
-- 	FROM drug)
-- 		INNER JOIN prescription USING(drug_name)
-- 			WHERE drug_type IN ('opioid', 'antibiotic')
-- 			GROUP BY drug_type
-- 			ORDER BY sum_total_drug_cost DESC;


-- Q5.A: 42

-- SELECT COUNT (fipscounty) AS cbsa_tn, state
-- FROM cbsa
-- INNER JOIN fips_county USING (fipscounty)
-- WHERE state = 'TN'
-- GROUP BY state; 


-- -- Q5.B: NASHVILLE, LARGEST, POP: 1,830,410 / MORRISTOWN, SMALLEST, POP: 116,352

-- SELECT SUM(population) AS total_pop, MAX(population) AS max_pop, MIN(population) AS min_pop, cbsaname
-- FROM cbsa
-- INNER JOIN population USING (fipscounty)
-- GROUP BY cbsaname
-- ORDER BY total_pop DESC;



-- Q5.C: SEVIER 95,523

-- (SELECT county, SUM(population) AS total_pop
-- FROM fips_county
-- INNER JOIN population USING (fipscounty)
-- GROUP BY county)
-- EXCEPT
-- (SELECT county, SUM(population) AS total_pop
-- FROM fips_county
-- INNER JOIN population USING (fipscounty)
-- INNER JOIN cbsa USING (fipscounty)
-- GROUP BY county)
-- ORDER BY total_pop DESC;




Q6.A

-- SELECT drug_name, total_claim_count
-- FROM prescription
-- WHERE total_claim_count >= 3000;

Q6.B

-- SELECT drug.drug_name, prescription.total_claim_count,
-- CASE 
-- 	 WHEN drug.opioid_drug_flag = 'Y' THEN 'Opioid'
-- 	 ELSE 'Not Opioid'
-- 	 END AS opioid_flag
-- FROM prescription
-- INNER JOIN drug ON drug.drug_name = prescription.drug_name
-- WHERE total_claim_count >= 3000;



-- SELECT total_claim_count, drug_name,
-- CASE 
-- 	 WHEN opioid_drug_flag = 'Y' THEN 'Opioid'
-- 	 ELSE 'Not Opioid'
-- 	 END AS opioid_flag
-- FROM prescription
-- INNER JOIN drug USING (drug_name)
-- WHERE total_claim_count >= 3000;


-- Q6.C 

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

-- Q7.A

-- SELECT  npi, drug_name
-- FROM prescriber
-- CROSS JOIN drug 
-- WHERE specialty_description = 'Pain Management' AND nppes_provider_city = 'NASHVILLE' AND opioid_drug_flag = 'Y';

-- SELECT npi, drug_name, specialty_description, nppes_provider_city, opioid_drug_flag
-- FROM prescriber 
-- CROSS JOIN drug
-- WHERE specialty_description = 'Pain Management' 
-- AND nppes_provider_city = 'NASHVILLE'
-- AND opioid_drug_flag = 'Y';

-- SELECT * 
-- FROM drug
-- WHERE opioid_drug_flag = 'Y';

--Q7.B 

-- SELECT  
-- 	drug.drug_name, 
-- 	npi,
-- 	SUM (total_claim_count) AS sum_total_claims, prescriber.nppes_provider_first_name || ' ' || prescriber.nppes_provider_last_org_name AS provider 
-- 		FROM prescriber
-- 			CROSS JOIN drug
-- 			INNER JOIN prescription USING (npi)
-- 				WHERE specialty_description = 'Pain Management' 
-- 				AND nppes_provider_city = 'NASHVILLE'
-- 				AND opioid_drug_flag = 'Y'
-- 					GROUP BY npi, drug.drug_name, provider
-- 					ORDER BY sum_total_claims DESC;
				

-- -- ----

-- SELECT drug.drug_name, npi,
-- 	SUM (total_claim_count) AS sum_total_claims
-- 		FROM prescriber
-- 			CROSS JOIN drug
-- 			INNER JOIN prescription USING (npi)
-- 				WHERE specialty_description = 'Pain Management' 
-- 				AND nppes_provider_city = 'NASHVILLE'
-- 				AND opioid_drug_flag = 'Y'
-- 				GROUP BY npi, drug.drug_name;
							

-- -- Q7.C ADD COALESCE

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
		