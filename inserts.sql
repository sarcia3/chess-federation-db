INSERT INTO countries(name, continent) VALUES
  ('Albania', 'Europe'),
  ('Andorra', 'Europe'),
  ('Austria', 'Europe'),
  ('Belarus', 'Europe'),
  ('Belgium', 'Europe'),
  ('Bosna and Herzegovina', 'Europe'),
  ('Bulgaria', 'Europe'),
  ('Croatia', 'Europe'),
  ('Cyprus', 'Europe'),
  ('Czechia', 'Europe'),
  ('Denmark', 'Europe'),
  ('Estonia', 'Europe'),
  ('Finland', 'Europe'),
  ('France', 'Europe'),
  ('Germany', 'Europe'),
  ('Greece', 'Europe'),
  ('Hungary', 'Europe'),
  ('Iceland', 'Europe'),
  ('Ireland', 'Europe'),
  ('Italy', 'Europe'),
  ('Latvia', 'Europe'),
  ('Liechtenstein', 'Europe'),
  ('Lithuania', 'Europe'),
  ('Luxemburg', 'Europe'),
  ('Malta', 'Europe'),
  ('Moldova', 'Europe'),
  ('Monaco', 'Europe'),
  ('Montenegro', 'Europe'),
  ('Netherlands', 'Europe'),
  ('North Macedonia', 'Europe'),
  ('Norway', 'Europe'),
  ('Poland', 'Europe'),
  ('Portugal', 'Europe'),
  ('Romania', 'Europe'),
  ('Russia', 'Europe'),
  ('San Marino', 'Europe'),
  ('Serbia', 'Europe'),
  ('Slovakia', 'Europe'),
  ('Slovenia', 'Europe'),
  ('Spain', 'Europe'),
  ('Sweden', 'Europe'),
  ('Switzerland', 'Europe'),
  ('Ukraine', 'Europe'),
  ('United Kingdom', 'Europe'),
  ('Vatican City', 'Europe'),
  ('Kosovo', 'Europe'),
  ('The Bahamas', 'North America'),
  ('Barbados', 'North America'),
  ('Canada', 'North America'),
  ('Costa Rica', 'North America'),
  ('Cuba', 'North America'),
  ('Dominica', 'North America'),
  ('El Salvador', 'North America'),
  ('Grenada', 'North America'),
  ('Guatemala', 'North America'),
  ('Haiti', 'North America'),
  ('Honduras', 'North America'),
  ('Jamaica', 'North America'),
  ('Mexico', 'North America'),
  ('Nicaragua', 'North America'),
  ('Panama', 'North America'),
  ('Puerto Rico', 'North America'), 
  ('United States', 'North America'),
  ('Argentina', 'South America'),
  ('Bolivia', 'South America'),
  ('Brazil', 'South America'),
  ('Chile', 'South America'),
  ('Colombia', 'South America'),
  ('Ecuador', 'South America'),
  ('Guyana', 'South America'),
  ('Paraguay', 'South America'),
  ('Peru', 'South America'),
  ('Suriname', 'South America'),
  ('Uruguay', 'South America'),
  ('Venezuela', 'South America'),
  ('Afghanistan', 'Asia'),
  ('Armenia', 'Asia'),
  ('Azerbaijan', 'Asia'),
  ('Bahrain', 'Asia'),
  ('Bangladesh', 'Asia'),
  ('Bhutan', 'Asia'),
  ('Brunei', 'Asia'),
  ('Cambodia', 'Asia'),
  ('China', 'Asia'),
  ('Georgia', 'Asia'),
  ('India', 'Asia'),
  ('Indonesia', 'Asia'),
  ('Iran', 'Asia'),
  ('Iraq', 'Asia'),
  ('Israel', 'Asia'),
  ('Japan', 'Asia'),
  ('Jordan', 'Asia'),
  ('Kazakhstan', 'Asia'),
  ('Kuwait', 'Asia'),
  ('Kyrgyzstan', 'Asia'),
  ('Laos', 'Asia'),
  ('Lebanon', 'Asia'),
  ('Malaysia', 'Asia'),
  ('Maldives', 'Asia'),
  ('Mongolia', 'Asia'),
  ('Myanmar', 'Asia'),
  ('Nepal', 'Asia'),
  ('North Korea', 'Asia'),
  ('Oman', 'Asia'),
  ('Pakistan', 'Asia'),
  ('Philippines', 'Asia'),
  ('Quatar', 'Asia'),
  ('Saudi Arabia', 'Asia'),
  ('Singapore', 'Asia'),
  ('South Korea', 'Asia'),
  ('Sri Lanka', 'Asia'),
  ('Syria', 'Asia'),
  ('Tajikistan', 'Asia'),
  ('Thailand', 'Asia'),
  ('Timor-Leste', 'Asia'),
  ('Turkey', 'Asia'),
  ('Turkmenistan', 'Asia'),
  ('United Arab Emirates', 'Asia'),
  ('Uzbekistan', 'Asia'),
  ('Vietnam', 'Asia'),
  ('Yemen', 'Asia'),
  ('Algieria', 'Africa'),
  ('Egypt', 'Africa'),
  ('Libya', 'Africa'),
  ('Morocco', 'Africa'),
  ('Sudan', 'Africa'),
  ('Tunisia', 'Africa'),
  ('Western Sahara', 'Africa'),
  ('Burundi', 'Africa'),
  ('Comoros', 'Africa'),
  ('Djibouti', 'Africa'),
  ('Eritrea', 'Africa'),
  ('Ethiopia', 'Africa'),
  ('Kenya', 'Africa'),
  ('Madagaskar', 'Africa'),
  ('Malawi', 'Africa'),
  ('Mauritius', 'Africa'),
  ('Mozambique', 'Africa'),
  ('Rwanda', 'Africa'),
  ('Somalia', 'Africa'),
  ('South Sudan', 'Africa'),
  ('Tanzania', 'Africa'),
  ('Uganda', 'Africa'),
  ('Zambia', 'Africa'),
  ('Zimbabwe', 'Africa'),
  ('Angola', 'Africa'),
  ('Cameroon', 'Africa'),
  ('Central African Republic', 'Africa'),
  ('Chad', 'Africa'),
  ('Democratic Republic of Congo', 'Africa'),
  ('Botswana', 'Africa'),
  ('Lesotho', 'Africa'),
  ('Namibia', 'Africa'),
  ('South America', 'Africa'),
  ('Benin', 'Africa'),
  ('Burkina Faso', 'Africa'),
  ('Ghana', 'Africa'),
  ('Guinea', 'Africa'),
  ('Guinea-Bissau', 'Africa'),
  ('Ivory Coast', 'Africa'),
  ('Liberia', 'Africa'),
  ('Mali', 'Africa'),
  ('Mauritania', 'Africa'),
  ('Niger', 'Africa'),
  ('Nigeria', 'Africa'),
  ('Senegal', 'Africa'),
  ('Sierra Leone', 'Africa'),
  ('Togo', 'Africa'),
  ('Australia', 'Australia'),
  ('New Zealand', 'Australia'),
  ('Fiji', 'Australia'),
  ('Papua New Guinea', 'Australia')
