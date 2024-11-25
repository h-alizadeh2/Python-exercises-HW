import psycopg2
from psycopg2 import OperationalError


class DatabaseManager:
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
            print(f"The error '{e}' occurred.")
            self.connection = None

    def execute_query(self, query, values=None):
        if self.connection is None:
            print("No active database connection.")
            return
        cursor = self.connection.cursor()
        try:
            cursor.execute(query, values)
            self.connection.commit()
            print("Query executed successfully.")
        except Exception as e:
            print(f"The error '{e}' occurred.")
        finally:
            cursor.close()