--1
select instructor.name
  from instructor
 where instructor.dept_name = 'Comp. Sci.';

--2
select instructor.name,
       instructor.salary
  from instructor
 where instructor.dept_name = 'Comp. Sci.'
   and instructor.salary > 75000;

--3
select course.title
  from course
 where course.dept_name = 'Comp. Sci.'
   and course.credits = 3;

--4
select takes.course_id,
       course.title
  from takes,
       course
 where takes.id = '76543'
   and takes.course_id = course.course_id;

--5
select takes.id,
       sum(course.credits) as total_credits
  from takes,
       course
 where takes.id = '76543'
   and takes.course_id = course.course_id
 group by takes.id;

--6
select takes.id,
       sum(course.credits) as total_credits
  from takes,
       course
 where takes.course_id = course.course_id
 group by takes.id;

--7
select distinct student.name
  from student,
       course,
       takes
 where course.dept_name = 'Comp. Sci.'
   and student.id = takes.id
   and course.course_id = takes.course_id; 

--8
select distinct instructor.id
  from instructor
minus
select distinct instructor.id
  from instructor,
       teaches
 where instructor.id = teaches.id;

--9
select distinct instructor.id,
                instructor.name
  from instructor
minus
select distinct instructor.id,
                instructor.name
  from instructor,
       teaches
 where instructor.id = teaches.id;

--10
update instructor
   set
	instructor.salary = '85752'
 where instructor.name = 'Katz';

--11
insert into instructor (
	id,
	name,
	dept_name,
	salary
) values ( '88888',
           'Marissa',
           'Comp. Sci.',
           '81000' );

--12
insert into section (
	course_id,
	sec_id,
	semester,
	year,
	building,
	room_number,
	time_slot_id
) values ( 'CS-101',
           '2',
           'Fall',
           '2024',
           'Packard',
           '101',
           'B' );
insert into teaches (
	id,
	course_id,
	sec_id,
	semester,
	year
) values ( '88888',
           'CS-101',
           '2',
           'Fall',
           '2024' );