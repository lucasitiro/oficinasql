CREATE TYPE sex as ENUM ('M','F','O')

CREATE TABLE employee (
	Fname varchar(15) not null,
	Mname varchar(15),
	Lname varchar(20) not null,
	ssn char(9) not null,
	Bdate date,
	Adress varchar(30),
	current_sex sex,
	salary decimal(10,2),
	Superssn char(9),
	Dno int not null default 1,
	constraint pk_employee primary key(ssn),
	constraint fk_employee foreign key(Superssn) references employee(ssn) on update cascade
	
);

create table departament(
	Dname varchar(15) not null,
    Dnumber int not null,
    Mgr_ssn char(9) not null,
    Mgr_start_date date, 
    Dept_create_date date,
    constraint chk_dept_date check (Dept_create_date <= Mgr_start_date and Dnumber <> 0) ,
    constraint pk_dept primary key (Dnumber),
    constraint unique_name_dept unique(Dname),
    constraint fk_dept foreign key (Mgr_ssn) references employee(Ssn) on update cascade
);

create table dept_locations(
	Dnumber int not null,
	Dlocation varchar(15) not null,
    constraint pk_dept_locations primary key (Dnumber, Dlocation),
    constraint fk_dept_locations foreign key (Dnumber) references departament (Dnumber) on update cascade
);

create table project(
	Pname varchar(15) not null,
	Pnumber int not null,
    Plocation varchar(15),
    Dnum int not null,
    constraint pk_project primary key (Pnumber),
    constraint unique_name_project unique (Pname),
    constraint fk_project foreign key (Dnum) references departament(Dnumber)
);

create table works_on(
	Essn char(9) not null,
    Pno int not null,
    Hours decimal(3,1) not null,
    primary key (Essn, Pno),
    constraint fk_works_on foreign key (Essn) references employee(ssn),
    foreign key (Pno) references project(Pnumber)
);

create table dependent(
	Essn char(9) not null,
    dependent_name varchar(255) not null,
    Sex char,
    Bdate date,
    Age int,
    Relationship varchar(8),
    constraint chk_age_dependent check (Age < 21),
    constraint pk_dependent primary key(Essn, dependent_name),
    constraint fk_dependent foreign key (Essn) references employee(ssn)
);



insert into employee values ('John', 'B', 'Smith', 123456789, '1965-01-09', '731-Fondren-Houston-TX', 'M', 30000, 333445555, 5),
							('Franklin', 'T', 'Wong', 333445555, '1955-12-08', '638-Voss-Houston-TX', 'M', 40000, 888665555, 5),
                            ('Alicia', 'J', 'Zelaya', 999887777, '1968-01-19', '3321-Castle-Spring-TX', 'F', 25000, 987654321, 4),
                            ('Jennifer', 'S', 'Wallace', 987654321, '1941-06-20', '291-Berry-Bellaire-TX', 'F', 43000, 888665555, 4),
                            ('Ramesh', 'K', 'Narayan', 666884444, '1962-09-15', '975-Fire-Oak-Humble-TX', 'M', 38000, 333445555, 5),
                            ('Joyce', 'A', 'English', 453453453, '1972-07-31', '5631-Rice-Houston-TX', 'F', 25000, 333445555, 5),
                            ('Ahmad', 'V', 'Jabbar', 987987987, '1969-03-29', '980-Dallas-Houston-TX', 'M', 25000, 987654321, 4),
                            ('James', 'E', 'Borg', 888665555, '1937-11-10', '450-Stone-Houston-TX', 'M', 55000, NULL, 1);

insert into dependent values (333445555, 'Alice', 'F', '1986-04-05',20, 'Daughter'),
							 (333445555, 'Theodore', 'M', '1983-10-25',8, 'Son'),
                             (333445555, 'Joy', 'F', '1958-05-03',19, 'Spouse'),
                             (987654321, 'Abner', 'M', '1942-02-28',10, 'Spouse'),
                             (123456789, 'Michael', 'M', '1988-01-04',7, 'Son'),
                             (123456789, 'Alice', 'F', '1988-12-30',12, 'Daughter'),
                             (123456789, 'Elizabeth', 'F', '1967-05-05',20, 'Spouse');

insert into departament values ('Research', 5, 333445555, '1988-05-22','1986-05-22'),
							   ('Administration', 4, 987654321, '1995-01-01','1994-01-01'),
                               ('Headquarters', 1, 888665555,'1981-06-19','1980-06-19');

insert into dept_locations values (1, 'Houston'),
								 (4, 'Stafford'),
                                 (5, 'Bellaire'),
                                 (5, 'Sugarland'),
                                 (5, 'Houston');

insert into project values ('ProductX', 1, 'Bellaire', 5),
						   ('ProductY', 2, 'Sugarland', 5),
						   ('ProductZ', 3, 'Houston', 5),
                           ('Computerization', 10, 'Stafford', 4),
                           ('Reorganization', 20, 'Houston', 1),
                           ('Newbenefits', 30, 'Stafford', 4);


insert into works_on values (123456789, 1, 32.5),
							(123456789, 2, 7.5),
                            (666884444, 3, 40.0),
                            (453453453, 1, 20.0),
                            (453453453, 2, 20.0),
                            (333445555, 2, 10.0),
                            (333445555, 3, 10.0),
                            (333445555, 10, 10.0),
                            (333445555, 20, 10.0),
                            (999887777, 30, 30.0),
                            (999887777, 10, 10.0),
                            (987987987, 10, 35.0),
                            (987987987, 30, 5.0),
                            (987654321, 30, 20.0),
                            (987654321, 20, 15.0),
                            (888665555, 20, 0.0);
							
-- Recuperando nomes masculinos
SELECT Fname from employee
WHERE current_sex = 'M';

-- Recuperando todas as colunas de dependent
SELECT * from dependent;

-- Recuperando salário por ordem crescente e Adress em ordem alfabética
SELECT * from employee order by salary;
SELECT * from employee order by Adress;

-- Recuperando a soma dos sálarios de 'M' e/ou 'F' maiores que 93000
SELECT current_sex, SUM(salary) as "Soma dos salários"
FROM employee
GROUP BY current_sex
HAVING SUM(salary) > 93000;

-- Recuperando os funcionários com os respectivos dependentes
SELECT employee.Fname, employee.Lname, dependent.dependent_name
FROM employee
LEFT JOIN dependent ON employee.ssn = dependent.Essn;

-- Essa consulta calcula o número de dependentes para cada funcionário
SELECT employee.Fname, employee.Lname,
COUNT(dependent.dependent_name) AS numero_de_dependentes
FROM employee
LEFT JOIN dependent ON employee.ssn = dependent.Essn
GROUP BY employee.Fname, employee.Lname;