;

INSERT INTO titles (short_name, full_name) VALUES
   ('GM', 'Grandmaster'),
   ('IM', 'International Master'),
   ('FM', 'FIDE Master'),
   ('CM', 'Candidate Master'),
   ('WGM', 'Woman Grandmaster'),
   ('WIM', 'Woman International Master'),
   ('WFM', 'Woman FIDE Master'),
   ('WCM', 'Woman Candidate Master')
;

-- czy k factor to cecha partii czy gracza? wzielam takie z internetu
INSERT INTO chess_types (name, total_time_from, total_time_to, rating_policy, k_factor) VALUES 
   ('Bullet', '1 second', '2 minutes 59 seconds', 'rated', 40),
   ('Blitz', '3 minutes', '9 minutes 59 seconds', 'rated', 20),
   ('Classical', '60 minutes', NULL, 'rated', 5),
   ('Rapid', '10 minutes', '59 minutes 59 seconds', 'rated', 10),
   ('Casual', NULL, NULL, 'unrated', NULL)
;

INSERT INTO clubs (country_id, name) VALUES
   ((SELECT country_id FROM countries WHERE name = 'United States'), 'Saint Louis Chess Club'),
   ((SELECT country_id FROM countries WHERE name = 'United States'), 'Marshall Chess Club'),
   ((SELECT country_id FROM countries WHERE name = 'United States'), 'Mechanics Institute Chess Club'),
   ((SELECT country_id FROM countries WHERE name = 'United Kingdom'), 'Battersea Chess Club'),
   ((SELECT country_id FROM countries WHERE name = 'Germany'), 'OSG Baden-Baden'),
   ((SELECT country_id FROM countries WHERE name = 'Germany'), 'Werder Bremen Chess Club'),
   ((SELECT country_id FROM countries WHERE name = 'France'), 'Clichy Echecs 92'),
   ((SELECT country_id FROM countries WHERE name = 'France'), 'Marseille-Echecs'),
   ((SELECT country_id FROM countries WHERE name = 'Spain'), 'Sestao Chess Club'),
   ((SELECT country_id FROM countries WHERE name = 'Spain'), 'Club Ajedrez Solvay'),
   ((SELECT country_id FROM countries WHERE name = 'Sweden'), 'Offerspill Sjakklubb'),
   ((SELECT country_id FROM countries WHERE name = 'Italy'), 'Academia Scacchistica Romana')
