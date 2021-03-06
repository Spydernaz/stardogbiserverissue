
CREATE TABLE Artist (
	id 	        INT,
	name        VARCHAR(30),
	description VARCHAR(1024),
	type        INT,
	PRIMARY KEY (id)
);

CREATE TABLE Album (
	id 	         INT,
	name         VARCHAR(30),
	release_date DATE,
	artist       INT,
	PRIMARY KEY (id),
	FOREIGN KEY (artist) REFERENCES Artist (id)
);

CREATE TABLE Membership (
	artist INT,
	band INT,
	FOREIGN KEY (band) REFERENCES Artist (id),
	FOREIGN KEY (artist) REFERENCES Artist (id)
);

CREATE TABLE Track (
	id INT,
	name VARCHAR(30),
	album INT,
	length INT,
	PRIMARY KEY (id),
	FOREIGN KEY (album) REFERENCES Album (id)
);

CREATE TABLE Songwriter (
	song INT,
	writer INT,
	FOREIGN KEY (writer) REFERENCES Artist (id),
	FOREIGN KEY (song) REFERENCES Track (id)
);


insert into Artist values (1, 'John Lennon', 'John Winston Ono Lennon, MBE (born John Winston Lennon; 9 October 1940 – 8 December 1980) was an English singer and Songwriter who co-founded the Beatles (1960-70), the most commercially successful band in the history of popular music. With fellow member Paul McCartney, he formed a celebrated songwriting partnership.', 1);
insert into Artist values (2, 'Paul McCartney', 'Sir James Paul McCartney, MBE (born 18 June 1942) is an English singer-Songwriter, multi-instrumentalist, and composer. With John Lennon, George Harrison, and Ringo Starr, he gained worldwide fame with the rock band the Beatles, one of the most popular and influential groups in the history of pop music. His songwriting partnership with Lennon is one of the most celebrated of the 20th century. After the band''s break-up, he pursued a solo career and formed the band Wings with his first wife, Linda, and Denny Laine.', 1);
insert into Artist values (3, 'Ringo Starr', '"Richard Starkey, MBE (born 7 July 1940), known professionally as Ringo Starr, is an English musician, singer, Songwriter and actor who gained worldwide fame as the drummer for the Beatles. He occasionally sang lead vocals, usually for one song on an album, including "With a Little Help from My Friends", "Yellow Submarine" and their cover of "Act Naturally". He also wrote the Beatles'' songs "Don''t Pass Me By" and "Octopus''s Garden", and is credited as a co-writer of others, including "What Goes On" and "Flying".', 1);
insert into Artist values (4, 'George Harrison', 'George Harrison, MBE (25 February 1943 – 29 November 2001) was an English guitarist, singer, Songwriter, and music and film producer who achieved international fame as the lead guitarist of the Beatles. Often referred to as "the quiet Beatle", Harrison embraced Hindu mythology and helped broaden the horizons of his fellow Beatles as well as their Western audience by incorporating Indian instrumentation in their music. Although the majority of the Beatles'' songs were written by John Lennon and Paul McCartney, most Beatles albums from 1965 onwards contained at least two Harrison compositions. His songs for the group included "Taxman", "Within You Without You", "While My Guitar Gently Weeps", "Here Comes the Sun", and "Something", the last of which became the Beatles'' second-most covered song"', 1);
insert into Artist values (5, 'The Beatles', 'The Beatles were the greatest rock band of all time. Formed in Liverpool, England in 1960, the group was composed of members John Lennon, Paul McCartney, George Harrison and Ringo Starr. Rooted in skiffle, beat, and 1950s rock and roll, the Beatles later experimented with several musical styles, ranging from pop ballads and Indian music to psychedelia and hard rock, often incorporating classical elements and unconventional recording techniques in innovative ways. In the early 1960s, their enormous popularity first emerged as "Beatlemania", but as the group''s music grew in sophistication, led by primary Songwriters Lennon and McCartney, they came to be perceived as an embodiment of the ideals shared by the counterculture of the 1960s.', 2);

insert into Membership values (1, 5);
insert into Membership values (2, 5);
insert into Membership values (3, 5);
insert into Membership values (4, 5);

insert into Album values (1, "Please Please Me", "1963-03-22", 5);
insert into Album values (2, "McCartney", "1970-04-17", 2);
insert into Album values (3, "Imagine", "1971-10-11", 1);

insert into Track values (1, "Love Me Do", 1, 125);

insert into Songwriter values (1, 1);
insert into Songwriter values (1, 2);
