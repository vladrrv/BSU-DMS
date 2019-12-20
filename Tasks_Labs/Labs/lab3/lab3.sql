--лабораторная выполняется в СУБД  Oracle.
--Скопируйте файлы  FPMI-stud\SUBFACULTY\каф ИСУ\Исаченко\Лабораторные\EDU3.sql  в каталог C:\TEMP .
--Раскройте файл и ознакомтесь со скриптом создания и заполнения таблиц для выполнения лабораторной. Таблица Bonus имеет дополнительный столбец tax (налог) со значениями null.
--Запустите скрипт EDU3.sql на выполнение.
--Вставте в эту строку Ваши ФИО, номер группы, курса. ФИО Реентович Владислав Викторович, группа 2, курс 4.
--Файл с отчётом о выполнении лабораторной создаётся путём вставки скриптов, созданных Вами программ после пунктов 1a), 1b), 1c), 2), 3), 4).
--Файл отчёта именуется фамилией студента  в английской транскрипции, с расширением .txt и сохраняется в каталог  fpmi-serv604\comman_stud\исаченко\Лаб\Гр_.
--Вам необходимо создать блоки и подпрограммы для начисления налога на прибыль и занесения его в столюец Tax соответсвующуй записи таблицы Bonus.
--Налог вычисляется по следующему правилу:
--налог равен 9% от начисленной  в месяце премии, если суммарная премия с начала года до конца рассматриваемого месяца не превышает 500;
--налог равен 12% от начисленной  в месяце премии, если суммарная премия с начала года до конца рассматриваемого месяца больше 500, но не превышает 1 000;
--налог равен 15% от начисленной  в месяце премии, если суммарная премия с начала года до конца рассматриваемого месяца  больше 1 000.

--1.	Составьте в виде неименованного блока программу вычисления налога и вставки его в таблицу Bonus:
--a) с помощью простого цикла (loop) с курсором, оператора if и/или опретора case;

DECLARE
    CURSOR bonusCursor IS
        SELECT bonus2.empno, bonus2.month, bonus2.year, sum(bonus.bonvalue) AS sumbonvalue
        FROM bonus bonus2 JOIN bonus ON bonus.empno = bonus2.empno AND bonus.year = bonus2.year AND bonus.month <= bonus2.month
        GROUP BY bonus2.empno, bonus2.month, bonus2.year;

    i bonusCursor % ROWTYPE;
    taxPercent REAL := 0;
BEGIN OPEN bonusCursor;
    LOOP FETCH bonusCursor INTO i;
        EXIT WHEN bonusCursor % NOTFOUND;

        IF i.sumbonvalue <= 500 THEN taxPercent := 0.09;
        ELSIF i.sumbonvalue <= 1000 THEN taxPercent := 0.12;
        ELSE taxPercent := 0.15;
        END IF;

        UPDATE bonus
        SET tax = bonvalue * taxPercent
        WHERE empno = i.empno AND YEAR = i.year AND MONTH = i.month;
    END LOOP;
    CLOSE bonusCursor;
END;
/

DECLARE
    CURSOR bonusCursor IS
        SELECT bonus2.empno, bonus2.month, bonus2.year, sum(bonus.bonvalue) AS sumbonvalue
        FROM bonus bonus2 JOIN bonus ON bonus.empno = bonus2.empno AND bonus.year = bonus2.year AND bonus.month <= bonus2.month
        GROUP BY bonus2.empno, bonus2.month, bonus2.year;

    i bonusCursor % ROWTYPE;
    taxPercent REAL := 0;
BEGIN OPEN bonusCursor;
    LOOP FETCH bonusCursor INTO i;
        EXIT WHEN bonusCursor % NOTFOUND;

        CASE
            WHEN i.sumbonvalue <= 500 THEN taxPercent := 0.09;
            WHEN i.sumbonvalue <= 1000 THEN taxPercent := 0.12;
            ELSE taxPercent := 0.15;
        END CASE;

        UPDATE bonus
        SET tax = bonvalue * taxPercent
        WHERE empno = i.empno AND YEAR = i.year AND MONTH = i.month;
    END LOOP;
    CLOSE bonusCursor;
END;
/

-- b)   с помощью курсорного цикла FOR;
DECLARE
    CURSOR bonusCursor IS
        SELECT bonus2.empno, bonus2.month, bonus2.year, sum(bonus.bonvalue) AS sumbonvalue
        FROM bonus bonus2 JOIN bonus ON bonus.empno = bonus2.empno AND bonus.year = bonus2.year AND bonus.month <= bonus2.month
        GROUP BY bonus2.empno, bonus2.month, bonus2.year;

    taxPercent REAL := 0;

BEGIN
    FOR i IN bonusCursor LOOP
        IF i.sumbonvalue <= 500 THEN taxPercent := 0.09;
        ELSIF i.sumbonvalue <= 1000 THEN taxPercent := 0.12;
        ELSE taxPercent := 0.15;
        END IF;

        UPDATE bonus
        SET tax = bonvalue * taxPercent
        WHERE empno = i.empno AND YEAR = i.year AND MONTH = i.month;
    END LOOP;