;

INSERT INTO club_contact_data (club_id, mail_address, website, timestamp_from, timestamp_to) VALUES
(1,  'contact@stlouischess.org',      'https://www.stlouischess.org',      CURRENT_DATE, NULL),
(2,  'info@marshallchess.org',        'https://www.marshallchess.org',      CURRENT_DATE, NULL),
(3,  'office@mechanicschess.org',     'https://www.mechanicschess.org',     CURRENT_DATE, NULL),
(4,  'admin@batterseachess.org.uk',   'https://www.batterseachess.org.uk',  CURRENT_DATE, NULL),
(5,  'info@osg-badenbaden.de',        'https://www.osg-badenbaden.de',      CURRENT_DATE, NULL),
(6,  'kontakt@werderchess.de',        'https://www.werderchess.de',         CURRENT_DATE, NULL),
(7,  'contact@clichyechecs.fr',       'https://www.clichyechecs.fr',        CURRENT_DATE, NULL),
(8,  'info@marseille-echecs.fr',      'https://www.marseille-echecs.fr',    CURRENT_DATE, NULL),
(9,  'office@sestaochess.es',         'https://www.sestaochess.es',         CURRENT_DATE, NULL),
(10, 'info@ajedrezsolvay.es',         'https://www.ajedrezsolvay.es',       CURRENT_DATE, NULL),
(11, 'kontakt@offerspill.no',         'https://www.offerspill.no',          CURRENT_DATE, NULL),
(12, 'segreteria@accademiascacchi.it','https://www.accademiascacchi.it',    CURRENT_DATE, NULL)
;


