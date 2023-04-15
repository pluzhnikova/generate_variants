import customtkinter
from tkinter import *

# Форма Помощь
class InfoFrame(customtkinter.CTkFrame):
    def __init__(self, master, **kwargs):
        super().__init__(master, **kwargs)
        self.info_frame = customtkinter.CTkFrame(self, corner_radius=0, fg_color="transparent")
        tabview = customtkinter.CTkTabview(self, width=900)
        tabview.add("1")
        tabview.add("2")
        tabview.add("3")
        tabview.add("4")

        self.l1 = customtkinter.CTkLabel(self.info_frame, justify='left',anchor=W,text="Приложение позволяет генерировать любое количество заданий "
                                                    "по базам данных на основе \nзаранее заготовленных шаблонов. "
                                                    "Процесс генерации можно разбить на 4 этапа:")

        self.l2 = customtkinter.CTkLabel(tabview.tab("1"), justify='left',text="1. Подключение к базе данных.")
        self.l3 = customtkinter.CTkLabel(tabview.tab("1"), justify='left', text="Для начала нужно подключиться к базе, на основе которой будут создаваться задания.\n"
                                                                                "Она должна быть создана на основе СУБД PostgreSQL и \n"
                                                                                "содержать достаточно материала для генерации вариантов.\n\n"
                                                                                "Перейдите на страницу Подключение к базе и введите \nНазвание базы, "
                                                    "Имя пользователя (по умолчанию, postgres), Пароль и Хост(по умолчанию, localhost).\n"
                                                    "Если подключение прошло успешно, вы увидите отметку Подключено.\n"
                                                    "После подключения к БД станет доступен просмотр параметров, шаблонов, вариантов.")
        self.l4 = customtkinter.CTkLabel(tabview.tab("2"), justify='left',text="2. Добавление шаблонов")
        self.l5 = customtkinter.CTkLabel(tabview.tab("2"), justify='left',text="Перейдите на страницу Шаблоны. Шаблоны заданий хранятся\n"
                                                    "в отдельной таблице, поэтому если в базе ещё нет этой таблицы, будет "
                                                    "предложено её создать. \nЧтобы создать таблицу, нажмите кнопку Добавить таблицу шаблонов.\n"
                                                    "После создания будет показано её содержимое, а также опции: Добавить шаблон, Изменить шаблон,\n"
                                                    "Удалить шаблон.\n\n"
                                                    "Добавить шаблон: нажмите Добавить шаблон. В появившейся форме напишите шаблон текста и шаблон запроса \nс параметрами на месте изменяемых значений. Нажмите Добавить или Enter.\n\n"
                                                    "Изменить шаблон: ЛКМ выберите шаблон и нажмите Изменить шаблон. \n"
                                                     "В появившейся форме внесите изменения и нажмите Сохранить изменения или Enter\n\n"
                                                    "Удалить шаблон: ЛКМ выберите шаблон и нажмите Удалить шаблон. Шаблон удалится.\n")
        self.l6 = customtkinter.CTkLabel(tabview.tab("3"), justify='left',text="3. Добавление параметров.")
        self.l7 = customtkinter.CTkLabel(tabview.tab("3"), justify='left',text="Перейдите на страницу Параметры. Параметры хранятся в отдельной таблице, \n"
                                                    "поэтому если в базе ещё нет этой таблицы, будет предложено её создать. \n" 
                                                    "Чтобы создать таблицу, нажмите кнопку Добавить таблицу шаблонов.\n"
                                                    "После создания будет показано её содержимое, "
                                                    "а также опции: Добавить параметр, Изменить параметр,\nУдалить параметр.\n\n"
                                                    "Добавить параметер: нажмите Добавить параметер. В появившейся форме впишите имя параметра\n(должно начинаться с PT_) "
                                                    "и запрос, по которому программа будет искать \nзначения в базе (запрос должен возвращать одно значение).\nНажмите Добавить или Enter.\n\n"
                                                    "Изменить параметер:  ЛКМ выберите параметер и нажмите Изменить параметер. \n"
                                                    "В появившейся форме внесите изменения и нажмите Сохранить изменения или Enter \n\n"
                                                    "Удалить параметер: ЛКМ выберите параметер и нажмите Удалить параметер. Параметер удалится.\n")
        self.l8 = customtkinter.CTkLabel(tabview.tab("4"), justify='left',text="4. Генерация вариантов.")
        self.l9 = customtkinter.CTkLabel(tabview.tab("4"), justify='left',text="Перейдите на страницу Варианты. Варианты хранятся в отдельной таблице, \n"
                                                    "поэтому, если в базе этой таблицы нет, будет предложено её создать. \n"
                                                     "Чтобы создать таблицу, нажмите кнопку Добавить таблицу вариантов.\n"
                                                    "После создания будет показано её содержимое, а также опции: Сгенерировать варианты, \n"
                                                    "Удалить вариант, Выгрузить. Содержимое таблицы можно отфильтровать по уровню сложностей заданий и id шаблона\n\n"
                                                    "Сгенерировать варианты: нажмите Сгенерировать варианты.\n"
                                                     "В появившейся форме выберите сколько заданий надо сгенерировать и по какому шаблону.\n"
                                                    "Нажмите Сгенерировать. При генерации возможно появление дубликатов. \n"
                                                                               "Информация по ним выведится в текстовом сообщении.\n\n"
                                                                               "Удалить параметер: ЛКМ выберите параметер и нажмите Удалить параметер. Параметер удалится.\n\n"
                                                                               "Выгрузить: нажмите Выгрузить и выберите файл, в который сохранятся задания.\n"
                                         )
        self.l1.grid(row=0, column=0, padx=20, pady=20, sticky=NSEW)
        self.l2.pack()
        self.l3.pack()
        self.l4.pack()
        self.l5.pack()
        self.l6.pack()
        self.l7.pack()
        self.l8.pack()
        self.l9.pack()
        self.info_frame.pack()
        tabview.pack()