END;

-- c) с помощью курсора с параметром, передавая номер сотрудника, для которого необходимо посчитать налог.
DECLARE
    CURSOR bonusCursor (employee INTEGER) IS
        SELECT bonus2.empno, bonus2.month, bonus2.year, sum(bonus.bonvalue) AS sumbonvalue
        FROM bonus bonus2 JOIN bonus ON bonus.empno = bonus2.empno AND bonus.year = bonus2.year AND bonus.month <= bonus2.month
        WHERE bonus2.empno = employee
        GROUP BY bonus2.empno, bonus2.month, bonus2.year;
    i bonusCursor % ROWTYPE;
    taxPercent REAL := 0;
BEGIN OPEN bonusCursor(505);
    LOOP FETCH bonusCursor INTO i;
        EXIT WHEN bonusCursor % NOTFOUND;

        IF i.sumbonvalue <= 500 THEN taxPercent := 0.09;
        ELSIF i.sumbonvalue <= 1000 THEN taxPercent := 0.12;
        ELSE taxPercent := 0.15;
        END IF;

        UPDATE bonus
        SET tax = bonvalue * taxPercent
        WHERE empno = i.empno AND YEAR = i.year AND MONTH = i.month;
    END LOOP;
    CLOSE bonusCursor;
END;

--2.   Оформите составленные программы в виде процедур Bonus_loop_if, Bonus_loop_case, Bonus_for, Bonus_cour(emp_par).
CREATE OR REPLACE PROCEDURE Bonus_loop_if IS
    CURSOR bonusCursor IS
        SELECT bonus2.empno, bonus2.month, bonus2.year, sum(bonus.bonvalue) AS sumbonvalue
        FROM bonus bonus2 JOIN bonus ON bonus.empno = bonus2.empno AND bonus.year = bonus2.year AND bonus.month <= bonus2.month
        GROUP BY bonus2.empno, bonus2.month, bonus2.year;

    i bonusCursor % ROWTYPE;
    taxPercent REAL := 0;
BEGIN OPEN bonusCursor;
    LOOP FETCH bonusCursor INTO i;
        EXIT WHEN bonusCursor % NOTFOUND;

        IF i.sumbonvalue <= 500 THEN taxPercent := 0.09;
        ELSIF i.sumbonvalue <= 1000 THEN taxPercent := 0.12;
        ELSE taxPercent := 0.15;
        END IF;

        UPDATE bonus
        SET tax = bonvalue * taxPercent
        WHERE empno = i.empno AND YEAR = i.year AND MONTH = i.month;
    END LOOP;
    CLOSE bonusCursor;
END Bonus_loop_if;
/

CREATE OR REPLACE PROCEDURE Bonus_loop_case IS
    CURSOR bonusCursor IS
        SELECT bonuscopy.empno, bonuscopy.month, bonuscopy.year, sum(bonus.bonvalue) AS sumbonvalue
        FROM bonus bonuscopy JOIN bonus ON bonus.empno = bonuscopy.empno AND bonus.year = bonuscopy.year AND bonus.month <= bonuscopy.month
        GROUP BY bonuscopy.empno, bonuscopy.month, bonuscopy.year;

    i bonusCursor % ROWTYPE;
    taxPercent REAL := 0;
BEGIN OPEN bonusCursor;
    LOOP FETCH bonusCursor INTO i;
        EXIT WHEN bonusCursor % NOTFOUND;

        CASE
            WHEN i.sumbonvalue <= 500 THEN taxPercent := 0.09;
            WHEN i.sumbonvalue <= 1000 THEN taxPercent := 0.12;
            ELSE taxPercent := 0.15;
            END CASE;

        UPDATE bonus
        SET tax = bonvalue * taxPercent
        WHERE empno = i.empno AND YEAR = i.year AND MONTH = i.month;
    END LOOP;
    CLOSE bonusCursor;
END Bonus_loop_case;
/

CREATE OR REPLACE PROCEDURE Bonus_for IS
    CURSOR bonusCursor IS
        SELECT bonuscopy.empno, bonuscopy.month, bonuscopy.year, sum(bonus.bonvalue) AS sumbonvalue
        FROM bonus bonuscopy JOIN bonus ON bonus.empno = bonuscopy.empno AND bonus.year = bonuscopy.year AND bonus.month <= bonuscopy.month
        GROUP BY bonuscopy.empno, bonuscopy.month, bonuscopy.year;

    taxPercent REAL := 0;

BEGIN
    FOR i IN bonusCursor LOOP
        IF i.sumbonvalue <= 500 THEN taxPercent := 0.09;
        ELSIF i.sumbonvalue <= 1000 THEN taxPercent := 0.12;
        ELSE taxPercent := 0.15;
        END IF;

        UPDATE bonus
        SET tax = bonvalue * taxPercent
        WHERE empno = i.empno AND YEAR = i.year AND MONTH = i.month;
    END LOOP;