INSERT INTO persons (first_name, last_name, date_of_birth, gender, country_id) VALUES
   ('Magnus', 'Carlsen', '1990-11-30', 'Male', (SELECT country_id FROM countries WHERE name = 'Norway')),
   ('Fabiano', 'Caruana', '1992-07-30', 'Male', (SELECT country_id FROM countries WHERE name = 'United States')),
   ('Hikaru', 'Nakamura', '1987-12-09', 'Male', (SELECT country_id FROM countries WHERE name = 'United States')),
   ('Javokhir', 'Sindarov', '2005-12-08', 'Male', (SELECT country_id FROM countries WHERE name = 'Uzbekistan')),
   ('Nodirbek', 'Abdusattorov', '2004-09-18', 'Male', (SELECT country_id FROM countries WHERE name = 'Uzbekistan')),
   ('Vincent', 'Keymer', '2004-11-15', 'Male', (SELECT country_id FROM countries WHERE name = 'Germany')),
   ('Anish', 'Giri', '1994-06-03', 'Male', (SELECT country_id FROM countries WHERE name = 'Netherlands')),
   ('Arjun', 'Erigaisi', '2003-09-03', 'Male', (SELECT country_id FROM countries WHERE name = 'India')),
   ('Wesley', 'So', '1993-10-09', 'Male', (SELECT country_id FROM countries WHERE name = 'United States')),
   ('Wei', 'Yi', '1999-06-02', 'Male', (SELECT country_id FROM countries WHERE name = 'China')),
   ('Alireza', 'Firouzja', '2003-06-18', 'Male', (SELECT country_id FROM countries WHERE name = 'France')),
   ('Hans', 'Niemann', '2003-06-20', 'Male', (SELECT country_id FROM countries WHERE name = 'United States')),
   ('Ian', 'Nepomniachtchi', '1990-07-14', 'Male', (SELECT country_id FROM countries WHERE name = 'Russia')),
   ('Levon', 'Aroniam', '1982-10-06', 'Male', (SELECT country_id FROM countries WHERE name = 'Armenia')),
   ('Jan-Krzysztof', 'Duda', '1998-04-26', 'Male', (SELECT country_id FROM countries WHERE name = 'Poland')),
   ('Maxime', 'Vachier-Lagrave', '1990-10-21', 'Male', (SELECT country_id FROM countries WHERE name = 'France')),
   ('Shakhriyar', 'Mamedyarov', '1985-04-12', 'Male', (SELECT country_id FROM countries WHERE name = 'Azerbaijan')),
   ('Nijat', 'Abasov', '1995-05-14', 'Male', (SELECT country_id FROM countries WHERE name = 'Azerbaijan')),
   ('Sergey', 'Karjakin', '1990-01-12', 'Male', (SELECT country_id FROM countries WHERE name = 'Russia')),
   ('Richard', 'Rapport', '1996-03-25', 'Male', (SELECT country_id FROM countries WHERE name = 'Hungary')),
   ('Hou', 'Yifan', '1994-02-27', 'Female', (SELECT country_id FROM countries WHERE name = 'China')),
   ('Ju', 'Wenjun', '1991-01-31', 'Female', (SELECT country_id FROM countries WHERE name = 'China')),
   ('Lei', 'Tingije', '1997-03-13', 'Female', (SELECT country_id FROM countries WHERE name = 'China')),
   ('Aleksandra', 'Goryachkina', '1998-09-28', 'Female', (SELECT country_id FROM countries WHERE name = 'Russia')),
   ('Koneru', 'Humpy', '1987-03-31', 'Female', (SELECT country_id FROM countries WHERE name = 'India')),
   ('Anna', 'Muzychuk', '1987-02-28', 'Female', (SELECT country_id FROM countries WHERE name = 'Ukraine')),
   ('Bibisara', 'Assaubayeva', '2004-02-26', 'Female', (SELECT country_id FROM countries WHERE name = 'Kazakhstan')),
   ('Anna', 'Nowak', '1980-04-12', 'Female', (SELECT country_id FROM countries WHERE name = 'Poland')),
   ('Piotr', 'Kowalski', '1975-09-21', 'Male', (SELECT country_id FROM countries WHERE name = 'Poland')),
   ('Marta', 'Zielinska', '1988-02-03', 'Female', (SELECT country_id FROM countries WHERE name = 'Poland')),
   ('Tomasz', 'Wisniewski', '1990-11-18', 'Male', (SELECT country_id FROM countries WHERE name = 'Poland')),
   ('Laura', 'Smith', '1983-06-14', 'Female', (SELECT country_id FROM countries WHERE name = 'United Kingdom')),
   ('Michael', 'Brown', '1978-01-30', 'Male', (SELECT country_id FROM countries WHERE name = 'United States')),
   ('Sophie', 'Martin', '1985-07-07', 'Female', (SELECT country_id FROM countries WHERE name = 'France')),
   ('Hans', 'Schneider', '1972-12-01', 'Male', (SELECT country_id FROM countries WHERE name = 'Germany'))
;

INSERT INTO arbiters (person_id) VALUES
   ((SELECT person_id FROM persons WHERE first_name = 'Anna' AND last_name = 'Nowak')),
   ((SELECT person_id FROM persons WHERE first_name = 'Piotr' AND last_name = 'Kowalski')),
   ((SELECT person_id FROM persons WHERE first_name = 'Laura' AND last_name = 'Smith')),
   ((SELECT person_id FROM persons WHERE first_name = 'Hans' AND last_name = 'Schneider'))
;

