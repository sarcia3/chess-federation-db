----Player cannot play against himself
--
--CREATE OR REPLACE FUNCTION dont_self_play()
--RETURNS TRIGGER AS
--$$
--BEGIN
--   IF NEW.white_player_id = NEW.black_player_id THEN RAISE EXCEPTION 'A player cannot play against themselves.';
--   END IF;
--   RETURN NEW;
--END;
--$$
--LANGUAGE plpgsql;
--
--CREATE TRIGGER trigger_dont_self_play
--BEFORE INSERT OR UPDATE ON games
--FOR EACH ROW EXECUTE FUNCTION dont_self_play();

-- I see no reason for this not to be a check. After discussing I commented this out ~sara.



--Monitoring contact history: when a new concact data is added, we close previous record

CREATE OR REPLACE FUNCTION close_previous_contact()
RETURNS TRIGGER AS
$$
BEGIN 
   UPDATE person_contact_data SET timestamp_to = CURRENT_DATE
   WHERE person_id = NEW.person_id AND timestamp_to IS NULL;
   RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER trigger_close_previous_contact 
BEFORE INSERT ON person_contact_data
FOR EACH ROW EXECUTE FUNCTION close_previous_contact();

--Block deleting finished games

CREATE RULE dont_delete_games AS
ON DELETE TO games DO INSTEAD NOTHING;


--Closing old country record in case of country change

CREATE OR REPLACE FUNCTION update_person_country_history()
RETURNS TRIGGER AS
$$
BEGIN
   IF OLD.country_id IS DISTINCT FROM NEW.country_id THEN
      UPDATE person_country_history
      SET date_to = CURRENT_DATE
      WHERE person_id = OLD.person_id AND date_to IS NULL;
      
      INSERT INTO person_country_history (person_id, country_id, date_from, date_to)
      VALUES(NEW.person_id, NEW.country_id, CURRENT_DATE, NULL);
    
   END IF;
   RETURN NEW;
END;      
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigg_update_person_country_history 
AFTER UPDATE OF country_id ON persons
FOR EACH ROW EXECUTE FUNCTION update_person_country_history();


--- Inserting the first country of a person to country_person_history

CREATE OR REPLACE FUNCTION person_first_country()
RETURNS TRIGGER AS
$$
BEGIN
   INSERT INTO person_country_history (person_id, country_id, date_from, date_to)
   VALUES (NEW.person_id, NEW.country_id, CURRENT_DATE, NULL);
   RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigg_person_first_country
AFTER INSERT ON persons
FOR EACH ROW EXECUTE FUNCTION person_first_country();


