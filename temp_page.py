import tkinter as tk
import customtkinter
from tkinter import *
import psycopg2
from tkinter import messagebox
from psycopg2 import OperationalError, errorcodes, errors
import config
import Pmw

# Форма Шаблоны
class TemplateFrame(customtkinter.CTkFrame):
    def __init__(self, master, **kwargs):
        super().__init__(master, **kwargs)
        self.button_frame = customtkinter.CTkFrame(self, corner_radius=0, fg_color="transparent")
        self.ins_temp_btn = customtkinter.CTkButton(self.button_frame, text='Добавить шаблон',
                                                    command=lambda: self.insert_template())
        self.ins_temp_btn.grid(row=0, column=0, padx=20, pady=20, sticky=NSEW)
        self.upd_temp_btn = customtkinter.CTkButton(self.button_frame, text='Изменить шаблон',
                                                    command=lambda: self.update_template())
        self.upd_temp_btn.grid(row=0, column=1, padx=20, pady=20, sticky=NSEW)
        self.del_temp_btn = customtkinter.CTkButton(self.button_frame, text='Удалить шаблон',
                                                    command=lambda:self.delete_template())
        self.del_temp_btn.grid(row=0, column=2, padx=20, pady=20, sticky=NSEW)
        self.button_frame.pack()

        self.templates_table = ttk.Treeview(self, column=('template_id', 'template_text', 'template_query', 'level'),
                                       show='headings')
        self.vertical_scrollbar = Scrollbar(self, orient='vertical')
        self.vertical_scrollbar.pack(side=RIGHT, fill=Y)
        self.vertical_scrollbar.config(command=self.templates_table.yview)

        self.templates_table.config(yscrollcommand=self.vertical_scrollbar.set)

        self.templates_table.column("template_id", width=30, anchor=CENTER)
        self.templates_table.column("template_text", width=100, anchor=CENTER)
        self.templates_table.column("template_query", width=100, anchor=CENTER)
        self.templates_table.column("level", width=30, anchor=CENTER)

        self.templates_table.heading('template_id', text='ID шаблона', anchor=CENTER)
        self.templates_table.heading('template_text', text='Шаблон текста', anchor=CENTER)
        self.templates_table.heading('template_query', text='Шаблон запроса', anchor=CENTER)
        self.templates_table.heading('level', text='Уровень сложности', anchor=CENTER)
        self.templates_table.pack(fill=tk.BOTH, expand=True)
        self.templates_table.bind("<Button-3>", self.sel_off)
        self.get_templates()

    def delete_template(self):
        selected_item = self.templates_table.selection()
        print(selected_item)
        if len(selected_item) == 0:
            messagebox.showinfo('Info', f'Выберите шаблон')
        else:
            query = 'DELETE FROM template WHERE template_id = ' + str(
                self.templates_table.item(selected_item)["values"][0])
            db_rows = self.run_query(query)
            self.get_templates()
            messagebox.showinfo('Info', f'Шаблон удалён')

    def insert_template(self):
        insert_template_window = customtkinter.CTkToplevel(self)
        insert_template_window.geometry('700x400')
        insert_template_window.title("Insert template")
        insert_template_window.focus()
        l1 = customtkinter.CTkLabel(insert_template_window, text="Шаблон тeкста:")
        l2 = customtkinter.CTkLabel(insert_template_window, text="Шаблон SQL-запроса:")
        l3 = customtkinter.CTkLabel(insert_template_window, text="Сложность:")
        l1.pack(anchor=NW, padx=10, pady=10)
        entry1 = customtkinter.CTkEntry(insert_template_window, width=800)
        entry1.pack(anchor=NW, padx=10, pady=10)
        l2.pack(anchor=NW, padx=10, pady=10)
        entry2 = customtkinter.CTkEntry(insert_template_window, width=800)
        entry2.pack(anchor=NW, padx=10, pady=10)
        l3.pack(anchor=NW, padx=10, pady=10)

        def slider_event(value):
            l4.configure(text=str(value))

        l4 = customtkinter.CTkLabel(insert_template_window, text='5.0')
        l4.pack(anchor=NW, padx=10, pady=10)
        slider = customtkinter.CTkSlider(insert_template_window, from_=1, to=10, number_of_steps=9,
                                         command=slider_event)
        slider.pack(anchor=NW, padx=10, pady=10)

        balloon = Pmw.Balloon(insert_template_window)
        lbl = balloon.component("label")
        lbl.config(background="grey13", foreground='white', font=("Roboto", 15))
        balloon.bind(entry1,
                     "На месте изменяемого значения укажите параметр.\n Например, Выведите информацию из таблицы t, где PT_FIRST_PARAM = 0")
        balloon.bind(entry2,
                     "На месте изменяемого значения укажите параметр.\n Например, SELECT * FROM t WHERE PT_FIRST_PARAM = 0")

        def insert(template_text, template_query, level):
            query = "INSERT INTO template VALUES (nextval('template_seq'), '" + template_text + "', '" \
                    + template_query + "', " + level + ")"
            db_rows = self.run_query(query)
            self.get_templates()
            insert_template_window.destroy()
            messagebox.showinfo('Info', f'Шаблон добавлен')

        btn_upd = customtkinter.CTkButton(
            insert_template_window,
            text='Добавить',
            command=lambda: insert(str(entry1.get()), str(entry2.get()), str(slider.get()))
        )
        btn_upd.pack(side=tk.BOTTOM, pady=20)
        insert_template_window.bind('<Return>', lambda x: insert(str(entry1.get()), str(entry2.get()), str(slider.get())))

    def update_template(self):
        selected_item = self.templates_table.selection()
        if len(selected_item) == 0:
            messagebox.showinfo('Info', f'Выберите шаблон')
        else:
            update_template_window = customtkinter.CTkToplevel(self)
            update_template_window.title("Update template")

            update_template_window.geometry('700x400')

            l1 = customtkinter.CTkLabel(update_template_window, text="Шаблон текста:")
            l2 = customtkinter.CTkLabel(update_template_window, text="Шаблон SQL-запроса:")
            l3 = customtkinter.CTkLabel(update_template_window, text="Уровень сложности:")
            l1.pack(anchor=NW, padx=10, pady=10)
            entry1 = customtkinter.CTkEntry(update_template_window, width=800)
            entry1.pack(anchor=NW, padx=10, pady=10)
            entry1.insert(0, self.templates_table.item(selected_item)["values"][1])
            l2.pack(anchor=NW, padx=10, pady=10)
            entry2 = customtkinter.CTkEntry(update_template_window, width=800)
            entry2.pack(anchor=NW, padx=10, pady=10)
            entry2.insert(0, self.templates_table.item(selected_item)["values"][2])
            l3.pack(anchor=NW, padx=10, pady=10)

            def slider_event(value):
                l4.configure(text=str(value))

            slider = customtkinter.CTkSlider(update_template_window, from_=1, to=10, number_of_steps=9,
                                             command=slider_event)
            slider.set(float(self.templates_table.item(selected_item)["values"][3]))
            l4 = customtkinter.CTkLabel(update_template_window,
                                        text=str(float(self.templates_table.item(selected_item)["values"][3])))
            l4.pack(anchor=NW, padx=10, pady=10)
            slider.pack(anchor=NW, padx=10, pady=10)

            def update(template_text, template_query, level, template_id):
                query = "UPDATE template SET template_text = '" + f"{template_text}" + "', template_query = " + \
                        "'{}'".format(template_query) + ", level = " + level + " WHERE template_id = " + template_id
                db_rows = self.run_query(query)
                self.get_templates()
                update_template_window.destroy()
                messagebox.showinfo('Info', f'Шаблон изменён')

            btn_upd = customtkinter.CTkButton(
                update_template_window,
                text='Изменить',
                command=lambda: update(str(entry1.get()), str(entry2.get()), str(slider.get()),
                                       str(self.templates_table.item(selected_item)["values"][0]))
            )
            btn_upd.pack(side=tk.BOTTOM, pady=20)
            update_template_window.bind('<Return>',
                                        lambda x: update(str(entry1.get()), str(entry2.get()), str(slider.get()),
                                       str(self.templates_table.item(selected_item)["values"][0])))

    def run_query(self, query):
        with config.conn as conn:
            cursor = conn.cursor()
            print(query)
            cursor.execute(query)
            try:
                result = cursor.fetchall()
            except:
                result = ''
            print(result)
            conn.commit()
        return result

    def get_templates(self):
        records = self.templates_table.get_children()
        for element in records:
            self.templates_table.delete(element)
        query = 'SELECT * FROM template ORDER BY template_id DESC'
        db_rows = self.run_query(query)
        for row in db_rows:
            self.templates_table.insert('', 0, values=row)
    def sel_off(self, event):
        iid = self.templates_table.identify_row(event.y)
        if iid:
            self.templates_table.selection_remove(iid)
        else:
            pass