INSERT INTO players (person_id) VALUES
   ((SELECT person_id FROM persons WHERE first_name ='Magnus' AND last_name='Carlsen')),
   ((SELECT person_id FROM persons WHERE first_name ='Fabiano' AND last_name='Caruana')),
   ((SELECT person_id FROM persons WHERE first_name ='Hikaru' AND last_name='Nakamura')),
   ((SELECT person_id FROM persons WHERE first_name ='Javokhir' AND last_name='Sindarov')),
   ((SELECT person_id FROM persons WHERE first_name ='Nodirbek' AND last_name='Abdusattorov')),
   ((SELECT person_id FROM persons WHERE first_name ='Vincent' AND last_name='Keymer')),
   ((SELECT person_id FROM persons WHERE first_name ='Anish' AND last_name='Giri')),
   ((SELECT person_id FROM persons WHERE first_name ='Arjun' AND last_name='Erigaisi')),
   ((SELECT person_id FROM persons WHERE first_name ='Wesley' AND last_name='So')),
   ((SELECT person_id FROM persons WHERE first_name ='Wei' AND last_name='Yi')),
   ((SELECT person_id FROM persons WHERE first_name ='Alireza' AND last_name='Firouzja')),
   ((SELECT person_id FROM persons WHERE first_name ='Hans' AND last_name='Niemann')),
   ((SELECT person_id FROM persons WHERE first_name ='Ian' AND last_name='Nepomniachtchi')),
   ((SELECT person_id FROM persons WHERE first_name ='Levon' AND last_name='Aroniam')),
   ((SELECT person_id FROM persons WHERE first_name ='Jan-Krzysztof' AND last_name='Duda')),
   ((SELECT person_id FROM persons WHERE first_name ='Maxime' AND last_name='Vachier-Lagrave')),
   ((SELECT person_id FROM persons WHERE first_name ='Shakhriyar' AND last_name='Mamedyarov')),
   ((SELECT person_id FROM persons WHERE first_name ='Nijat' AND last_name='Abasov')),
   ((SELECT person_id FROM persons WHERE first_name ='Sergey' AND last_name='Karjakin')),
   ((SELECT person_id FROM persons WHERE first_name ='Richard' AND last_name='Rapport')),
   ((SELECT person_id FROM persons WHERE first_name ='Hou' AND last_name='Yifan')),
   ((SELECT person_id FROM persons WHERE first_name ='Ju' AND last_name='Wenjun')),
   ((SELECT person_id FROM persons WHERE first_name ='Lei' AND last_name='Tingije')),
   ((SELECT person_id FROM persons WHERE first_name ='Aleksandra' AND last_name='Goryachkina')),
   ((SELECT person_id FROM persons WHERE first_name ='Koneru' AND last_name='Humpy')),
   ((SELECT person_id FROM persons WHERE first_name ='Anna' AND last_name='Muzychuk')),
   ((SELECT person_id FROM persons WHERE first_name ='Bibisara' AND last_name='Assaubayeva')),
   ((SELECT person_id FROM persons WHERE first_name = 'Anna' AND last_name = 'Nowak')) 
