-- create all tables
CREATE TABLE museum (
  museum_id INTEGER NOT NULL,
  museum_name VARCHAR(70) NOT NULL,
  address VARCHAR(70) NOT NULL,
  foundation_year INTEGER NOT NULL,
  latitude FLOAT(6) NOT NULL,
  longitude FLOAT(6) NOT NULL
);
CREATE TABLE excursion (
  excursion_id INTEGER NOT NULL,
  excursion_name VARCHAR(100) NOT NULL,
  museum_id INTEGER NOT NULL,
  price INTEGER NOT NULL,
  guide_id INTEGER
);
CREATE TABLE visitor (
  visitor_id INTEGER NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  gender CHAR(1) NOT NULL
);
create table schedule (
  schedule_id INTEGER NOT NULL,
  excursion_id INTEGER NOT NULL,
  starts_on TIMESTAMP NOT NULL
);
create table visitor_schedule (
  visitor_id INTEGER NOT NULL,
  schedule_id INTEGER NOT NULL
);
CREATE TABLE hall (
  hall_id INTEGER NOT NULL,
  hall_name VARCHAR(100) NOT NULL,
  floor INTEGER NOT NULL,
  museum_id INTEGER NOT NULL
);
CREATE TABLE exhibit (
  exhibit_id INTEGER NOT NULL,
  exhibit_name VARCHAR(150) NOT NULL,
  author VARCHAR(150),
  hall_id INTEGER NOT NULL,
  year_of_creation INTEGER,
  country_of_creation VARCHAR(50)
);
CREATE TABLE guide (
  guide_id INTEGER NOT NULL,
  first_name VARCHAR(20) NOT NULL,
  phone CHAR(12) NOT NULL
);
ALTER TABLE museum ADD PRIMARY KEY (museum_id);
ALTER TABLE excursion ADD PRIMARY KEY (excursion_id);
ALTER TABLE visitor ADD PRIMARY KEY (visitor_id);
ALTER TABLE schedule ADD PRIMARY KEY (schedule_id);
ALTER TABLE hall ADD PRIMARY KEY (hall_id);
ALTER TABLE exhibit ADD PRIMARY KEY (exhibit_id);
ALTER TABLE guide ADD PRIMARY KEY (guide_id);

ALTER TABLE visitor_schedule ADD CONSTRAINT fk_visitor_id FOREIGN KEY (visitor_id) REFERENCES visitor(visitor_id);
ALTER TABLE visitor_schedule ADD CONSTRAINT fk_schedule_id FOREIGN KEY (schedule_id) REFERENCES schedule(schedule_id);
ALTER TABLE schedule ADD CONSTRAINT fk_excursion_id FOREIGN KEY (excursion_id) REFERENCES excursion(excursion_id);
ALTER TABLE excursion ADD CONSTRAINT fk_museum_id_excursion FOREIGN KEY (museum_id) REFERENCES museum(museum_id);
ALTER TABLE excursion ADD CONSTRAINT fk_guide_id FOREIGN KEY (guide_id) REFERENCES guide(guide_id);
ALTER TABLE hall ADD CONSTRAINT fk_museum_id_hall FOREIGN KEY (museum_id) REFERENCES museum(museum_id);
ALTER TABLE exhibit ADD CONSTRAINT fk_hall_id FOREIGN KEY (hall_id) REFERENCES hall(hall_id);

--insert into museum
INSERT INTO museum VALUES (10, 'Государственный Эрмитаж', 'Дворцовая площадь, 2', 1764);
INSERT INTO museum VALUES (20, 'Музей Фаберже', 'Набережная реки Фонтанки, 21', 2013);
INSERT INTO museum VALUES (30, 'Государственный Русский музей', 'Инженерная улица, 4', 1978);
INSERT INTO museum VALUES (40, 'Государственный музей «Царскосельская коллекция»', 'Пушкин, Магазейная улица, 40', 1991);

--insert into guide
INSERT INTO guide VALUES (001, 'Михаил', 10, '+71834567390');
INSERT INTO guide VALUES (002, 'Ольга', 10, '+79644113854');
INSERT INTO guide VALUES (003, 'Иван', 10, '+75834567892');
INSERT INTO guide VALUES (004, 'Евгения', 10, '+79834465827');
INSERT INTO guide VALUES (005, 'Мария', 10, '+71834562824');
INSERT INTO guide VALUES (006, 'Михаил', 20, '+79635267816');
INSERT INTO guide VALUES (007, 'Андрей', 20, '+71834680865');
INSERT INTO guide VALUES (008, 'Александра', 20, '+73934004873');
INSERT INTO guide VALUES (009, 'Зоя', 30, '+75434117011');
INSERT INTO guide VALUES (010, 'Дарья', 30, '+74834513888');
INSERT INTO guide VALUES (011, 'Наталья', 30, '+70234527821');
INSERT INTO guide VALUES (012, 'Алла', 40, '+74634432813');

--insert into excursion
INSERT INTO excursion VALUES (001, 'Главный музейный комплекc', 10, 500, NULL);
INSERT INTO excursion VALUES (002, 'Золотая кладовая', 10, 1000, 001);
INSERT INTO excursion VALUES (003, 'Бриллиантовая кладовая', 10, 1000, 002);
INSERT INTO excursion VALUES (004, 'Главный музейный комплекс (обзорная)', 10, 1000, 003);
INSERT INTO excursion VALUES (005, 'Главный Штаб (обзорная)', 10, 1000, 004);
INSERT INTO excursion VALUES (006, 'Приключения богини Сохмет', 10, 600, 005);
INSERT INTO excursion VALUES (007, 'В мире прекрасного', 10, 600, 005);
INSERT INTO excursion VALUES (008, 'Дворец Меньшикова', 10, 600, NULL);
INSERT INTO excursion VALUES (009, 'Музей Императорского фарфорового завода', 10, 300, NULL);
INSERT INTO excursion VALUES (010, 'Зимний дворец Петра I', 10, 600, NULL);
INSERT INTO excursion VALUES (011, 'Основная экспозиция Музея Фаберже', 20, 500, NULL);
INSERT INTO excursion VALUES (012, 'Экскурсионный сеанс по Музею Фаберже', 20, 1000, NULL);
INSERT INTO excursion VALUES (013, 'Диковинные вещицы Фаберже', 20, 750, 006);
INSERT INTO excursion VALUES (014, 'Драгоценный зоопарк', 20, 500, 007);
INSERT INTO excursion VALUES (015, 'Сказка в музее Фаберже', 20, 500, 007);
INSERT INTO excursion VALUES (016, 'Средства связи времен Фаберже', 20, 750, 008);
INSERT INTO excursion VALUES (017, 'Михайловский дворец', 30, 550, NULL);
INSERT INTO excursion VALUES (018, 'Корпус Бенуа', 30, 450, NULL);
INSERT INTO excursion VALUES (019, 'Михаил Врубель. К 165-летию со дня рождения', 30, 1000, 009);
INSERT INTO excursion VALUES (020, 'Мраморный и Строгановский дворцы', 30, 500, NULL);
INSERT INTO excursion VALUES (021, 'Константин Романов - поэт (К.Р): жизнь и судьба', 30, 800, 009);
INSERT INTO excursion VALUES (022, 'Домик Петра I', 30, 400, 010);
INSERT INTO excursion VALUES (023, 'Летний дворец Петра I', 30, 800, 011);
INSERT INTO excursion VALUES (024, 'Вход на основную экспозицию', 40, 100, NULL);
INSERT INTO excursion VALUES (025, 'Экскурсионный сеанс по музею', 40, 250, 012);

