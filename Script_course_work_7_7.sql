/*
 * �� ��� �������� ���� ���� �����:
 * "�� ������� ������ ����� gb:
1. ��� gender ����� ������������ ENUM.
2. ������� first_quarter_topic_one - ��� ������������ ������, ������ ������ ������� ��������� �� � ������� ������.
 � �������� ������������ ��������� �� �� ������ ��������, � ����� �������� ��������� ����� ����� ��������� 
 ����� ������� � ������������ ���������� ��� ������ � ����. ������� ��� �� ������� ����� ���������� ��������, 
 ��� ����� �������� ��� "������ ������� ���� 1"
3. �� ���������� ������� ������ �������� ���������� ����� ������."

���������� ������ ��������. 
������ �� ������ �� 441 ���
 */



use gb;
show TABLES;

-- ������� �������������
DROP TABLE IF EXISTS users;
CREATE TABLE users (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY key COMMENT "������������� ������",
first_name VARCHAR(100) NOT null COMMENT "��� ������������", 
last_name VARCHAR(100) NOT null COMMENT "������� ������������",
email VARCHAR(100) NOT null COMMENT "�����",
phone VARCHAR(100) NOT null COMMENT "�������",
created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "������������";
select  * from users where created_at > update_at;-- ���������� ������ ��� ������ ��� update ����� ������ ��� ���� created
update users set update_at = NOW() where created_at > update_at; -- ������ �� ����������

-- ������� � ��������������� �����������, ���� �������� (��. ����. ������)
update users set first_name = '������', last_name = '���������' where users.id = 1;
update users set first_name = '������', last_name = '�����' where users.id = 2;

desc users;
SELECT * from users;


-- ������� ��������
DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
user_id INT UNSIGNED NOT NULL PRIMARY key COMMENT "������ �� ������������",
gender CHAR(1) NOT null COMMENT "���",
birthday DATE COMMENT "���� ��������",
city VARCHAR(130) NOT null COMMENT "����� ����������",
country VARCHAR(130) NOT null COMMENT "������ ����������",
created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "�������";
select  * from profiles where created_at > update_at;-- ���������� ������ ��� ������ ��� update ����� ������ ��� ���� created
update profiles set update_at = NOW() where created_at > update_at; -- ������ �� ����������
desc  profiles;
SELECT * from  profiles;
describe  profiles;

-- ������� ������� ����� ������� profiles
desc profiles;
select * from profiles limit 10;
alter TABLE profiles
ADD CONSTRAINT profiles_user_id_fk
foreign KEY (user_id) REFERENCES users(id)
on delete CASCADE;
-- ������ � gender ��� ������ CHAR(1) �� ENUM 
ALTER TABLE profiles MODIFY COLUMN gender ENUM('m', 'w');


-- ������� ������� ��� (sessions)
-- ������� ������� ������� ��� � id ��� ������ ��������
DROP TABLE IF EXISTS sessions;
CREATE TABLE sessions (
  id INT unsigned not null auto_increment PRIMARY KEY,
  user_id INT unsigned,
  topic VARCHAR(100) NOT null COMMENT "����",
  first_quarter_id VARCHAR(100) NOT null COMMENT "������ ��������",
  second_quarter_id VARCHAR(100) NOT null COMMENT "������ ��������",
  third_quarter_id VARCHAR(100) NOT null COMMENT "������ ��������",
  fourth_quarter_id VARCHAR(100) NOT null COMMENT "��������� ��������",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = '������� ���';
desc sessions;
INSERT into sessions (topic, first_quarter_id, second_quarter_id, third_quarter_id, fourth_quarter_id)
VALUES
  ('�������� � Backend-����������', 1, 2, 3, 4),
  ('Frontend � Backend ��������-��������', 1, 2, 3, 4),
  ('������� ���', 1, 2, 3, 4),
  ('��������� ���������� ���������� �������', 1, 2, 3, 4);
 -- ����������� �������� ��� user_id ������ NULL
-- ALTER TABLE communities add name_teacher_id INT unsigned after id;
update sessions set user_id = sessions.id;
SELECT * from sessions;

-- ������� ������� ���� ������� sessions
alter TABLE sessions
ADD CONSTRAINT sessions_user_id_fk
foreign KEY (user_id) REFERENCES users(id)
on delete CASCADE;


-- ������� ������ ����� Python
DROP TABLE IF EXISTS pythons;
CREATE TABLE pythons (
  id INT unsigned not null auto_increment PRIMARY KEY,
  user_id INT UNSIGNED,
  session_id INT UNSIGNED,
  topic VARCHAR(100) NOT null COMMENT "���� �����",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = '������ ����� Python';
desc pythons;
select * from pythons;

INSERT into pythons (user_id, session_id, topic) 
values
  (1, 1, '���� 1. ���������� � Python'),
 (2, 1, '���� 2. ���������� ���� � �������� � ����'),
 (3, 1, '���� 3. �������'),
 (4, 1, '���� 4. �������� �����������'),
 (5, 1, '���� 5. ������ � �������'),
 (6, 1, '���� 6. ��������-��������������� ����������������'),
 (7, 1, '���� 7. ���. ����������� �������'),
 (8, 1, '���� 8. ���. �������� ����������');
desc pythons;
SELECT * FROM pythons limit 10;

-- ������� ������� ���� ������� pythons
alter TABLE pythons
ADD CONSTRAINT pythons_user_id_fk
foreign KEY (user_id) REFERENCES users(id)
on delete CASCADE;

alter TABLE pythons
ADD CONSTRAINT pythons_session_id_fk
foreign KEY (session_id) REFERENCES sessions(id)
on delete CASCADE;


-- ������� Linux. ������� �������
DROP TABLE IF EXISTS linuxs;
CREATE TABLE linuxs (
  id INT unsigned not null auto_increment PRIMARY KEY,
  user_id INT UNSIGNED,
  session_id INT UNSIGNED,
  topic VARCHAR(100) NOT null COMMENT "���� �����",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Linux. ������� �������';
desc linuxs;

INSERT into linuxs (user_id, session_id, topic) 
values
  (1, 1, '���� 1. ��������. ��������� ��'),
 (2, 1, '���� 2. ��������� � ���������� � ����������� ��������� ������'),
 (3, 1, '���� 3. ������������. ���������� �������������� � ��������'),
 (4, 1, '���� 4. �������� �� � ��������'),
 (5, 1, '���� 5. ���������� �������� ������� Linux. ������� ����� � ��������'),
 (6, 1, '���� 6. �������� � ������� bash. ������������ ����� crontab � a'),
 (7, 1, '���� 7. ���������� �������� � �������������. ������ ������� ������������'),
 (8, 1, '���� 8. �������� � docker');
desc linuxs;
SELECT * FROM linuxs limit 10;

-- ������� ������� ���� ������� linuxs
alter TABLE linuxs
ADD CONSTRAINT linuxs_user_id_fk
foreign KEY (user_id) REFERENCES users(id)
on delete CASCADE;

alter TABLE linuxs
ADD CONSTRAINT linuxs_session_id_fk
foreign KEY (session_id) REFERENCES sessions(id)
on delete CASCADE;


-- ������� ������ ����������� ��� ������. MySQL
DROP TABLE IF EXISTS mysqls;
CREATE TABLE mysqls (
  id INT unsigned not null auto_increment PRIMARY KEY,
  user_id INT UNSIGNED,
  session_id INT UNSIGNED,
  topic VARCHAR(150) NOT null COMMENT "���� �����",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Linux. ������� �������';
desc mysqls;

INSERT into mysqls (user_id, session_id, topic) 
values
  (1, 1, '���� 1.�������. ��������� ���������. DDL - �������'),
 (2, 1, '���� 2. ���������. ���������� ��. ���� �������� SQL'),
 (3, 1, '���� 3. �������. �������� � �������������� ��'),
 (4, 1, '���� 4. �������. CRUD-��������'),
 (5, 1, '���� 5. ���������. ���������, ����������, ���������� � �����������. ��������� ������'),
 (6, 1, '���� 6. �������. ���������, ����������, ���������� � �����������. ��������� ������'),
 (7, 1, '����� 7. ���������. ������� �������'),
 (8, 1, '���� 8. �������. ������� �������'),
 (9, 1, '���� 9. ���������. ����������, ����������, �������������. �����������������. �������� ��������� � �������, ��������'),
 (10, 1, '���� 10. �������. ����������, ����������, �������������. �����������������. �������� ��������� � �������, ��������'),
 (11, 1, '���� 11. ���������. ����������� ��������. NoSQL'),
 (12, 1, '���� 12. �������. ����������� ��������');
SELECT * FROM mysqls limit 15;
show tables;

-- ������� ������� ���� ������� mysqls
alter TABLE mysqls
ADD CONSTRAINT mysqls_user_id_fk
foreign KEY (user_id) REFERENCES users(id)
on delete CASCADE;

alter TABLE mysqls
ADD CONSTRAINT mysqls_session_id_fk
foreign KEY (session_id) REFERENCES sessions(id)
on delete CASCADE;


-- ������� algorithm_structure_pythons (��������� � ��������� ������ �� Python. ������� ����)
DROP TABLE IF EXISTS algorithm_structure_pythons;
CREATE TABLE algorithm_structure_pythons (
  id INT unsigned not null auto_increment PRIMARY KEY,
  user_id INT unsigned COMMENT "������ �� ������������",
  session_id INT UNSIGNED COMMENT "������ �� ������� ���",
  topic VARCHAR(150) NOT null COMMENT "���� �����",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = '��������� � ��������� ������ �� Python. ������� ����';
SELECT * from algorithm_structure_pythons;

desc algorithm_structure_pythons;
INSERT into algorithm_structure_pythons (user_id, session_id, topic)
VALUES
  (1, 1, '���� 1. �������� � �������������� � ���������� ������� ���������� �� Python'),
 (2, 1, '���� 2. �����. ��������. �������.'),
 (3, 1, '���� 3. �������. �������. ���������. ������.'),
 (4, 1, '���� 4. ������������ ������ ���������� �� Python'),
 (5, 1, '���� 5. ���������. ������. �������. �������.'),
 (6, 1, '���� 6. ������ � ������������ �������'),
 (7, 1, '����� 7. ��������� ����������'),
 (8, 1, '���� 8. �������. ���-�������');
 SELECT * from algorithm_structure_pythons;


-- ������� ������� ���� ������� algorithm_structure_pythons
alter TABLE algorithm_structure_pythons
ADD CONSTRAINT algorithm_structure_pythons_user_id_fk
foreign KEY (user_id) REFERENCES users(id)
on delete CASCADE;

alter TABLE algorithm_structure_pythons
ADD CONSTRAINT algorithm_structure_pythons_session_id_fk
foreign KEY (session_id) REFERENCES sessions(id)
on delete CASCADE;

/*
 ����� ������� ��� ��� ������� (��� ��������) �� ��� ������ - ������ ����� ����������
 * 
second_quarter_id VARCHAR(100) NOT null COMMENT "������ ��������",
  third_quarter_id VARCHAR(100) NOT null COMMENT "������ ��������",
  fourth_quarter_id
*/

show tables;
-- ������� ��������� (messages)
DROP TABLE IF EXISTS messages;
create table messages (
id INT unsigned not null auto_increment primary key,
from_user_id INT unsigned not null COMMENT "������ �� ����������� ���������",
to_user_id INT unsigned not null COMMENT "������ �� ���������� ���������",
body TEXT COMMENT "����� ���������",
is_important BOOLEAN COMMENT "������� ��������",
is_delivered BOOLEAN COMMENT "������� ��������",
create_at DATETIME default CURRENT_TIMESTAMP COMMENT "����� �������� ������"
) COMMENT "���������";
desc messages;
SELECT * FROM messages limit 15;

-- ������� messages ������� ������� �����
desc messages;
select * from messages;

alter TABLE messages
add CONSTRAINT messages_from_user_id_fk
foreign KEY (from_user_id) REFERENCES users(id)
on delete cascade,
add CONSTRAINT messages_to_user_id_fk
foreign KEY (to_user_id) REFERENCES users(id)
on delete CASCADE;



-- ������� ������� "������" � ��������� ���-������� �������������� � ���������
DROP TABLE IF EXISTS communities;
create table communities (
id INT unsigned auto_increment primary key COMMENT "������������� ������",
name_teacher VARCHAR(50) COMMENT "�������� ������ ��������������",
name_student VARCHAR(50) COMMENT "�������� ������ ��������������",
created_at DATETIME default CURRENT_TIMESTAMP COMMENT "����� �������� ������",
update_at DATETIME default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "������";

SELECT * FROM communities limit 15;
-- ������ ���-������� ��������������
INSERT into communities (name_teacher) 
values
  ('������ ���������'),
 ('��������� �����������'),
 ('��������� �������������'),
 ('����� �������'),
('������ �������'),
('������� ��������');

-- ������ ���-������� ���������
INSERT into communities (name_student) 
values
  ('������ �����'),
 ('������� ��������'),
 ('������ �������'),
 ('����� ������'),
('�������� ��������'),
('��������� ���������'),
 ('����� ����������'),
 ('����� ����'),
 ('���������� ��������'),
 ('����� ��������'),
('������ �������'),
('��������� ��������'),
 ('������ �����');

ALTER TABLE communities add name_teacher_id INT unsigned after id;
update communities set name_teacher_id = floor(1 + rand() * 100);
-- select name_teacher_id from communities order by name_teacher_id;
ALTER TABLE communities add name_student_id INT unsigned after name_teacher;
update communities set name_student_id = floor(1 + rand() * 100);
select * from communities where name_teacher_id = name_student_id;
SHOW COLUMNS FROM communities;
desc communities;
SELECT * FROM communities limit 15;


-- ������� ����� ����������� � ����� 
drop table if exists communities_users;
create table communities_users (
communities_id INT unsigned not null COMMENT "������ �� ������",
users_id INT unsigned not null COMMENT "������ �� ������������",
created_at DATETIME default CURRENT_TIMESTAMP COMMENT "����� �������� ������",
primary key (communities_id, users_id) COMMENT "��������� ��������� ����"
) COMMENT "��������� �����, ����� ����� �������������� � ��������";
desc communities_users;
SELECT * FROM communities_users;

-- ������� ������� ����� ��� communities_users
alter TABLE communities_users
ADD CONSTRAINT communities_users_users_id_fk
foreign KEY (users_id) REFERENCES users(id)
on delete CASCADE,
ADD CONSTRAINT communities_users_communities_id_fk
foreign KEY (communities_id) REFERENCES communities(id)
on delete CASCADE;
desc communities_users;


-- ������� ������� ����������� study_materials_1
drop table if exists study_materials;
DROP TABLE IF EXISTS study_materials_1;
create table study_materials_1 (
id INT unsigned not null auto_increment primary key COMMENT "������������� ������",
user_id INT unsigned not null COMMENT "������ �� ������������, ������� �������� ����",
python_id INT unsigned not null COMMENT "������ �� ���� python",
linux_id INT unsigned not null COMMENT "������ �� ���� linux",
mysql_id INT unsigned not null COMMENT "������ �� ���� mysql",
algorithm_structure_python_id INT unsigned not null COMMENT "������ �� ���� algorithm_structure_python",
filename VARCHAR(250) not null COMMENT "���� � �����",
size INT not null COMMENT "������ �����",
metadata JSON COMMENT "���������� �����",
created_at DATETIME default CURRENT_TIMESTAMP COMMENT "������ �� ��� ��������",
update_at DATETIME default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "������� ����������";

show tables;
SELECT * FROM study_materials_1;
DESC study_materials_1;

-- UPDATE study_materials SET user_id = FLOOR(1 + RAND() * 100);
-- update study_materials_1 set study_materials_1.id = user_id;

-- ������� filename 
-- ��� ����� ����������? 
-- http://dropbox.com/vk/filename.ext ����������� ����: �����������������.��������� ����������
 -- ������� ��������� �������
DROP TABLE IF EXISTS extensions;
CREATE temporary table extensions (name VARCHAR(10));
insert into extensions 
values ('jpeg'), ('png'), ('mp4'), ('mp3'), ('avi'), ('txt'), ('doc'), ('docx'), ('sql'), ('odp'), ('pptx');
select * from extensions;

-- ��������� �������� ������ 
update study_materials_1 set filename = concat(
-- ������� concat ���������� ��� ���� ���������, ������������� ����� ������� � ���� ������. �.�. ���������� 4 ������ (��. ��������� ����) � ����.
'http://dropbox.com/vk/',
filename,
'.',
(select name from extensions order BY RAND() limit 1))-- ������ ����������. ���� ���������� ��. �� ��������� (extensions) �������
;
SELECT * FROM study_materials_1;

-- ������� metadata
-- ���� ������� ����� ������.
-- ������ ���������� ���-�� �����: '{"ouner": "Ferst Last"}', �.�. '{"����": "�������� - ��� �������"}'
update study_materials_1 set metadata = CONCAT(
-- update media - ������ �� ���������� � ��������� (set) ��� ������� metadata ����-�������� ���� ������ �� ����������.
'{"ouner": "',
(select CONCAT(first_name, ' ', last_name)-- ��� � ������� ����� �� ����. users 
from users where users.id = study_materials_1.user_id),
'"}'
);
select * from study_materials_1 limit 20;
desc study_materials_1;

-- ������ � metadata Type (longtext) �� Type (JSON). �.�. ����������, �����������, ���������� ��� ������.
-- ��. 8-� ��� �������� 4 (1:11:35)
alter table study_materials_1 modify COLUMN metadata JSON; 

select * from study_materials_1 limit 20;
desc study_materials_1;

-- ������� ������� ����� ��� study_materials_1
alter TABLE study_materials_1
ADD CONSTRAINT study_materials_1_user_id_fk
foreign KEY (user_id) REFERENCES users(id)
on delete CASCADE;

/*
 !!!!!!!!!!!!!!!! �� ������� ������� ������ ���� ???????????????7
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


-- ������� ����� ������� �����������
show tables;
select * from study_materials_types;
drop table if exists study_materials_types;
CREATE TABLE study_materials_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������",
  study_material_1_id INT unsigned COMMENT "������ �� ������� ������� ����������� (study_materials)",
  name VARCHAR(255) NOT NULL UNIQUE COMMENT "�������� ����",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "���� ������� �����������";
insert into study_materials_types (name) values
('document'),
('presentation'),
('video');
-- select  * from study_materials_types where created_at > updated_at; -- ���������� ������ ��� ������ ��� update ����� ������ ��� ���� created
-- update study_materials_types set updated_at = NOW() where created_at > updated_at; 
desc study_materials_types;
UPDATE study_materials_types SET study_material_1_id = FLOOR(1 + RAND() * 100);

insert into study_materials_types (name) values
('document'),
('presentation'),
('video');
select * from study_materials_types limit 10;
desc study_materials_types;



-- ������� ������� ����� ��� study_materials
alter TABLE study_materials_types
ADD CONSTRAINT study_materials_types_study_material_1_id_fk
foreign KEY (study_material_1_id) REFERENCES study_materials_1(id)
on delete CASCADE;

SELECT * FROM study_materials_1;
select * from study_materials_types;



-- ������� ����������� ������� (���������� �����������, JOIN'�, ��������� �������)

-- UNION �����������
-- ����������� ���� ���, ��������� � ������ ��������

select id, session_id, topic from pythons
union
select id, session_id, topic from linuxs
union
select id, session_id, topic from mysqls
union
select id, session_id, topic from algorithm_structure_pythons;
-- �, ����� �� ��������� ������������ �������, ��� �������?



-- ��������� ������
select * from pythons;
select * from sessions;
-- select id, session_id, topic from pythons where id = 1;
-- �������� ��������� ���� ����. pythons, �������������� "���� 1. ���������� � Python"
select id, topic from pythons where topic = '���� 1. ���������� � Python';
-- ���������� ���� ������ �� ��������� ������
select id, topic from pythons 
where id = (select id from pythons where topic = '���� 1. ���������� � Python');
select id, topic from pythons where id = 1;-- ������� ������ �������� topic
select id, topic from pythons where id IN (1, 2);-- ������� ���� �������� topic. ���-� IN !!!!!



-- JOIN ���������� ������ 

select * from sessions;
desc sessions;
select * from pythons;
select * from linuxs;

select pythons.*, linuxs.* from pythons join linuxs;-- ������� ����������� (���� ��������) ������ pythons � linuxs
-- �.�. ������ ������ ����� ����. ������������ � ������ ������� ������ (1-� ������ ����� ����������� � ������ �� 8-��
-- ����� ������. 2-� ������ - ��� ��. � ��� �����.
select pythons.id, pythons.topic, linuxs.topic from pythons join linuxs;-- ����������� �������� id, topic ������ pythons � linuxs
select pythons.topic as python, linuxs.topic as linux from pythons join linuxs where pythons.id = linuxs.id;
  

-- ���������� ����������� (INNER JOIN, ����� ������ JOIN).  ON ������ WHERE. ������  ������ JOIN, �� ����� �������.
-- ���-��, ����� ���������� �������� ����������� ������
select pythons.id, pythons.topic, linuxs.topic from pythons join linuxs ON pythons.id = linuxs.id;-- ����������� �������� id, topic ������ pythons � linuxs


-- ������� ����� ����������� LEFT OUTER JOIN (LEFT JOIN).
-- �������: ���, ���� ������ ������� �����������

select * from sessions;
select * from pythons;
select * from linuxs;

-- ������� �������� ������ �� ���� pythons � �������� ����� 1-�� ��������
select pythons.id, pythons.topic as python, sessions.topic as sessions_topic
from pythons left join sessions ON sessions.id = 1;-- �� ����� ����. ��������� ��� ������
-- �������� ������� ����. ������������ left join (������ right JOIN)
select pythons.id, pythons.topic as python, sessions.topic as sessions_topic
from sessions left join pythons ON sessions.id = 1;-- �� ������ ����. ��������� ��� ������

-- ������� ������� ���������� ������������ � id = 11
SELECT study_materials_1.id, users.first_name, users.last_name, study_materials_1.filename, study_materials_1.created_at
  FROM study_materials_1
    JOIN users
      ON study_materials_1.user_id = users.id     
  WHERE study_materials_1.user_id = 11;
 
  
 -- ��������� �� ������������ (teacher - ��������� �����������)
SELECT communities.name_teacher, messages.body, messages.create_at
  FROM messages
    JOIN communities
      ON communities.id = messages.to_user_id
  WHERE communities.id = 2;
  
 -- ��������� � ������������ (student - ������� ��������)
SELECT communities.name_student, messages.body, messages.create_at
  FROM messages
    JOIN communities
      ON communities.id = messages.from_user_id
  WHERE communities.id = 8;

-- ���������� ��� ��������� �� ������������ � � ������������
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



/*!!!!!!!!!!!!!!!!!!!!!!!! ������������� !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 * 
 * ������������� - ��� ���� ������ ����������� ������ � ����� �������� SQL.
 * ������������� � ��� ������ �� ������� (SELECT), �������� ������������� ���������� ���
 � ������� ����� ��������� ��� ������� �� ���� ������ ��� ������� �������� ���������.
 * ������������� ��������� ������� ���������� ������������ ������� ����� �������, ��� ����� ��� ����������� 
 * ������� ���� ������. ������������� ��������� ����� ����� ��������� ������� ������� � ��������: ����� ��������� 
 * ������ ��������� ������������� � ��������, � ��������� ������ ������ � ��������������.

 * ��� �������� ������������� ������������ ������� CREATE VIEW, ����� ������� �� ��������� 
 ��� ������������� products_catalogs. ����� ����� ��������� ����� AS ����� ������ �������������.
*/
  
-- ������������� ���� �������� ��������������� ������� sessions
CREATE VIEW representation AS SELECT id, topic FROM sessions ORDER BY topic;
SELECT * FROM representation;
-- ������������� 2-� �������� ��������������� ������� sessions
CREATE VIEW representation_1 AS SELECT id, topic FROM sessions ORDER BY topic;
SELECT * FROM representation_1;
-- ������������� 2-� �������� � ������ �� ����� ��������������� ������� sessions
CREATE VIEW representation_2 (quarter_number, topic) AS SELECT id, topic FROM sessions ORDER BY topic;
SELECT * FROM representation_2;


-- ������������� ������ ������� ���� �������� � ����� �� ��������� � ��� ���
CREATE OR REPLACE VIEW representation_3 as
select session_id as topic_id,
sessions.topic as '���� ��������',
pythons.topic as '����: python'
from sessions join pythons
on pythons.session_id = sessions.id; 
SELECT * FROM representation_3;


