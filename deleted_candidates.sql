-- creating trigger for taking back up of deleted candidate
CREATE OR REPLACE FUNCTION after_candidate_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO deleted_candidate
    VALUES (OLD.*);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- set TRigger on candidate table 
CREATE TRIGGER candidate_delete_trigger
AFTER DELETE ON candidates
FOR EACH ROW
EXECUTE FUNCTION after_candidate_delete();

select * from candidates;

-- creating pl_sql block for delete candidate in specified Range
DO $$
DECLARE
	startRange int:=11;
	endRange int:=20;
    candidate_id INT;
BEGIN
    FOR candidate_id IN startRange..endRange LOOP
        DELETE FROM Candidates WHERE CandidateID = candidate_id;
        RAISE NOTICE 'Candidate with ID % deleted successfully.', candidate_id;
    END LOOP;
END;
$$

select * from deleted_candidate;