-- insert into hall
INSERT INTO hall VALUES (01, 'Зал культуры и искусства Урарту', 1, 10);
INSERT INTO hall VALUES (02, 'Зал культуры и искусства древнего Ближнего Востока', 1, 10);
INSERT INTO hall VALUES (03, 'Зал Древнего Египта', 1, 10);
INSERT INTO hall VALUES (04, 'Зал Диониса. Римская декоративная скульптура', 1, 10);
INSERT INTO hall VALUES (05, 'Зал Афины. Искусство Древней Греции эпохи классики', 1, 10);
INSERT INTO hall VALUES (06, 'Зал Геракла. Искусство Древней Греции IV в. до н. э', 1, 10);
INSERT INTO hall VALUES (07, 'Зал культуры и искусства эпохи эллинизма', 1, 10);
INSERT INTO hall VALUES (08, 'Зал Большой вазы. Искусство Рима эпохи императоров Траяна и Адриана, конец I - II в.', 1, 10);
INSERT INTO hall VALUES (09, 'Древнерусская иконопись XIV — начала XVIII века', 2, 10);
INSERT INTO hall VALUES (10, 'Древнерусская культура', 2, 10);
INSERT INTO hall VALUES (11, 'Портретная галерея дома Романовых', 2, 10);
INSERT INTO hall VALUES (12, 'Ротонда', 2, 10);
INSERT INTO hall VALUES (13, 'Концертный зал', 2, 10);
INSERT INTO hall VALUES (14, 'Фельдмаршальский зал', 2, 10);
INSERT INTO hall VALUES (15, 'Гербовый зал', 2, 10);
INSERT INTO hall VALUES (16, 'Военная галерея 1812 года', 2, 10);
INSERT INTO hall VALUES (17, 'Георгиевский (Большой тронный) зал', 2, 10);
INSERT INTO hall VALUES (18, 'Павильонный зал', 2, 10);
INSERT INTO hall VALUES (19, 'Зал искусства Италии эпохи Возрождения XV в.', 2, 10);
INSERT INTO hall VALUES (20, 'Зал Леонардо да Винчи', 2, 10);
INSERT INTO hall VALUES (21, 'Зал искусства Венеции XVI в.', 2, 10);
INSERT INTO hall VALUES (22, 'Зал Тициана', 2, 10);
INSERT INTO hall VALUES (23, 'Зал Рафаэля', 2, 10);
INSERT INTO hall VALUES (24, 'Итальянский кабинет', 2, 10);
INSERT INTO hall VALUES (25, 'Большой итальянский просвет', 2, 10);
INSERT INTO hall VALUES (26, 'Зал Снейдерса', 2, 10);
INSERT INTO hall VALUES (27, 'Зал Рубенса', 2, 10);
INSERT INTO hall VALUES (28, 'Зал Рембрандта', 2, 10);
INSERT INTO hall VALUES (29, 'Искусство Германии XV—XVIII вв', 2, 10);
INSERT INTO hall VALUES (30, 'Зал искусства Франции XVII в. Зал Пуссена', 2, 10);
INSERT INTO hall VALUES (31, 'Белый зал', 2, 10);
INSERT INTO hall VALUES (32, 'Зал искусства Великобритании', 2, 10);
INSERT INTO hall VALUES (33, 'Зал культуры и искусства Китая', 3, 10);
INSERT INTO hall VALUES (34, 'Зал буддийского искусства Монголии и Тибета', 3, 10);
INSERT INTO hall VALUES (35, 'Зал искусства и культуры Ближнего Востока исламского периода VIII—XII вв', 3, 10);
INSERT INTO hall VALUES (36, 'Рыцарский зал', 2, 20);
INSERT INTO hall VALUES (37, 'Красная гостиная', 2, 20);
INSERT INTO hall VALUES (38, 'Синяя гостиная', 2, 20);
INSERT INTO hall VALUES (39, 'Золотая гостиная', 2, 20);
INSERT INTO hall VALUES (40, 'Аванзал', 2, 20);
INSERT INTO hall VALUES (41, 'Белая и Голубая гостинные', 2, 20);
INSERT INTO hall VALUES (42, 'Выставочный зал', 2, 20);
INSERT INTO hall VALUES (43, 'Готический зал', 2, 20);
INSERT INTO hall VALUES (44, 'Верхняя буфетная', 2, 20);
INSERT INTO hall VALUES (45, 'Бежевый зал', 2, 20);
INSERT INTO hall VALUES (46, 'Древнейшие иконы', 2, 30);
INSERT INTO hall VALUES (47, 'Андрей Рублев', 2, 30);
INSERT INTO hall VALUES (48, 'И. Я. Вишняков, А. П. Антропов, И. П. Аргунов', 2, 30);
INSERT INTO hall VALUES (49, 'Академический зал. К. П.Брюллов, И. К. Айвазовский', 2, 30);
INSERT INTO hall VALUES (50, 'С. Ф. Щедрин', 2, 30);
INSERT INTO hall VALUES (51, 'Ф. А. Васильев', 2, 30);
INSERT INTO hall VALUES (52, 'В. Г. Перов', 1, 30);
INSERT INTO hall VALUES (53, 'И. И. Шишкин', 1, 30);
INSERT INTO hall VALUES (54, 'А. К. Саврасов', 1, 30);
INSERT INTO hall VALUES (55, 'И. Е. Репин', 1, 30);
INSERT INTO hall VALUES (56, 'А. И. Куинджи', 1, 30);
INSERT INTO hall VALUES (57, 'В. И. Суриков', 1, 30);
INSERT INTO hall VALUES (58, 'В. М. Васнецов', 1, 30);
INSERT INTO hall VALUES (59, 'В. А. Серов, П.Трубецкой', 2, 30);
INSERT INTO hall VALUES (60, 'М. А. Врубель', 2, 30);
INSERT INTO hall VALUES (61, 'Кубофутуризм (Л. С. Попова, Н. А. Удальцова, Н. С. Гончарова). В. В. Кандинский', 2, 30);
INSERT INTO hall VALUES (62,  'К. С. Малевич, М. В. Матюшин, В. Е. Татлин', 2, 30);
INSERT INTO hall VALUES (63,  'Музей Людвига в Русском музее. Мировое искусство XX века', 2, 30);
INSERT INTO hall VALUES (64, 'Арефьевский круг', 2, 40);
INSERT INTO hall VALUES (65, 'Зал 1920 — 1940', 2, 40);

