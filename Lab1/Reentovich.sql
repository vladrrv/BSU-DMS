--1. Выдать информацию об дате рождения работника Robert Grishuk.
SELECT BIRTHDATE
FROM EMP
WHERE EMPNAME = 'Robert Grishuk';

--2. Выдать информацию обо всех работниках, родившихся в период с 1.01.1980 по 31.12.1982.
SELECT *
FROM EMP
WHERE BIRTHDATE BETWEEN to_date('1.01.1980','dd.mm.yyyy') AND to_date('31.12.1982','dd.mm.yyyy');

--3. Найти минимальный оклад, предусмотренный для бухгалтера (Accountant).
SELECT MINSALARY
FROM JOB
WHERE JOBNAME='Accountant';

--4. Подсчитать число работников, работавших в компании до 31 мая 2010 года включительно хотя бы один день.
SELECT count(DISTINCT EMPNO)
FROM CAREER
WHERE STARTDATE <= to_date('31-05-2010','dd-mm-yyyy');

--5. Найти масимальные премии, начисленные в 2014, 2015, 2016, 2017 годах (указать год и максимальную премию в хронологическом порядке).
SELECT YEAR, max(BONVALUE)
FROM BONUS
WHERE YEAR >= '2014' AND YEAR <= '2017'
GROUP BY YEAR
ORDER BY YEAR;

--6. Выдать информацию о кодах отделов, в которых работал работник Robert Grishuk. Если Robert Grishuk работает в настоящее время - отдел также включается в искомый список.
SELECT DISTINCT CAREER.DEPTID
FROM CAREER JOIN EMP ON CAREER.EMPNO=EMP.EMPNO
WHERE EMP.EMPNAME = 'Robert Grishuk';

--7. Выдать информацию о названиях должностей, на которых работали работники Vera Rovdo и Dave Hollander. Если один из них или оба работают в настоящее время - должность также включается в искомый список.
-- Должность выдаётся вместе с ФИО (empname) работника.
SELECT JOB.JOBNAME, EMP.EMPNAME
FROM JOB JOIN (CAREER JOIN EMP ON CAREER.EMPNO = EMP.EMPNO) ON JOB.JOBNO = CAREER.JOBNO
WHERE EMP.EMPNAME = 'Vera Rovdo' OR EMP.EMPNAME = 'Dave Hollander';

-- 8. Найти фамилии, коды должностей, периоды времени (даты приема и даты увольнения) для всех инженеров (Engineer) и программистов (Programmer), работавших или работающих в компании. Если работник работает
-- в настоящий момент, то дата увольнения должна выдаваться как Null.
SELECT EMP.EMPNAME, JOB.JOBNO, CAREER.STARTDATE, CAREER.ENDDATE
FROM JOB JOIN (CAREER JOIN EMP ON CAREER.EMPNO = EMP.EMPNO) ON JOB.JOBNO = CAREER.JOBNO
WHERE JOB.JOBNAME = 'Engineer' OR JOB.JOBNAME = 'Programmer';

-- 9. Найти фамилии, названия должностей, периоды времени (даты приема и даты увольнения) для бухгалтеров (Accountant) и продавцов (Salesman), работавших или работающих в компании. Если работник работает
-- в настоящий момент, то дата увольнения отсутствует.
SELECT EMP.EMPNAME, JOB.JOBNAME, CAREER.STARTDATE, CAREER.ENDDATE
FROM JOB JOIN (CAREER JOIN EMP ON CAREER.EMPNO = EMP.EMPNO) ON JOB.JOBNO = CAREER.JOBNO
WHERE JOB.JOBNAME = 'Accountant' OR JOB.JOBNAME = 'Salesman';

-- 10. Найти количество различных работников, работавших в отделе B02 хотя бы один день в период с 01.01.2005 по настоящий момент.
SELECT COUNT(DISTINCT CAREER.EMPNO)
FROM CAREER
WHERE CAREER.DEPTID = 'B02' AND (CAREER.STARTDATE >= to_date('01-01-2005','dd-mm-yyyy') OR CAREER.ENDDATE >= to_date('01-01-2005','dd-mm-yyyy'));

-- 11. Найти фамилии этих работников.
SELECT DISTINCT EMP.EMPNAME
FROM CAREER JOIN EMP on CAREER.EMPNO = EMP.EMPNO
WHERE CAREER.DEPTID = 'B02' AND (CAREER.STARTDATE >= to_date('01-01-2005','dd-mm-yyyy') OR CAREER.ENDDATE >= to_date('01-01-2005','dd-mm-yyyy'));

--12. Найти номера и названия отделов, в которых в период с 01.01.2017 по 31.12.2017 работало не более пяти работников.
SELECT DEPTID, DEPTNAME
FROM DEPT
WHERE DEPTID NOT IN (
    SELECT count(DISTINCT(EMPNO))
    FROM CAREER
    WHERE ENDDATE < to_date('01-01-2017','dd-mm-yyyy') AND STARTDATE > to_date('31-12-2017','dd-mm-yyyy')
);

