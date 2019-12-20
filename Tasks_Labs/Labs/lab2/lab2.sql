--Выбирите СУБД Oracle для выполнения лабораторной.
--Скопируйте файлы  FPMI-stud\SUBFACULTY\каф ИСУ\Исаченко\Лаб2019\EDU2.sql в каталог C:\TEMP .
--Раскройте файл и ознакомтесь со скриптом создания и заполнения таблиц для выполнения лабораторной.
--Запустите скрипты EDU1.sql, EDU2.sql на выполнение.
--Вставте в эту строку Ваши ФИО, номер группы, курса. ФИО Реентович Владислав Викторович, группа 2, курс 4.
--Файл с отчётом о выполнении лабораторной создаётся путём вставки соответсвующего предложения после строки с текстом задания.
--Файл отчёта именуется фамилией студента  в английской транскрипции, с расширением .txt и сохраняется в каталог FPMI-serv604\Common-stud\Исаченко\Лаб/Гр_                     .
--Тексты заданий:
--1.Поднимите нижнюю границу минимальной заработной платы в таблице JOB на 50 единиц.
UPDATE job
SET minsalary = minsalary + 50;
rollback;

--2. Поднимите минимальную зарплату в таблице JOB на 15%  для всех должностей, минимальная зарплата для которых не превышает 1500 единиц..
UPDATE job
SET minsalary = minsalary * 1.15
WHERE minsalary <= 1500;
rollback;

--3. Поднимите минимальную зарплату в таблице JOB на 10% для водителей  (Driver) и опустите минимальную зарплату для исполнительных директоров (Executive Director) на 10%  (одним оператором).
UPDATE job
SET minsalary =
    CASE
        WHEN jobname = 'Driver' THEN minsalary * 1.1
        WHEN jobname = 'Executive Director' THEN minsalary * 0.9
        ELSE minsalary
    END
;
rollback;

--4. Установите минимальную зарплату клерка (Clerk) равной половине от зарплаты  финансового директора ( Financial Director}.
UPDATE job
SET minsalary = (
    SELECT minsalary
    FROM job
    WHERE jobname = 'Financial Director'
) * 0.5
WHERE jobname = 'Clerk';
rollback;

--5. Приведите в таблице EMP имена и фамилии служащих, имена которых начинаются на буквы 'D', ‘J’ и ‘R’, полностью к верхнему регистру.
UPDATE emp
SET empname = upper(empname)
WHERE substr(empname, 1, 1) IN ('D', 'J', 'R');
rollback;

--6. Приведите в таблице EMP имена и фамилии служащих, имена которых начинаются на буквы 'A', ‘D’ и ‘O’, полностью к нижнему регистру.
UPDATE emp
SET empname = lower(empname)
WHERE substr(empname, 1, 1) IN ('A', 'D', 'O');
rollback;

--7. Приведите в таблице EMP имена и фамилии служащих, с именами Jon,  Ivan , полностью к нижнему регистру.
UPDATE emp
SET empname = lower(empname)
WHERE substr(empname, 1, 4) = 'Jon '
   OR substr(empname, 1, 5) = 'Ivan ';
rollback;

--8. Оставте в таблице EMP только фамилии сотрудников (имена удалите).
UPDATE emp
SET empname = substr(empname, instr(empname, ' ') + 1);
rollback;

--9. Перенесите отдел продаж (Sales) по адресу отдела с кодом C02.
UPDATE dept
SET deptaddress = (
    SELECT deptaddress
    FROM dept
    WHERE deptid = 'C02'
)
WHERE deptname = 'Sales';
rollback;

--10. Добавьте нового сотрудника в таблицу EMP. Его номер равен  900, имя и фамилия ‘Frank Hayes’, дата рождения ‘12-09-1978’.
INSERT INTO emp
VALUES(900, 'Frank Hayes', to_date('12-09-1978','dd-mm-yyyy'));

--11. Определите нового сотрудника (см. предыдущее задание) на работу в административный отдел (Administration) с адресом 'USA, San-Diego', начиная с текущей даты в должности водителя (Driver).
INSERT INTO career
VALUES ( (
    SELECT jobno
    FROM job
    WHERE jobname = 'Driver'
), 900, (
    SELECT deptid
    FROM dept
    WHERE deptname = 'Administration' AND deptaddress = 'USA, San-Diego'
), CURRENT_DATE, NULL
);
rollback;

