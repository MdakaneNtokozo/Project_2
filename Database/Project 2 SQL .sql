CREATE TABLE family_member(
	family_member_id INT PRIMARY KEY, 
	family_member_name CHAR(100),
	family_member_surname CHAR(100),
	family_member_email CHAR(100) NOT NULL,
	family_member_password CHAR(100),
	family_member_role INT NOT NULL, 
    family_group_id CHAR(30) NOT NULL
);

CREATE TABLE reward(
	reward_id INT PRIMARY KEY,
	reward_name CHAR(100) NOT NULL,
    reward_desc CHAR(100) NOT NULL,
	reward_img CHAR(100) 
);

CREATE TABLE week(
	week_id INT PRIMARY KEY,
	week_no INT NOT NULL,
	monday DATETIME NOT NULL,
	tuesday DATETIME NOT NULL,
	wednesday DATETIME NOT NULL,
	thursday DATETIME NOT NULL,
	friday DATETIME NOT NULL,
	saturday DATETIME NOT NULL,
	sunday DATETIME NOT NULL,
	reward_id INT NOT NULL,
	FOREIGN KEY (reward_id) REFERENCES reward(reward_id)
);

CREATE TABLE selected_days(
	selected_days_id INT PRIMARY KEY,
	monday DATETIME,
	tuesday DATETIME,
	wednesday DATETIME,
	thursday DATETIME,
	friday DATETIME,
	saturday DATETIME,
	sunday DATETIME
);

CREATE TABLE task(
	task_id INT PRIMARY KEY,
	task_name CHAR(100) NOT NULL,
    task_desc CHAR(150) NOT NULL,
    task_points INT NOT NULL,
	week_id INT NOT NULL,
	selected_days_id INT NOT NULL,
    family_group_id CHAR(30) NOT NULL,
	FOREIGN KEY (week_id) REFERENCES week(week_id),
	FOREIGN KEY (selected_days_id) REFERENCES selected_days(selected_days_id)
);

CREATE TABLE completed_task(
	task_id INT NOT NULL,
	family_member_id INT NOT NULL,
	day_needed_to_be_completed DATETIME NOT NULL,
    day_actually_completed DATETIME NOT NULL,
	PRIMARY KEY (task_id, family_member_id, day_needed_to_be_completed),
	FOREIGN KEY (task_id) REFERENCES task(task_id),
	FOREIGN KEY (family_member_id) REFERENCES family_member(family_member_id)
);

CREATE TABLE won_reward(
	reward_id INT NOT NULL,
	family_member_id INT NOT NULL,
	date_rewarded DATETIME NOT NULL,
	FOREIGN KEY (reward_id) REFERENCES reward(reward_id),
	FOREIGN KEY (family_member_id) REFERENCES family_member(family_member_id)
);