;

   
INSERT INTO person_contact_data (person_id, mail_address, phone_number, timestamp_from, timestamp_to) VALUES
   ((SELECT person_id FROM persons WHERE first_name = 'Magnus' AND last_name='Carlsen'), 'magnus.carlsen@chessmail.com', '+47900100001', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Fabiano' AND last_name='Caruana'), 'fabiano.caruana@chessmail.com', '+12021000002', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Hikaru' AND last_name='Nakamura'), 'hikaru.nakamura@chessmail.com', '+12021000003', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Javokhir' AND last_name='Sindarov'), 'javokhir.sindarov@chessmail.com', '+998901000004', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Nodirbek' AND last_name='Abdusattorov'), 'nodirbek.abdusattorov@chessmail.com', '+998901000005', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Vincent' AND last_name='Keymer'), 'vincent.keymer@chessmail.com', '+491511000006', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Anish' AND last_name='Giri'), 'anish.giri@chessmail.com', '+31610000007', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Arjun' AND last_name='Erigaisi'), 'arjun.erigaisi@chessmail.com', '+919001000008', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Wesley' AND last_name='So'), 'wesley.so@chessmail.com', '+12021000009', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Wei' AND last_name='Yi'), 'wei.yi@chessmail.com', '+861380000010', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Alireza' AND last_name='Firouzja'), 'alireza.firouzja@chessmail.com', '+33610000011', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Hans' AND last_name='Niemann'), 'hans.niemann@chessmail.com', '+12021000012', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Ian' AND last_name='Nepomniachtchi'), 'ian.nepomniachtchi@chessmail.com', '+79001000013', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Levon' AND last_name='Aroniam'), 'levon.aroniam@chessmail.com', '+37491000014', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Jan-Krzysztof' AND last_name='Duda'), 'jan.duda@chessmail.com', '+48500100015', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Maxime' AND last_name='Vachier-Lagrave'), 'maxime.vachierlagrave@chessmail.com', '+33610000016', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Shakhriyar' AND last_name='Mamedyarov'), 'shakhriyar.mamedyarov@chessmail.com', '+994501000017', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Nijat' AND last_name='Abasov'), 'nijat.abasov@chessmail.com', '+994501000018', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Sergey' AND last_name='Karjakin'), 'sergey.karjakin@chessmail.com', '+79001000019', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Richard' AND last_name='Rapport'), 'richard.rapport@chessmail.com', '+36301000020', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Hou' AND last_name='Yifan'), 'hou.yifan@chessmail.com', '+861380000021', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Ju' AND last_name='Wenjun'), 'ju.wenjun@chessmail.com', '+861380000022', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Lei' AND last_name='Tingije'), 'lei.tingije@chessmail.com', '+861380000023', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Aleksandra' AND last_name='Goryachkina'), 'aleksandra.goryachkina@chessmail.com', '+79001000024', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Koneru' AND last_name='Humpy'), 'koneru.humpy@chessmail.com', '+919001000025', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Anna' AND last_name='Muzychuk'), 'anna.muzychuk@chessmail.com', '+380501000026', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name = 'Bibisara' AND last_name='Assaubayeva'), 'bibisara.assaubayeva@chessmail.com', '+77011000027', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name ='Anna' AND last_name='Nowak'), 'anna.nowak@fide-mail.org', '+48501111001', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name ='Piotr' AND last_name='Kowalski'), 'piotr.kowalski@fide-mail.org', '+48501111002', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name ='Marta' AND last_name='Zielinska'), 'marta.zielinska@fide-mail.org', '+48501111003', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name ='Tomasz' AND last_name='Wisniewski'), 'tomasz.wisniewski@fide-mail.org', '+48501111004', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name ='Laura' AND last_name='Smith'), 'laura.smith@fide-mail.org', '+447700111005', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name ='Michael' AND last_name='Brown'), 'michael.brown@fide-mail.org', '+12025551106', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name ='Sophie' AND last_name='Martin'), 'sophie.martin@fide-mail.org','+33611111007', CURRENT_DATE, NULL),
   ((SELECT person_id FROM persons WHERE first_name ='Hans' AND last_name='Schneider'),'hans.schneider@fide-mail.org', '+491511111008', CURRENT_DATE, NULL)
;

INSERT INTO time_controls (starting_time, increment) VALUES
   (interval '1 minute', interval '0 seconds'),    --bullet  
   (interval '5 minutes', interval '3 seconds'),    --blitz
   (interval '15 minutes', interval '10 seconds'),   --rapid
   (interval '90 minutes', interval '30 seconds') -- classical
;   

INSERT INTO tournaments (chess_type_id, city, street_address, country_id, name, main_arbiter, time_control_id, date_from, date_to) VALUES 
   ((SELECT chess_type_id FROM chess_types WHERE name = 'Classical'), 'Warsaw', 'Aleje Jerozolimskie 1', (SELECT country_id FROM countries WHERE name = 'Poland'), 'Warsaw Grandmaster Open 2026', 3, (SELECT time_control_id FROM time_controls LIMIT 1), '2026-07-01', '2026-07-10'),
   ((SELECT chess_type_id FROM chess_types WHERE name = 'Rapid'), 'Krakow', 'Rynek Glowny 1', (SELECT country_id FROM countries WHERE name = 'Poland'), 'Krakow Rapid Masters', 1, (SELECT time_control_id FROM time_controls LIMIT 1), '2026-08-15', '2026-08-17'),
   ((SELECT chess_type_id FROM chess_types WHERE name = 'Blitz'), 'Paris', 'Rue de Chess 12', (SELECT country_id FROM countries WHERE name = 'France'), 'Paris Blitz Challenge', 2, (SELECT time_control_id FROM time_controls LIMIT 1), '2026-09-05', '2026-09-05'),
   ((SELECT chess_type_id FROM chess_types WHERE name = 'Bullet'), 'New York', 'Broadway 100', (SELECT country_id FROM countries WHERE name = 'United States'), 'New York Bullet Cup', 4, (SELECT time_control_id FROM time_controls LIMIT 1), '2026-10-03', '2026-10-03'),
   ((SELECT chess_type_id FROM chess_types WHERE name = 'Classical'), 'Oslo', 'Karl Johans gate 15', (SELECT country_id FROM countries WHERE name = 'Norway'), 'Nordic Invitational', 2, (SELECT time_control_id FROM time_controls LIMIT 1), '2026-11-01', '2026-11-08'),
   ((SELECT chess_type_id FROM chess_types WHERE name = 'Classical'), 'Toronto', 'High Street 3', (SELECT country_id FROM countries WHERE name = 'Canada'), 'Toronto Chess Championship', 4, (SELECT time_control_id FROM time_controls LIMIT 1), '2026-07-01', '2026-07-10')
