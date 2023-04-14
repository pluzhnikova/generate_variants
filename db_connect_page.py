import customtkinter
from tkinter import *
import psycopg2
from psycopg2 import OperationalError, errorcodes, errors
import config

# Форма Подключение к базе
class DbFrame(customtkinter.CTkFrame):
    def __init__(self, master, **kwargs):
        super().__init__(master, **kwargs)
        self.button_frame = customtkinter.CTkFrame(self, corner_radius=0, fg_color="transparent")
        self.l1 = customtkinter.CTkLabel(self.button_frame, text="Database name")
        self.l2 = customtkinter.CTkLabel(self.button_frame, text="User")
        self.l3 = customtkinter.CTkLabel(self.button_frame, text="Password")
        self.l4 = customtkinter.CTkLabel(self.button_frame, text="Host")
        self.l5 = customtkinter.CTkLabel(self.button_frame, text='')

        self.l1.grid(row=0, column=0, padx=20, pady=20, sticky=E)
        self.l2.grid(row=1, column=0, padx=20, pady=20, sticky=E)
        self.l3.grid(row=2, column=0, padx=20, pady=20, sticky=E)
        self.l4.grid(row=3, column=0, padx=20, pady=20, sticky=E)
        self.l5.grid(row=5, column=1, padx=20, sticky=W)

        self.entry1 = customtkinter.CTkEntry(self.button_frame, width=200)
        self.entry2 = customtkinter.CTkEntry(self.button_frame, width=200)
        self.entry2.insert(0, 'postgres')
        self.entry3 = customtkinter.CTkEntry(self.button_frame, show="*", width=200)
        self.entry4 = customtkinter.CTkEntry(self.button_frame, width=200)
        self.entry4.insert(0, 'localhost')
        self.entry1.grid(row=0, column=1, padx=20, pady=20, sticky=E)
        self.entry2.grid(row=1, column=1, padx=20, pady=20, sticky=E)
        self.entry3.grid(row=2, column=1, padx=20, pady=20, sticky=E)
        self.entry4.grid(row=3, column=1, padx=20, pady=20, sticky=E)
        self.conn_btn = customtkinter.CTkButton(self.button_frame, text='Подключиться',
                                                    command=lambda: self.connection(str(self.entry1.get()),
                                                                               str(self.entry2.get()),
                                                                               str(self.entry3.get()),
                                                                               str(self.entry4.get())))
        self.conn_btn.grid(row=4, column=1, padx=20, pady=20, sticky=W)
        self.button_frame.pack()

    def connection(self, dbname, user, password, host):
        try:
            config.conn = psycopg2.connect(dbname=dbname, user=user,
                                           password=password, host=host)
            config.connected = True
            self.l5.configure(text='Подключено', text_color='green')
        except:
            config.connected = False
            self.l5.configure(text='Ошибка подключения', text_color='red')