# Lab Submission Instructions

---

## Student Details

**Name of the team on GitHub Classroom:**

**Team Member Contributions:**

**Member 1**

| **Details**                                                                                        | **Comment** |
|:---------------------------------------------------------------------------------------------------|:------------|
| **Student ID:**                                                                                    |             |
| **Name:**                                                                                          |             |
| **What part of the lab did you personally contribute to,** <br>**and what did you learn from it?** |             |

**Member 2**

| **Details**                                                                                        | **Comment** |
|:---------------------------------------------------------------------------------------------------|:------------|
| **Student ID:**                                                                                    |             |
| **Name:**                                                                                          |             |
| **What part of the lab did you personally contribute to,** <br>**and what did you learn from it?** |             |

**Member 3**

| **Details**                                                                                        | **Comment** |
|:---------------------------------------------------------------------------------------------------|:------------|
| **Student ID:**                                                                                    |             |
| **Name:**                                                                                          |             |
| **What part of the lab did you personally contribute to,** <br>**and what did you learn from it?** |             |

## Scenario

The management of the organization (Siwaka Dishes) has made a decision to allow
customers to make purchases on credit. This means that the cash tendered does not have to be
the full amount of the order. Customers can make a partial payment, and the remaining
amount will be paid later.

1. Edit the frontend interface to accept the amount of cash tendered as input to be
sent to the backend through the API endpoint (`/api/meal_order_transaction`).
2. Edit the backend to accept the partial payment for the order through the same
API endpoint, i.e., `/api/meal_order_transaction`, and then insert it into the
`payment` table in the database system.
3. Create an API endpoint that uses the ORM to `GET` all orders that have not been paid in full
as well as the total amount of cash tendered, and the remaining balance.
4. Using the MySQL database system, simulate the termination of `Transaction 2` that is waiting for `Transaction 1` to
commit and release the write locks it has acquired.
_**Hint:** Transaction 1 should be executed using
the SQL code in [MySQL_SampleDatabaseTransaction_siwaka_dishes.sql](MySQL_SampleDatabaseTransaction_siwaka_dishes.sql) and Transaction 2 should be executed using the frontend in [meal_order_transaction.html](sample_application/frontend/meal_order_transaction.html)._
5. Identify the transaction (`trx_id`) of `Transaction 1` which is unable to `COMMIT`.
Re-attempt to execute `Transaction 2` after the simulation and, just before it is terminated automatically by the database system,
KILL `Transaction 1` manually to allow `Transaction 2` to complete successfully.

Make use of the following code for `Step 4` and `Step 5`:

- To list all the running transactions:
```sql
SELECT * FROM information_schema.innodb_trx;
```

- To identify the `Process ID` (`processlist_id`) of each running transaction:
```sql
SELECT t.trx_id, t.trx_mysql_thread_id AS processlist_id, p.USER, p.HOST, p.DB, p.COMMAND, p.TIME, p.STATE, p.INFO
FROM information_schema.innodb_trx t
JOIN information_schema.processlist p
  ON t.trx_mysql_thread_id = p.ID;
```

- To terminate the process running the transaction that is not committing:
```sql
KILL <processlist_id>;
```

## Video Demonstration

Submit the link to a short video (not more than 4 minutes) demonstrating your lab submission.

| **Key**                             | **Value** |
|:------------------------------------|:----------|
| **Link to the video:**              |           |
| **Link to the hosted application:** |           |