--insert into exhibit
INSERT INTO exhibit VALUES (0001, 'Фигура для украшения трона', NULL, 01, NULL, 'Урарту');
INSERT INTO exhibit VALUES (0002, 'Карас', NULL, 01, NULL, 'Урарту');
INSERT INTO exhibit VALUES (0003, 'Шлем царя Сардури II', NULL, 01, NULL, 'Урарту');
INSERT INTO exhibit VALUES (0004, 'Табличка с пиктографическими (протоклинописными) знаками', NULL, 02, NULL, NULL);
INSERT INTO exhibit VALUES (0005, 'Гиря для взвешивания серебра', NULL, 02, NULL, 'Древний Иран');
INSERT INTO exhibit VALUES (0006, 'Статуя Аменемхета III', NULL, 03, NULL, 'Древний Египет');
INSERT INTO exhibit VALUES (0007, 'Статуя Клеопатры VII', NULL, 03, NULL, 'Древний Египет');
INSERT INTO exhibit VALUES (0008, 'Статуя богини Мут-Сохмет', NULL, 03, NULL, 'Древний Египет');
INSERT INTO exhibit VALUES (0009, 'Афродита (Венера Таврическая)', NULL, 04, NULL, 'Древняя Греция');
INSERT INTO exhibit VALUES (0010, 'Дионис. Бог вина и виноделия, покровитель растительных сил природы', NULL, 04, NULL, 'Древний Рим');
INSERT INTO exhibit VALUES (0011, 'Статуя жрицы', NULL, 04, NULL, NULL);
INSERT INTO exhibit VALUES (0012, 'Статуя Афины', NULL, 05, NULL, 'Древний Рим');
INSERT INTO exhibit VALUES (0013, 'Надгробие Филостраты', NULL, 05, NULL, 'Аттика');
INSERT INTO exhibit VALUES (0014, 'Фрагмент рельефа "Геракл в саду Гесперид', NULL, 05, NULL, 'Древний Рим');
INSERT INTO exhibit VALUES (0015, 'Статуя отдыхающего Геракла', NULL, 06, NULL, NULL);
INSERT INTO exhibit VALUES (0016, 'Эрот, натягивающий лук', NULL, 06, NULL, 'Древний Рим');
INSERT INTO exhibit VALUES (0017, 'Две девушки (эфедризм)', NULL, 07, NULL, 'Коринф');
INSERT INTO exhibit VALUES (0018, 'Исида', NULL, 07, NULL, 'Рим');
INSERT INTO exhibit VALUES (0019, 'Портрет римлянки', NULL, 08, NULL, 'Древний Рим');
INSERT INTO exhibit VALUES (0020, 'Портрет Антиноя-Диониса', NULL, 08, NULL, 'Древний Рим');
INSERT INTO exhibit VALUES (0021, 'Икона: Иоанн Богослов в молчании', 'Нектарий Кулюксин', 09, 1679, 'Русский Север');
INSERT INTO exhibit VALUES (0022, 'Икона: Богоматерь Казанская', 'Ушаков, Симон Фёдорович.', 09, 1676, '');
INSERT INTO exhibit VALUES (0023, 'Икона: Мученики Флор и Лавр', NULL, 09, NULL, 'Ростовская провинция');
INSERT INTO exhibit VALUES (0024, 'Височное кольцо трехбусинное', NULL, 10, NULL, 'Древняя Русь');
INSERT INTO exhibit VALUES (0025, 'Тмутараканский камень', NULL, 10, NULL, 'Древняя Русь');
INSERT INTO exhibit VALUES (0026, 'Портрет императора Петра I (1672-1725) (копия)', 'Белли', 11, NULL, 'Россия');
INSERT INTO exhibit VALUES (0027, 'Портрет императрицы Александры Федоровны', 'Кристина Робертсон', 11, 1841, 'Россия');
INSERT INTO exhibit VALUES (0028, 'Полтавская баталия', 'Каравак, Луи', 12, 1718, 'Россия');
INSERT INTO exhibit VALUES (0029, 'Портрет императора Петра I', 'Растрелли, Бартоломео Карло', 12, 1730, 'Россия');
INSERT INTO exhibit VALUES (0030, 'Рака Александра Невского', 'Гроот, Георг Кристоф', 13, 1751, 'Россия');
INSERT INTO exhibit VALUES (0031, 'Портрет графа И.И. Дибича', 'Басин, Пётр Васильевич', 14, 1833, 'Россия');
INSERT INTO exhibit VALUES (0032, 'Портрет генерал-фельдмаршала князя Михаила Илларионовича Голенищева-Кутузова (1745-1813)', 'Басин, Пётр Васильевич', 14, 1834, 'Россия');
INSERT INTO exhibit VALUES (0033, 'Ваза "Россия"', 'Моро, Дени-Жозеф;  Давиньон, Жак Фердинанд; Шрейбер, Андрей; Мадерни, Викентий Ф.; Райт, Томас; Шилов, Иван Анфимович', 14, 1828, 'Россия');
INSERT INTO exhibit VALUES (0034, 'Часть Белого (Гербового) зала в Зимнем дворце', 'Ладюрнер, Адольф Игнатьевич', 15, 1838, 'Франция');
INSERT INTO exhibit VALUES (0035, 'Чаша', NULL, 15, 1842, 'Россия');
INSERT INTO exhibit VALUES (0036, 'Портрет Михаила Илларионовича Кутузова (1747-1813)', 'Доу, Джордж', 16, 1829, 'Англия');
INSERT INTO exhibit VALUES (0037, 'Портрет Михаила Богдановича Барклая-де-Толли (1761-1818)', 'Доу, Джордж', 16, 1829, 'Англия');
INSERT INTO exhibit VALUES (0038, 'Портрет Александра I (1777-1825) верхом на коне', 'Крюгер, Франц', 16, 1837, 'Германия');
INSERT INTO exhibit VALUES (0039, 'Портрет Франца I (1768-1835)', 'Крафт, Иоганн Петер', 16, 1832, 'Австрия');
INSERT INTO exhibit VALUES (0040, 'Тронное кресло и скамейка для ног ', NULL, 17, 1731, 'Великобритания, Лондон');
INSERT INTO exhibit VALUES (0041, 'Обелиск', NULL, 17, 1801, 'Россия');
INSERT INTO exhibit VALUES (0042, 'Часы "Павлин"', 'Кокс, Джеймс', 18, 1772, 'Великобритания');
INSERT INTO exhibit VALUES (0043, 'Стол с мозаичной столешницей "Аполлон и Музы"', 'Мокиутти, Эдоардо', 18, 1873, 'Италия');
INSERT INTO exhibit VALUES (0044, 'Мадонна с Младенцем на троне', 'Строцци, Дзаноби', 19, 1419, 'Италия');
INSERT INTO exhibit VALUES (0045, 'Видение блаженного Августина', 'Липпи, Филиппо фра', 19, 1460, 'Италия');
INSERT INTO exhibit VALUES (0046, 'Мадонна с Младенцем и четырьмя ангелами', 'Анджелико, фра Беато', 19, 1420, 'Италия');
INSERT INTO exhibit VALUES (0047, 'Мадонна с Младенцем (Мадонна Литта)', 'Леонардо да Винчи', 20, 1495, 'Италия');
INSERT INTO exhibit VALUES (0048, 'Мадонна с Младенцем (Мадонна Бенуа)', 'Леонардо да Винчи', 20, 1480, 'Италия');
INSERT INTO exhibit VALUES (0049, 'Кающаяся Мария Магдалина ', 'Джампьетрино (Джан Пьетро Риццоли)', 20, NULL, 'Италия');
INSERT INTO exhibit VALUES (0050, 'Юдифь', 'Джорджоне (Джорджо Барбарелли да Кастельфранко)', 21, 1504, 'Италия');
INSERT INTO exhibit VALUES (0051, 'Благовещение', 'Чима да Конельяно, Джованни Баттиста', 21, 1495, 'Италия');
INSERT INTO exhibit VALUES (0052, 'Мадонна с Младенцем', 'Виварини, Бартоломео', 21, 1490, 'Италия');
INSERT INTO exhibit VALUES (0053, 'Кающаяся Мария Магдалина', 'Тициан (Тициано Вечеллио)', 22, 1560, 'Италия');
INSERT INTO exhibit VALUES (0054, 'Даная', 'Тициан (Тициано Вечеллио)', 22, 1554, 'Италия');
INSERT INTO exhibit VALUES (0055, 'Св. Себастьян', 'Тициан (Тициано Вечеллио)', 22, 1576, 'Италия');
INSERT INTO exhibit VALUES (0056, 'Брак в Кане Галилейской', 'Гарофало (Бенвенуто Тизи)', 23, 1531, 'Италия');
INSERT INTO exhibit VALUES (0057, 'Чаша "Несение креста"', 'Никола да Урбино', 23, NULL, 'Италия');
INSERT INTO exhibit VALUES (0058, 'Святое семейство (Мадонна с безбородым Иосифом)', 'Рафаэль (Рафаэлло Санти)', 23, 1507, 'Италия');
INSERT INTO exhibit VALUES (0059, 'Мадонна с Младенцем (Мадонна Конестабиле)', 'Рафаэль (Рафаэлло Санти)', 23, 1504, 'Италия');
INSERT INTO exhibit VALUES (0060, 'Святой Иосиф с Младенцем Христом на руках', 'Рени, Гвидо', 24, '1635', 'Италия');
INSERT INTO exhibit VALUES (0061, 'Взятие Марии Магдалины на небо', 'Доменикино (Доменико Цампьери)', 24, 1621, 'Италия');
INSERT INTO exhibit VALUES (0062, 'Отдых святого семейства на пути в Египет ', 'Карраччи, Аннибале', 24, 1604, 'Италия');
INSERT INTO exhibit VALUES (0063, 'Исцеление Товита', 'Строцци, Бернардо', 25, 1632, 'Италия');
INSERT INTO exhibit VALUES (0064, 'Смерть св. Иосифа', 'Креспи, Джузеппе Мариа (Ло Спаньоло)', 25, 1712, 'Италия');
INSERT INTO exhibit VALUES (0065, 'Блудный сын', 'Роза, Сальватор', 25, 1650, 'Италия');
INSERT INTO exhibit VALUES (0066, 'Кузница Вулкана', 'Джордано, Лука', 25, 1660, 'Италия');
INSERT INTO exhibit VALUES (0067, 'Повар у стола с дичью', 'Снейдерс, Франс', 26, 1637, 'Фландрия');
INSERT INTO exhibit VALUES (0068, 'Сцена в кабачке', 'Браувер, Адриан', 26, 1770, 'Фландрия');
INSERT INTO exhibit VALUES (0069, 'Персей освобождает Андромеду', 'Рубенс, Питер Пауль (Пьетро Пауло) ', 27, 1622, 'Фландрия');
INSERT INTO exhibit VALUES (0070, 'Венера и Адонис', 'Рубенс, Питер Пауль (Пьетро Пауло)', 27, 1611, 'Фландрия');
INSERT INTO exhibit VALUES (0071, 'Союз Земли и Воды (Шельда и Антверпен)', 'Рубенс, Питер Пауль (Пьетро Пауло)', 27, 1618, 'Фландрия');
INSERT INTO exhibit VALUES (0072, 'Вакх', 'Рубенс, Питер Пауль (Пьетро Пауло)', 27, 1639, 'Фландрия');
INSERT INTO exhibit VALUES (0073, 'Отцелюбие римлянки (Кимон и Перо)', 'Рубенс, Питер Пауль (Пьетро Пауло)', 27, 1612, 'Фландрия');
INSERT INTO exhibit VALUES (0074, 'Уход Агари из дома Авраама', 'Рубенс, Питер Пауль (Пьетро Пауло)', 27, 1616, 'Фландрия');
INSERT INTO exhibit VALUES (0075, 'Пир у Симона Фарисея', 'Рубенс, Питер Пауль (Пьетро Пауло)', 27, 1619, 'Фландрия');
INSERT INTO exhibit VALUES (0076, 'Старушка с очками в руках', 'Рембрандт Харменс ван Рейн', 28, 1634, 'Голландия');
INSERT INTO exhibit VALUES (0077, 'Возвращение блудного сына', 'Рембрандт Харменс ван Рейн', 28, 1668, 'Голландия');
INSERT INTO exhibit VALUES (0078, 'Давид и Ионафан', 'Рембрандт Харменс ван Рейн', 28, 1642, 'Голландия');
INSERT INTO exhibit VALUES (0079, 'Флора', 'Рембрандт Харменс ван Рейн', 28, 1634, 'Голландия');
INSERT INTO exhibit VALUES (0080, 'Портрет Бартье Мартенс Доомер', 'Рембрандт Харменс ван Рейн', 28, 1640, 'Голландия');
INSERT INTO exhibit VALUES (0081, 'Жертвоприношение Авраама', 'Рембрандт Харменс ван Рейн', 28, 1635, 'Голландия');
INSERT INTO exhibit VALUES (0082, 'Натюрморт', 'Паудис, Христофер', 29, 1660, 'Германия');
INSERT INTO exhibit VALUES (0083, 'Мадонна с Младенцем под яблоней', 'Паудис, Христофер', 29, 1530, 'Германия');
INSERT INTO exhibit VALUES (0084, 'Моисей, иссекающий воду из скалы', 'Пуссен, Никола', 30, 1653, 'Франция');
INSERT INTO exhibit VALUES (0085, 'Битва израильтян с амаликитянами', 'Пуссен, Никола', 30, 1625, 'Франция');
INSERT INTO exhibit VALUES (0086, 'Танкред и Эрминия', 'Пуссен, Никола', 30, 1631, 'Франция');
INSERT INTO exhibit VALUES (0087, 'Автопортрет', 'Виже-Лебрен, Мари-Луиз-Элизабет', 31, 1800, 'Франция');
INSERT INTO exhibit VALUES (0088, 'Прачки в руинах', 'Робер, Гюбер', 31, 1760, 'Франция');
INSERT INTO exhibit VALUES (0089, 'У отшельника', 'Робер, Гюбер', 31, 1772, 'Франция');
INSERT INTO exhibit VALUES (0090, 'Портрет Джона Локка', 'Неллер, Годфри', 32, 1697, 'Великобритания');
INSERT INTO exhibit VALUES (0091, 'Кузница. Вид снаружи', 'Райт из Дерби, Джозеф', 32, 1773, 'Великобритания');
INSERT INTO exhibit VALUES (0092, 'Портрет Абрахама ван дер Дорта', 'Добсон, Уильям', 32, 1639, 'Великобритания');
INSERT INTO exhibit VALUES (0093, 'Портрет миссис Хэрриэт Грир', 'Ромни, Джордж', 32, 1788, 'Великобритания');
INSERT INTO exhibit VALUES (0094, 'Амур развязывает пояс Венеры', 'Рейнолдс, Джошуа', 32, 1788, 'Великобритания');
INSERT INTO exhibit VALUES (0095, 'Каминная решетка с двумя журавлями', NULL, 33, NULL, 'Китай');
INSERT INTO exhibit VALUES (0096, 'Кувшин для вина', NULL, 33, NULL, 'Китай');
INSERT INTO exhibit VALUES (0097, 'Сакья-Пандита', NULL, 34, NULL, 'Тибет');
INSERT INTO exhibit VALUES (0098, 'Астрологическая таблица с изображением животных двенадцатилетнего цикла', NULL, 34, NULL, 'Тибет');
INSERT INTO exhibit VALUES (0099, 'Водолей в виде орла', NULL, 35, 797, 'Ирак');
INSERT INTO exhibit VALUES (0100, 'Поднос', NULL, 35, NULL, 'Восточное средиземноморье');
INSERT INTO exhibit VALUES (0101, 'Кружка', 'Карл Альбрехт', 36, 1886, 'Россия');
INSERT INTO exhibit VALUES (0102, 'Портсигар со спичечницей и отверстием для фитиля', 'Михаил Перхин', 36, 1900, 'Россия');
INSERT INTO exhibit VALUES (0103, 'Доска закладная крейсера «Рюрик»', 'Андреас Невалайнен', 36, 1905, 'Россия');
INSERT INTO exhibit VALUES (0104, 'Часы настольные в форме грифона', 'Юлий Раппопорт', 37, 1904, 'Россия');
INSERT INTO exhibit VALUES (0105, 'Кувшин', 'Роберт Кохун', 37, 1875, 'Россия');
INSERT INTO exhibit VALUES (0106, 'Предметы из сервиза с монограммами великой княгини Ольги Николаевны', 'Карл-Иоганн Тегельстен, Генрих Август Лонг', 37, 1840, 'Россия');
INSERT INTO exhibit VALUES (0107, 'Парные канделябры на четыре свечи', 'Иоганн-Вильгельм Кейбель', 37, NULL,'Россия');
INSERT INTO exhibit VALUES (0108, 'Пасхальное яйцо «Курочка»', 'Эрик Коллин', 38, 1885, 'Россия');
INSERT INTO exhibit VALUES (0109, 'Пасхальное яйцо «Ренессанс»', 'Михаил Перхин', 38, 1894, 'Россия');
INSERT INTO exhibit VALUES (0110, 'Яйцо «Воскресение Христово»', 'Михаил Перхин', 38, 1898, 'Россия');
INSERT INTO exhibit VALUES (0111, 'Пасхальное яйцо «Пятнадцатилетие царствования»', 'Генрик Вигстрём', 38, 1911, 'Россия');
INSERT INTO exhibit VALUES (0112, 'Пасхальное яйцо «Ландыши»', 'Михаил Перхин', 38, 1898, 'Россия');
INSERT INTO exhibit VALUES (0113, 'Пасхальное яйцо-часы «Петушок»', 'Михаил Перхин', 38, 1900, 'Россия');
INSERT INTO exhibit VALUES (0114, 'Настольные часы с портретами младших сыновей датского принца Вальдемара', 'Йохан Виктор Аарне', 39, 1890, 'Россия');
INSERT INTO exhibit VALUES (0115, 'Бонбоньерка в форме кресла', 'Генрик Вигстрём', 39, 1911, 'Россия');
INSERT INTO exhibit VALUES (0116, 'Флакон парфюмерный с крышкой в виде женской головки', 'Генрик Вигстрём', 39, 1908, 'Россия');
INSERT INTO exhibit VALUES (0117, 'Портсигар', 'Оскар Пиль', 40, 1897, 'Россия');
INSERT INTO exhibit VALUES (0118, 'Кулон и брошь', 'Альберт Хольмстрём', 40, 1917, 'Россия');
INSERT INTO exhibit VALUES (0119, 'Шкатулка в виде сундука с изображением гербов городов Рязанской губернии', 'Павел Акимович Овчинников', 41, 1893, 'Россия');
INSERT INTO exhibit VALUES (0120, 'Спичечница с эмалевой миниатюрой "Адмиралтейство"', 'Федор Рюкерт', 41, 1917, 'Россия');
INSERT INTO exhibit VALUES (0121, 'Шкатулка с эмалевой миниатюрой "Право господина" (по картине В. Поленова)', 'Федор Рюкерт', 41, 1908, 'Россия');
INSERT INTO exhibit VALUES (0122, 'Бюст императора Александра III', 'Генрик Вигстрём', 42, 1917, 'Россия');
INSERT INTO exhibit VALUES (0123, 'Настольные часы с глобусом', 'Генрик Вигстрём', 42, NULL, 'Россия');
INSERT INTO exhibit VALUES (0124, 'Икона «Покров Богоматери»', 'Дмитрий Андреев', 43, 1842, 'Россия');
INSERT INTO exhibit VALUES (0125, 'Икона «Святой Николай Чудотворец»', 'Михаил Дикарев', 43, 1894, 'Россия');
INSERT INTO exhibit VALUES (0126, 'Складень "Господь Вседержитель, Богоматерь с младенцем, Св. Николай Чудотворец"', 'Федор Рюкерт', 43, 1900, 'Россия');
INSERT INTO exhibit VALUES (0127, 'Ваза c изображением цветов', 'Федор Красовский', 44, 1859, 'Россия');
INSERT INTO exhibit VALUES (0128, 'Лето в Гурзуфе', 'Константин Коровин', 44, 1917, 'Россия');
INSERT INTO exhibit VALUES (0129, 'Вазочка для цветов', NULL, 45, 1908, 'Россия');
INSERT INTO exhibit VALUES (0130, 'Чаша', NULL, 45, 1880, 'Россия');
INSERT INTO exhibit VALUES (0131, 'Архангел Гавриил (Ангел Златые Власы)', NULL, 46, NULL, 'Древняя русь');
INSERT INTO exhibit VALUES (0132, 'Апостол Павел', 'Рублев Андрей', 46, 1408, 'Россия');
INSERT INTO exhibit VALUES (0133, 'Покров Богоматери', NULL, 46, NULL, 'Россия');
INSERT INTO exhibit VALUES (0134, 'Крещение', 'Рублев Андрей', 47, 1408, 'Россия');
INSERT INTO exhibit VALUES (0135, 'Апостол Петр', 'Рублев Андрей', 47, 1408, 'Россия');
INSERT INTO exhibit VALUES (0136, 'Портрет графини А. К. Воронцовой (урожденной Скавронской)', 'Антропов А. П.', 48, 1917, 'Россия');
INSERT INTO exhibit VALUES (0137, 'Портрет С. Э. Фермор', 'Вишняков И. Я.', 48, 1750, 'Россия');
INSERT INTO exhibit VALUES (0138, 'Портрет князя И. И. Лобанова-Ростовского', 'Аргунов И. П.', 48, 1750, 'Россия');
INSERT INTO exhibit VALUES (0139, 'Русская эскадра на Севастопольском рейде', 'Айвазовский И. К.', 49, 1846, 'Россия');
INSERT INTO exhibit VALUES (0140, 'Девятый вал', 'Айвазовский И. К.', 49, 1850, 'Россия');
INSERT INTO exhibit VALUES (0141, 'Волна', 'Айвазовский И. К.', 49, 1889, 'Россия');
INSERT INTO exhibit VALUES (0142, 'Аричча близ Рима', 'Лебедев М. И.', 50, 1836, 'Россия');
INSERT INTO exhibit VALUES (0143, 'Вид с Петровского острова в Петербурге', 'Щедрин С. Ф.', 50, 1816, 'Россия');
INSERT INTO exhibit VALUES (0144, 'Вид Неаполя. Набережная Санта Лючия', 'Щедрин С. Ф.', 50, 1829, 'Россия');
INSERT INTO exhibit VALUES (0145, 'Новый Рим. Замок Святого Ангела', 'Щедрин С. Ф.', 50, 1823, 'Россия');
INSERT INTO exhibit VALUES (0146, 'После дождя. Проселок', 'Васильев Ф. А.', 51, 1869, 'Россия');
INSERT INTO exhibit VALUES (0147, 'В церковной ограде. Валаам', 'Васильев Ф. А.', 51, 1867, 'Россия');
INSERT INTO exhibit VALUES (0148, 'Охотники на привале', 'Перов В. Г.', 52, 1877, 'Россия');
INSERT INTO exhibit VALUES (0149, 'Суд Пугачева', 'Перов В. Г.', 52, 1879, 'Россия');
INSERT INTO exhibit VALUES (0150, 'Джованнина, сидящая на подоконнике', 'Чистяков П. П.', 52, 1864, 'Россия');
INSERT INTO exhibit VALUES (0151, 'Дубы', 'Шишкин И. И.', 53, 1865, 'Россия');
INSERT INTO exhibit VALUES (0152, 'Корабельная роща', 'Шишкин И. И.', 53, 1898, 'Россия');
INSERT INTO exhibit VALUES (0153, 'Разлив Волги под Ярославлем', 'Саврасов А. К.', 54, 1871, 'Россия');
INSERT INTO exhibit VALUES (0154, 'Радуга', 'Саврасов А. К.', 54, 1875, 'Россия');
INSERT INTO exhibit VALUES (0155, 'Степь днём', 'Саврасов А. К.', 54, 1852, 'Россия');
INSERT INTO exhibit VALUES (0156, 'Бурлаки на Волге', 'Репин И. Е.', 55, 1873, 'Россия');
INSERT INTO exhibit VALUES (0157, 'Запорожцы', 'Репин И. Е.', 55, 1891, 'Россия');
INSERT INTO exhibit VALUES (0158, 'Шторм на Волге', 'Репин И. Е.', 55, 1891, 'Россия');
INSERT INTO exhibit VALUES (0159, 'Лунная ночь на Днепре', 'Куинджи А. И.', 56, 1880, 'Россия');
INSERT INTO exhibit VALUES (0160, 'Ночное', 'Куинджи А. И.', 56, 1917, 'Россия');
INSERT INTO exhibit VALUES (0161, 'Переход Суворова через Альпы в 1799 году', 'Суриков В. И.', 57, 1899, 'Россия');
INSERT INTO exhibit VALUES (0162, 'Покорение Сибири Ермаком', 'Суриков В. И.', 57, 1895, 'Россия');
INSERT INTO exhibit VALUES (0163, 'Взятие снежного городка', 'Суриков В. И.', 57, 1891, 'Россия');
INSERT INTO exhibit VALUES (0164, 'Витязь на распутье', 'Васнецов В. М.', 58, 1882, 'Россия');
INSERT INTO exhibit VALUES (0165, 'Бой скифов со славянами', 'Васнецов В. М.', 58, 1881, 'Россия');
INSERT INTO exhibit VALUES (0166, 'Богоматерь с младенцем', 'Васнецов В. М.', 58, 1887, 'Россия');
INSERT INTO exhibit VALUES (0167, 'Купание лошади', 'Серов В. А.', 59, 1905, 'Россия');
INSERT INTO exhibit VALUES (0168, 'Портрет княгини Ольги Орловой', 'Серов В. А', 59, 1911, 'Россия');
INSERT INTO exhibit VALUES (0169, 'Дети', 'Трубецкой П. (П. П.)', 59, 1910, 'Россия');
INSERT INTO exhibit VALUES (0170, 'Демон', 'Врубель М. А.', 60, 1894, 'Россия');
INSERT INTO exhibit VALUES (0171, 'Летящий демон', 'Врубель М. А.', 60, 1899, 'Россия');
INSERT INTO exhibit VALUES (0172, 'Венеция', 'Врубель М. А.', 60, 1893, 'Россия');
INSERT INTO exhibit VALUES (0173, 'Портрет Ивана Васильевича Клюна (Усовершенствованный портрет Клюна(Строитель))', 'Малевич К. С.', 61, 1913, 'Россия');
INSERT INTO exhibit VALUES (0174, 'Сумеречное', 'Кандинский В.В', 61, 1917, 'Россия');
INSERT INTO exhibit VALUES (0175, 'Красный квадрат (Живописный реализм крестьянки в двух измерениях)', 'Малевич К. С.', 61, 1915, 'Россия');
INSERT INTO exhibit VALUES (0176, 'Супрематизм (supremus № 56)', 'Малевич К. С.', 61, 1916, 'Россия');
INSERT INTO exhibit VALUES (0177, 'Человек + воздух + пространство', 'Попова Л.С.', 61, 1913, 'Россия');
INSERT INTO exhibit VALUES (0178, 'Черный квадрат', 'Малевич К. С.', 62, 1923, 'СССР');
INSERT INTO exhibit VALUES (0179, 'Спортсмены', 'Малевич К. С.', 62, 1932, 'СССР');
INSERT INTO exhibit VALUES (0180, 'Красная конница', 'Малевич К. С.', 62, 1932, 'СССР');
INSERT INTO exhibit VALUES (0181, 'Угловой контррельеф', 'Татлин В. Е.', 62, 1914, 'Россия');
INSERT INTO exhibit VALUES (0182, 'Dios con nosotros', 'Жилинский Д. Д.', 63, 1991, 'Россия');
INSERT INTO exhibit VALUES (0183, 'Стулья', 'Иммендорф Йорг', 63, 1980, 'Германия');
INSERT INTO exhibit VALUES (0184, 'Большие головы', 'Пикассо Пабло', 63, 1969, 'Франция');
INSERT INTO exhibit VALUES (0185, 'Открытое окно', 'Матюшин М. В.', 64, 1920, 'СССР');
INSERT INTO exhibit VALUES (0186, 'Белая ночь. Кировские острова.', 'Гринберг В. А.', 64, 1940, 'СССР');
INSERT INTO exhibit VALUES (0187, 'В хлеву', 'Гуревич Д. Е.', 64, 1930, 'СССР');
INSERT INTO exhibit VALUES (0188, 'В поле', 'Костров И. Н.', 64, 1933, 'СССР');
INSERT INTO exhibit VALUES (0189, 'Двое. Сцена', 'Арефьев А. Д.', 65, 1953, 'СССР');
INSERT INTO exhibit VALUES (0190, 'Двое. Разговор в углу', 'Арефьев А. Д.', 65, 1955, 'Россия');
INSERT INTO exhibit VALUES (0191, 'На прудах', 'Шагин В. Н.', 65, 1980, 'СССР');
INSERT INTO exhibit VALUES (0192, 'Синий кувшин', 'Шварц Ш. А.', 65, 1993, 'Россия');

