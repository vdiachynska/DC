import mysql.connector
import time
from threading import Thread, Event

# --- Database Connection Details ---
DB_NAME = "il_levels_demo"
DB_USER = "root"
DB_PASSWORD = "Aa123456"
DB_HOST = "localhost"
DB_PORT = 3306  # Default MySQL port


# --- Helper Functions ---

def get_connection(isolation_level_str: str):
    """Establishes a database connection with a specified isolation level."""
    try:
        conn = mysql.connector.connect(
            host=DB_HOST,
            port=DB_PORT,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME
        )
        # Set the isolation level for this connection
        if isolation_level_str == "READ UNCOMMITTED":
            conn.autocommit = False  # Important for transactions
            conn.cmd_query(f"SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;")
            print(f"[INFO] Connection set to READ UNCOMMITTED.")
        elif isolation_level_str == "READ COMMITTED":
            conn.autocommit = False  # Important for transactions
            conn.cmd_query(f"SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;")
            print(f"[INFO] Connection set to READ COMMITTED.")
        else:
            raise ValueError(f"Unsupported isolation level: {isolation_level_str}")
        return conn
    except mysql.connector.Error as e:
        print(f"[ERROR] Could not connect to database: {e}")
        exit(1)


def fetch_balance(conn, account_holder: str, label: str = ""):
    """Fetches and prints the balance for a given account holder."""
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT balance FROM accounts WHERE account_holder = %s", (account_holder,))
            balance = cur.fetchone()
            if balance:
                print(f"[{label}] {account_holder}'s balance: {balance[0]:.2f}")
            else:
                print(f"[{label}] {account_holder} not found.")
            return balance[0] if balance else None
    except mysql.connector.Error as e:
        print(f"[ERROR] Error fetching balance: {e}")
        return None


def update_balance(conn, account_holder: str, amount: float, label: str = ""):
    """Updates the balance for a given account holder."""
    try:
        with conn.cursor() as cur:
            cur.execute(
                "UPDATE accounts SET balance = balance + %s WHERE account_holder = %s",
                (amount, account_holder)
            )
            print(f"[{label}] Updated {account_holder}'s balance by {amount:.2f}.")
    except mysql.connector.Error as e:
        print(f"[ERROR] Error updating balance: {e}")


# Reset the database state for the next demo
def reset_database():
    conn = get_connection("READ COMMITTED")  # Any isolation level is fine for reset
    try:
        with conn.cursor() as cur:
            cur.execute("UPDATE accounts SET balance = 1000.00 WHERE account_holder = 'Alice'")
            cur.execute("UPDATE accounts SET balance = 500.00 WHERE account_holder = 'Bob'")
            conn.commit()
            print("\n[INFO] Database reset to initial state.")
    except mysql.connector.Error as e:
        print(f"[ERROR] Error resetting database: {e}")
        conn.rollback()
    finally:
        conn.close()


# --- Scenario 1: READ UNCOMMITTED ---
# This isolation level allows dirty reads.
# A transaction operating under READ UNCOMMITTED can see changes made by other transactions
# even if those changes have not yet been committed (or might be rolled back).

print("\n--- DEMONSTRATING READ UNCOMMITTED ---")
print("This scenario will show how READ UNCOMMITTED permits dirty reads.")

# Use events to synchronize threads
tx1_ready_to_commit = Event()
tx2_can_read = Event()


def transaction_1_uncommitted(conn_str):
    """
    Transaction 1: Updates a balance but doesn't commit immediately.
    """
    conn = get_connection(conn_str)
    try:
        print(f"\n[Tx1-{conn_str}] Starting transaction 1.")
        # Ensure autocommit is off for explicit transaction control
        conn.start_transaction()

        initial_balance = fetch_balance(conn, 'Alice', f"Tx1-{conn_str}")
        update_balance(conn, 'Alice', -200.00, f"Tx1-{conn_str}")  # Alice spends 200

        print(f"[Tx1-{conn_str}] Alice's balance updated to uncommitted value.")
        tx1_ready_to_commit.set()  # Signal that Tx1 has updated and is waiting

        # Wait for Tx2 to try and read
        tx2_can_read.wait()
        print(f"[Tx1-{conn_str}] Tx2 has attempted to read. Now committing Tx1.")
        conn.commit()
        print(f"[Tx1-{conn_str}] Transaction 1 committed.")
    except mysql.connector.Error as e:
        print(f"[Tx1-{conn_str}] Error in Tx1: {e}")
        conn.rollback()
        print(f"[Tx1-{conn_str}] Transaction 1 rolled back.")
    finally:
        conn.close()


