DROP TABLE IF EXISTS Borrowed CASCADE;
DROP TABLE IF EXISTS Book CASCADE;
DROP TABLE IF EXISTS Member CASCADE;

-- Create Member table
CREATE TABLE Member (
    memb_no SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

-- Create Book table
CREATE TABLE Book (
    isbn VARCHAR(20) PRIMARY KEY,
    title VARCHAR(100),
    publisher VARCHAR(50)
);

-- Create Borrowed table
CREATE TABLE Borrowed (
    memb_no INT,
    isbn VARCHAR(20),
    date DATE,
    PRIMARY KEY (memb_no, isbn),
    FOREIGN KEY (memb_no) REFERENCES Member(memb_no),
    FOREIGN KEY (isbn) REFERENCES Book(isbn)
);

-- Insert data into Member table
INSERT INTO Member (name) VALUES
('Alice'),
('Bob'),
('Charlie'),
('David'),
('Eve');

INSERT INTO Book (isbn, title, publisher) VALUES
('978-1', 'Database Systems', 'McGraw-Hill'),
('978-2', 'Operating Systems', 'McGraw-Hill'),
('978-3', 'Networks', 'Pearson'),
('978-4', 'Artificial Intelligence', 'McGraw-Hill'),
('978-5', 'Machine Learning', 'O''Reilly'),
('978-6', 'Web Development', 'Pearson'),
('978-7', 'Algorithms', 'McGraw-Hill'),
('978-8', 'Cybersecurity', 'O''Reilly');

-- Insert data into Borrowed table
INSERT INTO Borrowed (memb_no, isbn, date) VALUES
(1, '978-1', '2024-01-01'), -- Alice borrows Database Systems
(1, '978-2', '2024-01-02'), -- Alice borrows Operating Systems
(2, '978-3', '2024-02-01'), -- Bob borrows Networks
(2, '978-1', '2024-02-10'), -- Bob borrows Database Systems
(3, '978-4', '2024-03-05'), -- Charlie borrows Artificial Intelligence
(4, '978-5', '2024-03-15'), -- David borrows Machine Learning
(4, '978-6', '2024-04-10'), -- David borrows Web Development
(5, '978-7', '2024-05-20'), -- Eve borrows Algorithms
(5, '978-8', '2024-06-01'); -- Eve borrows Cybersecurity



SELECT isbn, LENGTH(isbn) FROM Book;
SELECT isbn, LENGTH(isbn) FROM Borrowed;

UPDATE Book SET isbn = TRIM(isbn);
UPDATE Borrowed SET isbn = TRIM(isbn);

SELECT * FROM Book;
SELECT * FROM Borrowed;

SELECT * FROM Book;

SELECT * FROM Borrowed;



-- a. Print the names of members who have borrowed any book published by “McGraw-Hill.”
SELECT DISTINCT M.name
FROM Member M
JOIN Borrowed B ON M.memb_no = B.memb_no
JOIN Book BK ON B.isbn = BK.isbn
WHERE BK.publisher = 'McGraw-Hill';

-- b. Print the names of members who have borrowed all books published by “McGraw-Hill.”
SELECT M.name
FROM Member M
WHERE NOT EXISTS (
    SELECT BK.isbn
    FROM Book BK
    WHERE BK.publisher = 'McGraw-Hill'
    AND NOT EXISTS (
        SELECT B.isbn
        FROM Borrowed B
        WHERE B.memb_no = M.memb_no AND B.isbn = BK.isbn
    )
);

-- c. For each publisher, print the names of members who have borrowed more than five books of that publisher.
SELECT BK.publisher, M.name
FROM Member M
JOIN Borrowed B ON M.memb_no = B.memb_no
JOIN Book BK ON B.isbn = BK.isbn
GROUP BY BK.publisher, M.name
HAVING COUNT(B.isbn) > 5;

-- d. Print the average number of books borrowed per member, including members who haven’t borrowed any books.
SELECT M.name, COALESCE(COUNT(B.isbn), 0) AS borrowed_count
FROM Member M
LEFT JOIN Borrowed B ON M.memb_no = B.memb_no
GROUP BY M.name;
