#A simple bash script to log in to the DB using IAM Token

# ↓ Required for SSL/TLS connections to RDS, download the certificate first, and it requires only read permission
wget https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem -O ~/rds-combined-ca-bundle.pem #only read permission is sufficient


#Define variables

DB_HOST="your-rds-endpoint"
DB_USER="your-db-user-name"
DB_REGION="your RDS region"

# Using the inline token (no variable) avoids storing sensitive values in memory, enhancing security

mysql --host=$DB_HOST \
      --port=3306 \
      --user=$DB_USER \
      --password="$(aws rds generate-db-auth-token \
  	  --hostname $DB_HOST \
  	  --port 3306 \
          --region $DB_REGION \
  	      --username $DB_USER)" \
      	  --ssl-ca=/root/rds-combined-ca-bundle.pem


