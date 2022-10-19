#1.	Показать список книг, у которых более одного автора.
SELECT `b_name` FROM (SELECT  `b_name`, COUNT(*) AS `num_of_authors` FROM `books`
JOIN `m2m_books_authors` USING(`b_id`)  GROUP BY (`b_id`)) AS `temporary_data` WHERE `num_of_authors`>1;


#2.	Показать список книг, относящихся ровно к одному жанру
SELECT `b_name` FROM (SELECT  `b_name`, COUNT(*) AS `num_of_genres` FROM `books`
JOIN `m2m_books_genres` USING(`b_id`) GROUP BY (`b_id`)) AS `temporary_data` WHERE `num_of_genres`=1;

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

#4.	Показать всех авторов со всеми написанными ими книгами и всеми жанрами, 
#в ко-торых они работали (дублирование имён авторов, названий книг и жанров не допус-кается).
SELECT `b_name`
 AS `book`,
 GROUP_CONCAT(DISTINCT `a_name` ORDER BY `a_name` SEPARATOR ', ')
 AS `author(s)`,
 GROUP_CONCAT(DISTINCT `g_name` ORDER BY `g_name` SEPARATOR ', ')
 AS `genre(s)`
FROM `books`
 JOIN `m2m_books_authors` USING(`b_id`)
 JOIN `authors` USING(`a_id`)
 JOIN `m2m_books_genres` USING(`b_id`)
 JOIN `genres` USING(`g_id`)
GROUP BY `b_id`
ORDER BY `b_name`;

#5.	Показать список книг, которые когда-либо были взяты читателями.
SELECT `b_id`,
 `b_name` 
 FROM `books`
WHERE `b_id` IN (SELECT distinct `sb_book` FROM `subscriptions`);

#6.	Показать список книг, которые никто из читателей никогда не брал.
SELECT `b_id`,
 `b_name` 
 FROM `books`
WHERE `b_id` NOT IN (SELECT distinct `sb_book` FROM `subscriptions`);

#7.	Показать список книг, ни один экземпляр которых сейчас не находится на руках у читателей.
SELECT `b_id`,
 `b_name` 
		FROM `books`
		WHERE `b_id` NOT IN (SELECT distinct `sb_book`
		FROM `subscriptions`
		WHERE `sb_is_active`='Y');

#8.	Показать книги, написанные Пушкиным и/или Азимовым (индивидуально или в соавторстве – не важно).
SELECT  `b_name`
FROM `books`
WHERE `b_id` IN (SELECT  DISTINCT `b_id`
				FROM `m2m_books_authors` WHERE `a_id` IN 
                (SELECT `a_id` FROM `authors` WHERE `a_name` 
                IN('А.С. Пушкин','А. Азимов')));
                
#9.	Показать книги, написанные Карнеги и Страуструпом в соавторстве.
#SELECT `b_id`,
#	`b_name`
#FROM `books`
#where (SELECT `a_name`,`b_name` FROM `books`
#JOIN `m2m_books_authors` USING(`b_id`)
#JOIN authors USING (`a_id`))  ('А.С. Пушкин','А. Азимов');

#10.	Показать авторов, написавших более одной книги.
SELECT `a_id`,
 `a_name`,
 COUNT(`b_id`) AS `books_count`
FROM `authors`
 JOIN `m2m_books_authors` USING (`a_id`)
GROUP BY `a_id`
HAVING `books_count` > 1 ;

#11.	Показать книги, относящиеся к более чем одному жанру
SELECT `b_id`,
	`b_name`,
    COUNT(*) AS `genres_count`
FROM `books`
	 JOIN `m2m_books_genres` USING (`b_id`)
GROUP BY `b_id`
HAVING `genres_count` > 1 ;

#12.	Показать читателей, у которых сейчас на руках больше одной книги.
SELECT `s_id`,
	`s_name`,
    COUNT(*) AS `books_count`
FROM `subscribers`
	JOIN `subscriptions` ON `s_id`=`sb_subscriber`
    WHERE `sb_is_active`='Y'
GROUP BY `sb_subscriber`
HAVING `books_count`>1 ;

#13.	Показать, сколько экземпляров каждой книги сейчас выдано читателям.
SELECT `b_id`,`b_name`,
COUNT(*) AS `books_count`
FROM `books`
	JOIN `subscriptions` ON `b_id`=`sb_book`
     WHERE `sb_is_active`='Y'
GROUP BY `b_id`;


#14.	Показать всех авторов и количество экземпляров книг по каждому автору.


#15.	Показать всех авторов и количество книг (не экземпляров книг, а «книг как изда-ний») по каждому автору.
SELECT `a_id`,
 `a_name`,
 COUNT(*) AS `books`
FROM `authors`
 JOIN `m2m_books_authors` USING ( `a_id` )
 LEFT OUTER JOIN `books`
 USING (`b_id`)
GROUP BY `a_id`;

#16.	Показать всех читателей, не вернувших книги, и количество невозвращённых книг по каждому такому читателю.
SELECT `s_id`, `s_name` ,
COUNT(*) AS `num_of_books`
FROM `subscribers`
RIGHT JOIN `subscriptions` ON `s_id`=`sb_subscriber`
WHERE `sb_is_active`='Y'
GROUP BY `s_id`; 

#17.	Показать читаемость жанров, т.е. все жанры и то количество раз, которое книги этих жанров были взяты читателями.
SELECT `g_id`,`g_name`,
		COUNT(*) AS `num_of_genres`
		FROM `genres`
		JOIN `m2m_books_genres` USING(`g_id`)
        LEFT JOIN `subscriptions` ON `m2m_books_genres`.`b_id`=`sb_book`
        GROUP BY `g_id`;
        
#18.	Показать самый читаемый жанр, т.е. жанр (или жанры, если их несколько), относя-щиеся к которому книги читатели брали чаще всего.
