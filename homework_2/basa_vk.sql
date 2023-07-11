-- 1. Создаём базу данных 'vk' используя графический интерфейс 'DBaver'. 

DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

-- 2. Создаем таблицу 'users' используя команду 'CREATE TABLE'.

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамиль', -- COMMENT на случай, если имя неочевидное
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100), -- 123456 => vzx;clvgkajrpo9udfxvsldkrn24l5456345t
	phone BIGINT UNSIGNED UNIQUE,
	
	INDEX users_firstname_lastname_idx(firstname, lastname)

);

-- Заполнил данными таблицу 'users'

INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`)
VALUES
('Гриша', 'Власов', 'chiken@mail.ru', 7000035640),
('Саша', 'Катин', 'chikena@mail.ru', 7000045625),
('Петя', 'Соснов', 'chikens@gmail.ru', 5000456035),
('Миша', 'Пичкин', 'chiken2@mail.ru', 3000045659),
('Алексей', 'Никанов', 'chiken1@mail.ru', 5523400060),
('Антон', 'Смирнов', 'chikeng@gmail.ru', 2000234035),
('Олег', 'Буза', 'chiken7@mail.ru', 1900023428),
('Макс', 'Афоничев', 'chikenaa@ya.ru', 1500645025),
('Денис', 'Сидоров', 'chikensd@mail.ru', 1103450019),
('Паша', 'Антонов', 'chikenasd@ya.ru', 1200234024),
('Степа', 'Маркин', 'chikenasd@mail.ru', 1000234049);

-- 3. Создаем таблицу 'profiles' используя команду 'CREATE TABLE'.

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100)
	
    -- FOREIGN KEY (photo_id) REFERENCES media(id) -- пока рано, т.к. таблицы media еще нет
);

-- 4. Создаем 'FOREIGN KEY' и привязываем две таблицы между собой , а имеено 'users' и 'profiles'.

ALTER TABLE `profiles` ADD CONSTRAINT fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE -- (значение по умолчанию)
    ON DELETE RESTRICT; -- (значение по умолчанию)

-- 5. Создаем таблицу 'messages' используя команду 'CREATE TABLE'.

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(), -- можно будет даже не упоминать это поле при вставке

    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);

-- 6. Создаем таблицу 'friend_requests' используя команду 'CREATE TABLE'.

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	-- id SERIAL, -- изменили на составной ключ (initiator_user_id, target_user_id)
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('requested', 'approved', 'declined', 'unfriended'), # DEFAULT 'requested',
    -- `status` TINYINT(1) UNSIGNED, -- в этом случае в коде хранили бы цифирный enum (0, 1, 2, 3...)
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP, -- можно будет даже не упоминать это поле при обновлении
	
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)-- ,
    -- CHECK (initiator_user_id <> target_user_id)
);
-- чтобы пользователь сам себе не отправил запрос в друзья
-- ALTER TABLE friend_requests 
-- ADD CHECK(initiator_user_id <> target_user_id);

-- 7. Создаем таблицу 'communities' используя команду 'CREATE TABLE'.

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL,
	name VARCHAR(150),
	admin_user_id BIGINT UNSIGNED NOT NULL,
	
	INDEX communities_name_idx(name), -- индексу можно давать свое имя (communities_name_idx)
	FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

-- 8. Создаем таблицу 'users_communities' используя команду 'CREATE TABLE'.

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, community_id), -- чтобы не было 2 записей о пользователе и сообществе
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);

-- 9. Создаем таблицу 'media_types' используя команду 'CREATE TABLE'.

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
    name VARCHAR(255), -- записей мало, поэтому в индексе нет необходимости
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

-- 10. Создаем таблицу 'media' используя команду 'CREATE TABLE'.

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
  	body text,
    filename VARCHAR(255),
    -- file BLOB,    	
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

-- 10. Создаем таблицу 'likes' используя команду 'CREATE TABLE'.

DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW()

    -- PRIMARY KEY (user_id, media_id) – можно было и так вместо id в качестве PK
  	-- слишком увлекаться индексами тоже опасно, рациональнее их добавлять по мере необходимости (напр., провисают по времени какие-то запросы)  

/* намеренно забыли, чтобы позднее увидеть их отсутствие в ER-диаграмме
    , FOREIGN KEY (user_id) REFERENCES users(id)
    , FOREIGN KEY (media_id) REFERENCES media(id)
*/
);

-- 11. Создаем 'FOREIGN KEY' и привязываем две таблицы между собой.

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk 
FOREIGN KEY (media_id) REFERENCES vk.media(id);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk_1 
FOREIGN KEY (user_id) REFERENCES vk.users(id);

ALTER TABLE vk.profiles 
ADD CONSTRAINT profiles_fk_1 
FOREIGN KEY (photo_id) REFERENCES media(id);

-- 12. Создаем таблицу 'photo_albums' используя команду 'CREATE TABLE'.

DROP TABLE IF EXISTS `photo_albums`;
CREATE TABLE `photo_albums` (
	`id` SERIAL,
    `name` VARCHAR(255),
    `user_id` BIGINT UNSIGNED NOT NULL,
	
  	 FOREIGN KEY (user_id) REFERENCES users(id)  
);

DROP TABLE IF EXISTS `sales`;
CREATE TABLE `sales` (
	id INT PRIMARY KEY,
	order_date DATE,
	count_product INT

);

-- Заполнил данными таблицу 'sales'

INSERT INTO sales
(id, order_date, count_product)
VALUES
(1, "2022-01-01",156),
(2, "2022-01-02",180),
(3, "2022-01-03",21),
(4, "2022-01-04",124),
(5, "2022-01-05",341),
(6, "2022-01-06",123),
(7, "2022-01-07",421),
(8, "2022-01-08",22),
(9, "2022-01-09",412),
(11, "2022-01-11",523);

