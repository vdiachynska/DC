# 🏪 Store 01 — Database Modeling & SQL Practice

---

## 📘 Scenario

You are designing a database for a small retail store called **Store 01**. The store needs to track:

- Products in inventory
- Customers
- Orders placed by customers
- Items in each order

---

## 📐 ERD & Modeling Requirements

Design an Entity-Relationship Diagram (ERD) with the following **entities** and **relationships**:

### Required Tables

| Table         | Description |
|---------------|-------------|
| `products`    | Product details: name, category, price, stock |
| `customers`   | Customer details: name, email |
| `orders`      | Orders placed by customers: order date, customer ID |
| `order_items` | Items in each order: product ID, quantity, price at time of purchase |

### Relationships

- A **customer** can place **many orders**
- An **order** can contain **many products**
- A **product** can be in **many orders**

---

## 🛠️ To Do (3+0.5)

### ✅ A. Database Modeling
- Design and draw the ERD including:
  - Entity names
  - Attributes (with PKs & FKs)
  - Relationships between tables

### ✅ B. SQL Implementation

#### 1. Create Tables

Use MySQL to define the schema for the 4 core tables with:
- Primary Keys
- Foreign Keys
- Appropriate data types

#### 2. Insert Sample Data

Insert at least:
- 3 customers
- 5 products
- 15 orders (each with 2–3 items)

#### 3. Write SQL Queries

Write SQL to answer the following questions:

1. List all orders with customer names and total amounts
2. Find the most popular product by total quantity sold
3. Show current stock left for each product
4. List customers who haven’t placed any orders

---

1. **Create roles/users**:
   - `store_manager`: Full access to all tables
   - `sales_clerk`: Can insert orders and view products, but cannot change product data
   - `analyst`: Read-only access to all data

2. **Grant privileges** using `GRANT`:
   - `store_manager`: `ALL PRIVILEGES` on the whole database
   - `sales_clerk`: `SELECT` on `products`, `INSERT`/`SELECT` on `orders` and `order_items`
   - `analyst`: `SELECT` only on all tables


## 🌟 Bonus Challenges (0.5)

1. Add a `categories` table and link it to `products` (1 category → many products)
2. Create a trigger to reduce product stock when an `order_item` is added
3. Add `CHECK` constraints:
   - Price > 0
   - Quantity ≥ 0

---

## 📦 Deliverables

- SQL script to create and populate the database
- ERD diagram (image or draw.io URL)
- SQL query scripts for the tasks above
- README file (this one)

---

## 💡 Tips

- Use `JOIN` statements to connect related tables in your queries
- Keep table and column names consistent and lowercase
- Add meaningful sample data to better test your queries

---

## 📚 Technologies

- MySQL
- ERD tool: [dbdiagram.io](https://dbdiagram.io), [drawSQL](https://drawsql.app/), or [draw.io](https://app.diagrams.net)

---

## 🧠 Learning Goals

- Understand how to design normalized relational schemas
- Practice creating relationships with PKs and FKs
- Gain confidence writing SQL queries on realistic data
