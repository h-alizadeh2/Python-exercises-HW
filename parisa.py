import psycopg2
from psycopg2 import OperationalError


class DatabaseManager:
    # our database info
    def init(self, db_name, db_user, db_password, db_host, db_port):
        self.connection = None
        try:
            self.connection = psycopg2.connect(
                database=db_name,
                user=db_user,
                password=db_password,
                host=db_host,
                port=db_port
            )
            print(f"Connection to PostgreSQL DB {db_name} successful.")
        except OperationalError as e:
            print(f"the error {e} occurred.")

    # to execute our query to work with database
    def execute_query(self, query, values=None):
        cursor = self.connection.cursor()
        try:
            cursor.execute(query, values)
            self.connection.commit()
            print("Query execute successfully.")
        except OperationalError as e:
            print(f"the error {e} occurred.")
        finally:
            cursor.close()

    def create_database(self, db_name):
        try:
            connection = psycopg2.connect(
                database="postgres",
                user="parisa",
                password="mypassword123",
                host="127.0.0.1",
                port="5432"
            )
            connection.autocommit = True
            cursor = connection.cursor()
            cursor.execute(f"CREATE DATABASE {db_name}")
            print(f"Database '{db_name}' created successfully.")
        except OperationalError as e:
            print(f"The error '{e}' occurred.")
        finally:
            if connection:
                cursor.close()
                connection.close()

    def create_table(self, create_table_query):
        self.execute_query(create_table_query)

    # def delete_table(self, table_name):
    #     drop_table_query = f"DROP TABLE IF EXISTS {table_name};"
    #     self.execute_query(drop_table_query)
    def add_column(self, table_name, column_name, column_type):
        query = f"ALTER TABLE {table_name} ADD {column_name} {column_type};"
        self.execute_query(query)

# db_manager = DatabaseManager("postgres", "parisa", "mypassword123", "127.0.0.1", "5432")
# db_manager.create_database("inventory")
new_db_manager = DatabaseManager("inventory", "parisa", "mypassword123", "127.0.0.1", "5432")
create_inventory_table = """
CREATE TABLE IF NOT EXISTS inventory (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL NOT NULL,
    quantity INTEGER NOT NULL
);
"""


# new_db_manager.add_column("inventory", "type", "text")​