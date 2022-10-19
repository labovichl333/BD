#1.	Добавить в базу данных информацию о троих новых читателях: «Орлов О.О.», «Соколов С.С.», «Беркутов Б.Б.».
INSERT INTO `subscribers`
 (`s_name`)
VALUES ( 'Орлов О.О.' ),
 ( 'Соколов С.С.' ),
 ( 'Беркутов Б.Б.');
 
 select * from `subscribers`;
 
 #2.	Отразить в базе данных информацию о том, что 
 #каждый из троих добавленных чита-телей 20-го января 2016-го года на месяц взял в библиотеке книгу «Курс теоретической физики».
 INSERT INTO `subscriptions`
 (`sb_subscriber`,
 `sb_book`,
 `sb_start`,
 `sb_finish`,
 `sb_is_active`)
VALUES ( (SELECT `s_id` FROM `subscribers` WHERE `s_name`='Орлов О.О.'),
 (SELECT `b_id` FROM `books` WHERE `b_name`='Курс теоретической физики'),
 '2016-01-20',
 DATE_ADD(`sb_start`, INTERVAL 1 MONTH),
 'N' ),
 ( (SELECT `s_id` FROM `subscribers` WHERE `s_name`='Соколов С.С.'),
 (SELECT `b_id` FROM `books` WHERE `b_name`='Курс теоретической физики'),
 '2016-01-20',
 DATE_ADD(`sb_start`, INTERVAL 1 MONTH),
 'N' ),
 ( (SELECT `s_id` FROM `subscribers` WHERE `s_name`='Беркутов Б.Б.'),
 (SELECT `b_id` FROM `books` WHERE `b_name`='Курс теоретической физики'),
 '2016-01-20',
 DATE_ADD(`sb_start`, INTERVAL 1 MONTH),
 'N' );
 
 #4.	Отметить все выдачи с идентификаторами ≤50 как возвращённые.
 UPDATE `subscriptions` SET `sb_is_active`='N' WHERE `sb_id`<=50;
 
 #6.	Отметить как невозвращённые все выдачи, полученные читателем с идентификатором 2.
  UPDATE `subscriptions` SET `sb_is_active`='Y' WHERE `sb_subscriber`=2;
 
 #7.	Удалить информацию обо всех выдачах читателям книги с идентификатором 1.
DELETE FROM `subscriptions` WHERE `sb_book`=1;

