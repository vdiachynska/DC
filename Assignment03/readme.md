# MySQL Transaction Isolation Levels – Practical Assignment

## 🎯 Objective

Demonstrate how different MySQL transaction isolation levels affect data consistency and concurrency. Focus on identifying and explaining transactional anomalies such as dirty reads, non-repeatable reads, and deadlocks.

---

## 🧪 Tasks

### Task 1: Dirty Read (READ UNCOMMITTED)

- Create a scenario using two concurrent sessions where one session reads data modified but not yet committed by another session.
- Use the `READ UNCOMMITTED` isolation level.
- Record the output of both sessions.
- Explain why the anomaly observed is considered a **dirty read**.

**Points: 5**

---

### Task 2: Non-Repeatable Read (READ COMMITTED)

- Create a scenario where a transaction reads the same row twice but gets different results within the same transaction.
- Use the `READ COMMITTED` isolation level.
- Record the session output that demonstrates this behavior.
- Explain the concept of **non-repeatable read** using the observed results.

**Points: 5**

---

### Task 3: Explanation and Terminology

- For each of the above tasks, provide a brief written explanation using correct transaction terminology:
  - What caused the observed anomaly?
  - Why does the isolation level used permit it?
- Ensure that terms like "dirty read", "commit", "transaction", "concurrency" are used correctly.

**Points: 5**

---

## 🔁 Bonus Tasks

### Bonus Task 1: Repeatable Read (REPEATABLE READ)

- Design a scenario to demonstrate that once a transaction reads a row, any committed updates to that row by other transactions are not visible until the transaction ends.
- Use the `REPEATABLE READ` isolation level.
- Include the output and explanation.

**Bonus: +1 Point**

---

### Bonus Task 2: Non-Repeatable Read vs Repeatable Read

- Compare results of the same update scenario under `READ COMMITTED` and `REPEATABLE READ`.
- Clearly distinguish the behavior of each level in your explanation.

**Bonus: +1 Point**

---

### Bonus Task 3: Deadlock

- Create a scenario involving two sessions that leads to a deadlock.
- Describe the steps taken and how MySQL responded.
- Capture and include any MySQL error or diagnostic output related to the deadlock.
- Explain why the deadlock occurred and how it was resolved.

**Bonus: +1 Point**

---

## 📊 Evaluation Table

| Task                                                                 | Points |
|----------------------------------------------------------------------|--------|
| Dirty Read under READ UNCOMMITTED                                    | 5      |
| Non-Repeatable Read under READ COMMITTED                             | 5      |
| Clear explanation with correct terminology (2 questions in the  end) | 5      |
| Bonus: Demonstrates REPEATABLE READ                                  | +1     |
| Bonus: Comparison of READ COMMITTED vs REPEATABLE READ               | +1     |
| Bonus: Demonstrates and explains deadlock                            | +1     |
| **Total**                                                            | **15 + 3 Bonus** |

---

## 📦 Submission Requirements

- SQL scripts or screenshots showing each task executed
- A document or markdown report explaining each scenario
- Clearly labeled sections for each task and bonus

### 🧠 Transaction Knowledge Check – 10 Questions

1. What is a **dirty read**, and under which MySQL isolation level can it occur?

2. How does the **READ COMMITTED** isolation level prevent dirty reads but still allow non-repeatable reads?

3. Define a **non-repeatable read** and describe how it can be reproduced in a MySQL session.

4. What is a **transaction** in MySQL, and why are transactions important in multi-user database environments?

5. What does the **COMMIT** statement do in a transaction, and how does it affect data visibility?

6. Explain how the **REPEATABLE READ** isolation level prevents non-repeatable reads. What behavior did you observe during testing?

7. Compare the behavior of **READ COMMITTED** and **REPEATABLE READ** when a row is updated during an active transaction. What differences did you observe?

8. What is a **deadlock** in MySQL, and how can it occur in a multi-session environment?

9. How does MySQL detect and resolve **deadlocks**? What error message is typically shown?

10. Why is it important to choose the appropriate **transaction isolation level** for your application?
