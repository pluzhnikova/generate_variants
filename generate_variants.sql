CREATE OR REPLACE PROCEDURE pr_generate_variants 
   (
      	var_template_id INT,
	number_of_variants INT
   )
   language plpgsql  
   AS $$
   DECLARE num_of_var INT:=number_of_variants; param varchar(1000); num_of_par INT; 
   array_par varchar(100)[]; i INT;var_text varchar(1000); var_parametr varchar(100);
   var_query varchar(1000); var_result varchar(1000)[];
   BEGIN   
   SELECT number_of_parameters INTO num_of_par FROM template WHERE template_id = var_template_id;
   WHILE num_of_var > 0 LOOP
	array_par := '{}';
	i := 0;
	SELECT template_text INTO var_text FROM template WHERE template_id = var_template_id;
   	SELECT template_query INTO var_query FROM template WHERE template_id = var_template_id;
   	WHILE i != num_of_par LOOP
	i:= i + 1;
   	SELECT REGEXP_SUBSTR(var_text, '(PT_\w+)') into param;
	CASE param
	when 'PT_FIRST_NAME' then select first_name into var_parametr from visitor order by random() limit 1;
			array_par = array_par || var_parametr;
			var_text := regexp_replace(var_text, 'PT_FIRST_NAME', var_parametr);
			var_query := regexp_replace(var_query, 'PT_FIRST_NAME', var_parametr);
	when 'PT_LAST_NAME' then select last_name into var_parametr from visitor order by random() limit 1;
			array_par = array_par || var_parametr;
			var_text := regexp_replace(var_text, 'PT_LAST_NAME', var_parametr);
			var_query := regexp_replace(var_query, 'PT_LAST_NAME', var_parametr);
	when 'PT_VISITOR_ID' then select visitor_id::varchar(7) into var_parametr from visitor order by random() limit 1;
			array_par = array_par || var_parametr;
			var_text := regexp_replace(var_text, 'PT_VISITOR_ID', var_parametr);
			var_query := regexp_replace(var_query, 'PT_VISITOR_ID', var_parametr);
	when 'PT_AUTHOR' then select author into var_parametr from exhibit where author IS NOT NULL order by random() limit 1;
			array_par = array_par || var_parametr;
			var_text := regexp_replace(var_text, 'PT_AUTHOR', var_parametr);
			var_query := regexp_replace(var_query, 'PT_AUTHOR', var_parametr);
	when 'PT_YEAR_OF_CREATION' then select year_of_creation::varchar(7) into var_parametr from exhibit where year_of_creation IS NOT NULL order by random() limit 1;
			array_par = array_par || var_parametr;
			var_text := regexp_replace(var_text, 'PT_YEAR_OF_CREATION', var_parametr);
			var_query := regexp_replace(var_query, 'PT_YEAR_OF_CREATION', var_parametr);
	when 'PT_PRICE' then select price::varchar(7) into var_parametr from exhibit order by random() limit 1;
			array_par = array_par || var_parametr;
			var_text := regexp_replace(var_text, 'PT_PRICE', var_parametr);
			var_query := regexp_replace(var_query, 'PT_PRICE', var_parametr);
	when 'PT_LIMIT' then select (array['4', '5', '6', '7'])[floor(random() * 2 + 1)] into var_parametr;
			array_par = array_par || var_parametr;
			var_text := regexp_replace(var_text, 'PT_LIMIT', var_parametr);
			var_query := regexp_replace(var_query, 'PT_LIMIT', var_parametr);
	when 'PT_HALL_ID' then select hall_id::varchar(7) into var_parametr from hall order by random() limit 1;
			array_par = array_par || var_parametr;
			var_text := regexp_replace(var_text, 'PT_HALL_ID', var_parametr);
			var_query := regexp_replace(var_query, 'PT_HALL_ID', var_parametr);
	when 'PT_DESC' then select (array['ASC', 'DESC'])[floor(random() * 2 + 1)] into var_parametr;
			array_par = array_par || var_parametr;
			if var_parametr = 'ASC' THEN
			var_text := regexp_replace(var_text, 'возрастания', var_parametr);
			else
			var_text := regexp_replace(var_text, 'убывания', var_parametr);
			END IF;
			var_query := regexp_replace(var_query, 'PT_DESC', var_parametr);
	when 'PT_STARTS_ON' then select starts_on::date::varchar(20) into var_parametr from schedule order by random() limit 1;
			array_par = array_par || var_parametr;
			var_text := regexp_replace(var_text, 'PT_STARTS_ON', var_parametr);
			var_query := regexp_replace(var_query, 'PT_STARTS_ON', var_parametr);
	when 'PT_MUSEUM_ID' then select museum_id::varchar(7) into var_parametr from museum order by random() limit 1;
			array_par = array_par || var_parametr;
			var_text := regexp_replace(var_text, 'PT_MUSEUM_ID', var_parametr);
			var_query := regexp_replace(var_query, 'PT_MUSEUM_ID', var_parametr);
	when 'PT_ROUND' then select (array['2', '3', '4'])[floor(random() * 2 + 1)] into var_parametr;
			array_par = array_par || var_parametr;
			var_text := regexp_replace(var_text, 'PT_ROUND', var_parametr);
			var_query := regexp_replace(var_query, 'PT_ROUND', var_parametr);
	when 'PT_EXHIBIT_NAME' then select exhibit_name into var_parametr from exhibit order by random() limit 1;
			array_par = array_par || var_parametr;
			var_text := regexp_replace(var_text, 'PT_EXHIBIT_NAME', var_parametr);
			var_query := regexp_replace(var_query, 'PT_EXHIBIT_NAME', var_parametr);
	when 'PT_EXCURDION_NAME' then select excursion_name into var_parametr from excursion order by random() limit 1;
			array_par = array_par || var_parametr;
			var_text := regexp_replace(var_text, 'PT_EXCURDION_NAME', var_parametr);
			var_query := regexp_replace(var_query, 'PT_EXCURDION_NAME', var_parametr);
	when 'PT_EXCURDION_ID' then select excursion_id::varchar(7) into var_parametr from excursion order by random() limit 1;
			array_par = array_par || var_parametr;
			var_text := regexp_replace(var_text, 'PT_EXCURDION_ID', var_parametr);
			var_query := regexp_replace(var_query, 'PT_EXCURDION_ID', var_parametr);
	when 'PT_LETTER' then select (array['А', 'Б', 'В', 'Г', 'Д', 'Е','Ж', 'З', 'К','Л', 'М', 'Н','О', 'П', 'Р',
									   'С', 'Т', 'У','Ф', 'Ш', 'Э','Ю', 'Я'])[floor(random() * 23 + 1)] into var_parametr;
			array_par = array_par || var_parametr;
			var_text := regexp_replace(var_text, 'PT_LETTER', var_parametr);
			var_query := regexp_replace(var_query, 'PT_LETTER', var_parametr);
	when 'PT_COUNTRY_OF_CREATION' then select country_of_creation into var_parametr from exibit order by random() limit 1;
			array_par = array_par || var_parametr;
			var_text := regexp_replace(var_text, 'PT_COUNTRY_OF_CREATION', var_parametr);
			var_query := regexp_replace(var_query, 'PT_COUNTRY_OF_CREATION', var_parametr);
	ELSE
        	RAISE NOTICE 'Unfamiliar parameter % ', param;
		RETURN;
	END CASE;
   END LOOP;
   EXECUTE 'SELECT ARRAY('||var_query||');' into var_result;
   insert into variant(variant_id, template_id, parameters, variant_text, result) 
   values (nextval('variant_seq'), var_template_id, array_par, var_text, var_result);
  -- insert into parameters(parameters_id, template_id, parametr) values (nextval('parameters_seq'), v_template_id, array_par);
   num_of_var := num_of_var - 1;
   END LOOP;
END						
$$;

/*
--Добавляем шаблон в таблицу template. Допустим, это первая запись в таблице (template_id = 1)
insert into template values
(nextval('template_seq'),'Выведите фамилии посетителей с именем PT_FIRST_NAME или PT_FIRST_NAME', 
 'SELECT last_name FROM visitor WHERE first_name = ''PT_FIRST_NAME'' OR first_name = ''PT_FIRST_NAME''', 2, 2);
 
--Вызываем процедуру: генерируем 5 вариантов по первому шаблону
CALL pr_generate_variants(1,5);
 */
