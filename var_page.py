import tkinter as tk
import customtkinter
from tkinter import *
from tkinter import messagebox
import psycopg2
from psycopg2 import OperationalError, errorcodes, errors
import config
import pandas as pd
from tkinter.filedialog import asksaveasfilename


# Форма Варианты
class VarFrame(customtkinter.CTkFrame):
    def __init__(self, master, **kwargs):
        super().__init__(master, **kwargs)
        cursor = config.conn.cursor()
        cursor.execute("SELECT EXISTS (SELECT * FROM pg_catalog.pg_proc JOIN pg_namespace ON pg_catalog.pg_proc.pronamespace = pg_namespace.oid "
                       "WHERE proname = 'pr_generate_variants' AND pg_namespace.nspname = 'public')")
        if not cursor.fetchone()[0]:
            cursor.execute(
                "CREATE OR REPLACE PROCEDURE pr_generate_variants   (      var_template_id INT,	  number_of_variants INT   )   "
                "language plpgsql   AS $$   DECLARE num_of_var INT:=number_of_variants; var_value varchar(1000);  "
                " array_par varchar(100)[]; var_text varchar(1000); var_parametr varchar(1000);  "
                " var_query varchar(1000); var_result varchar(1000)[]; var_parameter_query varchar(1000);   "
                "dublicates int:=0; items record;  is_after_percent bool:=false; is_before_percent bool:=false;"
                " BEGIN   	WHILE num_of_var > 0 LOOP	array_par := '{}';	"
                "SELECT template_text INTO var_text FROM template WHERE template_id = var_template_id;   	"
                "SELECT template_query INTO var_query FROM template WHERE template_id = var_template_id;	"
                "SELECT REGEXP_SUBSTR(var_query, '(PT_\S+)') into var_parametr;    "
                "WHILE var_parametr is NOT NULL LOOP		"
                "IF SUBSTRING(var_parametr,  length(var_parametr)) = '%' "
                "THEN var_parametr := SUBSTRING(var_parametr,  0, length(var_parametr)); is_after_percent:= true; END IF; "
                "IF SUBSTRING(var_parametr,  0, 1) = '%' "
                "THEN var_parametr := SUBSTRING(var_parametr,  1, length(var_parametr)); is_before_percent:= true; END IF;"
                "SELECT parameter_query into var_parameter_query from parameter where parameter_name = var_parametr::varchar(255);		"
                "IF var_parameter_query is NULL THEN			RAISE NOTICE 'Добавьте параметр % в список параметров', var_parametr;			"
                "RETURN;		END IF;		EXECUTE var_parameter_query into var_value;		array_par = array_par || var_value;		"
                "var_text := regexp_replace(var_text, var_parametr, var_value);		"
                "if is_after_percent and is_before_percent "
                "THEN	var_query := regexp_replace(var_query, '%'||var_parametr||'%', ''''|| '%' || var_value || '%' ||'''');	"
                "is_before_percent:= false;			is_after_percent:= false;			"
                "SELECT REGEXP_SUBSTR(var_query, '(PT_\S+)') into var_parametr;			CONTINUE;		END IF;		"
                "if is_after_percent THEN			var_query := regexp_replace(var_query, var_parametr||'%', '''' || var_value || '%' ||'''');			"
                "is_after_percent:= false;			SELECT REGEXP_SUBSTR(var_query, '(PT_\S+)') into var_parametr;			"
                "CONTINUE;		END IF;		"
                "if is_before_percent THEN			var_query := regexp_replace(var_query, '%'||var_parametr, '''' || '%' || var_value || '''');			"
                "is_before_percent:= false;		ELSE	if var_value = 'DESC' or var_value = 'ASC' THEN	var_query := regexp_replace(var_query, var_parametr, var_value );"
                "ELSE	var_query := regexp_replace(var_query, var_parametr, '''' || var_value || ''''); END IF; END IF;	"
                "SELECT REGEXP_SUBSTR(var_query, '(PT_\S+)') into var_parametr;   "
                "END LOOP;   "
                "EXECUTE 'SELECT ARRAY('||var_query||');' into var_result;   "
                "insert into variant(variant_id, template_id, parameters, variant_text, result)    "
                "values (nextval('variant_seq'), var_template_id, array_par, var_text, var_result);   "
                "FOR items IN SELECT variant_id FROM variant WHERE template_id = var_template_id AND parameters = array_par AND variant_id != CURRVAL('variant_seq')   "
                "LOOP	RAISE NOTICE 'Вариант с id: %, дублирует вариант с id: %', 	CURRVAL('variant_seq'), items.variant_id;	END LOOP;  "
                "num_of_var := num_of_var - 1;   END LOOP;   RAISE NOTICE 'Варианты сгенерированы.';END $$;")
        self.button_frame = customtkinter.CTkFrame(self, corner_radius=0, fg_color="transparent")
        self.gen_var_btn = customtkinter.CTkButton(self.button_frame, text='Сгенерировать варианты',
                                                   command=lambda: self.generate_variants())
        self.gen_var_btn.grid(row=0, column=1, padx=20, pady=20, sticky=NSEW)
        self.del_var_btn = customtkinter.CTkButton(self.button_frame, text='Удалить вариант',
                                                   command=lambda: self.delete_variant())
        self.del_var_btn.grid(row=0, column=2, padx=20, pady=20, sticky=NSEW)
        self.load_to_txt_btn = customtkinter.CTkButton(self.button_frame, text='Выгрузить',
                                                   command=lambda: self.load_to_txt())
        self.load_to_txt_btn.grid(row=0, column=3, padx=20, pady=20, sticky=NSEW)
        self.button_frame.pack()
        self.variants_table = ttk.Treeview(self,
                                      column=('variant_id', 'template_id', 'parameters', 'variant_text', 'result'),
                                      show='headings')
        self.l1 = customtkinter.CTkLabel(self.button_frame, text="Id шаблона:")
        self.l2 = customtkinter.CTkLabel(self.button_frame, text="Сложность:")
        self.l1.grid(row=1, column=0, padx=20, pady=20, sticky=NSEW)
        self.Combo1 = customtkinter.CTkComboBox(self.button_frame, command=self.select_variants)
        self.Combo1.grid(row=1, column=1, padx=20, pady=20, sticky=NSEW)
        self.l2.grid(row=1, column=2, padx=20, pady=20, sticky=NSEW)
        self.Combo2 = customtkinter.CTkComboBox(self.button_frame, command=self.select_variants)
        self.Combo2.grid(row=1, column=3, padx=20, pady=20, sticky=NSEW)
        self.vertical_scrollbar = Scrollbar(self, orient='vertical')
        self.vertical_scrollbar.pack(side=RIGHT, fill=Y)
        self.vertical_scrollbar.config(command=self.variants_table.yview)

        self.variants_table.config(yscrollcommand=self.vertical_scrollbar.set)

        self.variants_table.column("variant_id", width=30, anchor=CENTER)
        self.variants_table.column("template_id", width=30, anchor=CENTER)
        self.variants_table.column("variant_text", width=300, anchor=CENTER)
        self.variants_table.column("parameters", width=100, anchor=CENTER)
        self.variants_table.column("result", width=100, anchor=CENTER)

        self.variants_table.heading('variant_id', text='ID варианта', anchor=CENTER)
        self.variants_table.heading('template_id', text='ID шаблона', anchor=CENTER)
        self.variants_table.heading('variant_text', text='Текст варианта', anchor=CENTER)
        self.variants_table.heading('parameters', text='Значения параметров', anchor=CENTER)
        self.variants_table.heading('result', text='Ответ', anchor=CENTER)
        self.variants_table.pack(fill=tk.BOTH, expand=True)
        self.get_variants()
        self.variants_table.bind("<Button-3>", self.sel_off)
        temp_ids = []
        for child in self.variants_table.get_children():
            temp_ids.append(self.variants_table.item(child, "values")[1])
        self.Combo1.configure(values = ['Произвольный'] + sorted(pd.Series(temp_ids).unique()))
        levels = list(range(1,11))
        levels = list(map(str, levels))
        self.Combo2.configure(values= ['Произвольная'] + levels)
        self.Combo1.set('Произвольный')
        self.Combo2.set('Произвольная')

    def sel_off(self, event):
        iid = self.variants_table.identify_row(event.y)
        if iid:
            self.variants_table.selection_remove(iid)
        else:
            pass

    def run_query(self, query, parameters=()):
        with config.conn as conn:
            cursor = conn.cursor()
            print(query)
            cursor.execute(query, parameters)
            try:
                result = cursor.fetchall()
            except:
                result = ''
            print(result)
            conn.commit()
        return result

    def get_variants(self):
        records = self.variants_table.get_children()
        for element in records:
            self.variants_table.delete(element)
        query = 'SELECT * FROM variant ORDER BY variant_id DESC'
        db_rows = self.run_query(query)
        for row in db_rows:
            string_data = [str(data) for data in row]
            self.variants_table.insert('', 0, values=string_data)

    def delete_variant(self):
        selected_item = self.variants_table.selection()
        if len(selected_item) == 0:
            messagebox.showinfo('Info', f'Выберите вариант')
        else:
            query = 'DELETE FROM variant WHERE variant_id = ' + str(
                self.variants_table.item(selected_item)["values"][0])
            db_rows = self.run_query(query)
            self.select_variants()
            messagebox.showinfo('Info', f'Вариант удалён')

    def generate_variants(self):
        gen_var_window = customtkinter.CTkToplevel(self)
        gen_var_window.title("Generate variants")
        gen_var_window.geometry('700x400')
        gen_var_window.focus()

        def get_templates():
            records = templates_table.get_children()
            for element in records:
                templates_table.delete(element)
            query = 'SELECT * FROM template ORDER BY template_id DESC'
            db_rows = self.run_query(query)
            for row in db_rows:
                templates_table.insert('', 0, values=row)

        def call_generate_variants(selected, number_of_variants):
            if len(selected) == 0:
                messagebox.showinfo('Info', f'Выберите шаблон')
                gen_var_window.focus()
            elif number_of_variants == 0:
                messagebox.showinfo('Info', f'Число вариантов должно быть больше 0')
                gen_var_window.focus()
            else:
                template_id = templates_table.item(selected)["values"][0]
                message = ''
                exc = ''
                with config.conn as conn:
                    cursor = conn.cursor()
                    try:
                        cursor.execute('CALL pr_generate_variants (%s, %s)', [template_id, number_of_variants])
                        for notice in conn.notices:
                            notice2 = notice[notice.find(":") + 1:]
                            message += notice2
                        messagebox.showinfo('Info', f'{message}')
                        del conn.notices[:]
                    except Exception as error:
                        messagebox.showinfo('Info', f'{error}')
                    conn.commit()
                    gen_var_window.destroy()
                self.Combo1.set(f'{template_id}')
                self.Combo2.set('Произвольная')
                self.select_variants()

        gen_var_window.grid_columnconfigure(0, weight=1)
        gen_var_window.grid_columnconfigure(1, weight=4)
        gen_var_window.grid_rowconfigure(0, weight=1)
        gen_var_window.grid_rowconfigure(1, weight=1)
        gen_var_window.grid_rowconfigure(2, weight=100)

        l1 = customtkinter.CTkLabel(gen_var_window, text="Выберите шаблон:")
        l2 = customtkinter.CTkLabel(gen_var_window, text="Число вариантов:")
        l2.grid(row=0, column=0, padx=20, pady=20, sticky=NSEW)
        vcmd = (self.register(self.validate),
                '%d', '%i', '%P', '%s', '%S', '%v', '%V', '%W')
        entry1 = customtkinter.CTkEntry(gen_var_window, width=100, validate='all', validatecommand=vcmd)
        entry1.grid(row=0, column=1, padx=20, pady=20, sticky=NSEW)

        l1.grid(row=1, column=0, padx=20, sticky=NSEW)

        table_frame = customtkinter.CTkFrame(gen_var_window)
        table_frame.grid(row=2, columnspan=2, column=0, padx=20, sticky=NSEW)
        templates_table = ttk.Treeview(table_frame,
                                       column=('template_id', 'template_text', 'template_query', 'level'),
                                       show='headings')
        vertical_scrollbar = Scrollbar(table_frame, orient='vertical')
        vertical_scrollbar.pack(side=RIGHT, fill=Y)
        vertical_scrollbar.config(command=templates_table.yview)

        templates_table.config( yscrollcommand=vertical_scrollbar.set)

        templates_table.column("template_id", width=30, anchor=CENTER)
        templates_table.column("template_text", width=300, anchor=CENTER)
        templates_table.column("template_query", width=300, anchor=CENTER)
        templates_table.column("level", width=30, anchor=CENTER)

        templates_table.heading('template_id', text='ID шаблона', anchor=CENTER)
        templates_table.heading('template_text', text='Шаблон текста', anchor=CENTER)
        templates_table.heading('template_query', text='Шаблон запроса', anchor=CENTER)
        templates_table.heading('level', text='Уровень сложности', anchor=CENTER)

        templates_table.pack(fill=tk.BOTH, expand=True)
        get_templates()
        btn_gpd = customtkinter.CTkButton(
            gen_var_window,
            text='Сгенерировать',
            command=lambda: call_generate_variants(templates_table.selection(),
                                                   int(entry1.get()))
        )
        btn_gpd.grid(row=3, column=1, pady=20, sticky=W)
        gen_var_window.bind('<Return>',
                                    lambda x:  call_generate_variants(templates_table.selection(),
                                                   int(entry1.get())))

    def select_variants(self, event=None):
        records = self.variants_table.get_children()
        for element in records:
            self.variants_table.delete(element)
        if(self.Combo1.get() != 'Произвольный'):
            cursor = config.conn.cursor()
            try:
                cursor.execute(f'SELECT level FROM template WHERE template_id = {self.Combo1.get()}')
                self.Combo2.set(str(cursor.fetchone()[0]))
            except:
                pass
        query = ''
        if self.Combo1.get() == 'Произвольный' and self.Combo2.get() == 'Произвольная':
            query = f'SELECT * FROM variant ORDER BY variant_id DESC'
        elif self.Combo1.get() == 'Произвольный':
            query = f'SELECT * FROM variant WHERE template_id in (SELECT template_id FROM template ' \
                    f'WHERE level={self.Combo2.get()}) ORDER BY variant_id DESC'
        elif self.Combo2.get() == 'Произвольная':
            query = f'SELECT * FROM variant WHERE template_id={self.Combo1.get()} ORDER BY variant_id DESC'
        else:
            query = f'SELECT * FROM variant WHERE template_id={self.Combo1.get()} AND template_id in ' \
                    f'(SELECT template_id FROM template ' \
                    f'WHERE level={self.Combo2.get()}) ORDER BY variant_id DESC'
        db_rows = self.run_query(query)
        for row in db_rows:
            string_data = [str(data) for data in row]
            self.variants_table.insert('', 0, values=string_data)

    def load_to_txt(self):
        f = asksaveasfilename(defaultextension=".txt",
                      initialfile='Untitled.txt', filetypes=[("All Files", "*.*"), ("Text Documents", "*.txt")])
        try:
            with open(f, "w", newline='') as myfile:
                temp_ids = []
                if self.Combo1.get() == 'Произвольный':
                    for child in self.variants_table.get_children():
                        temp_ids.append(self.variants_table.item(child, "values")[1])
                    temp_ids = sorted(pd.Series(temp_ids).unique())
                    counter = 0
                    for i in temp_ids:
                        counter+=1;
                        try:
                            cursor = config.conn.cursor()
                            try:
                                cursor.execute(
                                    f'SELECT template_text, level FROM template WHERE template_id = {i}')
                                result = cursor.fetchone()
                                myfile.write(f'\nЗадание № {counter} (Сложность {result[1]})\n')
                                myfile.write(f'{result[0]}\n\n')
                            except:
                                cursor.execute(
                                    f'SELECT template_text FROM template WHERE template_id = {i}')
                                result = cursor.fetchone()
                                myfile.write(f'\nЗадание № {counter}\n')
                                myfile.write(f'{result[0]}\n\n')
                            cursor.execute(
                                f'SELECT parameters, result FROM variant WHERE template_id = {i}')
                            result = cursor.fetchall()
                            myfile.write('PARAMETERS={')
                            for row_i in result:
                                myfile.write(f'{row_i[0]}')
                            myfile.write('}\n\nRESULT={')
                            for row_i in result:
                                myfile.write(f'{row_i[1]}')
                            myfile.write('}\n')
                        except:
                            pass
                    messagebox.showinfo('Info', f'Варианты выгружены')
                else:
                    cursor = config.conn.cursor()
                    try:
                        try:
                            cursor.execute(
                                f'SELECT template_text, level FROM template WHERE template_id = {self.Combo1.get()}')
                            result = cursor.fetchone()
                            myfile.write(f'\nЗадание № 1 (Сложность {result[1]})\n')
                            myfile.write(f'{result[0]}\n\n')
                        except:
                            cursor.execute(
                                f'SELECT template_text FROM template WHERE template_id = {self.Combo1.get()}')
                            result = cursor.fetchone()
                            myfile.write(f'\nЗадание № 1 \n')
                            myfile.write(f'{result[0]}\n\n')
                        myfile.write('PARAMETERS={')
                        for row_id in self.variants_table.get_children()[:-1]:
                            myfile.write(self.variants_table.item(row_id)['values'][2])
                            myfile.write(', ')
                        myfile.write(self.variants_table.item(self.variants_table.get_children()[-1])['values'][2])

                        myfile.write('}\n\nRESULT={')
                        for row_id in self.variants_table.get_children()[:-1]:
                            myfile.write(self.variants_table.item(row_id)['values'][4])
                            myfile.write(', ')
                        myfile.write(self.variants_table.item(self.variants_table.get_children()[-1])['values'][4])
                        myfile.write('}\n')
                    except:
                        pass
                    messagebox.showinfo('Info', f'Варианты выгружены')
        except:
            pass

    def validate(self, action, index, value_if_allowed,
                 prior_value, text, validation_type, trigger_type, widget_name):
        if text in '0123456789':
            try:
                int(value_if_allowed)
                return True
            except ValueError:
                return False
        else:
            return False