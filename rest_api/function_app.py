import os
import logging
import pyodbc
import pandas as pd
import azure.functions as func

from datetime import datetime
from io import StringIO
from azure.storage.blob import BlobClient

# TODO: add authentication to Azure function.
app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

# max rows per batch.
max_rows = 1000
# connection info.
blob_container_url = os.environ["BlobContainerURL"]
blob_sas_token = os.environ["BlobSASToken"]
sql_conn_string = os.environ["SqlConnectionString"]

@app.route(route="load_data")
def load_data(req: func.HttpRequest) -> func.HttpResponse:
    try:
        # read file streams and check row counts.
        depts_csv_file = req.files["departments_file"]
        depts_file_name = depts_csv_file.filename.replace(".csv", "") + "_" + datetime.now().strftime("%Y_%m_%d_%H_%M_%S") + ".csv"
        depts_file_stream = depts_csv_file.stream.read()
        depts_file_contents = depts_file_stream.decode("utf-8")

        if not(is_valid_file(depts_file_contents)):
            raise Exception(f"Row count for departments file is > than {max_rows}")
        
        jobs_csv_file = req.files["jobs_file"]
        jobs_file_name = jobs_csv_file.filename.replace(".csv", "") + "_" + datetime.now().strftime("%Y_%m_%d_%H_%M_%S") + ".csv"
        jobs_file_stream = jobs_csv_file.stream.read()
        jobs_file_contents = jobs_file_stream.decode("utf-8")

        if not(is_valid_file(jobs_file_contents)):
            raise Exception(f"Row count for jobs file is > than {max_rows}")
        
        empls_csv_file = req.files["employees_file"]
        empls_file_name = empls_csv_file.filename.replace(".csv", "") + "_" + datetime.now().strftime("%Y_%m_%d_%H_%M_%S") + ".csv"
        empls_file_stream = empls_csv_file.stream.read()
        empls_file_contents = empls_file_stream.decode("utf-8")

        if not(is_valid_file(empls_file_contents)):
            raise Exception(f"Row count for employees file is > than {max_rows}")
        
        # upload files to Azure Blob Storage.
        upload_blob(depts_file_name, depts_file_stream)
        upload_blob(jobs_file_name, jobs_file_stream)
        upload_blob(empls_file_name, empls_file_stream)

        # insert data into Azure SQL.
        sql_conn = pyodbc.connect(sql_conn_string)
        cursor = sql_conn.cursor()

        cursor.execute(f"EXEC SP_INSERT_DEPARTMENTS '{depts_file_name}'")
        cursor.execute(f"EXEC SP_INSERT_JOBS '{jobs_file_name}'")
        cursor.execute(f"EXEC SP_INSERT_EMPLOYEES '{empls_file_name}'")
        
        sql_conn.commit()
    except Exception as e:
        logging.error(str(e))
        return func.HttpResponse(str(e), status_code=500)

    return func.HttpResponse(f"Data loaded successfully.")

def is_valid_file(file_contents, max_rows):
    df = pd.read_csv(StringIO(file_contents), sep=",", header=None)
    row_count = len(df.index)

    return row_count <= max_rows

def upload_blob(file_name, file_stream):
    blob_url = f"{blob_container_url}/{file_name}?{blob_sas_token}"
    blob_client = BlobClient.from_blob_url(blob_url=blob_url)
    blob_client.upload_blob(file_stream, blob_type="BlockBlob")