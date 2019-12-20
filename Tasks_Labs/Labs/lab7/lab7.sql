--Лабораторная выполняется в СУБД  Oracle.
--Cкопируйте файл  FPMI\SERV314\SUBFACULTY\каф ИСУ\Исаченко\Лабораторные\EDU7.sql  в каталог C:\TEMP .
--Раскройте файл и ознакомтесь со скриптом создания и заполнения таблиц для выполнения лабораторной.
--База данных имеет дополнительную таблицу t_error.
--Произведите запуск Oracle.  Запустите скрипты EDU7.sql на выполнение.
--Вставте в эту строку Ваши ФИО, номер группы, курса. ФИО Реентович Владислав Викторович, группа 2, курс 4.
--Файл с отчётом о выполнении лабораторной создаётся путём вставки скриптов, созданных Вами программ после пунктов 1, 2.
--Файл отчёта именуется фамилией студента  в английской транскрипции, с расширением .txt и сохраняется в каталог  fpmi-serv604\comman_stud\исаченко\группа2                   .

--1a. Имеются PL/SQL-блоки, содержащий следующие операторы:
/*declare
     empnum integer;
     begin
      insert into bonus values (505,15, 2018, 500, null);
end;*/

/*declare
     empnum integer;
     begin
      insert into job values (1010, 'Accountant xxxxxxxxxx',5500);
end;*/

/*declare
     empnum integer;
     begin
      select empno into empnum from emp where empno=505 or empno=403;
end;*/
--Оператор исполняемого раздела вызывает предопределённое исключение со своими предопределёнными
--кодом и сообщением.
--Дополните блоки разделами обработки исключительных ситуаций.
--Обработка каждой ситуации состоит в занесении в таблицу t_error предопределённых кода ошибки,
--сообщения об ошибке и текущих даты и времени, когда ошибка произошла.
declare
     empnum integer;
     error_code integer;
     error_message varchar(100);
begin
      insert into bonus values (505,15, 2018, 500, null);
exception when others then error_code := sqlcode;
error_message := substr(sqlerrm, 1, 100);
insert into t_error values (error_code, error_message, sysdate);
end;

declare
     empnum integer;
     error_code integer;
     error_message varchar(100);
begin
      insert into job values (1010, 'Accountant xxxxxxxxxx',5500);
exception when others then error_code := sqlcode;
error_message := substr(sqlerrm, 1, 100);
insert into t_error values (error_code, error_message, sysdate);
end;

declare
     empnum integer;
     error_code integer;
     error_message varchar(100);
begin
      select empno into empnum from emp where empno=505 or empno=403;
exception when others then error_code := sqlcode;
error_message := substr(sqlerrm, 1, 100);
insert into t_error values (error_code, error_message, sysdate);
end;


--1b. Создайте собственную исключительную ситуацию с кодом -26000 и сообщением
--'January bonus greater February bonus' или 'February bonus greater March bonus' в зависимости от месяца,
--данные за который вызвали ситуацию.
--Исключительная ситуация наступает при нарушении бизнес-правила: "Сумма премий, начисленных
--в конкретном месяце 2018 года, не может быть меньше суммы премий, начисленных в предыдущий
--месяц этого же года".
--Таким образом рассматриваются только январь, февраль и март 2018 года.
--Создайте блок с операторами, вызывающими нарушение бизнес-правила и обработку соответсвующей ситуации.
--При наступлении пользователской исключительной ситуации обработка состоит в занесении данных о ней
--(аналогично разделу 1a) в таблицу t_error.

DECLARE
    CURSOR total_bonus_by_month (year_param INTEGER) IS
        SELECT month, sum(bonvalue) AS bonvalue
        FROM bonus
        WHERE year = year_param
        GROUP BY month
        ORDER BY month;

    prev_month_bonus REAL := 0;
    prev_moth INTEGER := 0;
    prev_moth_name VARCHAR(20);
    curr_month_name VARCHAR(20);
    error_code INTEGER;
    error_message VARCHAR(100);
BEGIN
    FOR i IN total_bonus_by_month(2018) LOOP
        IF ((prev_moth = i.month - 1) AND (prev_month_bonus > i.bonvalue)) THEN
            SELECT to_char(to_date(i.month - 1, 'MM'), 'MONTH')
            INTO prev_moth_name FROM DUAL;

            SELECT to_char(to_date(i.month, 'MM'), 'MONTH')
            INTO curr_month_name FROM DUAL;

            raise_application_error(-20000, prev_moth_name || 'bonus greater ' || curr_month_name || 'bonus');
        END IF;

        prev_month_bonus := i.bonvalue;
        prev_moth := i.month;
    END LOOP;

EXCEPTION WHEN OTHERS THEN error_code := sqlcode;
error_message := substr(sqlerrm, 1, 100);
INSERT INTO t_error VALUES (error_code, error_message, sysdate);
END;


