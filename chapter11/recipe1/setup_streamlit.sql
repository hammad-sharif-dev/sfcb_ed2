-- Create a virtual warehouse named 'streamlit_warehouse' with the smallest size 'XSMALL'.
-- The warehouse will automatically suspend after 60 seconds of inactivity and resume when needed.
-- Initially, the warehouse will be in a suspended state to avoid unnecessary costs.
CREATE WAREHOUSE streamlit_warehouse
  WITH WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

-- Create a new database named 'streamlit_db' to store objects related to the Streamlit app.
CREATE DATABASE streamlit_db;

-- Create a new schema named 'streamlit_schema' within the 'streamlit_db' database to organize related objects.
CREATE SCHEMA streamlit_schema;

-- Create a new user 'streamlit_user' with a specific password and default settings.
-- The user is required to change their password upon first login.
-- The user's default role is 'public', default warehouse is 'streamlit_warehouse', 
-- and default namespace is 'streamlit_db.streamlit_schema'.
CREATE USER streamlit_user
  PASSWORD = 'streamlit_SFCB_7!'
  DEFAULT_ROLE = 'public'
  DEFAULT_WAREHOUSE = streamlit_warehouse
  DEFAULT_NAMESPACE = streamlit_db.streamlit_schema
  MUST_CHANGE_PASSWORD = TRUE;

-- Create a new role named 'streamlit_creator' to manage permissions for the Streamlit app.
CREATE ROLE streamlit_creator;

-- Grant the 'streamlit_creator' role usage privileges on the 'streamlit_db' database.
GRANT USAGE ON DATABASE streamlit_db TO ROLE streamlit_creator;

-- Grant the 'streamlit_creator' role usage privileges on the 'streamlit_schema' schema within 'streamlit_db'.
GRANT USAGE ON SCHEMA streamlit_db.streamlit_schema TO ROLE streamlit_creator;

-- Allow the 'streamlit_creator' role to create Streamlit apps within the 'streamlit_schema'.
GRANT CREATE STREAMLIT ON SCHEMA streamlit_db.streamlit_schema TO ROLE streamlit_creator;

-- Allow the 'streamlit_creator' role to create stages (locations for data loading) within the 'streamlit_schema'.
GRANT CREATE STAGE ON SCHEMA streamlit_db.streamlit_schema TO ROLE streamlit_creator;

-- Grant the 'streamlit_creator' role usage privileges on the 'streamlit_warehouse'.
GRANT USAGE ON WAREHOUSE streamlit_warehouse TO ROLE streamlit_creator;

-- Assign the 'streamlit_creator' role to the 'streamlit_user', giving them the privileges defined by the role.
GRANT ROLE streamlit_creator TO USER streamlit_user;

-- Grant the 'streamlit_creator' role SELECT privileges on all future tables in the 'streamlit_schema'.
-- This ensures that as new tables are created, the Streamlit app will have access to them.
GRANT SELECT ON FUTURE TABLES IN SCHEMA streamlit_db.streamlit_schema TO ROLE streamlit_creator;

-- Create a table named 'sample_data_streamlit_r1' in the 'streamlit_schema'.
-- This table will store sample data that the Streamlit app will query and display.
CREATE OR REPLACE TABLE streamlit_db.streamlit_schema.sample_data_streamlit_r1 (
    id INT,
    name STRING,
    age INT,
    city STRING
);

-- Insert sample data into the 'sample_data_streamlit_r1' table.
-- This data includes records for individuals with their ID, name, age, and city.
INSERT INTO streamlit_db.streamlit_schema.sample_data_streamlit_r1 (id, name, age, city) VALUES
(1, 'Alice', 30, 'New York'),
(2, 'Bob', 25, 'San Francisco'),
(3, 'Charlie', 35, 'Los Angeles'),
(4, 'Diana', 28, 'Chicago');
