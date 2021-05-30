/*
 * Вы мне ответили пару дней назад:
 * "По проекту нашего сайта gb:
1. Для gender лучше использовать ENUM.
2. Таблица first_quarter_topic_one - это неправильный подход, нельзя путать уровень структуры БД с уровнем данных.
 В процессе эксплуатации структура БД не должна меняться, в вашем варианте постоянно нужно будет добавлять 
 новые таблицы и переписывать приложение для работы с ними. Помните что на таблицы нужно отображать сущности, 
 нет такой сущности как "первый квартал тема 1"
3. По проблемным внешним ключам покажите пожалуйста текст ошибки."

Попробовал внести изменеия. 
Вопрос по ошибке На 441 стр
 */



use gb;
show TABLES;

-- Таблица Пользователей
DROP TABLE IF EXISTS users;
CREATE TABLE users (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY key COMMENT "Идентификатор строки",
first_name VARCHAR(100) NOT null COMMENT "Имя пользователя", 
last_name VARCHAR(100) NOT null COMMENT "Фамилия пользователя",
email VARCHAR(100) NOT null COMMENT "Почта",
phone VARCHAR(100) NOT null COMMENT "Телефон",
created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Пользователи";
select  * from users where created_at > update_at;-- Используем фильтр для поиска дат update более ранних чем дата created
update users set update_at = NOW() where created_at > update_at; -- Запрос на ОБНОВЛЕНИЕ

-- Добавим к сгенерированным пользотелям, ДВУХ РЕАЛЬНЫХ (см. табл. группы)
update users set first_name = 'Виктор', last_name = 'Шупоченко' where users.id = 1;
update users set first_name = 'Михаил', last_name = 'Демин' where users.id = 2;

desc users;
SELECT * from users;


-- Таблица Профилей
DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
user_id INT UNSIGNED NOT NULL PRIMARY key COMMENT "Ссылка на пользователя",
gender CHAR(1) NOT null COMMENT "Пол",
birthday DATE COMMENT "Дата рождения",
city VARCHAR(130) NOT null COMMENT "Город проживания",
country VARCHAR(130) NOT null COMMENT "Страна проживания",
created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Профили";
select  * from profiles where created_at > update_at;-- Используем фильтр для поиска дат update более ранних чем дата created
update profiles set update_at = NOW() where created_at > update_at; -- Запрос на ОБНОВЛЕНИЕ
desc  profiles;
SELECT * from  profiles;
describe  profiles;

-- Создаем Внешние Ключи таблицы profiles
desc profiles;
select * from profiles limit 10;
alter TABLE profiles
ADD CONSTRAINT profiles_user_id_fk
foreign KEY (user_id) REFERENCES users(id)
on delete CASCADE;
-- Меняем в gender тип данных CHAR(1) на ENUM 
ALTER TABLE profiles MODIFY COLUMN gender ENUM('m', 'w');


-- Таблица Учебный год (sessions)
-- Получим таблицу Учебный год с id для каждой четверти
DROP TABLE IF EXISTS sessions;
CREATE TABLE sessions (
  id INT unsigned not null auto_increment PRIMARY KEY,
  user_id INT unsigned,
  topic VARCHAR(100) NOT null COMMENT "Тема",
  first_quarter_id VARCHAR(100) NOT null COMMENT "Первая четверть",
  second_quarter_id VARCHAR(100) NOT null COMMENT "Вторая четверть",
  third_quarter_id VARCHAR(100) NOT null COMMENT "Третья четверть",
  fourth_quarter_id VARCHAR(100) NOT null COMMENT "Четвертая четверть",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Учебный год';
desc sessions;
INSERT into sessions (topic, first_quarter_id, second_quarter_id, third_quarter_id, fourth_quarter_id)
VALUES
  ('Введение в Backend-разработку', 1, 2, 3, 4),
  ('Frontend и Backend интернет-магазина', 1, 2, 3, 4),
  ('Сетевой чат', 1, 2, 3, 4),
  ('Командная разработка выпускного проекта', 1, 2, 3, 4);
 -- Присваиваем значение для user_id вместо NULL
-- ALTER TABLE communities add name_teacher_id INT unsigned after id;
update sessions set user_id = sessions.id;
SELECT * from sessions;

-- Создаем Внешний Ключ таблицы sessions
alter TABLE sessions
ADD CONSTRAINT sessions_user_id_fk
foreign KEY (user_id) REFERENCES users(id)
on delete CASCADE;


-- Таблица Основы языка Python
DROP TABLE IF EXISTS pythons;
CREATE TABLE pythons (
  id INT unsigned not null auto_increment PRIMARY KEY,
  user_id INT UNSIGNED,
  session_id INT UNSIGNED,
  topic VARCHAR(100) NOT null COMMENT "Тема урока",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Основы языка Python';
desc pythons;
select * from pythons;

INSERT into pythons (user_id, session_id, topic) 
values
  (1, 1, 'Урок 1. Знакомство с Python'),
 (2, 1, 'Урок 2. Встроенные типы и операции с ними'),
 (3, 1, 'Урок 3. Функции'),
 (4, 1, 'Урок 4. Полезные инструменты'),
 (5, 1, 'Урок 5. Работа с файлами'),
 (6, 1, 'Урок 6. Объектно-ориентированное программирование'),
 (7, 1, 'Урок 7. ООП. Продвинутый уровень'),
 (8, 1, 'Урок 8. ООП. Полезные дополнения');
desc pythons;
SELECT * FROM pythons limit 10;

-- Создаем Внешний Ключ таблицы pythons
alter TABLE pythons
ADD CONSTRAINT pythons_user_id_fk
foreign KEY (user_id) REFERENCES users(id)
on delete CASCADE;

alter TABLE pythons
ADD CONSTRAINT pythons_session_id_fk
foreign KEY (session_id) REFERENCES sessions(id)
on delete CASCADE;


-- Таблица Linux. Рабочая станция
DROP TABLE IF EXISTS linuxs;
CREATE TABLE linuxs (
  id INT unsigned not null auto_increment PRIMARY KEY,
  user_id INT UNSIGNED,
  session_id INT UNSIGNED,
  topic VARCHAR(100) NOT null COMMENT "Тема урока",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Linux. Рабочая станция';
desc linuxs;

INSERT into linuxs (user_id, session_id, topic) 
values
  (1, 1, 'Урок 1. Введение. Установка ОС'),
 (2, 1, 'Урок 2. Настройка и знакомство с интерфейсом командной строки'),
 (3, 1, 'Урок 3. Пользователи. Управление Пользователями и группами'),
 (4, 1, 'Урок 4. Загрузка ОС и процессы'),
 (5, 1, 'Урок 5. Устройство файловой системы Linux. Понятие Файла и каталога'),
 (6, 1, 'Урок 6. Введение в скрипты bash. Планировщики задач crontab и a'),
 (7, 1, 'Урок 7. Управление пакетами и репозиториями. Основы сетевой безопасности'),
 (8, 1, 'Урок 8. Введение в docker');
desc linuxs;
SELECT * FROM linuxs limit 10;

-- Создаем Внешний Ключ таблицы linuxs
alter TABLE linuxs
ADD CONSTRAINT linuxs_user_id_fk
foreign KEY (user_id) REFERENCES users(id)
on delete CASCADE;

alter TABLE linuxs
ADD CONSTRAINT linuxs_session_id_fk
foreign KEY (session_id) REFERENCES sessions(id)
on delete CASCADE;


-- Таблица Основы реляционных баз данных. MySQL
DROP TABLE IF EXISTS mysqls;
CREATE TABLE mysqls (
  id INT unsigned not null auto_increment PRIMARY KEY,
  user_id INT UNSIGNED,
  session_id INT UNSIGNED,
  topic VARCHAR(150) NOT null COMMENT "Тема урока",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Linux. Рабочая станция';
desc mysqls;

INSERT into mysqls (user_id, session_id, topic) 
values
  (1, 1, 'Урок 1.Вебинар. Установка окружения. DDL - команды'),
 (2, 1, 'Урок 2. Видеоурок. Управление БД. Язык запросов SQL'),
 (3, 1, 'Урок 3. Вебинар. Введение в проектирование БД'),
 (4, 1, 'Урок 4. Вебинар. CRUD-операции'),
 (5, 1, 'Урок 5. Видеоурок. Операторы, фильтрация, сортировка и ограничение. Агрегация данных'),
 (6, 1, 'Урок 6. Вебинар. Операторы, фильтрация, сортировка и ограничение. Агрегация данных'),
 (7, 1, 'УУрок 7. Видеоурок. Сложные запросы'),
 (8, 1, 'Урок 8. Вебинар. Сложные запросы'),
 (9, 1, 'Урок 9. Видеоурок. Транзакции, переменные, представления. Администрирование. Хранимые процедуры и функции, триггеры'),
 (10, 1, 'Урок 10. Вебинар. Транзакции, переменные, представления. Администрирование. Хранимые процедуры и функции, триггеры'),
 (11, 1, 'Урок 11. Видеоурок. Оптимизация запросов. NoSQL'),
 (12, 1, 'Урок 12. Вебинар. Оптимизация запросов');
SELECT * FROM mysqls limit 15;
show tables;

-- Создаем Внешний Ключ таблицы mysqls
alter TABLE mysqls
ADD CONSTRAINT mysqls_user_id_fk
foreign KEY (user_id) REFERENCES users(id)
on delete CASCADE;

alter TABLE mysqls
ADD CONSTRAINT mysqls_session_id_fk
foreign KEY (session_id) REFERENCES sessions(id)
on delete CASCADE;


-- Таблица algorithm_structure_pythons (Алгоритмы и структуры данных на Python. Базовый курс)
DROP TABLE IF EXISTS algorithm_structure_pythons;
CREATE TABLE algorithm_structure_pythons (
  id INT unsigned not null auto_increment PRIMARY KEY,
  user_id INT unsigned COMMENT "Ссылка на пользователя",
  session_id INT UNSIGNED COMMENT "Ссылка на учебный год",
  topic VARCHAR(150) NOT null COMMENT "Тема урока",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Алгоритмы и структуры данных на Python. Базовый курс';
SELECT * from algorithm_structure_pythons;

desc algorithm_structure_pythons;
INSERT into algorithm_structure_pythons (user_id, session_id, topic)
VALUES
  (1, 1, 'Урок 1. Введение в алгоритмизацию и реализация простых алгоритмов на Python'),
 (2, 1, 'Урок 2. Циклы. Рекурсия. Функции.'),
 (3, 1, 'Урок 3. Массивы. Кортежи. Множества. Списки.'),
 (4, 1, 'Урок 4. Эмпирическая оценка алгоритмов на Python'),
 (5, 1, 'Урок 5. Коллекции. Список. Очередь. Словарь.'),
 (6, 1, 'Урок 6. Работа с динамической памятью'),
 (7, 1, 'УУрок 7. Алгоритмы сортировки'),
 (8, 1, 'Урок 8. Деревья. Хэш-функция');
 SELECT * from algorithm_structure_pythons;


-- Создаем Внешний Ключ таблицы algorithm_structure_pythons
alter TABLE algorithm_structure_pythons
ADD CONSTRAINT algorithm_structure_pythons_user_id_fk
foreign KEY (user_id) REFERENCES users(id)
on delete CASCADE;

alter TABLE algorithm_structure_pythons
ADD CONSTRAINT algorithm_structure_pythons_session_id_fk
foreign KEY (session_id) REFERENCES sessions(id)
on delete CASCADE;

/*
 МОЖНО СДЕЛАТЬ ЕЩЕ ТРИ таблицы (три четверти) но БЕЗ данных - ПОЛНЫЕ КОПИИ ПРЕДЫДУЩЕЙ
 * 
second_quarter_id VARCHAR(100) NOT null COMMENT "Вторая четверть",
  third_quarter_id VARCHAR(100) NOT null COMMENT "Третья четверть",
  fourth_quarter_id
*/

show tables;
-- Таблица сообщений (messages)
DROP TABLE IF EXISTS messages;
create table messages (
id INT unsigned not null auto_increment primary key,
from_user_id INT unsigned not null COMMENT "Ссылка на отправителя сообщения",
to_user_id INT unsigned not null COMMENT "Ссылка на получателя сообщения",
body TEXT COMMENT "Текст сообщения",
is_important BOOLEAN COMMENT "Признак важности",
is_delivered BOOLEAN COMMENT "Признак доставки",
create_at DATETIME default CURRENT_TIMESTAMP COMMENT "Время создания строки"
) COMMENT "Сообщения";
desc messages;
SELECT * FROM messages limit 15;

-- Таблица messages Создаем Внешние Ключи
desc messages;
select * from messages;

alter TABLE messages
add CONSTRAINT messages_from_user_id_fk
foreign KEY (from_user_id) REFERENCES users(id)
on delete cascade,
add CONSTRAINT messages_to_user_id_fk
foreign KEY (to_user_id) REFERENCES users(id)
on delete CASCADE;



-- Создаем таблицу "Группы" с РЕАЛЬНЫМИ Имя-Фамилия преподавателей и студентов
DROP TABLE IF EXISTS communities;
create table communities (
id INT unsigned auto_increment primary key COMMENT "Идентификатор строки",
name_teacher VARCHAR(50) COMMENT "Название группы преподавателей",
name_student VARCHAR(50) COMMENT "Название группы преподавателей",
created_at DATETIME default CURRENT_TIMESTAMP COMMENT "Время создания строки",
update_at DATETIME default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Группы";

SELECT * FROM communities limit 15;
-- Внесем Имя-Фамилия преподавателей
INSERT into communities (name_teacher) 
values
  ('Виктор Щупоченко'),
 ('Александр Васильченко'),
 ('Владислав Колокольчиков'),
 ('Павел Тиняков'),
('Сергей Романов'),
('Альбина Гилязова');

-- Внесем Имя-Фамилия студентов
INSERT into communities (name_student) 
values
  ('Михаил Демин'),
 ('Алексей Ероховец'),
 ('Андрей Синицын'),
 ('Роман Аширов'),
('Владимир Черненко'),
('Владислав Семилетов'),
 ('Артем Оболенский'),
 ('Шахин Авад'),
 ('Александра Науменко'),
 ('Антон Дмитриев'),
('Андрей Мусатов'),
('Екатерина Лобанова'),
 ('Сергей Зонов');

ALTER TABLE communities add name_teacher_id INT unsigned after id;
update communities set name_teacher_id = floor(1 + rand() * 100);
-- select name_teacher_id from communities order by name_teacher_id;
ALTER TABLE communities add name_student_id INT unsigned after name_teacher;
update communities set name_student_id = floor(1 + rand() * 100);
select * from communities where name_teacher_id = name_student_id;
SHOW COLUMNS FROM communities;
desc communities;
SELECT * FROM communities limit 15;


-- Таблица связи пользотелей и групп 
drop table if exists communities_users;
create table communities_users (
communities_id INT unsigned not null COMMENT "Ссылка на группу",
users_id INT unsigned not null COMMENT "Ссылка на пользователя",
created_at DATETIME default CURRENT_TIMESTAMP COMMENT "Время создания строки",
primary key (communities_id, users_id) COMMENT "Составной первичный ключ"
) COMMENT "Участники групп, связь между пользователями и группами";
desc communities_users;
SELECT * FROM communities_users;

-- Создаем Внешние Ключи для communities_users
alter TABLE communities_users
ADD CONSTRAINT communities_users_users_id_fk
foreign KEY (users_id) REFERENCES users(id)
on delete CASCADE,
ADD CONSTRAINT communities_users_communities_id_fk
foreign KEY (communities_id) REFERENCES communities(id)
on delete CASCADE;
desc communities_users;


-- Таблица учебных материаллов study_materials_1
drop table if exists study_materials;
DROP TABLE IF EXISTS study_materials_1;
create table study_materials_1 (
id INT unsigned not null auto_increment primary key COMMENT "Идентификатор строки",
user_id INT unsigned not null COMMENT "Ссылка на пользователя, который загрузил файл",
python_id INT unsigned not null COMMENT "Ссылка на тему python",
linux_id INT unsigned not null COMMENT "Ссылка на тему linux",
mysql_id INT unsigned not null COMMENT "Ссылка на тему mysql",
algorithm_structure_python_id INT unsigned not null COMMENT "Ссылка на тему algorithm_structure_python",
filename VARCHAR(250) not null COMMENT "Путь к файлу",
size INT not null COMMENT "Размер файла",
metadata JSON COMMENT "Метаданные файла",
created_at DATETIME default CURRENT_TIMESTAMP COMMENT "Ссылка на тип контента",
update_at DATETIME default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "учебные материаллы";

show tables;
SELECT * FROM study_materials_1;
DESC study_materials_1;

-- UPDATE study_materials SET user_id = FLOOR(1 + RAND() * 100);
-- update study_materials_1 set study_materials_1.id = user_id;

-- СТОЛБЕЦ filename 
-- Где взять расширение? 
-- http://dropbox.com/vk/filename.ext Прописываем путь: имяфайлаИЗтаблицы.случайное расширение
 -- Создаем ВРЕМЕННУЮ таблицу
DROP TABLE IF EXISTS extensions;
CREATE temporary table extensions (name VARCHAR(10));
insert into extensions 
values ('jpeg'), ('png'), ('mp4'), ('mp3'), ('avi'), ('txt'), ('doc'), ('docx'), ('sql'), ('odp'), ('pptx');
select * from extensions;

-- Компануем основной запрос 
update study_materials_1 set filename = concat(
-- Функция concat объеденяет все свои параметры, перечисленные через ЗАПЯТУЮ в ОДНУ строку. Т.е. объеденяет 4 строки (см. следующие ниже) в одну.
'http://dropbox.com/vk/',
filename,
'.',
(select name from extensions order BY RAND() limit 1))-- строка расширения. Сами расширения см. во временной (extensions) таблице
;
SELECT * FROM study_materials_1;

-- СТОЛБЕЦ metadata
-- Сюда помещае любой объект.
-- Должно получиться что-то вроде: '{"ouner": "Ferst Last"}', т.е. '{"КЛЮЧ": "ЗНАЧЕНИЕ - Имя Фамилия"}'
update study_materials_1 set metadata = CONCAT(
-- update media - запрос на обновление и вставляем (set) для столбца metadata ключ-значение ОДНУ строку из нескольких.
'{"ouner": "',
(select CONCAT(first_name, ' ', last_name)-- Имя и фамилию берем из табл. users 
from users where users.id = study_materials_1.user_id),
'"}'
);
select * from study_materials_1 limit 20;
desc study_materials_1;

-- Меняем в metadata Type (longtext) на Type (JSON). Т.е. возвращаем, подмененный, КОРРЕКТНЫЙ тип данных.
-- См. 8-ю стр вебинара 4 (1:11:35)
alter table study_materials_1 modify COLUMN metadata JSON; 

select * from study_materials_1 limit 20;
desc study_materials_1;

-- Создаем Внешние Ключи для study_materials_1
alter TABLE study_materials_1
ADD CONSTRAINT study_materials_1_user_id_fk
foreign KEY (user_id) REFERENCES users(id)
on delete CASCADE;

/*
 !!!!!!!!!!!!!!!! Не удается создать ВТОРОЙ ключ ???????????????7
SQL Error [1452] [23000]: Cannot add or update a child row: 
a foreign key constraint fails (`gb`.`#sql-18d4_19`, 
CONSTRAINT `study_materials_1_python_id_fk` FOREIGN KEY (`python_id`) 
REFERENCES `pythons` (`id`) ON DELETE CASCADE)
*/
  alter TABLE study_materials_1
ADD CONSTRAINT study_materials_1_python_id_fk
foreign KEY (python_id) REFERENCES pythons(id)
on delete CASCADE;
select * from study_materials_1 limit 10;


-- Таблица типов учебных материаллов
show tables;
select * from study_materials_types;
drop table if exists study_materials_types;
CREATE TABLE study_materials_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  study_material_1_id INT unsigned COMMENT "Ссылка на таблицу учебных материаллов (study_materials)",
  name VARCHAR(255) NOT NULL UNIQUE COMMENT "Название типа",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Типы учебных материаллов";
insert into study_materials_types (name) values
('document'),
('presentation'),
('video');
-- select  * from study_materials_types where created_at > updated_at; -- Используем фильтр для поиска дат update более ранних чем дата created
-- update study_materials_types set updated_at = NOW() where created_at > updated_at; 
desc study_materials_types;
UPDATE study_materials_types SET study_material_1_id = FLOOR(1 + RAND() * 100);

insert into study_materials_types (name) values
('document'),
('presentation'),
('video');
select * from study_materials_types limit 10;
desc study_materials_types;



-- Создаем Внешние Ключи для study_materials
alter TABLE study_materials_types
ADD CONSTRAINT study_materials_types_study_material_1_id_fk
foreign KEY (study_material_1_id) REFERENCES study_materials_1(id)
on delete CASCADE;

SELECT * FROM study_materials_1;
select * from study_materials_types;



-- Скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы)

-- UNION объединение
-- Объединение всех тем, изучаемых в ПЕРВОЙ четверти

select id, session_id, topic from pythons
union
select id, session_id, topic from linuxs
union
select id, session_id, topic from mysqls
union
select id, session_id, topic from algorithm_structure_pythons;
-- А, можно ли сохранить объединенную таблицу, как таблицу?



-- Вложенный запрос
select * from pythons;
select * from sessions;
-- select id, session_id, topic from pythons where id = 1;
-- Извлечем первичный ключ табл. pythons, соответсвующий "Урок 1. Знакомство с Python"
select id, topic from pythons where topic = 'Урок 1. Знакомство с Python';
-- Превращаем этот запрос во вложенный запрос
select id, topic from pythons 
where id = (select id from pythons where topic = 'Урок 1. Знакомство с Python');
select id, topic from pythons where id = 1;-- Возврат ОДНОГО значения topic
select id, topic from pythons where id IN (1, 2);-- Возврат ДВУХ значений topic. Исп-я IN !!!!!



-- JOIN соединение таблиц 

select * from sessions;
desc sessions;
select * from pythons;
select * from linuxs;

select pythons.*, linuxs.* from pythons join linuxs;-- Простое объединение (всех столбцов) даблиц pythons и linuxs
-- Т.е. каждая строка ЛЕВОЙ табл. объединяется с КАЖДОЙ строкой правой (1-я строка ЛЕВОЙ соединяется с каждой из 8-ми
-- строк правой. 2-я строка - ток же. И так далее.
select pythons.id, pythons.topic, linuxs.topic from pythons join linuxs;-- Объединение столбцов id, topic даблиц pythons и linuxs
select pythons.topic as python, linuxs.topic as linux from pythons join linuxs where pythons.id = linuxs.id;
  

-- ВНУТРЕННЕЕ объединение (INNER JOIN, можно просто JOIN).  ON вместо WHERE. Аналог  просто JOIN, но более быстрый.
-- Исп-ся, когда необходимо получить пересечение данных
select pythons.id, pythons.topic, linuxs.topic from pythons join linuxs ON pythons.id = linuxs.id;-- Объединение столбцов id, topic даблиц pythons и linuxs


-- ВНЕШНЕЕ ЛЕВОЕ объединение LEFT OUTER JOIN (LEFT JOIN).
-- Слышипь: ВСЕ, ВСЕХ значит ВНЕШНЕЕ объединение

select * from sessions;
select * from pythons;
select * from linuxs;

-- Выводим перечень уроков по теме pythons и название курса 1-ой четверти
select pythons.id, pythons.topic as python, sessions.topic as sessions_topic
from pythons left join sessions ON sessions.id = 1;-- Из ЛЕВОЙ табл. выводятся ВСЕ строки
-- Поменяем местами табл. относительно left join (аналог right JOIN)
select pythons.id, pythons.topic as python, sessions.topic as sessions_topic
from sessions left join pythons ON sessions.id = 1;-- Из ПРАВОЙ табл. выводятся ВСЕ строки

-- Выборка учебных материалов пользователя с id = 11
SELECT study_materials_1.id, users.first_name, users.last_name, study_materials_1.filename, study_materials_1.created_at
  FROM study_materials_1
    JOIN users
      ON study_materials_1.user_id = users.id     
  WHERE study_materials_1.user_id = 11;
 
  
 -- Сообщения от пользователя (teacher - Александр Васильченко)
SELECT communities.name_teacher, messages.body, messages.create_at
  FROM messages
    JOIN communities
      ON communities.id = messages.to_user_id
  WHERE communities.id = 2;
  
 -- Сообщения к пользователю (student - Алексей Ероховец)
SELECT communities.name_student, messages.body, messages.create_at
  FROM messages
    JOIN communities
      ON communities.id = messages.from_user_id
  WHERE communities.id = 8;

-- Объединяем все сообщения от пользователя и к пользователю
SELECT 
  messages.from_user_id, communities.name_teacher AS from_user,
  messages.to_user_id, communities.name_student AS to_user,     
  messages.body, messages.create_at
  FROM communities
    JOIN messages
      ON communities.id = messages.to_user_id
        OR communities.id = messages.from_user_id
    JOIN communities users_from
      ON communities.id = messages.from_user_id
    JOIN communities users_to
      ON communities.id = messages.to_user_id
  WHERE communities.id = 8;



/*!!!!!!!!!!!!!!!!!!!!!!!! ПРЕДСТАВЛЕНИЯ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 * 
 * Представления - еще один способ организации данных в языке запросов SQL.
 * Представление — это запрос на выборку (SELECT), которому присваивается уникальное имя
 и который можно сохранять или удалять из базы данных как обычную хранимую процедуру.
 * Представления позволяют увидеть результаты сохраненного запроса таким образом, как будто это полноценная 
 * таблица базы данных. Представления позволяют более гибко управлять правами доступа к таблицам: можно запретить 
 * прямое обращение пользователей к таблицам, и разрешить доступ только к представлениям.

 * Для создания представления используется команда CREATE VIEW, после которой мы указываем 
 имя представления products_catalogs. Затем после ключевого слова AS пишем запрос представления.
*/
  
-- представление всех столбцов отсортированной таблицы sessions
CREATE VIEW representation AS SELECT id, topic FROM sessions ORDER BY topic;
SELECT * FROM representation;
-- представление 2-х столбцов отсортированной таблицы sessions
CREATE VIEW representation_1 AS SELECT id, topic FROM sessions ORDER BY topic;
SELECT * FROM representation_1;
-- представление 2-х столбцов и замена их имени отсортированной таблицы sessions
CREATE VIEW representation_2 (quarter_number, topic) AS SELECT id, topic FROM sessions ORDER BY topic;
SELECT * FROM representation_2;


-- Представление вывода назвния темы четверти и одной из изучаемых в ней тем
CREATE OR REPLACE VIEW representation_3 as
select session_id as topic_id,
sessions.topic as 'Тема четверти',
pythons.topic as 'Тема: python'
from sessions join pythons
on pythons.session_id = sessions.id; 
SELECT * FROM representation_3;


