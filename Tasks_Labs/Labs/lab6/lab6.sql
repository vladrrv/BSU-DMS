--Лабораторная выполняется в СУБД  Oracle.
--Cкопируйте файл  FPMI\SERV314\SUBFACULTY\каф ИСУ\Исаченко\Лабораторные\Lab6.sql  в каталог C:\TEMP .
--Раскройте файл и ознакомтесь со скриптом создания и заполнения таблиц для выполнения лабораторной.
--Запустите скрипт EDU6.sql на выполнение.
--Вставте в эту строку Ваши ФИО, номер группы, курса. ФИО Реентович Владислав Викторович, группа 2, курс 4.
--Файл с отчётом о выполнении лабораторной создаётся путём вставки скриптов, созданных
--Вами операторов после пунктов 1- 8.
--Файл отчёта именуется фамилией студента  в английской транскрипции, с расширением .txt
--и сохраняется в каталог  fpmi-serv604\comman_stud\исаченко\Лаб\Гр_.

--1. Модифицируйте таблицу emp, добавив поле empaddr, содержащую сведения об адресе сотрудника.
--Данное поле должно являться полем объектного типа empaddr_ty  с атрибутами country varchar (10),
--city varchar (10), street varchar (10), homenumber integer, postcode integer,
--startlifedate date (дата заселения).
--Объектный тип должен содержать метод , определяющий время проживания (в днях) сотрудника по указанному
--адресу до текущего момента, округлённое до дня.
CREATE OR REPLACE TYPE empaddr_ty AS OBJECT (
    country VARCHAR(10),
    city VARCHAR(10),
    street VARCHAR(10),
    homenumber INTEGER,
    postcode INTEGER,
    startlifedate DATE,
    MEMBER FUNCTION living_days RETURN integer
) NOT FINAL;

CREATE OR REPLACE TYPE BODY empaddr_ty AS MEMBER FUNCTION living_days RETURN INTEGER IS
    BEGIN
        RETURN SYSDATE - startlifedate;
    END living_days;
END;

ALTER TABLE emp ADD empaddr empaddr_ty;


--2. Дополните таблицу emp следующими данными для сотрудников:
--505	Belarus	Minsk	Chkalova 		2	220039		15.01.2007
--303	Belarus	Minsk	Poushkina		12	220087		16.05.2005
--205	Belarus	Minsk	Serova		14	220013		20.11.2008
--412	Belarus	Minsk	Serova		23	220013		14.12.2005
--503	Belarus	Minsk	Chkalova		6	220039		28.10.2008
--Для остальных сотрудников атрибуты поля  empaddr не определены.
UPDATE emp SET empaddr = empaddr_ty('Belarus', 'Minsk', 'Chkalova', 2, 220039, TO_DATE('15-01-2007', 'dd-mm-yyyy'))
WHERE empno = 505;
UPDATE emp SET empaddr = empaddr_ty('Belarus', 'Minsk', 'Poushkina', 12, 220087, TO_DATE('16-05-2005', 'dd-mm-yyyy'))
WHERE empno = 303;
UPDATE emp SET empaddr = empaddr_ty('Belarus', 'Minsk', 'Serova', 14, 220013, TO_DATE('20-11-2008', 'dd-mm-yyyy'))
WHERE empno = 205;
UPDATE emp SET empaddr = empaddr_ty('Belarus', 'Minsk', 'Serova', 23, 220013, TO_DATE('14-12-2005', 'dd-mm-yyyy'))
WHERE empno = 412;
UPDATE emp SET empaddr = empaddr_ty('Belarus', 'Minsk', 'Chkalova', 6, 220039, TO_DATE('28-10-2008', 'dd-mm-yyyy'))
WHERE empno = 503;


--3. Создайте запрос, определяющий номер сотрудника, его имя,  время проживания по данному в таблице  emp адресу
--для сотрудников с номерами 505, 205, 503. Использовать метод, созданный в п.1.
SELECT empno, empname, temp.empaddr.living_days() AS living_days
FROM emp temp WHERE empno IN (505, 205, 503);


--4. Используя наследование, создайте объектный тип empaddres_ty на основе ранее созданного объектного типа
--empaddr_ty с дополнительными атрибутами houmtel varchar (15), mtstel varchar (15), welcomtel varchar (15).
ALTER TYPE empaddr_ty NOT FINAL CASCADE;
CREATE OR REPLACE TYPE empaddres_ty UNDER empaddr_ty (
    houmtel VARCHAR(15),
    mtstel VARCHAR(15),
    welcomtel VARCHAR(15)
);


--5. Создайте таблицу emphouminf с полями empno, empaddres (объектного типа  empaddres_ty),
--связанную с таблицей emp по полю empno.
CREATE TABLE emphouminf (
    empno INTEGER NOT NULL REFERENCES emp(empno),
    empaddres empaddres_ty
);


--6. Внесите в таблицу emphouminf следующие данные для сотрудников:
--505	Belarus	Minsk	Chkalova    2   220039	15.01.2007	2241412	    7111111      6111111
--303	Belarus	Minsk	Poushkina  12   220087	16.05.2005	2341516        Null         6137677
--205	Belarus	Minsk	Serova	 14   220013	20.11.2008   	Null	    Null         6276655
--412	Belarus	Minsk	Serova       23   220013	14.12.2005	2351412	    Null         Null
--503	Belarus	Minsk	Chkalova    6   220039	28.10.2008      	Null	    7161512      6122334
INSERT INTO emphouminf (empno, empaddres)
VALUES (505, empaddres_ty('Belarus', 'Minsk', 'Chkalova', 2, 220039, TO_DATE('15.01.2007', 'dd-mm-yyyy'),
    2241412, 7111111, 6111111));
INSERT INTO emphouminf (empno, empaddres)
VALUES (303, empaddres_ty('Belarus', 'Minsk', 'Poushkina', 12, 220087, TO_DATE('16.05.2005', 'dd-mm-yyyy'),
    2341516, NULL, 6137677));
INSERT INTO emphouminf (empno, empaddres)
VALUES (205, empaddres_ty('Belarus', 'Minsk', 'Serova', 14, 220013, TO_DATE('20.11.2008', 'dd-mm-yyyy'),
    NULL, NULL, 6276655));
INSERT INTO emphouminf (empno, empaddres)
VALUES (412, empaddres_ty('Belarus', 'Minsk', 'Serova', 23, 220013, TO_DATE('14.12.2005', 'dd-mm-yyyy'),
    2351412, NULL, NULL));
INSERT INTO emphouminf (empno, empaddres)
VALUES (503, empaddres_ty('Belarus', 'Minsk', 'Chkalova', 6, 220039, TO_DATE('28.10.2008', 'dd-mm-yyyy'),
    NULL, 7161512, 6122334));


--7. Создайте запрос, определяющий номер сотрудника, его имя, домашний телефон и время проживания
--по указанному адресу для сотрудников с номерами 303, 205, 412. Использовать метод, созданный в п.1.
SELECT
    temp.empno,
    temp.empname,
    emphouminf.empaddres.houmtel AS houmtel,
    temp.empaddr.living_days() AS living_days
FROM emp temp LEFT OUTER JOIN emphouminf ON temp.empno = emphouminf.empno
WHERE temp.empno IN (303, 205, 412);

--8. Удалите созданные таблицы и объектные типы.
DROP TABLE emphouminf;
ALTER TABLE emp DROP COLUMN empaddr;
DROP TYPE empaddres_ty;
DROP TYPE empaddr_ty;