--13. Найти информацию об отделах (номер, название), всем работникам которых не начислялась премия в период с 01.01.2017 по 31.12.2017.
SELECT DEPTID, DEPTNAME
FROM DEPT
WHERE DEPTID NOT IN (
    SELECT DEPT.DEPTID
    FROM DEPT JOIN CAREER ON DEPT.DEPTID = CAREER.DEPTID JOIN BONUS on CAREER.EMPNO = BONUS.EMPNO
    WHERE YEAR = 2012 AND STARTDATE <= to_date('31.12.2017','dd-mm-yyyy') AND (ENDDATE >= to_date('01.01.2017','dd-mm-yyyy') OR ENDDATE IS NULL)
    GROUP BY DEPT.DEPTID
);

--14. Найти количество работников, никогда не работавших и не работающих в исследовательском (Research) отделе, но работавших или работающих в отделе поддержки (Support).
SELECT COUNT(EMPNO)
FROM EMP
WHERE EMP.EMPNO NOT IN (
    SELECT DISTINCT EMPNO
    FROM CAREER JOIN DEPT ON CAREER.DEPTID = DEPT.DEPTID
    WHERE DEPT.DEPTNAME = 'Research'
) AND EMP.EMPNO IN (
    SELECT DISTINCT EMPNO
    FROM CAREER JOIN DEPT ON CAREER.DEPTID = DEPT.DEPTID
    WHERE DEPT.DEPTNAME = 'Support'
);

-- 15 Найти коды и фамилии работников, работавших в двух и более отделах, но не работающих в настоящее время в компании.
SELECT EMPNO, EMPNAME
FROM EMP
WHERE EMP.EMPNO IN (
    SELECT CAREER.EMPNO
    FROM CAREER
    GROUP BY CAREER.EMPNO HAVING count(DISTINCT CAREER.DEPTID) >= 2
) AND EMP.EMPNO NOT IN (
    SELECT CAREER.EMPNO
    FROM CAREER
    WHERE CAREER.ENDDATE IS NULL
);

-- 16 Найти коды и фамилии работников, работавших в двух и более должностях, но не работающих в настоящее время в компании.
SELECT EMPNO, EMPNAME
FROM EMP
WHERE EMP.EMPNO IN (
    SELECT CAREER.EMPNO
    FROM CAREER
    GROUP BY CAREER.EMPNO HAVING count(DISTINCT CAREER.JOBNO) >= 2
) AND EMP.EMPNO NOT IN (
    SELECT CAREER.EMPNO
    FROM CAREER
    WHERE CAREER.ENDDATE IS NULL
);

-- 17 Найти коды и фамилии работников, суммарный стаж работы которых в компании на текущий момент не более 8 лет.
SELECT EMP.EMPNO, EMPNAME
FROM EMP JOIN CAREER ON EMP.EMPNO = CAREER.EMPNO
GROUP BY EMP.EMPNO, EMPNAME HAVING sum(months_between(nvl(ENDDATE, current_date), STARTDATE)) <= 8 * 12;

-- 18 Найти всех работников (коды и фамилии), увольнявшихся хотя бы один раз.
SELECT DISTINCT EMP.EMPNO, EMPNAME
FROM CAREER JOIN EMP ON CAREER.EMPNO = EMP.EMPNO
WHERE CAREER.ENDDATE IS NOT NULL;

--19. Найти среднии премии, начисленные за период в три 2014, 2015, 2016 года, и за период в три 2015, 2016, 2017 года, в разрезе работников (т.е. для работников, имевших начисления хотя бы в одном месяце трёхгодичного периода).
-- Вывести id, имя и фимилию работника, период, среднюю премию.
SELECT avg(BONVALUE), '2014, 2015, 2016' AS YEARS
FROM BONUS
WHERE YEAR IN (2014, 2015, 2016) UNION (
    SELECT avg(BONVALUE), '2015, 2016, 2017' AS YEARS
    FROM BONUS
    WHERE YEAR IN (2015, 2016, 2017)
);

--20. Найти отделы (id, название, адрес), в которых есть начисления премий в апреле и марте 2016 года.
SELECT DISTINCT DEPT.DEPTID, DEPTNAME, DEPTADDRESS
FROM DEPT JOIN (CAREER JOIN BONUS ON CAREER.EMPNO = BONUS.EMPNO) ON DEPT.DEPTID = CAREER.DEPTID
WHERE BONUS.MONTH IN (3,4) AND BONUS.YEAR = 2009 AND STARTDATE <= to_date('01-04-2016','dd-mm-yyyy') AND (ENDDATE >= to_date('30-04-2016','dd-mm-yyyy') OR ENDDATE IS NULL);
