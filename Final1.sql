drop table user;
delete from expenses;
delete from insurance;
delete from bankaccount;
delete from investment;
delete from loan;
delete from user;
create table user
( 
userid INT NOT NULL PRIMARY KEY,
username varchar(15) NOT NULL,
password1 varchar(15) NOT NULL,
phone_no varchar(10) NOT NULL,
email varchar(20) NOT NULL
);

ALTER TABLE user MODIFY userid INT AUTO_INCREMENT;
SELECT * FROM USER;

DELIMITER $$
CREATE PROCEDURE insert_user(
  IN username_in VARCHAR(15),
  IN password_in VARCHAR(15),
  IN phone_no_in VARCHAR(10),
  IN email_in VARCHAR(20)
)
BEGIN
  INSERT INTO user (username, password1, phone_no, email)
  VALUES ( username_in, password_in, phone_no_in, email_in);
END $$
DELIMITER ;

CALL insert_user('john', 'password123', '555-1234', 'john@example.com');
CALL insert_user('johny', 'password123', '555-1234', 'john@example.com');
CALL insert_user('john123', 'assword123', '555-1234', 'john@example.com');
CALL insert_user('cool', 'password123', '555-1234', 'john@example.com');


SELECT * FROM USER;


DELIMITER $$
CREATE PROCEDURE select_user(IN in_userid INT)
BEGIN
    SELECT * FROM user WHERE userid = in_userid;
END $$
DELIMITER ;

CALL select_user(4);


DELIMITER $$
CREATE PROCEDURE update_username(
  IN userid_in INT,
  IN new_username VARCHAR(15)
)
BEGIN
  UPDATE user
  SET username = new_username
  WHERE userid = userid_in;
END $$
DELIMITER ;

CALL update_username(2, 'awesome');

SELECT * FROM USER;

DELIMITER $$
CREATE PROCEDURE update_password(
  IN userid_in INT,
  IN new_password VARCHAR(15)
)
BEGIN
  UPDATE user
  SET password1 = new_password
  WHERE userid = userid_in;
END $$
DELIMITER ;


CALL update_password(2, 'new_pass');

SELECT * FROM USER;

DELIMITER $$
CREATE PROCEDURE update_email(
  IN userid_in int,
  IN new_email VARCHAR(20)
)
BEGIN
  UPDATE user
  SET email = new_email
  WHERE userid = userid_in;
END $$
DELIMITER ;

CALL update_email(2, 'new324@example.com');

SELECT * FROM USER;

DELIMITER $$
CREATE PROCEDURE update_phone_no(
  IN userid_in INT,
  IN new_phone_no VARCHAR(10)
)
BEGIN
  UPDATE user
  SET phone_no = new_phone_no
  WHERE userid = userid_in;
END $$
DELIMITER ;

CALL update_phone_no(2, '1234563890');

SELECT * FROM USER;

SELECT * FROM USER;

CREATE TABLE expenses(
  spend_id INT ,
  userid INT,
  date DATE,
  item_name VARCHAR(50),
  category VARCHAR(50),
  amount numeric,
  notes TEXT,
  PRIMARY KEY (userid,spend_id),
  FOREIGN KEY (userid) REFERENCES user(userid)
);


DELIMITER $$

CREATE PROCEDURE insert_expense(
  IN p_userid INT,
  IN p_date DATE,
  IN p_amount NUMERIC,
  IN p_item_name VARCHAR(50),
  IN p_category VARCHAR(50),
  IN p_notes TEXT
)
BEGIN
  DECLARE count1 INTEGER;
  SELECT max(spend_id) into count1 from expenses where userid=p_userid;
  SELECT COALESCE(count1, 0) into count1;
  INSERT INTO expenses (spend_id,userid, date,amount, item_name, category, notes)
  VALUES (count1+1,p_userid, p_date, p_amount,p_item_name, p_category, p_notes);
END $$
DELIMITER ;

CALL insert_expense(10, '2012-04-01', 1000.7,'Groceries', 'Food', 'Bought groceries for the week');

select * from expenses;

DELIMITER $$
CREATE PROCEDURE delete_expense(IN in_spendid INT,IN user_id INT)
BEGIN
    DELETE FROM expenses WHERE spend_id = in_spendid and userid=user_id;
END $$
DELIMITER ;

CALL delete_expense(2,10);


DELIMITER $$
CREATE PROCEDURE select_expenses(IN in_userid INT)
BEGIN
    SELECT * FROM expenses WHERE userid = in_userid;
