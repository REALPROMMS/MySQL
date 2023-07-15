-- 1. Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений 
-- в алфавитном порядке

USE vk_new;

SELECT DISTINCT firstname 
FROM users 
ORDER BY firstname;

-- 2. Выведите количество мужчин старше 35 лет [COUNT].

SELECT COUNT(*)
FROM profiles
WHERE gender = 'm' AND birthday < DATE_SUB(CURDATE(), INTERVAL 35 YEAR);

-- 3. Сколько заявок в друзья в каждом статусе? (таблица friend_requests) [GROUP BY]

SELECT status, COUNT(*) 
FROM friend_requests 
GROUP BY status;

-- 4 Выведите номер пользователя, который отправил больше всех заявок в друзья
-- (таблица friend_requests) [LIMIT].

SELECT initiator_user_id, COUNT(*) AS num_requests
FROM friend_requests
GROUP BY initiator_user_id
ORDER BY num_requests DESC
LIMIT 1;

-- 5  Выведите названия и номера групп, имена которых состоят из 5 символов [LIKE].
SELECT name, id 
FROM communities 
WHERE name LIKE '_____';

