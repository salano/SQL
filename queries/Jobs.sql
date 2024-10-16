SELECT m.action, 
       s.NAME             AS job_state, 
       Trim(p.start_date) AS job_start_date, 
       Count(*) 
FROM   cbs_owner.wp_proci p, 
       cbs_owner.wp_proc_state s, 
       cbs_owner.arm_action_plugin_map_ref@read_cust m 
WHERE  p.proc_ref = m.process_id 
       AND p.proc_state_id = s.proc_state_id 
       AND p.start_date BETWEEN To_date('19-OCT-2020', 'DD-MON-YYYY') AND 
                                To_date('21-OCT-2020', 'DD-MON-YYYY') 
GROUP  BY m.action, 
          s.NAME, 
          Trim(p.start_date) 
ORDER  BY 3, 
          2, 
          1; 
