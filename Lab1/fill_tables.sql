INSERT ALL
   INTO Country (id, Name, Visa_Cost) VALUES ('1', 'Norway', '50')
   INTO Country (id, Name, Visa_Cost) VALUES ('2', 'Sweden', '100')
   INTO Country (id, Name, Visa_Cost) VALUES ('3', 'Finland', '60')
   INTO Country (id, Name, Visa_Cost) VALUES ('4', 'Russia', '0')
SELECT 1 FROM DUAL;

INSERT ALL
   INTO City (id, Name, Country_id) VALUES ('1', 'Oslo', '1')
   INTO City (id, Name, Country_id) VALUES ('2', 'Stockholm', '2')
   INTO City (id, Name, Country_id) VALUES ('3', 'Helsinki', '3')
   INTO City (id, Name, Country_id) VALUES ('4', 'Petrozavodsk', '4')
   INTO City (id, Name, Country_id) VALUES ('5', 'Murmansk', '4')
SELECT 1 FROM DUAL;

