CREATE TABLE parameters(parameters_id int, template_id int, parametr varchar(1000)[], task varchar(1000), REZULT varchar(1000)[]);
CREATE TABLE template(template_id int, text varchar(1000), query varchar(1000), number_of_parameters int, level int);
ALTER TABLE parameters ADD CONSTRAINT parameters_id_pk PRIMARY KEY (parameters_id);
ALTER TABLE template ADD CONSTRAINT template_id_pk PRIMARY KEY (template_id);
ALTER TABLE parameters ADD FOREIGN KEY (template_id) REFERENCES template;

CREATE SEQUENCE template_seq
START WITH 1
INCREMENT BY 1;		
					  
CREATE SEQUENCE parameters_seq
START WITH 1
INCREMENT BY 1;

/*
drop sequence template_seq;
drop sequence parameters_seq;
drop table template;	
drop table parameters;
*/
