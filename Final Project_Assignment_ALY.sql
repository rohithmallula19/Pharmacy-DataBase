USE `pharmacy`;
SELECT * FROM drugs_ndc;
SELECT * FROM claims_fact;
SELECT * FROM drug_brand_generic;
SELECT * FROM drug_form;
SELECT * FROM members;


## Indexes for imported tables



ALTER TABLE `drugs_ndc` ADD PRIMARY KEY (`drug_ndc`);
ALTER TABLE `drug_brand_generic` ADD PRIMARY KEY (`drug_brand_generic_code`);
ALTER TABLE `drug_form` ADD PRIMARY KEY (`drug_form_code`);
ALTER TABLE `members` ADD PRIMARY KEY (`member_id`);
ALTER TABLE `claims_fact` MODIFY `claim_id` int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY, AUTO_INCREMENT=12;




### Adding Fks for table `claims_fact`

ALTER TABLE `claims_fact`
 ADD CONSTRAINT `fk1` FOREIGN KEY (`drug_brand_generic_code`)
REFERENCES `drug_brand_generic` (`drug_brand_generic_code`) ON UPDATE CASCADE,
 ADD CONSTRAINT `fk2` FOREIGN KEY (`drug_form_code`) REFERENCES
`drug_form` (`drug_form_code`) ON UPDATE CASCADE;
ALTER TABLE `claims_fact` ADD CONSTRAINT `fk3` FOREIGN KEY
(`member_id`) REFERENCES `members` (`member_id`) ON DELETE CASCADE ON UPDATE
CASCADE,
 ADD CONSTRAINT `fk4` FOREIGN KEY (`drug_ndc`) REFERENCES
`drugs_ndc` (`drug_ndc`) ON UPDATE CASCADE;
 COMMIT;

## no of prescriptions grouped by drug name

SELECT COUNT(member_id) AS no_of_presc, drug_name FROM claims_fact JOIN drugs_ndc ON claims_fact.drug_ndc = drugs_ndc.drug_ndc GROUP BY drug_name;
SELECT CASE WHEN member_age > 65 THEN 'age 65+' ELSE '<65' END AS 'age_group',COUNT(DISTINCT members.member_id) as total_user_count,COUNT(claims_fact.member_id) as no_of_presc, SUM(copay) as sum_copay,
SUM(insurance_paid) as sum_insurance_paid FROM members INNER JOIN claims_fact ON claims_fact.member_id = members.member_id GROUP BY age_group;

## most recent prescription paid
SELECT dm.member_id, member_first_name, member_last_name, drug_name, date, insurance_paid FROM claims_fact fc 
JOIN members dm ON fc.member_id = dm.member_id 
JOIN drugs_ndc dd ON fc.drug_ndc = dd.drug_ndc ORDER BY date DESC LIMIT 1 ;

## most recent precription for member 10003
SELECT dm.member_id, member_first_name, member_last_name, drug_name, date, insurance_paid FROM claims_fact fc
JOIN members dm ON fc.member_id = dm.member_id 
JOIN drugs_ndc dd ON fc.drug_ndc = dd.drug_ndc
WHERE fc.member_id = 10003 ORDER BY date DESC LIMIT 1;