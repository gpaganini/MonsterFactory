--Colocar número do cartão no campo 'booking_id' e fazer o filtro da data de check-in/check-out
SELECT
  rf_id AS Cartão,
  Status,
  start_date AS DataCheckIn,
  end_date AS DataCheckOut,
  booking_id AS Apartamento
    FROM mvlive.kc_rfid WHERE booking_id = 05408
      AND start_date BETWEEN To_Date('02/11/2015 00:00:00','dd/mm/yyyy hh24:mi:ss') AND
                             To_Date('02/11/2015 23:59:59','dd/mm/yyyy hh24:mi:ss');