END Bonus_for;
/

CREATE OR REPLACE PROCEDURE Bonus_cour(employee IN INTEGER) IS
    CURSOR bonusCursor (employee INTEGER) IS
        SELECT bonuscopy.empno, bonuscopy.month, bonuscopy.year, sum(bonus.bonvalue) AS sumbonvalue
        FROM bonus bonuscopy JOIN bonus ON bonus.empno = bonuscopy.empno AND bonus.year = bonuscopy.year AND bonus.month <= bonuscopy.month
        WHERE bonuscopy.empno = employee
        GROUP BY bonuscopy.empno, bonuscopy.month, bonuscopy.year;

    i bonusCursor % ROWTYPE;
    taxPercent REAL := 0;
BEGIN OPEN bonusCursor(employee);
    LOOP FETCH bonusCursor INTO i;
        EXIT WHEN bonusCursor % NOTFOUND;

        IF i.sumbonvalue <= 500 THEN taxPercent := 0.09;
        ELSIF i.sumbonvalue <= 1000 THEN taxPercent := 0.12;
        ELSE taxPercent := 0.15;
        END IF;

        UPDATE bonus
        SET tax = bonvalue * taxPercent
        WHERE empno = i.empno AND YEAR = i.year AND MONTH = i.month;
    END LOOP;
    CLOSE bonusCursor;
END Bonus_cour;
/

--3.   Создайте процедуру Bonus_emp(perc1, perc2, perc3, emp_par), вычисления налога и вставки его в таблицу Bonus за всё время начислений для конкретного сотрудника.
--В качестве параметров передать проценты налога (до 500, от 501 до 1000, выше 1000), номер сотрудника.
CREATE OR REPLACE PROCEDURE Bonus_emp(perc1 IN REAL, perc2 IN REAL, perc3 IN REAL, emp_par IN INTEGER) IS
    CURSOR bonusCursor (employee INTEGER) IS
        SELECT bonuscopy.empno, bonuscopy.month, bonuscopy.year, sum(bonus.bonvalue) AS sumbonvalue
        FROM bonus bonuscopy JOIN bonus ON bonus.empno = bonuscopy.empno AND bonus.year = bonuscopy.year AND bonus.month <= bonuscopy.month
        WHERE bonuscopy.empno = employee
        GROUP BY bonuscopy.empno,
                 bonuscopy.month,
                 bonuscopy.year;

    i bonusCursor % ROWTYPE;
    taxPercent REAL := 0;

BEGIN OPEN bonusCursor(emp_par);
    LOOP FETCH bonusCursor INTO i;
        EXIT WHEN bonusCursor % NOTFOUND;
        IF i.sumbonvalue <= 500 THEN taxPercent := perc1;
        ELSIF i.sumbonvalue <= 1000 THEN taxPercent := perc2;
        ELSE taxPercent := perc3;
        END IF;

        UPDATE bonus
        SET tax = bonvalue * taxPercent
        WHERE empno = i.empno AND YEAR = i.year AND MONTH = i.month;
    END LOOP;
    CLOSE bonusCursor;
END Bonus_emp;
/

--4.   Создайте функцию Bonus_summ(perc1, perc2, perc3, emp_par), вычисляющую суммарный налог на премию сотрудника за всё время начислений.
--В качестве параметров передать процент налога (до 500, от 501 до 100 , выше 1000), номер сотрудника.
-- Возвращаемое значение – суммарный налог.
CREATE OR REPLACE FUNCTION Bonus_summ(perc1 IN REAL, perc2 IN REAL, perc3 IN REAL, emp_par IN INTEGER) RETURN REAL IS
    CURSOR bonusCursor (employee INTEGER) IS
        SELECT bonus2.EMPNO, bonus2.MONTH, bonus2.YEAR, sum(bonus.BONVALUE) AS sumbonvalue, avg(bonus.BONVALUE) AS avgbonvalue
        FROM bonus bonus2 JOIN bonus ON bonus.EMPNO = bonus2.EMPNO AND bonus.YEAR = bonus2.YEAR AND bonus.MONTH <= bonus2.MONTH
        WHERE bonus2.EMPNO = employee
        GROUP BY bonus2.EMPNO, bonus2.MONTH, bonus2.YEAR;
    i bonusCursor % ROWTYPE;
    taxPercent REAL := 0;
    total REAL := 0;

BEGIN OPEN bonusCursor (emp_par);
    LOOP FETCH bonusCursor INTO i;
        EXIT WHEN bonusCursor % NOTFOUND;
        IF i.sumbonvalue <= 500 THEN taxPercent := perc1;
        ELSIF i.sumbonvalue <= 1000 THEN taxPercent := perc2;
        ELSE taxPercent := perc3;
        END IF;
        total := total + i.avgbonvalue * taxPercent;
    END LOOP;
    CLOSE bonusCursor;
    RETURN total;
END Bonus_summ;
/