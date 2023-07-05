-- 1. Создайте таблицу с мобильными телефонами, используя графический интерфейс. 

CREATE TABLE `realpromms`.`mobile_phones` (
  `idmobile_phones` INT NOT NULL AUTO_INCREMENT,
  `product_name` VARCHAR(45) NOT NULL,
  `manufacturers` VARCHAR(45) NOT NULL,
  `product_count` INT NOT NULL,
  `price` DECIMAL NOT NULL,
  PRIMARY KEY (`idmobile_phones`));

-- Заполните БД данными

INSERT INTO `realpromms`.`mobile_phones` (`product_name`, `manufacturers`, `product_count`, `price`)
VALUES 
('Galaxy S22 Ultra', 'Samsung', '5', '86254');
('Galaxy A23 4/64 Gb', 'Samsung', '50', '17524');
('Galaxy Note20 Ultra 12/256 Gb', 'Samsung', '3', '58456');
('iPhone 11 128 Gb', 'Apple', '22', '32598');
('iPhone 12 64 Gb', 'Apple', '14', '42154');
('iPhone 13 128 Gb', 'Apple', '9', '52487');
('Redmi Note 10 Pro 6/128 Gb', 'Xiaomi', '24', '17548');
('Redmi 10 2022 4/64 Gb', 'Xiaomi', '74', '11845');
('Redmi A1+ 2/32 Gb', 'Xiaomi', '30', '6451');

-- Напишите SELECT-запрос, который выводит название товара, производителя и цену для товаров, количество которых превышает 2

SELECT product_name, manufacturers, price
FROM mobile_phones
WHERE product_count > 2;

-- Выведите SELECT-запросом весь ассортимент товаров марки “Samsung”

SELECT * FROM mobile_phones
WHERE manufacturer = "Samsung";

-- Выведите информацию о телефонах, где суммарный чек больше 100 000 и меньше 145 000**

SELECT product_name, manufacturer, product_count, price, price * product_count AS total_price
FROM mobile_phones
WHERE price * product_count > 100000 AND price * product_count < 145000;

-- С помощью регулярных выражений найти nовары, в которых есть упоминание "Iphone"

SELECT * FROM mobile_phones
WHERE product_name 
LIKE "iPhone%";

-- С помощью регулярных выражений найти "Galaxy"

SELECT * FROM mobile_phones
WHERE product_name 
LIKE "%Galaxy%"; 


-- С помощью регулярных выражений найти товары, в которых есть ЦИФРЫ

SELECT * FROM mobile_phones
WHERE product_name 
RLIKE "[0-9]";

-- С помощью регулярных выражений найти товары, в которых есть ЦИФРА "8"  

SELECT * FROM mobile_phones
WHERE product_name
RLIKE "[8]";