def transaction_2_read_uncommitted_attempt(conn_str):
    """
    Transaction 2: Attempts to read uncommitted data from Transaction 1.
    """
    conn = get_connection(conn_str)
    try:
        print(f"\n[Tx2-{conn_str}] Starting transaction 2.")
        conn.start_transaction(isolation_level=conn_str)  # Start transaction with specified isolation level

        # Wait for Tx1 to make its uncommitted change
        tx1_ready_to_commit.wait()
        print(f"[Tx2-{conn_str}] Tx1 has made an uncommitted change. Attempting to read Alice's balance.")

        # This read *will* see the uncommitted data
        fetch_balance(conn, 'Alice', f"Tx2-{conn_str} (first read)")
        tx2_can_read.set()  # Signal that Tx2 has attempted to read

        # Give some time for Tx1 to commit
        time.sleep(1)
        print(f"[Tx2-{conn_str}] Re-reading Alice's balance after Tx1 (should be committed now).")
        fetch_balance(conn, 'Alice', f"Tx2-{conn_str} (second read)")

    except mysql.connector.Error as e:
        print(f"[Tx2-{conn_str}] Error in Tx2: {e}")
    finally:
        conn.close()


# Run the READ UNCOMMITTED scenario
reset_database()
thread1 = Thread(target=transaction_1_uncommitted, args=("READ UNCOMMITTED",))
thread2 = Thread(target=transaction_2_read_uncommitted_attempt, args=("READ UNCOMMITTED",))

thread1.start()
thread2.start()

thread1.join()
thread2.join()

print("\n--- END OF READ UNCOMMITTED DEMO ---")
print(
    "Observations: In MySQL's READ UNCOMMITTED, Transaction 2 DOES see the uncommitted change from Transaction 1. This is a 'dirty read'.")

# --- Scenario 2: READ COMMITTED ---
# This isolation level prevents dirty reads.
# A transaction only sees changes that were committed before each statement started.

print("\n\n--- DEMONSTRATING READ COMMITTED ---")
print("This scenario shows how READ COMMITTED prevents dirty reads.")

# Reset events for the next scenario
tx1_ready_to_commit.clear()
tx2_can_read.clear()


def transaction_1_committed(conn_str):
    """
    Transaction 1: Updates a balance and then commits.
    """
    conn = get_connection(conn_str)
    try:
        print(f"\n[Tx1-{conn_str}] Starting transaction 1.")
        conn.start_transaction()

        initial_balance = fetch_balance(conn, 'Bob', f"Tx1-{conn_str}")
        update_balance(conn, 'Bob', 150.00, f"Tx1-{conn_str}")  # Bob gains 150

        print(f"[Tx1-{conn_str}] Bob's balance updated to uncommitted value.")
        tx1_ready_to_commit.set()  # Signal that Tx1 has updated and is waiting

        # Wait for Tx2 to try and read before Tx1 commits
        tx2_can_read.wait()
        print(f"[Tx1-{conn_str}] Tx2 has attempted to read. Now committing Tx1.")
        conn.commit()
        print(f"[Tx1-{conn_str}] Transaction 1 committed.")
    except mysql.connector.Error as e:
        print(f"[Tx1-{conn_str}] Error in Tx1: {e}")
        conn.rollback()
        print(f"[Tx1-{conn_str}] Transaction 1 rolled back.")
    finally:
        conn.close()


def transaction_2_read_committed(conn_str):
    """
    Transaction 2: Attempts to read data, observing only committed changes.
    """
    conn = get_connection(conn_str)
    try:
        print(f"\n[Tx2-{conn_str}] Starting transaction 2.")
        conn.start_transaction(isolation_level=conn_str)

        # Wait for Tx1 to make its uncommitted change
        tx1_ready_to_commit.wait()
        print(f"[Tx2-{conn_str}] Tx1 has made an uncommitted change. Attempting to read Bob's balance.")

        # This read will only see the *initial* committed value
        fetch_balance(conn, 'Bob', f"Tx2-{conn_str} (first read)")
        tx2_can_read.set()  # Signal that Tx2 has attempted to read

        # Give some time for Tx1 to commit
        time.sleep(1)
        print(f"[Tx2-{conn_str}] Re-reading Bob's balance after Tx1 has committed.")
        # This read will now see the *newly committed* value
        fetch_balance(conn, 'Bob', f"Tx2-{conn_str} (second read)")

    except mysql.connector.Error as e:
        print(f"[Tx2-{conn_str}] Error in Tx2: {e}")
    finally:
        conn.close()


# Run the READ COMMITTED scenario
reset_database()
thread1_rc = Thread(target=transaction_1_committed, args=("READ COMMITTED",))
thread2_rc = Thread(target=transaction_2_read_committed, args=("READ COMMITTED",))

thread1_rc.start()
thread2_rc.start()

thread1_rc.join()
thread2_rc.join()

print("\n--- END OF READ COMMITTED DEMO ---")
print(
    "Observations: In READ COMMITTED, Transaction 2 does NOT see the uncommitted change from Transaction 1. It only "
    "sees the initial committed state. After Transaction 1 commits, Transaction 2 (when re-reading) then sees the "
    "newly committed value. This prevents dirty reads.")
