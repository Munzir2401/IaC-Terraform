-- 1) Create the user and tell MySQL to use the AWSAuthenticationPlugin
CREATE USER 'iam_user'@'%' 
  IDENTIFIED WITH AWSAuthenticationPlugin AS 'RDS'
  REQUIRE SSL; -- use for mysql version 8.0 and above

-- 2) Grant the required database privileges (example: full access to a single database)
GRANT ALL PRIVILEGES ON your_database_name.* TO 'iam_user'@'%';

-- 3) Apply privileges
FLUSH PRIVILEGES;
