# 1.	Показать всю информацию об авторах.
SELECT * FROM `authors`;

# 3.	Показать без повторений идентификаторы книг, которые были взяты читателями.
SELECT DISTINCT `sb_book` FROM `subscriptions`;


# 5.	Показать, сколько всего читателей зарегистрировано в библиотеке.
SELECT COUNT(*) AS `count_of_readers` FROM `subscribers`;

# 12.	Показать идентификатор одного (любого) читателя, взявшего в библиотеке больше всего книг.
SELECT `sb_subscriber`  
FROM  (SELECT `sb_subscriber`, COUNT(*) AS `count`
		FROM `subscriptions` GROUP BY `sb_subscriber`) AS `temporary_data` 
        ORDER BY `count` DESC LIMIT 1;

# 13.	Показать идентификаторы всех «самых читающих читателей», взявших в библиоте-ке больше всего книг.
SELECT `sb_subscriber`  
FROM  (SELECT `sb_subscriber`,
 RANK() OVER (ORDER BY `count` DESC) AS `rn`
		FROM (SELECT `sb_subscriber`,
		COUNT(*) AS `count` FROM `subscriptions`
        GROUP BY `sb_subscriber`) AS `temp_data`) AS `temporary_data`
WHERE `rn` = 1;