-- insert into schedule
CREATE OR REPLACE PROCEDURE every_day 
   (
        excursion_id INT,
	   	open_time TIME,	   
	    close_time TIME,
	   inter INTERVAL,
	   first_day DATE,
	   last_day DATE,
	   days_off INT[]
   )
   language plpgsql  
   AS $$
   DECLARE schedule_id INT; excursion_time TIME; i_day DATE := first_day;
   BEGIN
		WHILE i_day < last_day LOOP
			excursion_time:= open_time;
			IF(days_off = '{}' OR extract(dow from i_day) <> ALL(days_off)) THEN
				WHILE excursion_time < close_time LOOP	
					SELECT MAX(schedule_id) into schedule_id from schedule;
					INSERT INTO schedule(id, excursion_id, starts_on)
						VALUES (COALESCE(schedule_id + 1, 1), Excursion_id, i_day + excursion_time);
					excursion_time := excursion_time + inter;
				END LOOP;
			END IF;	
			i_day := i_day + INTERVAL '1 day';
		END LOOP;
	END						
   $$;
   
   
CREATE OR REPLACE PROCEDURE every_week 
   (
        excursion_id INT,
        weekday INT,
	   	first_day DATE,
	   	last_day DATE,
	   	excursion_time TIME
   )
   language plpgsql  
   AS $$
   DECLARE v_schedule_id INT; i_day DATE := first_day + cast(abs(extract(dow FROM first_day) - 7) + weekday AS int);
   BEGIN
		WHILE i_day < last_day
		LOOP
			SELECT MAX(schedule_id) into v_schedule_id from schedule;
			INSERT INTO schedule(schedule_id, excursion_id, starts_on)
					VALUES (COALESCE(v_schedule_id + 1, 1), Excursion_id, i_day + excursion_time);
			i_day := i_day + INTERVAL '1 week';			
		END LOOP;
	END						
   $$;

 CALL every_day(001,'11:00:00', '18:00:00', INTERVAL '1 hour', '02.01.2023','31.03.2024', '{1, 2}'); 
 CALL every_week(002, 2,'02.01.2023','31.03.2024', '13:40:00');
 CALL every_week(003, 3,'02.01.2023','31.03.2024', '12:00:00');
 CALL every_day(004,'10:00:00', '15:00:00', INTERVAL '2 hour', '02.01.2023','31.03.2024', '{1}'); 
 CALL every_day(005,'11:00:00', '16:00:00', INTERVAL '2 hour', '02.01.2023','31.03.2024', '{1}'); 
 CALL every_week(006, 3,'02.01.2023','31.03.2024', '15:00:00');
 CALL every_week(007, 3,'02.01.2023','31.03.2024', '17:00:00');
 CALL every_day(008,'12:00:00', '18:00:00', INTERVAL '2 hour', '02.01.2023','31.03.2024', '{0, 1, 2}'); 
 CALL every_day(009,'12:00:00', '18:00:00', INTERVAL '4 hour', '02.01.2023','31.03.2024', '{1, 2}'); 
 CALL every_day(010,'12:00:00', '18:00:00', INTERVAL '4 hour', '02.01.2023','31.03.2024', '{1, 2}'); 
 CALL every_day(011,'12:00:00', '16:00:00', INTERVAL '1 hour', '02.01.2023','31.03.2024', '{}'); 
 CALL every_day(012,'11:00:00', '17:00:00', INTERVAL '1 hour', '02.01.2023','31.03.2024', '{}'); 
 CALL every_week(013, 3,'02.01.2023','31.03.2024', '11:00:00');
 CALL every_week(014, 3,'02.01.2023','31.03.2024', '12:00:00');
 CALL every_week(015, 3,'02.01.2023','31.03.2024', '14:30:00');
 CALL every_week(016, 3,'02.01.2023','31.03.2024', '15:00:00');
 CALL every_day(017,'12:00:00', '18:00:00', INTERVAL '2 hour', '02.01.2023','31.03.2024', '{1, 2}'); 
 CALL every_day(018,'12:00:00', '18:00:00', INTERVAL '2 hour', '02.01.2023','31.03.2024', '{1, 2}'); 
 CALL every_day(019,'12:00:00', '18:00:00', INTERVAL '4 hour', '02.01.2023','31.03.2024', '{2}'); 
 CALL every_day(020,'11:00:00', '18:00:00', INTERVAL '2 hour', '02.01.2023','31.03.2024', '{2}'); 
 CALL every_week(021, 3,'02.01.2023','31.03.2024', '12:30:00');
 CALL every_day(022,'12:00:00', '18:00:00', INTERVAL '3 hour', '02.01.2023','31.03.2024', '{1, 2}'); 
 CALL every_day(023,'12:00:00', '18:00:00', INTERVAL '3 hour', '02.01.2023','31.03.2024', '{1, 2}'); 
 CALL every_day(024,'11:00:00', '18:00:00', INTERVAL '1 hour', '02.01.2023','31.03.2024', '{1, 2}'); 
 CALL every_day(025,'11:00:00', '18:00:00', INTERVAL '2 hour', '02.01.2023','31.03.2024', '{1, 2}'); 

