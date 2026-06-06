CREATE OR REPLACE FUNCTION total_minutes(a INTERVAL)
RETURNS INTEGER
AS
$$
    BEGIN
       RETURN EXTRACT('HOURS' FROM a) * 60 +
           EXTRACT('MINUTES' FROM a);
    END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION get_total_time(p_time_control_id INT)
RETURNS INTEGER
AS
$$
    BEGIN
        RETURN (SELECT total_minutes(starting_time)+
                           + EXTRACT('MINUTES' FROM increment) * 60
                           + EXTRACT('SECONDS' FROM increment)
                FROM time_controls
                WHERE time_control_id = p_time_control_id
        );
    END;
$$ language plpgsql;