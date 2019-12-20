--Лабораторная выполняется в СУБД  Oracle.
--Cкопируйте файл  FPMI-STUD\SUBFACULTY\каф ИСУ\Исаченко\Лабораторные\EDU5.sql  в каталог C:\TEMP .
--Раскройте файл и ознакомтесь со скриптом создания и заполнения таблиц для выполнения лабораторной.
--Таблица Emp имеет дополнительные столбцы mstat (семейное положение), Nchild (количество несовершеннолетних детей).
--Произведите запуск Oracle.  Запустите скрипты EDU4.sql на выполнение.
--Вставте в эту строку Ваши ФИО, номер группы, курса. ФИО Реентович Владислав Викторович, группа 2, курс 4.
--Файл с отчётом о выполнении лабораторной создаётся путём вставки скриптов, созданных Вами программ после пунктов 1-5.
--Файл отчёта именуется фамилией студента  в английской транскрипции, с расширением .txt и сохраняется в каталог  fpmi-serv604\comman_stud\исаченко\Лаб\группа_.                  .

--1. Создайте триггер, который при добавлении или обновлении записи в таблице EMP
-- должен отменять действие и сообщать об ошибке:
--a) если для сотрудника с семейным положением холост (s)  в столбце Nchild указывается данное, отличное от NULL или 0;
--b) если для любого сотрудника указывается отрицательное количество детей.
CREATE OR REPLACE TRIGGER t1
    BEFORE INSERT OR UPDATE ON emp
    FOR EACH ROW
BEGIN
    IF (:new.mstat = 's' AND NOT(:new.nchild IS NULL OR :new.nchild = 0))
    THEN RAISE_APPLICATION_ERROR(-20000, 'Number of children for single employee must be == 0 or NULL!');
    END IF;

    IF (:new.nchild < 0)
    THEN RAISE_APPLICATION_ERROR(-20000, 'Number of children must be >= 0!');
    END IF;
END;


--2. Создайте триггер, который при добавлении или обновлении записи в таблице EMP должен:
-- a) осуществлять вставку данного равного 0,
--если для сотрудника с семейным положением холост (s)  в столбце Nchild указывается данное, отличное от NULL или 0;
--b) осуществлять вставку данного NULL,
--если для любого сотрудника указывается отрицательное количество детей.
CREATE OR REPLACE TRIGGER t2
    BEFORE INSERT OR UPDATE ON emp
    FOR EACH ROW
BEGIN
    IF (:new.nchild < 0)
    THEN :new.nchild := NULL;
    END IF;

    IF (:new.mstat = 's' AND NOT(:new.nchild IS NULL OR :new.nchild = 0))
    THEN :new.nchild := 0;
    END IF;
END;

--3. Создайте триггер, который при обновлении записи в таблице EMP
--должен отменять действие и сообщать об ошибке, если для сотрудников, находящихся в браке (m) в столбце Nchild
--новое значение отличается от текущего более чем на 1.
CREATE OR REPLACE TRIGGER t3
    BEFORE UPDATE ON emp FOR EACH ROW
BEGIN
    IF (:new.mstat = 'm' AND ABS(:new.nchild - :old.nchild) > 1)
    THEN RAISE_APPLICATION_ERROR(-20000, 'nchild difference must be < 1!');
    END IF;
END;

--4. Создать триггер, который отменяет любые действия (начисление, изменение, удаление) с премиями (таблица bonus)
-- неработающих в настоящий момент в организации сотрудников и сообщает об ошибке.
CREATE OR REPLACE TRIGGER t4
    BEFORE INSERT OR UPDATE OR DELETE ON bonus
    FOR EACH ROW
DECLARE
    career_count INTEGER;
BEGIN
    SELECT COUNT(*) into career_count FROM career
    WHERE empno = :new.empno and enddate IS NULL;

    IF career_count = 0
    THEN RAISE_APPLICATION_ERROR(-20000, 'This employee doesnt work anymore!');
    END IF;
END;

--5. Создайте триггер, который до выполнения действия (вставка, обновление, удаление) с таблицей job
--создаёт запись в таблице temp_table, с указанием названия действия (delete, update, insert) активизирующего триггер.
CREATE OR REPLACE TRIGGER t5
    BEFORE INSERT OR UPDATE OR DELETE ON job
    FOR EACH ROW
BEGIN
    IF INSERTING
    THEN INSERT INTO temp_table VALUES('insert');
    END IF;

    IF UPDATING
    THEN INSERT INTO temp_table VALUES('update');
    END IF;

    IF DELETING
    THEN INSERT INTO temp_table values('delete');
    END IF;
END;