;

INSERT INTO live_ratings (player_id, chess_type_id, value) VALUES
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Magnus' AND p.last_name='Carlsen'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2841.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Fabiano' AND p.last_name='Caruana'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2792.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Hikaru' AND p.last_name='Nakamura'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2792.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Javokhir' AND p.last_name='Sindarov'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2777.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Nodirbek' AND p.last_name='Abdusattorov'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2777.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Vincent' AND p.last_name='Keymer'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2767.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Anish' AND p.last_name='Giri'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2764.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Arjun' AND p.last_name='Erigaisi'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2761.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Wesley' AND p.last_name='So'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2755.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Wei' AND p.last_name='Yi'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2753.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Alireza' AND p.last_name='Firouzja'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2750.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Hans' AND p.last_name='Niemann'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2748.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Ian' AND p.last_name='Nepomniachtchi'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2745.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Levon' AND p.last_name='Aroniam'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2738.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Jan-Krzysztof' AND p.last_name='Duda'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2735.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Maxime' AND p.last_name='Vachier-Lagrave'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2732.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Shakhriyar' AND p.last_name='Mamedyarov'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2725.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Nijat' AND p.last_name='Abasov'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2705.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Sergey' AND p.last_name='Karjakin'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2700.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Richard' AND p.last_name='Rapport'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2698.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Hou' AND p.last_name='Yifan'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2630.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Ju' AND p.last_name='Wenjun'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2555.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Lei' AND p.last_name='Tingije'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2550.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Aleksandra' AND p.last_name='Goryachkina'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2530.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Koneru' AND p.last_name='Humpy'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2525.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Anna' AND p.last_name='Muzychuk'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2505.00),
   ((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name ='Bibisara' AND p.last_name='Assaubayeva'), (SELECT chess_type_id FROM chess_types WHERE name='Classical'), 2470.00)
;

INSERT INTO live_ratings (player_id, chess_type_id, value)
   SELECT lr.player_id, ct.chess_type_id,
      CASE ct.name
        WHEN 'Rapid' THEN lr.value + 10
        WHEN 'Blitz' THEN lr.value + 30
        WHEN 'Bullet' THEN lr.value + 50
      END
  FROM live_ratings lr CROSS JOIN chess_types ct
  WHERE lr.chess_type_id = (SELECT chess_type_id FROM chess_types WHERE name='Classical') AND ct.name IN ('Rapid', 'Blitz', 'Bullet');
  
INSERT INTO club_memberships (player_id, club_id) VALUES
((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name='Magnus' AND p.last_name='Carlsen'),
 (SELECT club_id FROM clubs WHERE name='Offerspill Sjakklubb')),
((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name='Fabiano' AND p.last_name='Caruana'),
 (SELECT club_id FROM clubs WHERE name='Saint Louis Chess Club')),
((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name='Hikaru' AND p.last_name='Nakamura'),
 (SELECT club_id FROM clubs WHERE name='Saint Louis Chess Club')),
((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name='Vincent' AND p.last_name='Keymer'),
 (SELECT club_id FROM clubs WHERE name='OSG Baden-Baden')),
((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name='Anish' AND p.last_name='Giri'),
 (SELECT club_id FROM clubs WHERE name='Marshall Chess Club')),
((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name='Jan-Krzysztof' AND p.last_name='Duda'),
 (SELECT club_id FROM clubs WHERE name='Academia Scacchistica Romana')),
((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name='Maxime' AND p.last_name='Vachier-Lagrave'),
 (SELECT club_id FROM clubs WHERE name='Clichy Echecs 92')),
((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name='Shakhriyar' AND p.last_name='Mamedyarov'),
 (SELECT club_id FROM clubs WHERE name='Club Ajedrez Solvay')),
((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name='Richard' AND p.last_name='Rapport'),
 (SELECT club_id FROM clubs WHERE name='Werder Bremen Chess Club')),
((SELECT pl.player_id FROM players pl JOIN persons p USING(person_id) WHERE p.first_name='Hou' AND p.last_name='Yifan'),
 (SELECT club_id FROM clubs WHERE name='Mechanics Institute Chess Club'))
