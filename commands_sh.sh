#!/bin/bash

# Google Cloud Storage Lab - Complete Command Reference
# This script contains all commands used in the lab for reference

echo "=== Google Cloud Storage Lab Commands ==="
echo "⚠️  Note: This is a reference script. Run commands individually, not as a batch!"

# Task 1: Preparation
echo "=== Task 1: Preparation ==="

# Set environment variable (replace with your unique bucket name)
echo "# Set bucket name environment variable"
echo "export BUCKET_NAME_1=<your-unique-bucket-name>"
echo "echo \$BUCKET_NAME_1"

# Download sample file
echo "# Download sample HTML file"
echo "curl https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/ClusterSetup.html > setup.html"

# Create copies
echo "# Create file copies"
echo "cp setup.html setup2.html"
echo "cp setup.html setup3.html"

# Task 2: Access Control Lists (ACLs)
echo ""
echo "=== Task 2: Access Control Lists (ACLs) ==="

# Upload file
echo "# Upload file to bucket"
echo "gcloud storage cp setup.html gs://\$BUCKET_NAME_1/"

# Get default ACL
echo "# Get and view default ACL"
echo "gsutil acl get gs://\$BUCKET_NAME_1/setup.html > acl.txt"
echo "cat acl.txt"

# Set private ACL
echo "# Set private ACL"
echo "gsutil acl set private gs://\$BUCKET_NAME_1/setup.html"
echo "gsutil acl get gs://\$BUCKET_NAME_1/setup.html > acl2.txt"
echo "cat acl2.txt"

# Make publicly readable
echo "# Make file publicly readable"
echo "gsutil acl ch -u AllUsers:R gs://\$BUCKET_NAME_1/setup.html"
echo "gsutil acl get gs://\$BUCKET_NAME_1/setup.html > acl3.txt"
echo "cat acl3.txt"

# Test file operations
echo "# Delete local file and re-download"
echo "rm setup.html"
echo "ls"
echo "gcloud storage cp gs://\$BUCKET_NAME_1/setup.html setup.html"

# Task 3: Customer-Supplied Encryption Keys (CSEK)
echo ""
echo "=== Task 3: Customer-Supplied Encryption Keys (CSEK) ==="

# Generate encryption key
echo "# Generate CSEK key"
echo "python3 -c 'import base64; import os; print(base64.encodebytes(os.urandom(32)))'"

# View and edit boto file
echo "# View and edit boto configuration"
echo "ls -al"
echo "nano .boto"
echo "# Uncomment encryption_key= and add your generated key"

# Upload encrypted files
echo "# Upload files with encryption"
echo "gsutil cp setup2.html gs://\$BUCKET_NAME_1/"
echo "gsutil cp setup3.html gs://\$BUCKET_NAME_1/"

# Test encrypted file operations
echo "# Test encrypted file operations"
echo "rm setup*"
echo "gsutil cp gs://\$BUCKET_NAME_1/setup* ./"
echo "cat setup.html"
echo "cat setup2.html"
echo "cat setup3.html"

# Task 4: Rotate CSEK Keys
echo ""
echo "=== Task 4: Rotate CSEK Keys ==="

# Edit boto file for key rotation
echo "# Move current key to decryption key"
echo "nano .boto"
echo "# Comment out encryption_key and set decryption_key1"

# Generate new key
echo "# Generate new encryption key"
echo "python3 -c 'import base64; import os; print(base64.encodebytes(os.urandom(32)))'"

# Update boto with new key
echo "# Update boto with new encryption key"
echo "nano .boto"
echo "# Set new encryption_key value"

# Rewrite object with new key
echo "# Rewrite object with new key"
echo "gsutil rewrite -k gs://\$BUCKET_NAME_1/setup2.html"

# Comment out old decrypt key
echo "# Comment out old decryption key"
echo "nano .boto"
echo "# Add # to comment out decryption_key1"

# Test downloads
echo "# Test downloading files"
echo "gsutil cp gs://\$BUCKET_NAME_1/setup2.html recover2.html"
echo "gsutil cp gs://\$BUCKET_NAME_1/setup3.html recover3.html"

# Task 5: Enable Lifecycle Management
echo ""
echo "=== Task 5: Enable Lifecycle Management ==="

# Check current lifecycle policy
echo "# Check current lifecycle policy"
echo "gsutil lifecycle get gs://\$BUCKET_NAME_1"

# Create lifecycle policy file
echo "# Create lifecycle policy JSON file"
echo "nano life.json"
echo "# Add the JSON policy content"

# Apply lifecycle policy
echo "# Apply lifecycle policy"
echo "gsutil lifecycle set life.json gs://\$BUCKET_NAME_1"

# Verify policy
echo "# Verify lifecycle policy"
echo "gsutil lifecycle get gs://\$BUCKET_NAME_1"

# Task 6: Enable Versioning
echo ""
echo "=== Task 6: Enable Versioning ==="

# Check versioning status
echo "# Check versioning status"
echo "gsutil versioning get gs://\$BUCKET_NAME_1"

# Enable versioning
echo "# Enable versioning"
echo "gsutil versioning set on gs://\$BUCKET_NAME_1"

# Verify versioning
echo "# Verify versioning enabled"
echo "gsutil versioning get gs://\$BUCKET_NAME_1"

# Create file versions
echo "# Create multiple versions of file"
echo "ls -al setup.html"
echo "nano setup.html"
echo "# Delete 5 lines from the file"
echo "gcloud storage cp -v setup.html gs://\$BUCKET_NAME_1"

echo "nano setup.html"
echo "# Delete another 5 lines"
echo "gcloud storage cp -v setup.html gs://\$BUCKET_NAME_1"

# List all versions
echo "# List all versions"
echo "gcloud storage ls -a gs://\$BUCKET_NAME_1/setup.html"

# Set version environment variable
echo "# Set version environment variable"
echo "export VERSION_NAME=<full-version-path>"
echo "echo \$VERSION_NAME"

# Recover old version
echo "# Recover original version"
echo "gcloud storage cp \$VERSION_NAME recovered.txt"

# Compare file sizes
echo "# Compare file sizes"
echo "ls -al setup.html"
echo "ls -al recovered.txt"

# Task 7: Synchronize Directory
echo ""
echo "=== Task 7: Synchronize Directory ==="

# Create directory structure
echo "# Create nested directory structure"
echo "mkdir firstlevel"
echo "mkdir ./firstlevel/secondlevel"
echo "cp setup.html firstlevel"
echo "cp setup.html firstlevel/secondlevel"

# Synchronize with bucket
echo "# Synchronize directory with bucket"
echo "gsutil rsync -r ./firstlevel gs://\$BUCKET_NAME_1/firstlevel"

# List synchronized files
echo "# List synchronized files"
echo "gcloud storage ls -r gs://\$BUCKET_NAME_1/firstlevel"

# Cleanup
echo ""
echo "=== Cleanup Commands ==="
echo "# Clean up local files"
echo "rm setup*.html *.txt life.json recovered.txt recover*.html"
echo "rm -rf firstlevel"

echo "# Clean up bucket (optional)"
echo "gsutil rm -r gs://\$BUCKET_NAME_1/*"
echo "gsutil rb gs://\$BUCKET_NAME_1"

echo ""
echo "=== End of Lab Commands ==="
echo "ℹ️  Remember to run these commands individually in Cloud Shell!"