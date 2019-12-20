--Выбирите СУБД Oracle для выполнения лабораторной.
--Cкопируйте файл FPMI-stud\SUBFACULTY\кафИСУ\Исаченко\МДиСУБДII\EDU1.sql в каталог C:\TEMP .
--Раскройте файл и ознакомтесь со скриптом создания и заполнения таблиц для выполнения лабораторной.
-- Произведите запуск SQLPlus. или PLSQLDeveloper. или другого инструментария Oracle b соеденитесь с БД. Запустите скрипт EDU.sql на выполнение.
--Вставте в эту строку Ваши ФИО, номер группы, курса. ФИО , группа , курс 4.
--Файл с отчётом о выполнении лабораторной создаётся путём вставки соответсвующего select-предложения после строки с текстом задания.
--Файл отчёта именуется фамилией студента в английской транскрипции, с расширением .txt и сохраняется в каталог fpmi-serv604\common-stud\Исаченко\гр_ .
--Тексты заданий:
--1. Выдать информацию об адресе отдела продаж (Sales) компании.
SELECT DEPTADDRESS
FROM DEPT
WHERE DEPTNAME = 'Sales';

--2. Выдать информацию обо всех работниках, родившихся не ранее 1 января 1985 года.
SELECT *
FROM EMP
WHERE BIRTHDATE >= to_date('01-01-1985', 'dd-mm-yyyy');

--3. Найти минимальный оклад, предусмотренный для водителя (Driver).
SELECT MINSALARY
FROM JOB
WHERE JOBNAME = 'Driver';

--4. Подсчитать число работников, работавших в компании после 31 мая 2017 года хотя бы один день (31 мая 2017 года не включается).
SELECT count(DISTINCT empno)
FROM career
WHERE (startdate > to_date('31-05-2017','dd-mm-yyyy') AND (startdate < enddate OR enddate IS NULL));

--5. Найти минимальные премии, начисленные в 2014, 2015, 2016, 2017 годах (указать год и минимальную. премию в хронологическом порядке).
SELECT YEAR, min(bonvalue)
FROM bonus
WHERE (YEAR > 2013 AND YEAR < 2018)
GROUP BY YEAR
ORDER BY YEAR;

--6. Выдать информацию о кодах всех должностей, на которых работала работник Nina Tihanovich. Если Nina Tihanovich работает в настоящее время - должность также включается в искомый список.
SELECT DISTINCT career.jobno
FROM career INNER JOIN emp ON emp.empno = career.empno
WHERE (emp.empname = 'Nina Tihanovich');

--7. Выдать информацию о названиях должностей, на которых работали работники Richard Martin и Jon Martin. Если один из них или оба работают в настоящее время - должность также включается в искомый список. Должность выдаётся вместе с ФИО (empname) работника.
SELECT DISTINCT job.jobname, emp.empname
FROM career
         INNER JOIN emp ON emp.empno = career.empno
         INNER JOIN job ON job.jobno = career.jobno
WHERE (emp.empname = 'Richard Martin' OR emp.empname = 'Jon Martin');

-- 8. Найти фамилии, коды должностей и периоды работы (даты приема и даты увольнения) для всех клерков (Clerk) и водителей (Driver), работавших или работающих в компании. Для работающих дата увольнения для периода неопределена и при выводе либо отсутсвует, либо определяется как Null.
SELECT emp.empname,
       job.jobno,
       career.startdate,
       career.enddate
FROM career
         INNER JOIN emp ON emp.empno = career.empno
         INNER JOIN job ON job.jobno = career.jobno
WHERE (job.jobname = 'Clerk' OR job.jobname = 'Driver');

-- 9. Найти фамилии, названия должностей и периоды работы (даты приема и даты увольнения) для бухгалтеров (Accountant) и исполнительных директоров (Executive Director), работавших или работающих в компании. Для работающих дата увольнения для периода неопределена и при выводе либо отсутсвует, либо определяется как Null.
SELECT emp.empname,
       job.jobname,
       career.startdate,
       career.enddate
FROM career
         INNER JOIN emp ON emp.empno = career.empno
         INNER JOIN job ON job.jobno = career.jobno
WHERE (job.jobname = 'Accountant' OR job.jobname = 'Executive Director');

-- 10. Найти количество различных работников, работавших в отделе B02 в период с 01.01.2014 по 31.12.2017 хотя бы один день.
SELECT count(DISTINCT empno)
FROM career
WHERE ( deptid = 'B02'
    AND startdate <= to_date('31.12.2017','dd.mm.yyyy')
    AND (enddate >= to_date('01.01.2014','dd.mm.yyyy') OR enddate IS NULL));

