PGDMP         :            	    {         	   Recruitee    15.2    15.2                 0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    32839 	   Recruitee    DATABASE     ~   CREATE DATABASE "Recruitee" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_India.1252';
    DROP DATABASE "Recruitee";
                postgres    false            �            1255    32952 W   addcandidate(character varying, character varying, text, character varying, text, text) 	   PROCEDURE     �  CREATE PROCEDURE public.addcandidate(IN iname character varying, IN icontactdetails character varying, IN iresume text, IN iskills character varying, IN iexperience text, IN ieducation text)
    LANGUAGE plpgsql
    AS $$
DECLARE
	candidateCount INT;
BEGIN
   

    -- Check if the candidate already exists based on Name and ContactDetails
    SELECT COUNT(*) INTO candidateCount
    FROM Candidates
    WHERE name = iName AND ContactDetails = iContactDetails;

    IF candidateCount = 0 THEN
        -- If the candidate does not exist, insert the new candidate
        INSERT INTO Candidates (Name, ContactDetails, Resume, Skills, Experience, Education)
        VALUES (iName, iContactDetails, iResume, iSkills, iExperience, iEducation);
        RAISE NOTICE 'Candidate added successfully.' ;
    ELSE
        -- If the candidate already exists, raise an error notice
        Raise NOTICE 'Candidate data is invalid or repeated..!!';
    END IF;
END;
$$;
 �   DROP PROCEDURE public.addcandidate(IN iname character varying, IN icontactdetails character varying, IN iresume text, IN iskills character varying, IN iexperience text, IN ieducation text);
       public          postgres    false            �            1255    32936    after_candidate_delete()    FUNCTION     �   CREATE FUNCTION public.after_candidate_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO deleted_candidate
    VALUES (OLD.*);
    RETURN OLD;
END;
$$;
 /   DROP FUNCTION public.after_candidate_delete();
       public          postgres    false            �            1255    32955    deletecandidatebyid(integer)    FUNCTION     �  CREATE FUNCTION public.deletecandidatebyid(candidate_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	OutText Text;
	c_count int:=0;
BEGIN
	select count(*) into c_count from candidates where candidateid = candidate_id;
	if c_count <> 0 then
    DELETE FROM Candidates WHERE CandidateID = candidate_id;
	OutText:= 'Candidate deleted successfully.';
    Return OutText;
	else 
		OutText:= 'Candidate can not deleted successfully.';
    	Return OutText;
	END IF;																					
END;
$$;
 @   DROP FUNCTION public.deletecandidatebyid(candidate_id integer);
       public          postgres    false            �            1255    32920 )   hirecandidate(integer, character varying)    FUNCTION     �  CREATE FUNCTION public.hirecandidate(num integer, candidate_type character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$

BEGIN
	if candidate_type='experience' then 
		insert into selected_candidates select * from candidates order by experience desc limit num;
	elsif candidate_type='skills' then
		insert into selected_candidates select * from candidates order by skills limit num;
	elsif candidate_type in ('edu','education') then
		insert into selected_candidates select * from candidates order by education limit num;
	else 
		
		Raise Notice 'Enter Invalid candidates count or sorting type...!!  ';
		Raise Notice 'there are 3 soritng types experience,skills, and education';
	end if;
 -- now, deleting those candidates from applied candidate list
 
 delete from candidates where candidateid IN(select candidateid from selected_candidates);
Raise Notice 'Hiered candidate : %  | Candidate based on sorting : %',num,candidate_type;
 END;
 $$;
 S   DROP FUNCTION public.hirecandidate(num integer, candidate_type character varying);
       public          postgres    false            �            1255    32930    sortjobpositionsbydepartment() 	   PROCEDURE     /  CREATE PROCEDURE public.sortjobpositionsbydepartment()
    LANGUAGE plpgsql
    AS $$
DECLARE
	i int:=0;
    job_record JobPositions%ROWTYPE;
    cursor_job_positions CURSOR FOR
        SELECT * FROM JobPositions ORDER BY department;
BEGIN
    OPEN cursor_job_positions;

    LOOP
        FETCH cursor_job_positions INTO job_record;
        EXIT WHEN NOT FOUND;
		i:=i+1;
        RAISE NOTICE '#%. JobID: %, Title: %, Department: %',i,job_record.JobID, job_record.Title, 
                     job_record.Department;
		RAISE NOTICE 'Description: %, RequiredSkills: %, ExperienceLevel: %, Salary: %', job_record.Description, 
                     job_record.RequiredSkills, job_record.ExperienceLevel, 
                     job_record.Salary;
		RAISE NOTICE'';
    END LOOP;

    CLOSE cursor_job_positions;
END;
$$;
 6   DROP PROCEDURE public.sortjobpositionsbydepartment();
       public          postgres    false            �            1255    32929    sortjobpositionsbyexperience() 	   PROCEDURE     4  CREATE PROCEDURE public.sortjobpositionsbyexperience()
    LANGUAGE plpgsql
    AS $$
DECLARE
	i int:=0;
    job_record JobPositions%ROWTYPE;
    cursor_job_positions CURSOR FOR
        SELECT * FROM JobPositions ORDER BY experiencelevel;
BEGIN
    OPEN cursor_job_positions;

    LOOP
        FETCH cursor_job_positions INTO job_record;
        EXIT WHEN NOT FOUND;
		i:=i+1;
        RAISE NOTICE '#%. JobID: %, Title: %, Department: %',i,job_record.JobID, job_record.Title, 
                     job_record.Department;
		RAISE NOTICE 'Description: %, RequiredSkills: %, ExperienceLevel: %, Salary: %', job_record.Description, 
                     job_record.RequiredSkills, job_record.ExperienceLevel, 
                     job_record.Salary;
		RAISE NOTICE'';
    END LOOP;

    CLOSE cursor_job_positions;
END;
$$;
 6   DROP PROCEDURE public.sortjobpositionsbyexperience();
       public          postgres    false            �            1255    32928    sortjobpositionsbysalary() 	   PROCEDURE     ,  CREATE PROCEDURE public.sortjobpositionsbysalary()
    LANGUAGE plpgsql
    AS $$
DECLARE
	i int:=0;
    job_record JobPositions%ROWTYPE;
    cursor_job_positions CURSOR FOR
        SELECT * FROM JobPositions ORDER BY salary desc;
BEGIN
    OPEN cursor_job_positions;

    LOOP
        FETCH cursor_job_positions INTO job_record;
        EXIT WHEN NOT FOUND;
		i:=i+1;
        RAISE NOTICE '#%. JobID: %, Title: %, Department: %',i,job_record.JobID, job_record.Title, 
                     job_record.Department;
		RAISE NOTICE 'Description: %, RequiredSkills: %, ExperienceLevel: %, Salary: %', job_record.Description, 
                     job_record.RequiredSkills, job_record.ExperienceLevel, 
                     job_record.Salary;
		RAISE NOTICE'';
    END LOOP;

    CLOSE cursor_job_positions;
END;
$$;
 2   DROP PROCEDURE public.sortjobpositionsbysalary();
       public          postgres    false            �            1255    32931 *   sortjobpositionsbyskill(character varying) 	   PROCEDURE     o  CREATE PROCEDURE public.sortjobpositionsbyskill(IN requiered_skill character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
	i int:=0;
    job_record JobPositions%ROWTYPE;
    cursor_job_positions CURSOR FOR
        SELECT * FROM JobPositions where requiredskills like '%'||requiered_skill||'%' ;
BEGIN
    OPEN cursor_job_positions;

    LOOP
        FETCH cursor_job_positions INTO job_record;
        EXIT WHEN NOT FOUND;
		i:=i+1;
        RAISE NOTICE '#%. JobID: %, Title: %, Department: %',i,job_record.JobID, job_record.Title, 
                     job_record.Department;
		RAISE NOTICE 'Description: %, RequiredSkills: %, ExperienceLevel: %, Salary: %', job_record.Description, 
                     job_record.RequiredSkills, job_record.ExperienceLevel, 
                     job_record.Salary;
		RAISE NOTICE'';
    END LOOP;

    CLOSE cursor_job_positions;
END;
$$;
 U   DROP PROCEDURE public.sortjobpositionsbyskill(IN requiered_skill character varying);
       public          postgres    false            �            1255    32927    sortjobpositionsbytitle() 	   PROCEDURE     %  CREATE PROCEDURE public.sortjobpositionsbytitle()
    LANGUAGE plpgsql
    AS $$
DECLARE
	i int:=0;
    job_record JobPositions%ROWTYPE;
    cursor_job_positions CURSOR FOR
        SELECT * FROM JobPositions ORDER BY Title;
BEGIN
    OPEN cursor_job_positions;

    LOOP
        FETCH cursor_job_positions INTO job_record;
        EXIT WHEN NOT FOUND;
		i:=i+1;
        RAISE NOTICE '#%. JobID: %, Title: %, Department: %',i,job_record.JobID, job_record.Title, 
                     job_record.Department;
		RAISE NOTICE 'Description: %, RequiredSkills: %, ExperienceLevel: %, Salary: %', job_record.Description, 
                     job_record.RequiredSkills, job_record.ExperienceLevel, 
                     job_record.Salary;
		RAISE NOTICE'';
    END LOOP;

    CLOSE cursor_job_positions;
END;
$$;
 1   DROP PROCEDURE public.sortjobpositionsbytitle();
       public          postgres    false            �            1259    32841 
   candidates    TABLE     �   CREATE TABLE public.candidates (
    candidateid integer NOT NULL,
    name character varying(100),
    contactdetails character varying(255),
    resume text,
    skills character varying(255),
    experience text,
    education text
);
    DROP TABLE public.candidates;
       public         heap    postgres    false            �            1259    32840    candidates_candidateid_seq    SEQUENCE     �   CREATE SEQUENCE public.candidates_candidateid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.candidates_candidateid_seq;
       public          postgres    false    215                       0    0    candidates_candidateid_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.candidates_candidateid_seq OWNED BY public.candidates.candidateid;
          public          postgres    false    214            �            1259    32938    deleted_candidate    TABLE     �   CREATE TABLE public.deleted_candidate (
    candidateid integer,
    name character varying(100),
    contactdetails character varying(255),
    resume text,
    skills character varying(255),
    experience text,
    education text
);
 %   DROP TABLE public.deleted_candidate;
       public         heap    postgres    false            �            1259    32850    jobpositions    TABLE       CREATE TABLE public.jobpositions (
    jobid integer NOT NULL,
    title character varying(100) NOT NULL,
    department character varying(50),
    description text,
    requiredskills character varying(255),
    experiencelevel character varying(50),
    salary numeric(10,2)
);
     DROP TABLE public.jobpositions;
       public         heap    postgres    false            �            1259    32849    jobpositions_jobid_seq    SEQUENCE     �   CREATE SEQUENCE public.jobpositions_jobid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.jobpositions_jobid_seq;
       public          postgres    false    217                       0    0    jobpositions_jobid_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.jobpositions_jobid_seq OWNED BY public.jobpositions.jobid;
          public          postgres    false    216            �            1259    32921    selected_candidates    TABLE     �   CREATE TABLE public.selected_candidates (
    candidateid integer,
    name character varying(100),
    contactdetails character varying(255),
    resume text,
    skills character varying(255),
    experience text,
    education text
);
 '   DROP TABLE public.selected_candidates;
       public         heap    postgres    false            {           2604    32844    candidates candidateid    DEFAULT     �   ALTER TABLE ONLY public.candidates ALTER COLUMN candidateid SET DEFAULT nextval('public.candidates_candidateid_seq'::regclass);
 E   ALTER TABLE public.candidates ALTER COLUMN candidateid DROP DEFAULT;
       public          postgres    false    214    215    215            |           2604    32853    jobpositions jobid    DEFAULT     x   ALTER TABLE ONLY public.jobpositions ALTER COLUMN jobid SET DEFAULT nextval('public.jobpositions_jobid_seq'::regclass);
 A   ALTER TABLE public.jobpositions ALTER COLUMN jobid DROP DEFAULT;
       public          postgres    false    217    216    217                      0    32841 
   candidates 
   TABLE DATA           n   COPY public.candidates (candidateid, name, contactdetails, resume, skills, experience, education) FROM stdin;
    public          postgres    false    215   �=                 0    32938    deleted_candidate 
   TABLE DATA           u   COPY public.deleted_candidate (candidateid, name, contactdetails, resume, skills, experience, education) FROM stdin;
    public          postgres    false    219   xB                 0    32850    jobpositions 
   TABLE DATA           v   COPY public.jobpositions (jobid, title, department, description, requiredskills, experiencelevel, salary) FROM stdin;
    public          postgres    false    217   �D                 0    32921    selected_candidates 
   TABLE DATA           w   COPY public.selected_candidates (candidateid, name, contactdetails, resume, skills, experience, education) FROM stdin;
    public          postgres    false    218   J                  0    0    candidates_candidateid_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.candidates_candidateid_seq', 64, true);
          public          postgres    false    214                       0    0    jobpositions_jobid_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.jobpositions_jobid_seq', 26, true);
          public          postgres    false    216            ~           2606    32848    candidates candidates_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.candidates
    ADD CONSTRAINT candidates_pkey PRIMARY KEY (candidateid);
 D   ALTER TABLE ONLY public.candidates DROP CONSTRAINT candidates_pkey;
       public            postgres    false    215            �           2606    32857    jobpositions jobpositions_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.jobpositions
    ADD CONSTRAINT jobpositions_pkey PRIMARY KEY (jobid);
 H   ALTER TABLE ONLY public.jobpositions DROP CONSTRAINT jobpositions_pkey;
       public            postgres    false    217            �           2620    32937 #   candidates candidate_delete_trigger    TRIGGER     �   CREATE TRIGGER candidate_delete_trigger AFTER DELETE ON public.candidates FOR EACH ROW EXECUTE FUNCTION public.after_candidate_delete();
 <   DROP TRIGGER candidate_delete_trigger ON public.candidates;
       public          postgres    false    220    215               �  x��W]o�6|��>Fb[��:���%NsV��E�b#3�l�(�w���I�/@���x����r��@� d�cm����}�8���آ��WSw�G�˙���W,�cf'�Wrsqa�ϰϗa�Y����=������4��W�*����'�\Dbs8#��-�B�	������͢&q�~�nrx<d���������7� �R�\�텢�����Ї�.�&�I|��q�\���1HX�;U�d�`�QbX�K�cQ���I#n��R@Q�q�gLR������9�B�?`{���9Bd\�4�0������Y\�y$vt��X۱��f����>5�营@2���`Z�4&3#K��`(��I�8�e�ڴ�M�12��R�2�$+�}fjm���=�\�Z��h�{Y����M���X3{���OfH<4�?�I$U��Q��8FC�l�)�tg�G�fɼ/��ҳƓ�U�mS��ٶ�fR�Z�mxf�|��9(6�CR�f�U@�'�2)0m��������I2���zL��k�Vצ���}XŬĺ7fkM\�iǬ���]|K$KS�0Ǆ�ܻp�}c�����L�j�}��&6SQ�3�K��2堔az�T�3Ո֘
��A�Hc��	3��g���2�u��,Sm��������#!W������W�����q���.U�..�l1]yb�>I�6��1�Q�15@� �I�� (����W���?`>B�v��s_�"dº/*��OyQ/Go��$Hl	��b�2��q_�<��0X�m�Ë́霩#�+Tf��ڠdjճ[�!����,� $;��[՜"� =�Nig}#���\�bN�,�|э���PO�C�k2�vLn��+S�Us�����>s���K�����$��2����n<_� ��$Ӎͱ9E�캵�8k�yt[��&df,�] �㡨;{���+Ӏ��Q's�P���ӧ���蒇�WW��y+m�T�X�����!C�N�Ը��6"���&niyjHU�όn%�`G�8�.'�������)��}�v���W��~�=�O�IXFE���2���BqtI��_�/���G�Uۉ�O�5a�q"��������L�^ּ�Gcg�N�f�]l5���0����/{0�ś��         p  x��T�N�0}v��J{$�h��V
llu��^&M��61$vd;e���.PWP¤=$�W��=9��NبF�Zwg�n�ޗ���ME<Wu
{'���G���A��?� �}C���7���l�d
gw(��T[hʾ_�>��a�������֒�,$sJS"d%�]��U��z�JZ�J�����d@?��hI�jH�S�KWjP��|z��}�D�]��<�/4��KL�q�I6x�bFy��}vM�O�52Ik=\ݥH�����g��M��lr�7r\�U���>Re��3�59���DZ�"9`7X�暒i_s��.f1l�!��,�
u��7��+�$�;|����P�zRU�X%�l��
a��*���7��b��[�FMS�<�4ɀ�P[�0C_�;��bo�'3���:`w	��,���Y2t6KaJ��6Y^�����1܍��*�xMV^�(e�Z���vƶ4;r!�#7�� ���%�c��>g��|Biw;�P��v�	׫z�f(�fZ,i.���뮋�6���8��ee����F��}}A����p�8�[�����t��Ǝ��[��mO����0{�ϲR,�v��y����r��:�H���v7Zַ���x�$��g6         �  x��VK[�8]�_��$-�%�����PLg����/����Jr ��s$�rf��ؖ���ܣ;a�~v/�_��TD�uR-ٜ�T�U�JH���mg"꺔�pR+��k1�������rd**�p��N�����h���	~�D����_'s�~Q�%�im��\WuI���F��e!��ƭ����/iQ�_!������g�N�m������J,Q��{Eʡ�gT��v�hQT"�L�5�l2˜AY�R1�_�u���ڰ�������߮���\*�lf��|��trk_�jʍ��P�Z�ƒ��<�I|�޺��u�/�D��|����܋6?�:j�%��!��p�ZX]6�g��z�g���G��4�l�n��.�)�zH�_5�P���n�/�nM�ql9�dC��K�ʖ_�t�A7l�E��
�A�B���FN��o#���9_k�;yc���-�$U �<Z�C�y�56�x�;���tg}�>I%T.E�H�P��s�h���1%C�6 y��VT��������e�x�W�O���>��۰\�("�y�-��q+�k����Ё���6�;k2f_}�����1��a�-�����Z�lj0[�*��H6�}� ���Ì�L�n�6Ќ��v�.�RݩS�!-��R�t�͓)KPeM��A�,�D �i�f��x��%�^7�UoDf-s򌫪F�;L�ɇ��O�yYTR!�^?�XK��k'+	���VH��b��|d���W2K��k-b�E��B���e?����#?a:�*��u�\ڃ��<r�F�ִ�������ȿ�:þ�LN{�H�ud�z�L"\��~u��夿7�r)�o���hg솖�2Ӎ�8��智�����(<WB
�%[4�Β0�*
����/�D��M���?�f�=�{dI?u+ Rn�c��7�g�=�!���?���&߻��I�m�d�J{䯆!��:��g�7���TJ����WF�u�;�W����m��k�Ǵ��xH�A9�N�]�%��o�\�)�Y!6�N�������<EY���ul���e:ea�߃�m�������=펅W��P�Y�������z_aR��VM�{د !n�c�dsikBpo���e�����9B�E?���]�S�٢���pd���(L�M�1n�� M�����'�F/Q��̙֦���<}e�kd~���^&����(��<[��w�O�ضtk�3�:��������%�g���8������^�         �  x����o�0ş�_ai�cV!!M�F�쳙�PM�4i�%��ldLT��a>�T�Ε|��;�ď��с@%Yn�g|�4K��2��ǅ�i1��yӉ�4���o�y�"���������*md�:C�Rj��A�d�֔��iVhTt-".�AkN|C���É@=��}��nҺj�%϶�)l����Mw�&� Hr!Z��SP�gQ}	Tv4r�`V;j���[��Ha��xbBv��(��� ss�Ho�KI��;�IN���	�Z��w�8.	��k�i ��,2zd!��S[�}I ?�-�x�*�+�gB&2*-���]4���S;z�4Um�yQY2k16��z5gB�̲mi^C-=��u�Zz�B7�W6ݔf#��F�Q�U�����}�*^��e���~�e����M�<ߧG�:�:weÂ�*ʌ< f�ر��&����x��,�P�2˲���     