END $$
DELIMITER ;

CALL select_expenses(10);


CREATE TABLE loan (
  loan_no varchar(10) NOT NULL ,
  amount DECIMAL(10, 2) NOT NULL,
  due_date DATE NOT NULL,
  interest_rate DECIMAL(5, 2) NOT NULL,
  bank_name VARCHAR(50) NOT NULL,
  userid INT NOT NULL,
  PRIMARY KEY (bank_name,loan_no),
  FOREIGN KEY (userid) REFERENCES user(userid)
);



DELIMITER $$
CREATE PROCEDURE insert_loan(
	IN p_loan_no varchar(10),
    IN p_amount DECIMAL(10,2),
    IN p_due_date DATE,
    IN p_interest_rate DECIMAL(4,2),
    IN p_bank_name VARCHAR(50),
    IN p_user_id INT
)
BEGIN
    INSERT INTO loan (loan_no, amount, due_date, interest_rate, bank_name, userid) 
    VALUES (p_loan_no, p_amount, p_due_date, p_interest_rate, p_bank_name, p_user_id);
END $$
DELIMITER ;

CALL insert_loan('ABC',5000.00, '2023-04-30', 5.5, 'Example1 Bank',10);

select * from loan;

DELIMITER $$
CREATE PROCEDURE select_loans_by_userid(IN in_userid INT)
BEGIN
  SELECT *  FROM loan WHERE userid = in_userid;
END $$
DELIMITER ;

CALL select_loans_by_userid(4);


DELIMITER $$
CREATE PROCEDURE update_loan_amount(IN p_loan_no varchar(10), IN p_userid INT, IN p_new_amount DECIMAL(10, 2),IN p_bank_name varchar(50))
BEGIN
    UPDATE loan SET amount = p_new_amount WHERE loan_no = p_loan_no AND userid = p_userid AND bank_name=p_bank_name;
END $$
DELIMITER ;

CALL update_loan_amount('ABC', 4, 5300.00,'Example Bank');

select * from loan;

DELIMITER $$
CREATE PROCEDURE update_due_date (IN user_id INT,IN loan_no varchar(10),IN new_due_date DATE,IN p_bank_name varchar(50))
BEGIN
  UPDATE loan
  SET due_date = new_due_date
  WHERE user_id = user_id AND loan_no = loan_no AND bank_name=p_bank_name;
END $$
DELIMITER ;

SET SQL_SAFE_UPDATES = 0;

CALL update_due_date(4,'ABC','2024-05-31','Example Bank');

DELIMITER $$
CREATE PROCEDURE delete_loan(IN in_loan_no varchar(10),IN user_id INT,IN in_bank_name VARCHAR(50))
BEGIN
    DELETE FROM loan WHERE loan_no = in_loan_no and userid=user_id and bank_name=in_bank_name;
END $$
DELIMITER ;

CALL delete_loan('ABC',10,'Example1 Bank');



DELIMITER $$
CREATE PROCEDURE delete_user(
  IN userid_in int
)
BEGIN
  DELETE FROM expenses where userid = userid_in;
  DELETE FROM loan where userid = userid_in;
  DELETE FROM INSURANCE where userid=userid_in;
  delete from investment where userid=userid_in;
  delete from bankaccount where userid=userid_in;
  DELETE FROM user WHERE userid = userid_in;
  
  
END $$
DELIMITER ;

CALL delete_user(6);

create table insurance
(
	userid int,
	Insurance_id int,
    Type_insurance varchar(20),
    IdHolderName varchar(26),
    Holder_id int,
    expiry date,
    amount_paid double,
    agent varchar(20),
    primary key(userid,Insurance_id,agent),
    foreign key(userid) references user(userid)
);

insert into insurance values(8,1,'Life insurance','Sharmi',33,'2004-01-14',10000,'LIC');
insert into insurance values(8,2,'Car insurance','Dhikshi',26,'2004-10-08',20000,'LIC');
insert into insurance values(9,3,'Bike insurance','Dhivya',06,'2004-03-20',30000,'LIC');
insert into insurance values(11,4,'Health insurance','Jai',14,'2004-03-14',40000,'Sid');
insert into insurance values(10,5,'Commercial insurance','Harshu',12,'2003-04-10',50000,'Sid');


select * from insurance;

