use defaultdb;
CREATE TABLE Movie (
    id varchar(255) primary key,
    movie_name varchar(255),
    description_text text,
    image text,
    start_date date,
    end_date date
);

CREATE TABLE ticket (
    id varchar(255) primary key,
    user_id varchar(255),
    show_id varchar(255),
    qty int,
    movie_id varchar(255),
    amount int
);

CREATE TABLE shows (
    id varchar(255) primary key,
    movie_id varchar(255),
    date_selected date,
    time_id varchar(255),
    seats_left int,
    location_id varchar(255)
);

CREATE TABLE location (
    id varchar(255) primary key,
    loc_name varchar(255),
    address varchar(255),
    seats int,
    time_id varchar(255)
);

CREATE TABLE times (
    id varchar(255) primary key,
    times varchar(255)
);

# populate movie table
INSERT INTO `defaultdb`.`Movie` (`id`, `movie_name`, `description_text`, `image`, `start_date`, `end_date`) VALUES ('123', 'movie 1', 'hello', 'image', DATE '2024-01-01', DATE '2024-01-10');
INSERT INTO `defaultdb`.`Movie` (`id`, `movie_name`, `description_text`, `image`, `start_date`, `end_date`) VALUES ('1234', 'movie 2', 'hello 2', 'image 2', DATE '2024-02-01', DATE '2024-02-10');

# populate location table
INSERT INTO `defaultdb`.`location` (`id`, `loc_name`, `address`, `seats`, `time_id`) VALUES ('123', 'austin', 'austin', 20, '123');
INSERT INTO `defaultdb`.`location` (`id`, `loc_name`, `address`, `seats`, `time_id`) VALUES ('124', 'austin', 'austin', 20, '124');
INSERT INTO `defaultdb`.`location` (`id`, `loc_name`, `address`, `seats`, `time_id`) VALUES ('125', 'austin', 'austin', 20, '125');

INSERT INTO `defaultdb`.`location` (`id`, `loc_name`, `address`, `seats`, `time_id`) VALUES ('126', 'austin', 'austin', 20, '123');
INSERT INTO `defaultdb`.`location` (`id`, `loc_name`, `address`, `seats`, `time_id`) VALUES ('127', 'austin', 'austin', 20, '126');

# populate times
INSERT INTO `defaultdb`.`times` (`id`, `times`) VALUES ('123', '2PM');
INSERT INTO `defaultdb`.`times` (`id`, `times`) VALUES ('124', '4PM');
INSERT INTO `defaultdb`.`times` (`id`, `times`) VALUES ('125', '5PM');
INSERT INTO `defaultdb`.`times` (`id`, `times`) VALUES ('126', '6PM');

# insert a show
INSERT INTO `defaultdb`.`shows` (`id`, `movie_id`, `date_selected`,`time_id`, `seats_left`, `location_id`) VALUES ('123', '123',DATE '2024-01-24', '123', 18, '123');

SELECT `defaultdb`.`location`.id as location_id, `defaultdb`.`times`.id as time_id FROM `defaultdb`.`location` LEFT JOIN `defaultdb`.`times` ON `defaultdb`.`location`.time_id = `defaultdb`.`times`.id;
SELECT * FROM `defaultdb`.`shows` WHERE location_id='123' AND movie_id='123' AND time_id='123' AND date_selected='2024-01-24';