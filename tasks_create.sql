CREATE TABLE template(template_id int, template_text varchar(1000), template_query varchar(1000), number_of_parameters int, level int);
CREATE TABLE variant(variant_id int, template_id int, parameters varchar(1000)[], variant_text varchar(1000), result varchar(1000)[]);
ALTER TABLE variant ADD CONSTRAINT variant_id_pk PRIMARY KEY (variant_id);
ALTER TABLE template ADD CONSTRAINT template_id_pk PRIMARY KEY (template_id);
ALTER TABLE variant ADD FOREIGN KEY (template_id) REFERENCES template;

CREATE SEQUENCE template_seq
START WITH 1
INCREMENT BY 1;		
					  
CREATE SEQUENCE variant_seq
START WITH 1
INCREMENT BY 1;

/*
drop sequence template_seq;
drop sequence variant_seq;
drop table template;	
drop table variant;
*/
