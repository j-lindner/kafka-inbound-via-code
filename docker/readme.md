# (No need to run those commands, the created files are also committed)


# How to create certificate for CN=kafka
kafka = name of kafka container in docker network
To make this also work without docker network, I let "kafka" point to localhost by added the following line to /etc/hosts:
127.0.0.1 kafka

# Create a directory to store certificates
mkdir kafka-ssl
cd kafka-ssl

# Generate a CA key
openssl req -new -x509 -keyout ca-key -out ca-cert -days 365 -subj "/CN=Kafka-CA"

# Create a truststore and import the CA certificate
keytool -keystore kafka.server.truststore.jks -alias CARoot -importcert -file ca-cert -storepass password -noprompt

# Generate a keystore for the broker
keytool -keystore kafka.server.keystore.jks -alias kafka-server -validity 365 -genkey -keyalg RSA -storepass password -dname "CN=kafka"

# Create a certificate signing request (CSR)
keytool -keystore kafka.server.keystore.jks -alias kafka-server -certreq -file cert-file -storepass password

# Sign the server certificate with the CA
openssl x509 -req -CA ca-cert -CAkey ca-key -in cert-file -out cert-signed -days 365 -CAcreateserial -passin pass:password

# Import the CA and signed certificate into the keystore
keytool -keystore kafka.server.keystore.jks -alias CARoot -importcert -file ca-cert -storepass password -noprompt
keytool -keystore kafka.server.keystore.jks -alias kafka-server -importcert -file cert-signed -storepass password

