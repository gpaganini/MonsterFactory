select
 c.rf_id,
 c.start_date,
 c.end_date,
 c.booking_id,
 round(sum(h.amount)/100,2) as saldoConta
 from
 mvlive.kc_rfid c
  join
 mvlive.kc_history h
  ON
 c.rf_id = h.rf_id
 where
 --not exists (select 1 from mvlive.kc_rfid rf where rf.rf_id=h.rf_id and rf.booking_id=1)
 h.status='CASH'
 group by
 c.rf_id,
 c.start_date,
 c.end_date,
 c.booking_id






