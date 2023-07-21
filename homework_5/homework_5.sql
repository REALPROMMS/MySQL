-- 1.	Создайте представление с произвольным SELECT-запросом из прошлых уроков [CREATE VIEW]
-- Количество друзей у каждого пользователя

SELECT 
	COUNT(*) AS cnt,
	u.id
FROM users AS u
JOIN friend_requests AS fr ON (
	u.id = fr.target_user_id OR u.id = fr.initiator_user_id 
)
WHERE fr.status = 'approved'
GROUP BY u.id
ORDER BY cnt DESC;


CREATE OR REPLACE VIEW friends_amount AS 
SELECT 
	COUNT(*) AS cnt,
	u.id
FROM users AS u
JOIN friend_requests AS fr ON (
	u.id = fr.target_user_id OR u.id = fr.initiator_user_id 
)
WHERE fr.status = 'approved'
GROUP BY u.id
ORDER BY cnt DESC;


-- 2.	Выведите данные, используя написанное представление [SELECT]

SELECT * FROM friends_amount;


-- 3.	Удалите представление [DROP VIEW]

DROP VIEW friends_amount;