--insert into visitor
--запуск скрипта postgresql_create_table.sql
--запуск скрипта russian_names.sql
CREATE OR REPLACE FUNCTION fn_insert_on_russian_surnames()
RETURNS trigger AS $$
BEGIN
  IF NEW.Sex IS NULL AND (NEW.Surname LIKE '%ов' OR NEW.Surname LIKE '%ев' OR NEW.Surname LIKE '%ёв') THEN
    NEW.Sex := 'М';
	RETURN NEW;
  END IF;
  IF NEW.Sex IS NULL AND (NEW.Surname LIKE '%ова' OR NEW.Surname LIKE '%ева' OR NEW.Surname LIKE '%ёва') THEN
    NEW.Sex := 'Ж';
	RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tr_russian_surnames
BEFORE INSERT ON russian_surnames
FOR EACH ROW
EXECUTE FUNCTION fn_insert_on_russian_surnames();

--запуск скрипта russian_surnames.sql

CREATE OR REPLACE PROCEDURE pr_ins_visitor ( )
   language plpgsql  
   AS $$
   DECLARE crs_vis CURSOR FOR select surname, sex FROM russian_surnames;

   var_name CHAR(100); var_sex CHAR(1); var_surname CHAR(100); id INT := 100000;
   BEGIN
   OPEN crs_vis;
    LOOP
		FETCH crs_vis INTO var_surname, var_sex;
		IF NOT FOUND THEN EXIT;END IF;
		SELECT name into var_name FROM russian_names WHERE russian_names.sex = var_sex ORDER BY random() LIMIT 1;
		INSERT INTO visitor VALUES (id, var_name, var_surname, var_sex);
		id := id + 1;
	END LOOP;
   	CLOSE crs_vis;
	END						
   $$;
 CALL pr_ins_visitor();
