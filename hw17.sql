create table Orders(
    order_id serial primary key ,
    date date,
    quantity bigint ,
    total_price bigint 
);

alter table Orders
add column track_id BIGINT;
alter table Orders
add constraint fk_track_id
foreign key (track_id) references Tracks(track_id);

update Orders
set track_id =25 where order_id=25;
select * from orders;

create table Creater(
    creater_id serial primary key,
    c_name varchar(255),
    last_name varchar(255),
    country varchar(255)
);
select * from Creater;

create type u_role as enum('customer', 'admin');

create table Users(
    user_id serial primary key,
    creater_id bigint,
    order_id bigint,
    u_name varchar(255),
    last_name varchar(255),
    Email varchar(255),
    address varchar(255),
    phone_number bigint,
    user_role u_role,
    birth_date date,
	foreign key(creater_id) references Creater(creater_id),
	foreign key(order_id) references Orders(order_id)
);
select * from Users;

create table Publisher(
    publisher_id serial primary key,
    p_name varchar(255),
    address text,
    phone_number bigint
);
select * from Publisher;

create table Albums(
    album_id serial primary key,
    publisher_id bigint,
    creater_id bigint,
    titel varchar(255),
    price bigint,
    creation_date date,
	foreign key(publisher_id) references Publisher(publisher_id),
	foreign key(creater_id) references Creater(creater_id)
);
alter table Albums
add track_num integer;
update Albums
-- set track_num=5 where album_id=1;
-- set track_num=4 where album_id=2;
-- set track_num=5 where album_id=3;
-- set track_num=6 where album_id=4;
-- set track_num=7 where album_id=5;
-- set track_num=2 where album_id=6;
-- set track_num=3 where album_id=7;
set track_num=5 where album_id=8;

select * from Albums;

create table Category(
    category_id serial primary key,
    books text,
    musics text,
    lectures text
);
select * from Category;

create type file_type as enum('MP3','MP4','WAV','WMA','M4A','FLAC','AAC');
create type music_style as enum( 'POP','CLASSICAL','ROCK AND ROLL','JAZZ','BLUES','HIP-HOP','ELECTRONIC','COUNTRY');

create table Tracks(
    track_id serial primary key,
    creater_id bigint,
    album_id bigint,
    category_id bigint,
    t_name varchar(255),
    file_size bigint,
    price bigint,
    file_type file_type,
    music_style music_style,
	foreign key(creater_id) references Creater(creater_id),
	foreign key(album_id) references Albums(album_id),
	foreign key(category_id) references Category(category_id)
);

alter table Tracks
add track_time interval;
update Tracks
-- set track_time= '3 minutes' where track_id=20; 1,3,5,14,17,20;
-- set track_time= '4 minutes' where track_id=28; 2,13,16,21,23,28;
-- set track_time= '5 minutes' where track_id=31; 4,15,22,24,27,29,30,31;
set track_time='45 minutes' where track_id=38; 18,19,25,26,32,33,34,35,36,37,38;

alter table Tracks
add t_cost bigint;
update Tracks
set t_cost=price*0.8;
alter table Tracks
add discont_price bigint;

select * from Tracks;

creat table orders_track(
    order_id bigint,
    track_id bigint,
	foreign key(order_id) references orders(order_id),
	foreign key(track_id) references Tracks(track_id)
);
select * from orders_track;

create table Searches(
    search_id serial primary key,
    creater_id bigint,
    track_id bigint,
    album_id bigint,
    publisher_id bigint,
    category_id bigint,
    order_id bigint,
    user_id bigint,
	foreign key(creater_id) references Creater(creater_id),
	foreign key(track_id) references Tracks(track_id),
	foreign key(album_id) references Albums(album_id),
	foreign key(publisher_id) references Publisher(publisher_id),
	foreign key(order_id) references orders(order_id),
	foreign key(user_id) references Users(user_id),
	foreign key(category_id) references Category(category_id)
);
select * from Searches;


INSERT INTO Orders (date, quantity, total_price) VALUES
('2023-01-01', 2, 300),
('2023-02-05', 1, 150),
('2023-03-10', 3, 450),
('2023-04-15', 5, 750),
('2023-05-20', 4, 600);


INSERT INTO Creater (c_name, last_name, country) VALUES
('Taylor', 'Swift', 'USA'),
('Zach', 'Bryan', 'UK'),
('Myles', 'Smith', 'Canada'),
('Cameron', 'Whitcomb', 'Australia'),
('Ella', 'Mai', 'France'),
('Tyler','The Creator', 'USA'),
('Wyatt', 'Flores','USA'),
('Sir Ken', 'Robinson','UK'),
('Brené', 'Brown','USA'),
('Peter', 'Attia','UK'),
('Jennette', 'McCurdy','Canada');


INSERT INTO Users (creater_id, order_id, u_name, last_name, Email, address, phone_number, user_role, birth_date) VALUES
(6, 15, 'Emily', 'White', 'emily@example.com', '123 Main St', 1234567890, 'customer', '1990-01-01'),
(8, 14, 'David', 'Black', 'david@example.com', '456 Side St', 9876543210, 'customer', '1985-02-05'),
(4, 13, 'Sophia', 'Gray', 'sophia@example.com', '789 Center Ave', 5432167890, 'customer', '1992-03-10'),
(2, 12, 'Michael', 'Green', 'michael@example.com', '321 North St', 3216549870, 'customer', '1988-04-15'),
(10, 11, 'Olivia', 'Red', 'olivia@example.com', '654 East Blvd', 9871234560, 'customer', '1995-05-20');


