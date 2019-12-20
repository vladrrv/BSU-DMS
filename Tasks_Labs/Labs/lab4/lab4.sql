--Лабораторная выполняется в СУБД  Oracle.
--Cкопируйте файл  FPMI-stud\SUBFACULTY\каф ИСУ\Исаченко\Лабораторные2019\EDU4.sql  в каталог C:\TEMP .
--Раскройте файл и ознакомтесь со скриптом создания и заполнения таблиц для выполнения лабораторной.
--Таблица Emp имеет дополнительные столбцы mstat (семейное положение), Nchild (количество несовершеннолетних детей).
--Произведите запуск Oracle.  Запустите скрипты EDU4.sql на выполнение.
--Вставте в эту строку Ваши ФИО, номер группы, курса. ФИО Реентович Владислав Викторович, группа 2, курс 4.
--Файл с отчётом о выполнении лабораторной создаётся путём вставки скриптов, созданных Вами программ после пункта 1.
--Файл отчёта именуется фамилией студента  в английской транскрипции, с расширением .txt и сохраняется в каталог  fpmi-serv604\comman_stud\исаченко\Лаб\Гр_                   .

--1. Создайте пакет PackLab, включающий в свой состав процедуру ProcChild и функцию FuncEmpChild. Процедура должна вычислять ежегодную добавку к
--зарплате сотрудников на детей за 2017 год и заносить её в виде дополнительной премии в последнем месяце (декабре)  2017
--года в поле Bonvalue таблицы Bonus.
--В качестве параметров процедуре передаются проценты в зависимости от количества детей (см. правило начисления добавки).
--Функция должна вычислять ежегодную добавку за 2016 год на детей к  зарплате конкретного сотрудника (номер сотрудника - параметр передаваемый функции) без занесения в таблицу.

--ПРАВИЛО ВЫЧИСЛЕНИЯ ДОБАВКИ

--Добавка к заработной плате на детей  вычисляется только для работавших в декабре (хотя бы один день) 2016 году сотрудников по следующему правилу:
--добавка равна X% от суммы должностного месячного оклада (поле minsalary таблицы job) по занимаемой в декабре 2016 года должности и всех начисленных за 2016 год премий (поле bonvalue таблицы bonus), где:
--X% равны X1% , если сотрудник имеет одного ребёнка;
--X% равны X2% , если сотрудник имеет двух детей;
--X% равны X3% , если сотрудник имеет трёх и более детей.
--X1%<X2%<X3%  являются передаваемыми процедуре и функции параметрами . Кроме этого, функции в качестве параметра передаётся номер сотрудника (empno).


CREATE OR REPLACE PACKAGE PackLab AS FUNCTION FuncEmpChild(employee IN INTEGER, x1 IN REAL, x2 IN REAL, x3 IN REAL) RETURN REAL;
PROCEDURE ProcChild(x1 IN REAL, x2 IN REAL, x3 IN REAL);
END PackLab;
/
CREATE OR REPLACE PACKAGE BODY PackLab AS
    PROCEDURE ProcChild(x1 IN REAL, x2 IN REAL, x3 IN REAL) IS
        CURSOR child_bonus_cursor IS
            SELECT salaryempno, nvl(salary, 0) + nvl(bonusearnings, 0)
            FROM (
                SELECT career.empno AS salaryempno, nvl(sum(nvl(minsalary, 0)), 0) AS salary
                FROM career JOIN job ON job.jobno = career.jobno
                WHERE (extract(YEAR FROM career.startdate) <= 2017) AND (
                    (career.enddate IS NULL) OR
                    ((extract(YEAR FROM career.enddate) = 2017) AND (extract(MONTH FROM career.enddate) = 12)) OR
                    (extract(YEAR FROM career.enddate) > 2017)
                )
                GROUP BY career.empno
            ) LEFT OUTER JOIN (
                SELECT empno AS bonusempno, nvl(sum(nvl(bonvalue, 0)), 0) AS bonusearnings
                FROM bonus
                WHERE bonus.year = 2017
                GROUP BY empno
            ) ON salaryempno = bonusempno;

        employee INTEGER := 0;
        earnings REAL := 0;
        children INTEGER := 0;
        child_bonus REAL := 0;

    BEGIN
        OPEN child_bonus_cursor;
        LOOP
            FETCH child_bonus_cursor INTO employee, earnings;
            EXIT WHEN child_bonus_cursor % NOTFOUND;

            SELECT nchild INTO children
            FROM emp
            WHERE empno = employee;

            IF (children > 0) THEN
                IF children = 1 THEN child_bonus := earnings * x1 / 100;
                ELSIF children = 2 THEN child_bonus := earnings * x2 / 100;
                ELSIF children > 2 THEN child_bonus := earnings * x3 / 100;
                END IF;

                INSERT INTO bonus
                VALUES (employee, 12, 2017, child_bonus, NULL);

            END IF;
        END LOOP;
        CLOSE child_bonus_cursor;
    END ProcChild;

    FUNCTION FuncEmpChild(
        employee IN INTEGER, x1 IN REAL, x2 IN REAL, x3 IN REAL
    ) RETURN REAL IS bonus_earnings REAL := 0;

    salary REAL := 0;
    total REAL := 0;
    children INTEGER := 0;
    child_bonus REAL := 0;

    BEGIN
        BEGIN
            SELECT nvl(sum(nvl(bonvalue, 0)), 0) INTO bonus_earnings
            FROM bonus
            WHERE empno = employee AND bonus.year = 2016
            GROUP BY empno;
        EXCEPTION WHEN no_data_found THEN bonus_earnings := 0;
        END;

        BEGIN
            SELECT nvl(sum(nvl(minsalary, 0)), 0) INTO salary
            FROM career JOIN job ON job.jobno = career.jobno
            WHERE (career.empno = employee)
                AND (extract(YEAR FROM career.startdate) <= 2016)
                AND (
                    (career.enddate IS NULL) OR
                    ((extract(YEAR FROM career.enddate) = 2016) AND (extract(MONTH FROM career.enddate) = 12)) OR
                    (extract(YEAR FROM career.enddate) > 2016)
                )
            GROUP BY career.empno;
        EXCEPTION WHEN no_data_found THEN salary := 0;
        END;

        BEGIN
            SELECT nchild INTO children
            FROM emp
            WHERE empno = employee;
        EXCEPTION WHEN no_data_found THEN children := 0;
        END;

        total := bonus_earnings + salary;

        IF children = 1 THEN child_bonus := total * x1 / 100;
        ELSIF children = 2 THEN child_bonus := total * x2 / 100;
        ELSIF children > 2 THEN child_bonus := total * x3 / 100;
        END IF;

        RETURN child_bonus;
    END FuncEmpChild;
END PackLab;