delimiter //
create procedure insert_insurance(in user_id int,in Insurance_id int,in Type_insurance varchar(20),in IdHolderName varchar(20),in Holder_id int,in expiry date,in amount_paid double,in agent varchar(20))
	begin
		insert into insurance values(user_id,Insurance_id,Type_insurance,IdHolderName,Holder_id,expiry,amount_paid,agent);
	end
    //
delimiter ;

delimiter //
create procedure delete_insurance(in user_id int)
	begin
		delete from insurance where userid=user_id;
	end
    //
delimiter ;

delimiter //
create procedure display_insurance(in user_id int)
	begin
		select * from insurance where userid=user_id;
	end
    //
delimiter ;




create table investment
(
	userid int,
	Investment_id int,
    Investment_type varchar(30),
    amount double,
    date_invested date,
    investment_platform varchar(26),
    scheme varchar(20),
    primary key(userid,Investment_id),
    foreign key(userid) references user(userid)
);

insert into investment values(8,10,'PPF',26000,'2003-07-14','Post office','Fixed deposit');
insert into investment values(9,20,'SCSS Scheme',30000,'2003-04-10','Bank','Mutual Funds');

delimiter //
create procedure insert_investment(in user_id int,in Investment_id int,in Investment_type varchar(30),in amount double,in date_invested date,in investment_platform varchar(26),in scheme varchar(20))
	begin
		insert into insurance values(user_id,Invest_id,Invest_type,amt,date_invest,invest_plat,scheme);
	end
    //
delimiter ;

delimiter //
create procedure delete_investment(in user_id int,in Invest_id int)
	begin
		delete from insurance where userid=user_id and Investment_id=Invest_id;
	end
    //
delimiter ;

delimiter //
create procedure display_investment(in user_id int)
	begin
		select * from investment where userid=user_id;
	end
    //
delimiter ;

select * from investment;


create table BankAccount
(
	userid int,
	Acct_no int,
    amount double,
    TypeAcct varchar(20),
    interest_rate int,
    BankName varchar(30),
    Maturity_date date,
    primary key(userid,Acct_no),
    foreign key(userid) references user(userid)
);

insert into BankAccount values(8,35,3000,'Current',2,'State Bank of India','2004-03-01');
insert into BankAccount values(9,36,4000,'Salary',5,'Karur Vysya Bank','2003-12-05');
insert into BankAccount values(10,17,5000,'Savings',4,'ICICI Bank','2004-03-17');

delimiter //
create procedure insert_bankacct(in user_id int,in Acctnum int,in amt double,in typeacct varchar(20),in intrate int,in bank varchar(30),in Matudate date)
	begin
		insert into BankAccount values(user_id,Acctnum,amt,typeacct,intrate,bank,Matudate);
	end
    //
delimiter ;

delimiter //
create procedure delete_bankacct(in user_id int,in acc int)
	begin
		delete from BankAccount where userid=user_id and Acct_no=acc;
	end
    //
delimiter ;

delimiter //
create procedure display_bankacct(in user_id int)
	begin
		select * from BankAccount where userid=user_id;
	end
    //
delimiter ;

delimiter //
create procedure update_amt(in user_id int,in acctno double,in amt double)
	begin
		update BankAccount
        set amount=amt where userid=user_id and Acct_no=acctno;
	end
    //
delimiter ;
        
delimiter //
create procedure update_matdate(in user_id int,in acctno int,in matdate date)
	begin
		update BankAccount
        set Maturity_date=matdate where userid=user_id and Acct_no=acctno;
	end
    //
delimiter 

select * from bankaccount;



DELIMITER $$
CREATE PROCEDURE check_user(IN in_userid INT, IN password12 varchar(15))
BEGIN
    DECLARE count1 INTEGER;
    SELECT COUNT(userid) into count1 FROM user WHERE userid = in_userid AND password1 = password12;
    SELECT count1;
END $$
DELIMITER ;


CALL check_user(20,'password123');


select * from expenses;
select * from insurance;
select * from bankaccount;
select * from investment;
select * from loan;
select * from USER;


DELIMITER $$
CREATE TRIGGER remove_child_rows
BEFORE DELETE ON user
FOR EACH ROW
BEGIN
  -- Delete child rows
  DELETE FROM expenses WHERE userid = OLD.userid;
  DELETE FROM loan WHERE userid = OLD.userid;
  DELETE FROM insurance WHERE userid = OLD.userid;
  DELETE FROM investment WHERE userid = OLD.userid;
  DELETE FROM bankaccount WHERE userid = OLD.userid;
END $$
DELIMITER ;


delete from user where userid=11;