-- �� ������� 10 - ������, ������� 10(2) � 12 - �������� (10:30)


-- 2. ������� �� ������� �������
-- ��������� ������, ������� ����� �������� ��������� �������:
-- ��� ������
-- ������� ���������� ������������� � �������
-- ����� ������� ������������ � ������
-- ����� ������� ������������ � ������
-- ����� ���������� ������������� � ������
-- ����� ������������� � �������
-- ��������� � ��������� 
-- (����� ���������� ������������� � ������ /  ����� ������������� � �������) * 100

/*
 * ������� ����������� �� ������, �� ������� ����� ����� ������: communities (����. �����), communities_users (��� �������� ���-�� ���������� � �������), 
 * users (��� ������ ������� � ����� ������� � ������� ����-���) � profiles (��� ���������� ������ �������� � ������ �������� ����-��)
 */


-- ������� � ���������� ��������� � ����� SELECT

-- ������� ������� ���������� � ��������� OVER � ������������� � ������� ��� ������ ����������: PARTITION BY, ORDER BY � ROWS.
SELECT DISTINCT 
  communities.name AS group_name,-- 2. ������� ��� ������
-- ��� �������� ���������� ������������� � �������,
  COUNT(communities_users.user_id) OVER()-- ���������� user_id � ����. communities_users, �.�. ���-�� ����������. OVER()-������ ������, ������ ����� �������� ��� �������.
    / (SELECT COUNT(*) FROM communities) AS avg_users_in_groups,-- � ����� �� ���-�� �����. ����� ��� ��������� ������ � ����. communities. ��. ����� ������ �������. 
 -- ������� �������� � �������� ����������    
    FIRST_VALUE(CONCAT_WS(" ", users.first_name, users.last_name))-- ���-� �-� first_value �������� ��� � �������, �������������� ����������� � � ������� CONCAT_WS ���������� �� � ���� ������ 
    OVER (w_community ORDER BY profiles.birthday DESC) AS w_community,-- � ������ ���� w_community ��������� ������ �� ��� �������� � �������� ������� ��� w_community  
  FIRST_VALUE(CONCAT_WS(" ", users.first_name, users.last_name)) 
    OVER (w_community ORDER BY profiles.birthday ASC) AS oldest,-- � � ������ ������� ��� oldest
 -- ������� ���-�� ����������� � ������ ������.
  COUNT(communities_users.user_id) OVER w_community AS users_in_group,-- ������� ���-�� �����, �.�. ���-�� ���������� � ������ ����
  (SELECT COUNT(*) FROM users) AS users_total,-- ������ ������ ���-�� ����������� � ������� ���������� �������, ��� SELECT COUNT(*) ������� ���������� ����� � �������.
  COUNT(communities_users.user_id) OVER w_community / (SELECT COUNT(*) FROM users) *100 AS '%%'-- ������� ���������
  /*
   *1. ����� �������! �������� ������� �����, � ������� ��� �������������. ��� �� � ����� ������ ��� ������ (� �������������� � ���) 
   *�������� ������� ����������� � ����. communities, � ��� ��������� ����. ������������ � ������� LEFT JOIN. 
   *���� ������� � ���-�� ������� ��� ������.  
   */ 
    FROM communities
      LEFT JOIN communities_users 
        ON communities_users.community_id = communities.id
      LEFT JOIN users 
        ON communities_users.user_id = users.id
      LEFT JOIN profiles 
        ON profiles.user_id = users.id
-- ���������� ����, �� �������� ����� ��������. ���������� ��������, ��� ������� �� ����������� �� ���� � ����������� ���������������� ������.
-- ��� ��� ����������� ��������� �� �������.
-- ���������� ����, ����������� ��� ����� w_community � ��������� ��� �� ���������������� ������ (PARTITION BY communities.id).  
      WINDOW w_community AS (PARTITION BY communities.id);
                              
     /*        
-- ������� (����� ����������������) � ���������� ��������� � ����������� JOIN (20:00)
-- �.�. ������� ��� ��������� �������� � ����� SELECT.
-- ��� ����� ������� �������� ������� ���-�� ���-�� � ���-�� ����� ����� � ����������� JOIN 
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
     
 
     
           
-- 1. (10:30) ���������������� ����� ������� ����� ����������� �������� ����� �
-- �������� ������ ���������� � �������� ����������� �������.
     
     * �� ��������� �������  ���� ������� ������� ������������� - ������� ���������� �����, ������� ������ � ������� � ������������ ������������.
 * 


     EXPLAIN SELECT id, first_name FROM users ORDER BY id;  
     
         
-- �������

-- �������� ������ �� ������� ������������
CREATE INDEX users_last_name_idx ON users(last_name);

-- �������� ��������� ������ �� ��� � ������� ������������
CREATE INDEX users_first_name_last_name_idx ON users(first_name, last_name);

-- �������� ���������� ������ �� ������� ����������� �����
CREATE UNIQUE INDEX users_email_uq ON users(email);

-- �������� ������������ ��������
SHOW INDEX FROM users;

-- �������� ��������
ALTER TABLE users DROP INDEX users_first_name_last_name_idx;
ALTER TABLE users DROP index users_email_uq;

*/
 
