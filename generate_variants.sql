create or replace function fn_insert_on_parameters()
RETURNS trigger AS $$
DECLARE var_REZULT varchar(1000)[];   
	    var_text varchar(1000);
		var_query varchar(1000);
		var_num_of_param int;
BEGIN
	select text into var_text from template where template_id = NEW.template_id;
	select query into var_query from template where template_id = NEW.template_id;
	select number_of_parameters into var_num_of_param from template where template_id = NEW.template_id;
	case var_num_of_param
		when 1 then EXECUTE 'SELECT ARRAY('||regexp_replace(var_query, '(PT\w*)', NEW.parametr[1])||');' into var_REZULT;
				update parameters set task = regexp_replace(var_text, '(PT\w*)', NEW.parametr[1]) where parameters_id = NEW.parameters_id;
				
		when 2 then EXECUTE 'SELECT ARRAY('|| regexp_replace(regexp_replace(var_query, '(PT\w*)', NEW.parametr[1]), '(PT\w*)', NEW.PARAMETR[2])||');' into var_REZULT;
				update parameters set task = regexp_replace(regexp_replace(var_text, '(PT\w*)', NEW.parametr[1]), '(PT\w*)', NEW.PARAMETR[2]) where parameters_id = NEW.parameters_id;
		
		when 3 then EXECUTE 'SELECT ARRAY('|| regexp_replace(regexp_replace(regexp_replace(var_query, '(PT\w*)', NEW.parametr[1]), '(PT\w*)', NEW.PARAMETR[2]),'(PT\w*)', NEW.PARAMETR[3])||');' into var_REZULT;
				update parameters set task = regexp_replace(regexp_replace(regexp_replace(var_text, '(PT\w*)', NEW.parametr[1]), '(PT\w*)', NEW.PARAMETR[2]), '(PT\w*)', NEW.PARAMETR[3])  where parameters_id = NEW.parameters_id;
		ELSE
        var_REZULT = 'Empty';
    END CASE;
	update parameters set REZULT = var_REZULT where parameters_id = NEW.parameters_id;
	RETURN NEW;
end;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER tr_parameters
AFTER INSERT ON parameters
FOR EACH ROW
EXECUTE FUNCTION fn_insert_on_parameters();

CREATE OR REPLACE PROCEDURE pr_generate_variants 
   (
      v_template_id INT,
	  number_of_variants INT
   )
   language plpgsql  
   AS $$
   DECLARE num_of_var INT:=number_of_variants; param varchar(1000); num_of_par INT; 
   array_par varchar(100)[]; i INT;var_text varchar(1000); var_parametr varchar(100);
   BEGIN   
   SELECT number_of_parameters INTO num_of_par FROM template WHERE template_id = v_template_id;
   SELECT text INTO var_text FROM template WHERE template_id = v_template_id;
	WHILE num_of_var > 0 LOOP
	array_par := '{}';
	i := 0;
    WHILE i != num_of_par LOOP
	i:= i + 1;
   	SELECT REGEXP_SUBSTR(var_text, '(PT\w*)', 1, i) into param;
	case param
	when 'PT_FIRST_NAME' then select first_name into var_parametr from visitor order by random() limit 1;
	array_par = array_par || var_parametr;
	when 'PT_LAST_NAME' then select last_name into var_parametr from visitor order by random() limit 1;
		array_par = array_par || var_parametr;
	when 'PT_VISITOR_ID' then select visitor_id::varchar(7) into var_parametr from visitor order by random() limit 1;
			array_par = array_par || var_parametr;
	when 'PT_AUTHOR' then select author into var_parametr from exhibit where author IS NOT NULL order by random() limit 1;
			array_par = array_par || var_parametr;
	when 'PT_YEAR_OF_CREATION' then select year_of_creation::varchar(7) into var_parametr from exhibit where year_of_creation IS NOT NULL order by random() limit 1;
			array_par = array_par || var_parametr;
	when 'PT_PRICE' then select price::varchar(7) into var_parametr from exhibit order by random() limit 1;
			array_par = array_par || var_parametr;
	when 'PT_LIMIT' then select (array['4', '5', '6', '7'])[floor(random() * 2 + 1)] into var_parametr;
		array_par = array_par || var_parametr;
	when 'PT_HALL_ID' then select hall_id::varchar(7) into var_parametr from hall order by random() limit 1;
			array_par = array_par || var_parametr;
	when 'PT_DESC' then select (array['ASC', 'DESC'])[floor(random() * 2 + 1)] into var_parametr;
		array_par = array_par || var_parametr;
	when 'PT_STARTS_ON' then select starts_on::varchar(20) into var_parametr from schedule order by random() limit 1;
		array_par = array_par || var_parametr;
	when 'PT_MUSEUM_ID' then select museum_id::varchar(7) into var_parametr from museum order by random() limit 1;
			array_par = array_par || var_parametr;
	when 'PT_ROUND' then select (array['2', '3', '4'])[floor(random() * 2 + 1)] into var_parametr;
		array_par = array_par || var_parametr;
	when 'PT_EXHIBIT_NAME' then select exhibit_name into var_parametr from exhibit order by random() limit 1;
			array_par = array_par || var_parametr;
	when 'PT_EXCURDION_NAME' then select excursion_name into var_parametr from excursion order by random() limit 1;
			array_par = array_par || var_parametr;
	when 'PT_EXCURDION_ID' then select excursion_id::varchar(7) into var_parametr from excursion order by random() limit 1;
			array_par = array_par || var_parametr;
	when 'PT_LETTER' then select (array['А', 'Б', 'В', 'Г', 'Д', 'Е','Ж', 'З', 'К','Л', 'М', 'Н','О', 'П', 'Р',
									   'С', 'Т', 'У','Ф', 'Ш', 'Э','Ю', 'Я'])[floor(random() * 23 + 1)] into var_parametr;
			array_par = array_par || var_parametr;
	when 'PT_COUNTRY_OF_CREATION' then select country_of_creation into var_parametr from exibit order by random() limit 1;
			array_par = array_par || var_parametr;
	ELSE
        array_par = '{}';
	END CASE;
   END LOOP;
   insert into parameters(parameters_id, template_id, parametr) 
	values (nextval('parameters_seq'), v_template_id, array_par);
   num_of_var := num_of_var - 1;
   END LOOP;
END						
$$;
