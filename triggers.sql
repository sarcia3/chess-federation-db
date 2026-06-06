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


CREATE OR REPLACE FUNCTION total_time_matches_chess_type()
RETURNS TRIGGER AS
$$
    DECLARE
        tt INT;
    BEGIN
        tt = get_total_time(NEW.time_control_id);
        IF (
            SELECT COALESCE(total_minutes(total_time_from), 0) <= tt AND tt::FLOAT <= COALESCE(total_minutes(total_time_from)::FLOAT, 'INFINITY'::FLOAT)
            FROM chess_types
            WHERE chess_type_id = NEW.chess_type_id) THEN RETURN NEW;
        ELSE RAISE EXCEPTION 'Total time does not match chess type.';
        END IF;
    END;
$$ language plpgsql;

CREATE OR REPLACE TRIGGER total_time_matches_chess_type
AFTER INSERT OR UPDATE OR DELETE ON tournaments
FOR EACH ROW EXECUTE FUNCTION total_time_matches_chess_type();