-- 11. Найти фамилии этих работников.
SELECT DISTINCT emp.empname
FROM emp INNER JOIN career ON emp.empno = career.empno
WHERE ( deptid = 'B02'
    AND startdate <= to_date('31.12.2017','dd.mm.yyyy')
    AND (enddate >= to_date('01.01.2014','dd.mm.yyyy') OR enddate IS NULL));

--12. Найти номера и названия отделов, в которых не было ни одного работника в период с 01.01.2015 по 31.12.2015.
SELECT DISTINCT dept.deptid,
                dept.deptname
FROM dept LEFT OUTER JOIN career ON career.deptid = dept.deptid
WHERE (
          SELECT count(*)
          FROM career
          WHERE ( career.deptid = dept.deptid
              AND career.startdate <= to_date('31.12.2015','dd-mm-yyyy')
              AND (career.enddate >= to_date('01.01.2015','dd-mm-yyyy') OR career.enddate IS NULL) )
      ) = 0;

--13. Найти информацию о работниках (номер, фамилия), для которых нет начислений премии в период с 01.01. 2014 по 31.12.2015.
SELECT DISTINCT emp.empno,
                emp.empname
FROM emp LEFT OUTER JOIN bonus ON bonus.empno = emp.empno
WHERE (
          SELECT count(*)
          FROM bonus
          WHERE bonus.empno = emp.empno
            AND bonus.year BETWEEN 2014 AND 2015
      ) = 0;

--14. Найти количество работников, никогда не работавших ни в исследовательском (Research) отделе, ни в отделе поддержки (Support).
SELECT count(DISTINCT emp.empno)
FROM emp
         LEFT OUTER JOIN career ON career.empno = emp.empno
         INNER JOIN dept ON dept.deptid = career.deptid
WHERE (
          SELECT count(*)
          FROM career
          WHERE career.empno = emp.empno AND (dept.deptname = 'Research' OR dept.deptname = 'Support')
      ) = 0;

-- 15. Найти коды и фамилии работников, работавших в двух и более отделах. Если работник работает в настоящее время, то отдел также учитывается.
SELECT DISTINCT emp.empno, emp.empname
FROM emp INNER JOIN career ON career.empno = emp.empno
WHERE (
          SELECT count(DISTINCT deptid)
          FROM career
          WHERE career.empno = emp.empno
      ) >= 2;

-- 16. Найти коды и фамилии работников, работавших на двух и более должностях. Если работник работает в настоящее время, то должность также учитывается.
SELECT DISTINCT emp.empno, emp.empname
FROM emp INNER JOIN career ON career.empno = emp.empno
WHERE (
          SELECT count(DISTINCT jobno)
          FROM career
          WHERE career.empno = emp.empno
      ) >= 2;

-- 17. Найти коды и фамилии работников, суммарный стаж работы которых в компании не менее 4 лет.
SELECT emp.empno, empname
FROM emp JOIN career ON emp.empno = career.empno
GROUP BY emp.empno, empname
HAVING sum(MONTHS_BETWEEN(NVL(enddate, current_date), startdate)) >= 4 * 12;

-- 18. Найти всех работников (коды и фамилии), увольнявшихся хотя бы один раз.
SELECT DISTINCT emp.empno, emp.empname
FROM emp INNER JOIN career ON career.empno = emp.empno
WHERE (
          SELECT count(*)
          FROM career
          WHERE career.empno = emp.empno AND enddate IS NOT NULL
      ) > 0;

--19. Найти среднии премии, начисленные за период в два 2014, 2015 года, и за период в два 2015, 2016 года, в разрезе работников (т.е. для работников, имевших начисления хотя бы в одном месяце двугодичного периода). Вывести id, имя и фимилию работника, период, среднюю премию.
SELECT emp.empno, emp.empname, '2014, 2015' years, avg(bonvalue)
FROM bonus JOIN emp ON bonus.empno = emp.empno
WHERE year IN (2014, 2015)
GROUP BY emp.empno, emp.empname
UNION
(
    SELECT emp.empno, emp.empname, '2015, 2016' years, avg(bonvalue)
    FROM bonus JOIN emp ON bonus.empno = emp.empno
    WHERE year IN (2015, 2016)
    GROUP BY emp.empno, emp.empname
);

--20. Найти отделы (id, название, адрес), в которых есть начисления премий в феврале 2017 года.
SELECT dept.deptid, deptname, deptaddress
FROM dept JOIN (career JOIN bonus ON career.empno = bonus.empno) ON dept.deptid = career.deptid
WHERE bonus.month = 2 AND bonus.year = 2017;
