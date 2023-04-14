import customtkinter
from tkinter import *

# Приветственное окно
class WelcomePage(customtkinter.CTkToplevel):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.title("Generate variants")
        self.geometry("750x450+450+100")
        self.wel_frame = customtkinter.CTkFrame(self, corner_radius=0, fg_color="transparent")
        self.l1 = customtkinter.CTkLabel(self.wel_frame, text="Добро пожаловать!", font=('Valiska',30))
        self.l2 = customtkinter.CTkLabel(self.wel_frame, text="Создайте варианты на основе любой базы данных!")
        self.l3 = customtkinter.CTkLabel(self.wel_frame, text="1", font=('Valiska', 15))
        self.l4 = customtkinter.CTkLabel(self.wel_frame, text="2", font=('Valiska', 15))
        self.l5 = customtkinter.CTkLabel(self.wel_frame, text="3", font=('Valiska', 15))
        self.l6 = customtkinter.CTkLabel(self.wel_frame, text="4", font=('Valiska', 15))
        self.l7 = customtkinter.CTkLabel(self.wel_frame, text="Подключайтесь\nк базе данных", font=('Valiska', 15))
        self.l8 = customtkinter.CTkLabel(self.wel_frame, text="Добавляйте\nпараметры", font=('Valiska', 15))
        self.l9 = customtkinter.CTkLabel(self.wel_frame, text="Добавляйте\nшаблоны", font=('Valiska', 15))
        self.l10 = customtkinter.CTkLabel(self.wel_frame, text="Генерируйте\nварианты!", font=('Valiska', 15))
        self.l11 = customtkinter.CTkLabel(self.wel_frame, text="Подробнее в разделе Помощь")
        self.l1.grid(row=0, column=0, columnspan=4, padx=20, pady=20, sticky=NSEW)
        self.l2.grid(row=1, column=0, columnspan=4, padx=20, pady=20, sticky=NSEW)
        self.l3.grid(row=2, column=0, padx=20, pady=20, sticky=NSEW)
        self.l4.grid(row=2, column=1, padx=20, pady=20, sticky=NSEW)
        self.l5.grid(row=2, column=2, padx=20, pady=20, sticky=NSEW)
        self.l6.grid(row=2, column=3, padx=20, pady=20, sticky=NSEW)
        self.l7.grid(row=3, column=0, padx=20, sticky=NSEW)
        self.l8.grid(row=3, column=1, padx=20, sticky=NSEW)
        self.l9.grid(row=3, column=2, padx=20, sticky=NSEW)
        self.l10.grid(row=3, column=3, padx=20, sticky=NSEW)
        self.l11.grid(row=4, column=0, columnspan=4, padx=20, pady=40, sticky=NSEW)
        self.wel_frame.pack()
        self.start_btn = customtkinter.CTkButton(self, text='Начать',
                                                   command=lambda: self.get_started())
        self.start_btn.pack(padx=20)
        self.bind('<Return>', lambda x: self.get_started())
        self.grab_set()
        self.wait_window(self)

    def get_started(self):
        self.destroy()