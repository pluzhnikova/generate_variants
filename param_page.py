import tkinter as tk
import customtkinter
from tkinter import *
from tkinter import messagebox
import psycopg2
from psycopg2 import OperationalError, errorcodes, errors
import config
import Pmw

# Форма Параметры
class ParamFrame(customtkinter.CTkFrame):
    def __init__(self, master, **kwargs):
        super().__init__(master, **kwargs)

        self.button_frame = customtkinter.CTkFrame(self, corner_radius=0, fg_color="transparent")
        self.ins_par_btn = customtkinter.CTkButton(self.button_frame, text='Добавить параметр',
                                                   command=lambda: self.insert_parameter())
        self.ins_par_btn.grid(row=0, column=0, padx=20, pady=20, sticky=NSEW)
        self.upd_par_btn = customtkinter.CTkButton(self.button_frame, text='Изменить параметр',
                                                   command=lambda: self.update_parameter())
        self.upd_par_btn.grid(row=0, column=1, padx=20, pady=20, sticky=NSEW)
        self.del_par_btn = customtkinter.CTkButton(self.button_frame, text='Удалить параметр',
                                                   command=lambda: self.delete_parameter())
        self.del_par_btn.grid(row=0, column=2, padx=20, pady=20, sticky=NSEW)
        self.button_frame.pack()
        self.params_table = ttk.Treeview(self, column=('parameter_id', 'parameter_name', 'parameter_query'),
                                                                      show='headings')
        self.vertical_scrollbar = Scrollbar(self, orient='vertical')
        self.vertical_scrollbar.pack(side=RIGHT, fill=Y)
        self.vertical_scrollbar.config(command=self.params_table.yview)

        self.params_table.config(yscrollcommand=self.vertical_scrollbar.set)
        self.params_table.column("parameter_id", width=5, anchor=CENTER)
        self.params_table.column("parameter_name", width=10, anchor=CENTER)
        self.params_table.column("parameter_query", width=100, anchor=CENTER)

        self.params_table.heading('parameter_id', text='ID параметра', anchor=CENTER)
        self.params_table.heading('parameter_name', text='Имя параметра', anchor=CENTER)
        self.params_table.heading('parameter_query', text='Запрос по параметру', anchor=CENTER)
        self.params_table.pack(fill=tk.BOTH, expand=True)
        self.params_table.bind("<Button-3>", self.sel_off)
        self.get_params()

    def update_parameter(self):
        selected_item = self.params_table.selection()
        if len(selected_item) == 0:
            messagebox.showinfo('Info', f'Выберите параметр')
        else:
            update_parameter_window = customtkinter.CTkToplevel(self)
            update_parameter_window.title("Update parameter")
            update_parameter_window.geometry('700x300')

            l1 = customtkinter.CTkLabel(update_parameter_window, text="Имя параметра:")
            l2 = customtkinter.CTkLabel(update_parameter_window, text="Запрос по параметру:")
            l1.pack(anchor=NW, padx=10, pady=10)
            entry1 = customtkinter.CTkEntry(update_parameter_window, width=800)
            entry1.pack(anchor=NW, padx=10, pady=10)
            entry1.insert(0, self.params_table.item(selected_item)["values"][1])
            l2.pack(anchor=NW, padx=10, pady=10)
            entry2 = customtkinter.CTkEntry(update_parameter_window, width=800)
            entry2.pack(anchor=NW, padx=10, pady=10)
            entry2.insert(0, self.params_table.item(selected_item)["values"][2])

            def update(parameter_name, parameter_query, parameter_id, selected_name):
                try:
                    for child in self.params_table.get_children():
                        if parameter_name in self.params_table.item(child)['values'] \
                                and parameter_name!=selected_name:
                            raise
                    try:
                        with config.conn as conn:
                            with conn.cursor() as cursor:
                                cursor.execute(parameter_query)
                                result = cursor.fetchall()
                                colnames = [desc[0] for desc in cursor.description]
                        if len(result) == 1 and len(colnames) == 1:
                                try:
                                    query = "UPDATE parameter SET parameter_name = '" + parameter_name + "', parameter_query = '" + parameter_query + "' WHERE parameter_id = " + parameter_id
                                    db_rows = self.run_query(query)
                                    self.get_params()
                                    update_parameter_window.destroy()
                                    messagebox.showinfo('Info', f'Параметер изменён')
                                except:
                                    parameter_query = parameter_query.replace("'", "''")
                                    query = "UPDATE parameter SET parameter_name = '" + parameter_name + "', parameter_query = '" + parameter_query + "' WHERE parameter_id = " + parameter_id
                                    db_rows = self.run_query(query)
                                    self.get_params()
                                    update_parameter_window.destroy()
                                    messagebox.showinfo('Info', f'Параметер изменён')
                        else:
                            messagebox.showinfo('Info', f'Запрос должен возвращать одно значение')
                            update_parameter_window.focus()
                    except:
                        messagebox.showinfo('Info', f'Запрос должен возвращать одно значение')
                        update_parameter_window.focus()
                except:
                    messagebox.showinfo('Info',
                                f'Пожалуйста, проверьте имя параметра. Оно должно быть уникальным.')
                    update_parameter_window.focus()

            btn_upd = customtkinter.CTkButton(
                update_parameter_window,
                text='Сохранить измененения',
                command=lambda: update(str(entry1.get()), str(entry2.get()),
                                       str(self.params_table.item(selected_item)["values"][0]),
                                       str(self.params_table.item(selected_item)["values"][1]))
            )
            btn_upd.pack(side=tk.BOTTOM, pady=20)
            update_parameter_window.bind('<Return>', lambda x: update(str(entry1.get()), str(entry2.get()),
                                       str(self.params_table.item(selected_item)["values"][0]),
                                                                      str(self.params_table.item(selected_item)["values"][1])))
    def delete_parameter(self):
        selected_item = self.params_table.selection()
        if len(selected_item) == 0:
            messagebox.showinfo('Info', f'Выберите параметр')
        else:
            query = 'DELETE FROM parameter WHERE parameter_id = ' + str(
                self.params_table.item(selected_item)["values"][0])
            db_rows = self.run_query(query)
            self.get_params()
            messagebox.showinfo('Info', f'Параметер удалён')

    def insert_parameter(self):
        insert_parameter_window = customtkinter.CTkToplevel(self)
        insert_parameter_window.geometry('700x300')
        insert_parameter_window.title("Insert parameter")
        insert_parameter_window.focus()
        l1 = customtkinter.CTkLabel(insert_parameter_window, text="Имя параметра:")
        l2 = customtkinter.CTkLabel(insert_parameter_window, text="Запрос по параметру:")
        l1.pack(anchor=NW, padx=10, pady=10)
        entry1 = customtkinter.CTkEntry(insert_parameter_window, width=200)
        entry1.insert(0, 'PT_')
        entry1.pack(anchor=NW, padx=10, pady=10)
        balloon = Pmw.Balloon(insert_parameter_window)
        balloon.bind(entry1, "Имя параметра должно быть уникальным и начинаться с PT_ .\n Например, PT_FIRST_PARAM ")
        lbl = balloon.component("label")
        lbl.config(background="grey13", foreground='white', font=("Roboto", 15))
        l2.pack(anchor=NW, padx=10, pady=10)
        entry2 = customtkinter.CTkEntry(insert_parameter_window, width=800)
        entry2.pack(anchor=NW, padx=10, pady=10)
        balloon.bind(entry2, "Запрос должен возвращать одно случайное значение.\n"
                             "Параметр будет заменяться этим значением при генерации\n")

        def insert(parameter_name, parameter_query):
            try:
                for child in self.params_table.get_children():
                    if parameter_name in self.params_table.item(child)['values']:
                        raise
                try:
                    with config.conn as conn:
                        with conn.cursor() as cursor:
                            cursor.execute(parameter_query)
                            result = cursor.fetchall()
                            colnames = [desc[0] for desc in cursor.description]
                    if len(result) == 1 and len(colnames) == 1:
                            try:
                                query = "INSERT INTO parameter VALUES (nextval('parameter_seq'), '" + parameter_name + "', '" \
                                        + parameter_query + "')"
                                db_rows = self.run_query(query)
                                self.get_params()
                                insert_parameter_window.destroy()
                                messagebox.showinfo('Info', f'Параметер {parameter_name} добавлен')
                            except:
                                parameter_query = parameter_query.replace("'","''")
                                query = "INSERT INTO parameter VALUES (nextval('parameter_seq'), '" + parameter_name + "', '" \
                                        + parameter_query + "')"
                                db_rows = self.run_query(query)
                                self.get_params()
                                insert_parameter_window.destroy()
                                messagebox.showinfo('Info', f'Параметер {parameter_name} добавлен')
                    else:
                        messagebox.showinfo('Info', f'Запрос должен возвращать одно значение')
                        insert_parameter_window.focus()
                except:
                    messagebox.showinfo('Info', f'Запрос должен возвращать одно значение')
                    insert_parameter_window.focus()
            except:
                messagebox.showinfo('Info',
                                    f'Пожалуйста, проверьте имя параметра. Оно должно быть уникальным.')
                insert_parameter_window.focus()

        btn_upd = customtkinter.CTkButton(
            insert_parameter_window,
            text='Добавить',
            command=lambda: insert(str(entry1.get()), str(entry2.get()))
        )
        btn_upd.pack(side=tk.BOTTOM, pady=20)
        insert_parameter_window.bind('<Return>', lambda x: insert(str(entry1.get()), str(entry2.get())))

    def run_query(self, query, parameters=()):
        with config.conn as conn:
            cursor = conn.cursor()
            print(query)
            print(cursor.execute(query, parameters))
            try:
                result = cursor.fetchall()
            except:
                result = ''
            print(result)
            conn.commit()
        return result

    def get_params(self):
        records = self.params_table.get_children()
        for element in records:
            self.params_table.delete(element)
        query = 'SELECT * FROM parameter ORDER BY parameter_id DESC'
        db_rows = self.run_query(query)
        for row in db_rows:
            self.params_table.insert('', 0, values=row)

    def sel_off(self, event):
        iid = self.params_table.identify_row(event.y)
        print(iid)
        if iid:
            self.params_table.selection_remove(iid)
        else:
            pass