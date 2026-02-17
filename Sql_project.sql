DROP TABLE IF EXISTS Customers;
CREATE TABLE Books(
	Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(100),
	Genre VARCHAR(50),
	Published_Year INT,
	Price NUMERIC(10,2),
	Stock INT
);

CREATE TABLE Customers(
	Customer_ID SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(15),
	City VARCHAR(50),
	Country VARCHAR(150)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE Orders(
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10,2)
);

SELECT * FROM Books;

SELECT * FROM Customers;

SELECT * FROM Orders;

--Retrieving all books in fiction genre
SELECT * FROM Books
WHERE Genre='Fiction';

--Books published after 1950
SELECT * FROM Books
WHERE published_year>1950;

--All customers from canada
SELECT * FROM Customers
WHERE Country='Canada';

--Show orders placed in November 2023
SELECT * FROM Orders
WHERE Order_date BETWEEN '2023-11-01' AND '2023-11-30';

--Retrieving the total stock of books available
SELECT sum(Stock) AS Total_stock FROM Books;

--Find the details of the most expensive book
SELECT * FROM Books ORDER BY Price DESC;

--All customers who ordered more than 1 quantity of a book
SELECT * FROM Orders
WHERE quantity>1;

--Retrieve all orders where the total amount exceeds $20
SELECT * FROM Orders
WHERE total_amount>20;

--List all Genres available in Books table
SELECT DISTINCT genre FROM Books;

--Find book with lowest stock
SELECT * FROM Books ORDER BY stock ASC
LIMIT 1;

--Total revenue generated from all orders
SELECT sum(total_amount) AS Revenue FROM Orders;



--Advance Questions
--Retrieve books sold for each genre
SELECT * FROM Orders;

SELECT b.Genre,SUM(o.Quantity) AS Total_Books_Sold
FROM Orders o
JOIN Books b ON o.book_id=b.book_id
GROUP BY b.Genre;

--Average Price of "Fantasy" Genre books
SELECT AVG(price) AS Average_Price
FROM Books
WHERE Genre='Fantasy';

---List Customers who have atleast placed in 2 orders
SELECT o.customer_id,c.name, COUNT(o.Order_id) AS Order_count
FROM Orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id,c.name
HAVING COUNT(Order_id)>=2;

--Find the most frequently ordered book
SELECT o.Book_id,b.title, COUNT(o.order_id) AS Orders_count
FROM Orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.Book_id,b.title
ORDER BY Orders_count DESC LIMIT 1;

--Show the 3 most expensive books 'Fantasy' genre
SELECT * FROM Books
WHERE Genre='Fantasy'
ORDER BY price DESC LIMIT 3;

--Retrieve the total quantity of books sold by each_author
SELECT b.author, SUM(o.quantity) AS Total_Books_Sold
FROM Orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.Author ;

--List cities where customers spent over $30 are located
SELECT DISTINCT c.city,total_amount 
FROM Orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount>100;

--Find the customers who spent more on orders
SELECT c.customer_id, c.name, SUM(total_amount) AS Total_spent
FROM Orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id,c.name
ORDER BY Total_spent DESC LIMIT 1;

--Calculate the stock remaining after fulfilling all orders
SELECT b.book_id,b.title,b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,
	b.stock-COALESCE(SUM(o.quantity),0) AS Remaining_quantity
FROM Books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY book_id;



