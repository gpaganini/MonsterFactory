SELECT * FROM mvlive.kc_history;

SELECT
    h.rf_id,
    h.trans_date,
    SUBSTR(h.descr,24) as usuario,
    pr.descr
  from
    mvlive.kc_history h
    join MVLIVE.KC_PRODUCT_DESCR pr on h.product_id=pr.product_id
  where
    h.rf_id in (80007699,
                80007826,
                80006863,
                80006891,
                80007868,
                80007057,
                80006754,
                80007949,
                80007957,
                80006028,
                80005700,
                50054507,
                50054680,
                50054647,
                50054659,
                80007799,
                50054907,
                80005303,
                80007977,
                50052879)
  AND
    h.status='BUY'
  order by
    1,2;