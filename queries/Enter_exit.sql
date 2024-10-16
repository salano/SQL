SELECT display_value AS service_category, 
       action, 
       dt, 
       Count(*) 
FROM  (SELECT DISTINCT sv.parent_account_no, 
                       scv.display_value, 
                       amv.display_value AS action, 
                       Trim(entry_date)      AS dt 
       FROM   arm_history ah, 
              subscriber_view sv, 
              offer_ref ofr, 
              service_category_values scv,
              arm_milestone_values amv 
       WHERE  ah.milestone in (10,12,13) 
          AND entry_date BETWEEN To_date('01-JAN-2021', 'DD-MON-YYYY') AND sysdate
          AND ah.account_no = sv.parent_account_no 
          AND sv.primary_offer_id = ofr.offer_id 
          AND ofr.reseller_version_id = (SELECT Max(reseller_version_id) 
                                         FROM   reseller_version) 
          AND ofr.service_category_id = scv.service_category_id 
          AND scv.service_version_id = (SELECT Max(service_version_id) 
                                        FROM   service_version)
          AND ah.milestone = amv.milestone )
GROUP  BY dt,
          action,
          display_value;
		  
SELECT parent_account_no,
       display_value AS service_category, 
       action, 
       dt
FROM  (SELECT DISTINCT sv.parent_account_no, 
                       scv.display_value, 
                       amv.display_value AS action, 
                       Trim(entry_date)      AS dt 
       FROM   arm_history ah, 
              subscriber_view sv, 
              offer_ref ofr, 
              service_category_values scv,
              arm_milestone_values amv 
       WHERE  ah.milestone in (10,12,13) 
          AND entry_date BETWEEN To_date('01-JAN-2021', 'DD-MON-YYYY') AND sysdate
          AND ah.account_no = sv.parent_account_no 
          AND sv.primary_offer_id = ofr.offer_id 
          AND ofr.reseller_version_id = (SELECT Max(reseller_version_id) 
                                         FROM   reseller_version) 
          AND ofr.service_category_id = scv.service_category_id 
          AND scv.service_version_id = (SELECT Max(service_version_id) 
                                        FROM   service_version)
          AND ah.milestone = amv.milestone )
order by 4;
