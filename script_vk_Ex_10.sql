-- ДЗ Вебинар 10 - Теория, Вебинар 10(2) и 12 - практика (10:30)


-- 2. Задание на оконные функции
-- Построить запрос, который будет выводить следующие столбцы:
-- имя группы
-- среднее количество пользователей в группах
-- самый молодой пользователь в группе
-- самый старший пользователь в группе
-- общее количество пользователей в группе
-- всего пользователей в системе
-- отношение в процентах 
-- (общее количество пользователей в группе /  всего пользователей в системе) * 100

/*
 * Создаем объединение из таблиц, из которых будем брать данные: communities (табл. групп), communities_users (для подсчета кол-ва участников в группах), 
 * users (для вывлда фамилии и имени старших и младших поль-лей) и profiles (для нахождения самого старшего и самого младшего поль-ля)
 */


-- Вариант с вложенными запросами в части SELECT

-- Оконные функции начинаются с оператора OVER и настраиваются с помощью трёх других операторов: PARTITION BY, ORDER BY и ROWS.
SELECT DISTINCT 
  communities.name AS group_name,-- 2. Выводим имя группы
-- Для среднего количества пользователей в группах,
  COUNT(communities_users.user_id) OVER()-- подсчитаем user_id в табл. communities_users, т.е. кол-во участников. OVER()-скобки пустые, значит окном является вся выборка.
    / (SELECT COUNT(*) FROM communities) AS avg_users_in_groups,-- и делим на кол-во групп. ЗДЕСЬ это вложенный запрос к табл. communities. См. далее другой вариант. 
 -- Находим старшего и младшего пользотеля    
    FIRST_VALUE(CONCAT_WS(" ", users.first_name, users.last_name))-- Исп-я ф-ю first_value выбираем имя и фамилию, соотвествующих пользотелей и с помощью CONCAT_WS объединяем их в одну строку 
    OVER (w_community ORDER BY profiles.birthday DESC) AS w_community,-- а внутри окна w_community сортируем строки по дню рождения в обратном порядке для w_community  
  FIRST_VALUE(CONCAT_WS(" ", users.first_name, users.last_name)) 
    OVER (w_community ORDER BY profiles.birthday ASC) AS oldest,-- и в прямом порядке для oldest
 -- Подсчет кол-ва пользотелей в каждой группе.
  COUNT(communities_users.user_id) OVER w_community AS users_in_group,-- Подсчет кол-ва строк, т.е. кол-во участников в каждом окне
  (SELECT COUNT(*) FROM users) AS users_total,-- Подсет общего кол-ва пользотелей с помощью вложенного запроса, где SELECT COUNT(*) подсчет количества строк в таблице.
  COUNT(communities_users.user_id) OVER w_community / (SELECT COUNT(*) FROM users) *100 AS '%%'-- находим отношение
  /*
   *1. Важен порядок! Возможно наличие групп, в которых нет пользователей. Что бы в отчет попали все группы (с пользователями и без) 
   *начинаем строить объединение с табл. communities, а все остальные табл. присоединяем с помощью LEFT JOIN. 
   *Таки образом в рез-те получим все группы.  
   */ 
    FROM communities
      LEFT JOIN communities_users 
        ON communities_users.community_id = communities.id
      LEFT JOIN users 
        ON communities_users.user_id = users.id
      LEFT JOIN profiles 
        ON profiles.user_id = users.id
-- Определяем окно, по которому будем работать. Необходимо поделить, что получим из объединения на окна с одинаковыми идентификаторами группы.
-- Так как выполняется аналитика по группам.
-- Определяем окно, присваиваем ему именя w_community и разбиваем его по идентификаторами группы (PARTITION BY communities.id).  
      WINDOW w_community AS (PARTITION BY communities.id);
                              
     /*        
-- Вариант (Более предпочтительный) с вложенными запросами в объединении JOIN (20:00)
-- Т.е. вариант без вложенных запросов в части SELECT.
-- Это можно сделать поместив подсчет кол-ва пол-ей и кол-ва групп сразу в объединение JOIN 
SELECT DISTINCT 
  communities.name AS group_name,
  COUNT(communities_users.user_id) OVER() / total_communities AS avg_users_in_groups,
  FIRST_VALUE(CONCAT_WS(" ", users.first_name, users.last_name)) 
    OVER (w_community ORDER BY profiles.birthday DESC) AS youngest,
  FIRST_VALUE(CONCAT_WS(" ", users.first_name, users.last_name)) 
    OVER (w_community ORDER BY profiles.birthday ASC) AS oldest,
  COUNT(communities_users.user_id) OVER w_community AS users_in_group,
  total_users,
  COUNT(communities_users.user_id) OVER w_community / total_communities * 100 AS '%%'
    FROM 
        (SELECT COUNT(*) AS total_users FROM users) AS tu
  	  CROSS JOIN 
  	    (SELECT COUNT(*) AS total_communities FROM communities) AS tc
  	  CROSS JOIN communities
      LEFT JOIN communities_users 
        ON communities_users.community_id = communities.id
      LEFT JOIN users 
        ON communities_users.user_id = users.id
      LEFT JOIN profiles 
        ON profiles.user_id = users.id
      WINDOW w_community AS (PARTITION BY communities.id); 
     
 
     
           
-- 1. (10:30) Проанализировать какие запросы могут выполняться наиболее часто в
-- процессе работы приложения и добавить необходимые индексы.
     
     * На некоторые столбцы  СУБД создает индексы автоматически - Столбцы Первичного ключа, Внешних ключей и столбцы с ограничением Уникальности.
 * 


     EXPLAIN SELECT id, first_name FROM users ORDER BY id;  
     
         
-- Индексы

-- Создадим индекс на фамилию пользователя
CREATE INDEX users_last_name_idx ON users(last_name);

-- Создадим составной индекс на имя и фамилию пользователя
CREATE INDEX users_first_name_last_name_idx ON users(first_name, last_name);

-- Создадим уникальный индекс на столбец электронной почты
CREATE UNIQUE INDEX users_email_uq ON users(email);

-- Просмотр существующих индексов
SHOW INDEX FROM users;

-- Удаление индексов
ALTER TABLE users DROP INDEX users_first_name_last_name_idx;
ALTER TABLE users DROP index users_email_uq;

*/
 