ON CONFLICT DO NOTHING;

INSERT INTO rating_history (player_id, value, chess_type_id, date_from, date_to)
SELECT player_id, value::INTEGER, chess_type_id, DATE '2026-01-01', NULL
FROM live_ratings
ON CONFLICT DO NOTHING;

INSERT INTO tournament_players (tournament_id, player_id)
SELECT t.tournament_id, pl.player_id
FROM tournaments t JOIN players pl ON TRUE
JOIN persons p USING(person_id)
WHERE t.name = 'Warsaw Grandmaster Open 2026'
  AND (p.first_name, p.last_name) IN (
    ('Magnus','Carlsen'),
    ('Fabiano','Caruana'),
    ('Hikaru','Nakamura'),
    ('Jan-Krzysztof','Duda'),
    ('Anish','Giri'),
    ('Arjun','Erigaisi')
  )
ON CONFLICT DO NOTHING;

INSERT INTO tournament_players (tournament_id, player_id)
SELECT t.tournament_id, pl.player_id
FROM tournaments t JOIN players pl ON TRUE
JOIN persons p USING(person_id)
WHERE t.name = 'Krakow Rapid Masters'
  AND (p.first_name, p.last_name) IN (
    ('Nodirbek','Abdusattorov'),
    ('Vincent','Keymer'),
    ('Wesley','So'),
    ('Wei','Yi'),
    ('Alireza','Firouzja'),
    ('Hans','Niemann')
  )
ON CONFLICT DO NOTHING;

INSERT INTO tournament_players (tournament_id, player_id)
SELECT t.tournament_id, pl.player_id
FROM tournaments t JOIN players pl ON TRUE
JOIN persons p USING(person_id)
WHERE t.name = 'Paris Blitz Challenge'
  AND (p.first_name, p.last_name) IN (
    ('Ian','Nepomniachtchi'),
    ('Levon','Aroniam'),
    ('Maxime','Vachier-Lagrave'),
    ('Richard','Rapport'),
    ('Shakhriyar','Mamedyarov'),
    ('Nijat','Abasov')
  )
ON CONFLICT DO NOTHING;

INSERT INTO tournament_players (tournament_id, player_id)
SELECT t.tournament_id, pl.player_id
FROM tournaments t JOIN players pl ON TRUE
JOIN persons p USING(person_id)
WHERE t.name = 'New York Bullet Cup'
  AND (p.first_name, p.last_name) IN (
    ('Hikaru','Nakamura'),
    ('Hans','Niemann'),
    ('Fabiano','Caruana'),
    ('Wesley','So')
  )
ON CONFLICT DO NOTHING;

INSERT INTO tournament_players (tournament_id, player_id)
SELECT t.tournament_id, pl.player_id
FROM tournaments t JOIN players pl ON TRUE
JOIN persons p USING(person_id)
WHERE t.name = 'Nordic Invitational'
  AND (p.first_name, p.last_name) IN (
    ('Magnus','Carlsen'),
    ('Vincent','Keymer'),
    ('Nodirbek','Abdusattorov'),
    ('Jan-Krzysztof','Duda'),
    ('Anish','Giri'),
    ('Wei','Yi')
  )
ON CONFLICT DO NOTHING;

INSERT INTO tournament_players (tournament_id, player_id)
SELECT t.tournament_id, pl.player_id
FROM tournaments t JOIN players pl ON TRUE
JOIN persons p USING(person_id)
WHERE t.name = 'Toronto Chess Championship'
  AND (p.first_name, p.last_name) IN (
    ('Magnus','Carlsen'),
    ('Vincent','Keymer'),
    ('Nodirbek','Abdusattorov'),
    ('Jan-Krzysztof','Duda'),
    ('Anish','Giri'),
    ('Wei','Yi')
  )
ON CONFLICT DO NOTHING;

--przykladowy turniej do testowania generate_round_robin_games
INSERT INTO tournament_players (tournament_id, player_id)
SELECT
    6,
    pl.player_id
FROM players pl
JOIN persons p USING(person_id)
WHERE (p.first_name, p.last_name) IN (
    ('Magnus','Carlsen'),
    ('Fabiano','Caruana'),
    ('Hikaru','Nakamura'),
    ('Jan-Krzysztof','Duda'),
    ('Anish','Giri'),
    ('Arjun','Erigaisi')
)
ON CONFLICT DO NOTHING;