--12. Удалите все записи из таблицы TMP_EMP. Добавьте в нее информацию о сотрудниках, которые работают инженерами (Engineer) или программистами (Programmer) в настоящий момент.
DELETE FROM tmp_emp;
INSERT INTO tmp_emp (empno, empname, birthdate) (
    SELECT emp.empno, emp.empname, emp.birthdate
    FROM emp JOIN ( career JOIN job ON career.jobno = job.jobno ) ON emp.empno = career.empno
    WHERE career.enddate IS NULL AND (job.jobname = 'Engineer' OR job.jobname = 'Programmer') );
rollback;

--13. Добавьте в таблицу TMP_EMP информацию о тех сотрудниках, которые увольнялись, но затем опять зачислялись на работу и работают на предприятии в настоящий момент.
INSERT INTO tmp_emp (empno, empname, birthdate) (
    SELECT empno, empname, birthdate
    FROM emp
    WHERE (empno IN  (
        SELECT empno
        FROM career
        WHERE enddate IS NULL
    ) AND empno IN (
        SELECT empno
        FROM career
        WHERE enddate IS NOT NULL
    ) ) AND empno NOT IN (
        SELECT empno
        FROM tmp_emp
    )
);
rollback;

--14. Добавьте в таблицу TMP_EMP информацию о тех сотрудниках, которые были уволены и не работают на предприятии в настоящий момент.
INSERT INTO tmp_emp (empno, empname, birthdate) (
    SELECT empno, empname, birthdate
    FROM emp
    WHERE empno NOT IN (
        SELECT empno
        FROM career
        WHERE career.enddate IS NULL
    ) AND empno NOT IN (
        SELECT empno
        FROM tmp_emp
    )
);
rollback;

--15. Удалите все записи из таблицы TMP_JOB и добавьте в нее информацию по тем должностям, на которых работает ровно два служащих  в  настоящий момент.
DELETE FROM tmp_job;

INSERT INTO tmp_job (jobno, jobname, minsalary) (
    SELECT job.jobno, jobname, minsalary
    FROM job JOIN career ON job.jobno = career.jobno
    WHERE career.enddate IS NULL
    GROUP BY job.jobno, jobname, minsalary
    HAVING count(DISTINCT career.empno) = 2
);
rollback;

--16. Удалите всю информацию о начислениях премий сотрудникам, которые в настоящий момент уже не работают на предприятии.
DELETE
FROM bonus
WHERE empno NOT IN (
    SELECT empno
    FROM career
    WHERE enddate IS NULL
);
rollback;

--17. Начислите премию в размере 20% минимального должностного оклада всем сотрудникам, работающим на предприятии.
--Зарплату начислять по должности, занимаемой сотрудником в настоящий момент и отнести ее на текущий месяц.
INSERT INTO bonus (
    SELECT career.empno, extract(MONTH FROM CURRENT_DATE), extract(YEAR FROM CURRENT_DATE), job.minsalary * 0.2
    FROM career JOIN job ON career.jobno = job.jobno
    WHERE enddate IS NULL
);
rollback;

--18. Удалите данные о премиях  за все годы до 2015 включительно.
DELETE
FROM bonus
WHERE YEAR < 2016;
rollback;

--19. Удалите информацию о прошлой карьере тех сотрудников, которые в настоящий момент  работают на предприятии.
DELETE
FROM career
WHERE enddate IS NOT NULL AND empno IN (
    SELECT empno
    FROM career
    WHERE enddate IS NULL
);
rollback;

--20. Удалите записи из таблицы EMP для тех сотрудников, которые не работают на предприятии в настоящий момент.
DELETE
FROM career
WHERE empno NOT IN (
    SELECT DISTINCT empno
    FROM career
    WHERE enddate IS NULL
);

DELETE
FROM bonus
WHERE empno NOT IN (
    SELECT DISTINCT empno
    FROM career
    WHERE enddate IS NULL
);

DELETE
FROM emp
WHERE empno NOT IN (
    SELECT DISTINCT empno
    FROM career
    WHERE enddate IS NULL
);
rollback;