DROP TABLE russian_names;
DROP TABLE russian_surnames;

--insert into visitor_shedule
CREATE OR REPLACE PROCEDURE pr_ins_visitor_schedule()
   language plpgsql  
   AS $$
   DECLARE crs_vis CURSOR FOR select visitor_id FROM visitor;
   	sessions timestamp[];
	excursions int[];
	sess_amount int;
	var_visitor_id int;
	var_schedule_id int;
	var_starts_on timestamp;
	var_excursion_id int;
BEGIN
   OPEN crs_vis;
    LOOP
	FETCH crs_vis INTO var_visitor_id;
	IF NOT FOUND THEN EXIT;END IF;
	sessions:='{}';
	excursions:='{}';
	SELECT floor(random() * 5 + 1)::int into sess_amount;
	while sess_amount > 0 
	LOOP
		select schedule_id, excursion_id, starts_on into var_schedule_id, var_excursion_id, var_starts_on from schedule 
		where starts_on <> ALL(sessions) AND var_excursion_id <> ALL(excursions) ORDER BY random() LIMIT 1;
		insert into visitor_schedule VALUES (var_visitor_id, var_schedule_id);
		sessions:= array_append(sessions, var_starts_on);
		excursions:= array_append(excursions, var_excursion_id);
		sess_amount:= sess_amount - 1;
	END LOOP;
	END LOOP;
   	CLOSE crs_vis;
	END;
$$ 
CALL pr_ins_visitor_schedule();
