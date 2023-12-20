import tkinter as tk
import customtkinter
from tkinter import *
from tkinter import ttk
import psycopg2
from tkinter import messagebox
import atexit
import os
from psycopg2 import OperationalError, errorcodes, errors
from temp_page import TemplateFrame
from param_page import ParamFrame
from var_page import VarFrame
from welcome_page import WelcomePage
from db_connect_page import DbFrame
from info_page import InfoFrame
import config

class App(customtkinter.CTk):
    def __init__(self):
        super().__init__()
        welcome_window = WelcomePage(self)
        self.title("Generate variants")
        self.geometry("950x450")
        self.grid_rowconfigure(0, weight=1)
        self.grid_columnconfigure(1, weight=1)
        self.navigation_frame = customtkinter.CTkFrame(self, corner_radius=0)
        self.navigation_frame.grid(row=0, column=0, sticky="nsew")
        self.navigation_frame.grid_rowconfigure(5, weight=1)
        style_value = ttk.Style()
        style_value.configure("Treeview", rowheight=30, font=("Roboto", 15))
        style_value.configure("Treeview.Heading", font=("Roboto", 15))

        # Добавление боковой навигации
        self.navigation_frame_label = customtkinter.CTkLabel(self.navigation_frame, text=" ",
                                                             compound="left", font=customtkinter.CTkFont(size=15, weight="bold"))
        self.navigation_frame_label.grid(row=0, column=0, padx=20, pady=20)

        self.par_button = customtkinter.CTkButton(self.navigation_frame, corner_radius=0, height=40, border_spacing=10, text="Параметры",
                                                   fg_color="transparent", text_color=("gray10", "gray90"), hover_color=("gray70", "gray30"),
                                                    anchor="w", command=self.par_button_event)
        self.par_button.grid(row=2, column=0, sticky="ew")

        self.templ_button = customtkinter.CTkButton(self.navigation_frame, corner_radius=0, height=40, border_spacing=10, text="Шаблоны",
                                                      fg_color="transparent", text_color=("gray10", "gray90"), hover_color=("gray70", "gray30"),
                                                       anchor="w", command=self.templ_button_event)
        self.templ_button.grid(row=3, column=0, sticky="ew")

        self.variant_button = customtkinter.CTkButton(self.navigation_frame, corner_radius=0, height=40, border_spacing=10, text="Варианты",
                                                      fg_color="transparent", text_color=("gray10", "gray90"), hover_color=("gray70", "gray30"),
                                                       anchor="w", command=self.variant_button_event)
        self.variant_button.grid(row=4, column=0, sticky="ew")

        self.db_connect_button = customtkinter.CTkButton(self.navigation_frame, corner_radius=0, height=40,
                                                      border_spacing=10, text="Подключение к базе",
                                                      fg_color="transparent", text_color=("gray10", "gray90"),
                                                      hover_color=("gray70", "gray30"),
                                                      anchor="w", command=self.db_conn_button_event)
        self.db_connect_button.grid(row=1, column=0, sticky="ew")
        self.info_button = customtkinter.CTkButton(self.navigation_frame, corner_radius=0, height=40,
                                                      border_spacing=10, text="Помощь",
                                                      fg_color="transparent", text_color=("gray10", "gray90"),
                                                      hover_color=("gray70", "gray30"),
                                                      anchor="w", command=self.info_button_event)
        self.info_button.grid(row=5, column=0, sticky="ew")

        # Добавление содержимого страниц Подключение к базе и Помощь
        self.forth_frame = customtkinter.CTkFrame(self, corner_radius=0, fg_color="transparent")
        self.forth_frame.grid_columnconfigure(0, weight=1)
        self.forth_frame.grid_rowconfigure(2, weight=100)
        self.db_connect_frame = DbFrame(master=self.forth_frame, width=700)
        self.db_connect_frame.grid(row=2, column=0, padx=20, pady=20, sticky=NSEW)

        self.info_frame = customtkinter.CTkFrame(self, corner_radius=0, fg_color="transparent")
        self.info_frame.grid_columnconfigure(0, weight=1)
        self.info_frame.grid_rowconfigure(2, weight=100)
        self.inf_frame = InfoFrame(master=self.info_frame, width=700)
        self.inf_frame.grid(row=2, column=0, padx=20, pady=20, sticky=NSEW)
        self.no_conn_frame = customtkinter.CTkFrame(self, corner_radius=0, fg_color="transparent")

        self.l1 = customtkinter.CTkLabel(self.no_conn_frame, text="Нет подключения к базе данных")
        self.l1.pack(pady=20)

        # select default frame
        self.select_frame_by_name("db_conn")

    def select_frame_by_name(self, name):
        # set button color for selected button
        self.par_button.configure(fg_color=("gray75", "gray25") if name == "param" else "transparent")
        self.templ_button.configure(fg_color=("gray75", "gray25") if name == "templ" else "transparent")
        self.variant_button.configure(fg_color=("gray75", "gray25") if name == "variant" else "transparent")
        self.db_connect_button.configure(fg_color=("gray75", "gray25") if name == "db_conn" else "transparent")
        self.info_button.configure(fg_color=("gray75", "gray25") if name == "info" else "transparent")
        # show selected frame
        if config.connected:
            self.no_conn_frame.grid_forget()
            if name == "param":
                cur = config.conn.cursor()
                cur.execute("select exists(select * from information_schema.tables where table_name=%s)", ('parameter',))
                self.home_frame = customtkinter.CTkFrame(self, corner_radius=0, fg_color="transparent")
                self.home_frame.grid_columnconfigure(0, weight=1)
                self.home_frame.grid_rowconfigure(2, weight=100)
                if not cur.fetchone()[0]:
                    self.l1 = customtkinter.CTkLabel(self.home_frame, text="Пожалуйста, добавьте в базу данных таблицу параметров.\n"
                                                                "Параметры указывают программе, какие значения подставлять в шаблоны.")
                    self.start_btn = customtkinter.CTkButton(self.home_frame, text='Добавить таблицу',
                                                             command=lambda: self.create_table('parameter'))
                    self.l1.grid(row=0, column=0, pady=20)
                    self.start_btn.grid(row=1, column=0, pady=20)
                    self.home_frame.grid(row=0, column=1, sticky="nsew")
                else:
                    self.param_frame = ParamFrame(master=self.home_frame, width=700, height=1200)
                    self.param_frame.grid(row=2, column=0, padx=20, pady=20, sticky=NSEW)
                    self.home_frame.grid(row=0, column=1, sticky="nsew")
            else:
                try:
                    self.home_frame.grid_forget()
                except:
                    pass
            if name == "templ":
                cur = config.conn.cursor()
                cur.execute("select exists(select * from information_schema.tables where table_name=%s)", ('template',))
                self.second_frame = customtkinter.CTkFrame(self, corner_radius=0, fg_color="transparent")
                self.second_frame.grid_columnconfigure(0, weight=1)
                self.second_frame.grid_rowconfigure(2, weight=100)
                if not cur.fetchone()[0]:
                    self.l1 = customtkinter.CTkLabel(self.second_frame, text="Пожалуйста, добавьте в базу данных таблицу шаблонов.\n"
                                                                "По шаблонам из этой таблицы будут генерироваться варианты.")
                    self.start_btn = customtkinter.CTkButton(self.second_frame, text='Добавить таблицу',
                                                             command=lambda: self.create_table('template'))
                    self.l1.grid(row=0, column=0, pady=20)
                    self.start_btn.grid(row=1, column=0, pady=20)
                    self.second_frame.grid(row=0, column=1, sticky="nsew")
                else:
                    self.temp_frame = TemplateFrame(master=self.second_frame, width=700)
                    self.temp_frame.grid(row=2, column=0, padx=20, pady=20, sticky=NSEW)
                    self.second_frame.grid(row=0, column=1, sticky="nsew")
            else:
                try:
                    self.second_frame.grid_forget()
                except:
                    pass
            if name == "variant":
                cur = config.conn.cursor()
                cur.execute("select exists(select * from information_schema.tables where table_name=%s)",
                            ('template',))
                if not cur.fetchone()[0]:
                    self.third_frame = customtkinter.CTkFrame(self, corner_radius=0, fg_color="transparent")
                    self.third_frame.grid_columnconfigure(0, weight=1)
                    self.third_frame.grid_rowconfigure(2, weight=100)
                    self.l1 = customtkinter.CTkLabel(self.third_frame,
                                                    text="Пожалуйста, сначала добавьте в базу данных таблицу шаблонов.\n"
                                                         "Затем добавьте таблицу вариантов.")
                    self.l1.grid(row=0, column=0, pady=20)
                    self.third_frame.grid(row=0, column=1, sticky="nsew")
                else:
                    #cur = config.conn.cursor()
                    cur.execute("select exists(select * from information_schema.tables where table_name=%s)",
                                ('variant',))
                    self.third_frame = customtkinter.CTkFrame(self, corner_radius=0, fg_color="transparent")
                    self.third_frame.grid_columnconfigure(0, weight=1)
                    self.third_frame.grid_rowconfigure(2, weight=100)
                    if not cur.fetchone()[0]:
                        self.l1 = customtkinter.CTkLabel(self.third_frame, text="Пожалуйста, добавьте в базу данных таблицу вариантов.\n"
                                                                    "Она будет хранить сгенерированные варианты.")
                        self.start_btn = customtkinter.CTkButton(self.third_frame, text='Добавить таблицу',
                                                                 command=lambda: self.create_table('variant'))
                        self.l1.grid(row=0, column=0, pady=20)
                        self.start_btn.grid(row=1, column=0, pady=20)
                        self.third_frame.grid(row=0, column=1, sticky="nsew")
                    else:
                        self.var_frame = VarFrame(master=self.third_frame, width=700)
                        self.var_frame.grid(row=2, column=0, padx=20, pady=20, sticky=NSEW)
                        self.third_frame.grid(row=0, column=1, sticky="nsew")
            else :
                try:
                    self.third_frame.grid_forget()
                except:
                    pass
        else:
            self.no_conn_frame.grid(row=0, column=1, sticky="nsew")

        if name == "db_conn":
            self.no_conn_frame.grid_forget()
            self.forth_frame.grid(row=0, column=1, sticky="nsew")
        else:
            self.forth_frame.grid_forget()

        if name == "info":
            self.no_conn_frame.grid_forget()
            self.info_frame.grid(row=0, column=1, sticky="nsew")
        else:
            self.info_frame.grid_forget()

    def create_table(self, table_name):
        cursor = config.conn.cursor()
        if table_name == 'template':
            cursor.execute('CREATE TABLE template (template_id int, template_text varchar(1000), template_query varchar(1000), level int)')
            cursor.execute('ALTER TABLE template ADD CONSTRAINT template_id_pk PRIMARY KEY (template_id)')
            cursor.execute('CREATE SEQUENCE template_seq START WITH 1 INCREMENT BY 1')
            self.l1.grid_remove()
            self.start_btn.grid_remove()
            self.temp_frame = TemplateFrame(master=self.second_frame, width=700)
            self.temp_frame.grid(row=2, column=0, padx=20, pady=20, sticky=NSEW)
            self.second_frame.grid(row=0, column=1, sticky="nsew")
        if table_name == 'parameter':
            cursor.execute('CREATE TABLE parameter(parameter_id int, parameter_name varchar(300) NOT NULL UNIQUE, parameter_query varchar(1000))')
            cursor.execute('ALTER TABLE parameter ADD CONSTRAINT parameter_id_pk PRIMARY KEY (parameter_id)')
            cursor.execute('CREATE SEQUENCE parameter_seq START WITH 1 INCREMENT BY 1')
            self.l1.grid_remove()
            self.start_btn.grid_remove()
            self.param_frame = ParamFrame(master=self.home_frame, width=700, height=1200)
            self.param_frame.grid(row=2, column=0, padx=20, pady=20, sticky=NSEW)
            self.home_frame.grid(row=0, column=1, sticky="nsew")
        if table_name == 'variant':
            cursor.execute('CREATE TABLE variant(variant_id int, template_id int NOT NULL, parameters varchar(300)[], variant_text varchar(1000), result varchar(300)[])')
            cursor.execute('ALTER TABLE variant ADD CONSTRAINT variant_id_pk PRIMARY KEY (variant_id)')
            cursor.execute('ALTER TABLE variant ADD FOREIGN KEY (template_id) REFERENCES template')
            cursor.execute('CREATE SEQUENCE variant_seq START WITH 1 INCREMENT BY 1')
            self.l1.grid_remove()
            self.start_btn.grid_remove()
            self.var_frame = VarFrame(master=self.third_frame, width=700)
            self.var_frame.grid(row=2, column=0, padx=20, pady=20, sticky=NSEW)
            self.third_frame.grid(row=0, column=1, sticky="nsew")
        config.conn.commit()

    def par_button_event(self):
        self.select_frame_by_name("param")

    def templ_button_event(self):
        self.select_frame_by_name("templ")

    def variant_button_event(self):
        self.select_frame_by_name("variant")

    def db_conn_button_event(self):
        self.select_frame_by_name("db_conn")

    def info_button_event(self):
        self.select_frame_by_name("info")


if __name__ == "__main__":
    app = App()
    app.mainloop()
