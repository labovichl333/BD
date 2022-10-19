#1.	Показать список книг, у которых более одного автора.
SELECT `b_name` FROM (SELECT  `b_name`, COUNT(*) AS `num_of_authors` FROM `books`
JOIN `m2m_books_authors` USING(`b_id`)  GROUP BY (`b_id`)) AS `temporary_data` WHERE `num_of_authors`>1;

#3.	Показать все книги с их жанрами (дублирование названий книг не допускается).
SELECT `b_name`
 AS `book`,
 GROUP_CONCAT(`g_name` ORDER BY `g_name` SEPARATOR ', ')
 AS `gener(s)`
FROM `books`
 JOIN `m2m_books_genres` USING(`b_id`)
 JOIN `genres` USING(`g_id`)
GROUP BY `b_id`
ORDER BY `b_name`;

#5.	Показать список книг, которые когда-либо были взяты читателями.
SELECT `b_id`,
 `b_name` 
 FROM `books`
WHERE `b_id` IN (SELECT distinct `sb_book` FROM `subscriptions`);

#17.	Показать читаемость жанров, т.е. все жанры и то количество раз, которое книги этих жанров были взяты читателями.
SELECT `g_id`,`g_name`,
		COUNT(`sb_book`) AS `num_of_books`
		FROM `genres`
		JOIN `m2m_books_genres` USING(`g_id`)
        LEFT OUTER JOIN `subscriptions` ON `m2m_books_genres`.`b_id`=`sb_book`
        GROUP BY `g_id`;

#18.	Показать самый читаемый жанр, т.е. жанр (или жанры, если их несколько), относя-щиеся к которому книги читатели брали чаще всего.
WITH `prepared_data`
	AS (SELECT `genres`.`g_id`,
		`genres`.`g_name`,
		COUNT(`sb_book`) AS `books`
	FROM `genres`
		JOIN `m2m_books_genres`
		ON `genres`.`g_id` = `m2m_books_genres`.`g_id`
		LEFT OUTER JOIN `subscriptions`
			ON `m2m_books_genres`.`b_id` = `sb_book`
	GROUP BY `genres`.`g_id`,
	`genres`.`g_name`)
SELECT `g_id`,
 `g_name`,
 `books`
FROM `prepared_data`
WHERE `books` = (SELECT MAX(`books`)
	FROM `prepared_data`);