INSERT INTO Publisher (p_name, address, phone_number) VALUES
('Penguin Books', '100 Penguin Rd', 1112223333),
('Sony Music', '500 Sony Ln', 2223334444),
('Universal Music', '750 Universal Dr', 3334445555),
('HarperCollins', '900 Harper St', 4445556666),
('EMI Music', '200 EMI Blvd', 5556667777);


INSERT INTO Albums (publisher_id, creater_id, titel, price, creation_date) VALUES
(1, 1, 'Greatest Hits', 200, '2023-01-15'),
(2, 2, 'Classical Treasures', 300, '2023-02-20'),
(3, 3, 'Rock Classics', 250, '2023-03-25'),
(4, 4, 'Jazz Vibes', 180, '2023-04-30'),
(5, 5, 'Pop Essentials', 220, '2023-05-10'),
(5,13,'TED Talk',215,'2006-02-03'),
(3,15,'Outlive',200,'2020-04-20'),
(3,16,'Im Glad My Mom Died',300,'2021-06-10');


INSERT INTO Category (books, musics, lectures) VALUES
('Mystery', 'Jazz', 'Art History'),
('Science Fiction', 'Rock', 'Computer Science'),
('Non-Fiction', 'Classical', 'Business Management'),
('Romance', 'Pop', 'Psychology'),
('History', 'Electronic', 'Philosophy');


INSERT INTO Tracks (creater_id, album_id, category_id, t_name, file_size, price, file_type, music_style) VALUES
(3, 3, 2, 'THATS SO TRUE', 5000, 10, 'MP3', 'POP'),
(4, 2, 2, 'Classic Tune', 8000, 15, 'FLAC', 'CLASSICAL'),
(5, 4, 1, 'Rock Anthem', 7000, 12, 'MP4', 'ROCK AND ROLL'),
(6, 2, 1, 'Jazz Improvisation', 6000, 8, 'WAV', 'JAZZ'),
(7, 3, 3, 'Electronic Beat', 9000, 20, 'MP3', 'ELECTRONIC'),
(13, 6, 4, 'Do schools kill creativity?',4500,10,'MP4','CLASSICAL'),
(16, 8, 4, 'Im Glad My Mom Died-4',5000,20,'WAV','CLASSICAL');


INSERT INTO Orders_Track (order_id, track_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);


INSERT INTO Search (creater_id, track_id, album_id, publisher_id, category_id, order_id, user_id) VALUES
(1, 1, 1, 1, 1, 1, 1),
(2, 2, 2, 2, 2, 2, 2),
(3, 3, 3, 3, 3, 3, 3),
(4, 4, 4, 4, 4, 4, 4),
(5, 5, 5, 5, 5, 5, 5);

select * from orders;
select * from Creater;
select * from Users;
select * from Publisher;
select * from Albums;
select * from Category;
select * from Tracks;
select * from orders_track;
=================================
1

select Albums.album_id, Albums.track_num, 
avg(Tracks.track_time) as avg_track_time, Albums.price 
from Albums
inner join Tracks on Albums.album_id = Tracks.album_id
group by Albums.album_id, Albums.track_num, Albums.price
order by price;
=====================================
2

select Users.order_id, Orders.quantity,Tracks.track_id 
from Users
inner join Orders on Users.order_id = Orders.order_id
inner join Tracks on Users.creater_id = Tracks.creater_id
where Orders.quantity > 0.6 * (select max(quantity) from Orders);
======================================
3

select Creater.c_name,Creater.last_name,count(Tracks.category_id) 
from Creater
inner join Tracks on Tracks.creater_id = Creater.creater_id
inner join Category on Tracks.category_id = Category.category_id
group by Creater.c_name,Creater.last_name, Category.category_id
having count(Tracks.category_id) > 5;
=======================================
4

select Users.u_name, Users.last_name, orders.date
from Users
inner join Orders on Users.order_id = Orders.order_id
order by orders.date desc;
========================================
5

select Albums.titel, Tracks.album_id, sum(Orders.quantity) as total_quantity
from Albums
inner join Tracks ON Albums.album_id = Tracks.album_id
inner join Creater ON Albums.creater_id = Creater.creater_id
inner join Users ON Creater.creater_id = Users.creater_id
inner join Orders ON Users.order_id = Orders.order_id
group by Albums.titel, Tracks.album_id
having sum(Orders.quantity) <= 2;
========================================
6

select category_id, sum(t_cost), sum(t_cost)*0.6 as base from Tracks
group by category_id;
select track_id, sum(total_price) as track_total_price from Orders
group by track_id;

WITH CategoryBase AS (
    SELECT 
        category_id,
        SUM(t_cost) AS total_category_cost,
        SUM(t_cost) * 0.6 AS base
    FROM Tracks
    GROUP BY category_id
),
TrackOrderTotal AS (
    SELECT 
        track_id, 
        SUM(total_price) AS track_total_price
    FROM Orders
    GROUP BY track_id
)
UPDATE Tracks
SET discont_price = price * 0.5
WHERE track_id IN (
    SELECT t.track_id 
    FROM Tracks t
    INNER JOIN CategoryBase cb ON t.category_id = cb.category_id
    INNER JOIN TrackOrderTotal tot ON t.track_id = tot.track_id
    WHERE tot.track_total_price < cb.base
);

