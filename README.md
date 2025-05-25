# Cloud Storage

A comprehensive hands-on lab demonstrating advanced Google Cloud Storage features including bucket management, access control, encryption, lifecycle policies, versioning, and directory synchronization.

## Video

https://youtu.be/LbONgw4ijiM

## 🎯 Objectives

This lab covers the following Google Cloud Storage features:
- Creating and managing Cloud Storage buckets
- Implementing Access Control Lists (ACLs) for security
- Using Customer-Supplied Encryption Keys (CSEK)
- Managing encryption key rotation
- Configuring lifecycle management policies
- Enabling and managing object versioning
- Directory synchronization with `gsutil rsync`

## 📋 Prerequisites

- Google Cloud Platform account
- Google Cloud Console access
- Basic familiarity with command-line interfaces
- Understanding of cloud storage concepts

## 🚀 Lab Setup

### Initial Setup
1. Access Google Cloud Console
2. Create a new project or use an existing one
3. Enable Cloud Storage API
4. Open Cloud Shell for command-line operations

### Environment Variables
```bash
# Set your bucket name (must be globally unique)
export BUCKET_NAME_1=<your-unique-bucket-name>

# Verify the variable
echo $BUCKET_NAME_1
```

## 📚 Lab Tasks Overview

### Task 1: Preparation and Bucket Creation

#### Create Cloud Storage Bucket
1. Navigate to **Cloud Storage > Buckets** in the Google Cloud Console
2. Click **Create** and configure:
   - **Name**: Enter a globally unique name
   - **Location type**: Region
   - **Region**: Choose your preferred region
   - **Access control**: Fine-grained (object-level permissions)
   - **Public access prevention**: Unchecked

#### Download Sample Files
```bash
# Download sample HTML file
curl https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/ClusterSetup.html > setup.html

# Create copies for testing
cp setup.html setup2.html
cp setup.html setup3.html
```

### Task 2: Access Control Lists (ACLs)

#### Upload and Configure ACLs
```bash
# Upload file to bucket
gcloud storage cp setup.html gs://$BUCKET_NAME_1/

# Get default ACL
gsutil acl get gs://$BUCKET_NAME_1/setup.html > acl.txt
cat acl.txt

# Set private access
gsutil acl set private gs://$BUCKET_NAME_1/setup.html
gsutil acl get gs://$BUCKET_NAME_1/setup.html > acl2.txt
cat acl2.txt

# Make publicly readable
gsutil acl ch -u AllUsers:R gs://$BUCKET_NAME_1/setup.html
gsutil acl get gs://$BUCKET_NAME_1/setup.html > acl3.txt
cat acl3.txt
```

#### Verify Public Access
- Check in Google Cloud Console that the file shows a "Public link"
- Test downloading the file after local deletion

### Task 3: Customer-Supplied Encryption Keys (CSEK)

#### Generate Encryption Key
```bash
# Generate AES-256 base-64 key
python3 -c 'import base64; import os; print(base64.encodebytes(os.urandom(32)))'
```

#### Configure Encryption in .boto File
```bash
# Open boto configuration
nano .boto

# Find and uncomment the encryption_key line
# encryption_key=<your-generated-key>
```

#### Upload Encrypted Files
```bash
# Upload remaining files with encryption
gsutil cp setup2.html gs://$BUCKET_NAME_1/
gsutil cp setup3.html gs://$BUCKET_NAME_1/
```

### Task 4: CSEK Key Rotation

#### Move Current Key to Decryption Key
1. Edit `.boto` file
2. Comment out current `encryption_key`
3. Uncomment and set `decryption_key1` with the old key

#### Generate New Encryption Key
```bash
# Generate new key
python3 -c 'import base64; import os; print(base64.encodebytes(os.urandom(32)))'

# Update .boto with new encryption_key
```

#### Rewrite Objects with New Key
```bash
# Rewrite setup2.html with new key
gsutil rewrite -k gs://$BUCKET_NAME_1/setup2.html

# Test downloading files
gsutil cp gs://$BUCKET_NAME_1/setup2.html recover2.html  # Should work
gsutil cp gs://$BUCKET_NAME_1/setup3.html recover3.html  # Will fail - not rewritten
```

### Task 5: Lifecycle Management

#### Create Lifecycle Policy
```bash
# Create lifecycle policy file
nano life.json
```

Add the following JSON configuration:
```json
{
  "rule": [
    {
      "action": {"type": "Delete"},
      "condition": {"age": 31}
    }
  ]
}
```

#### Apply Lifecycle Policy
```bash
# Set the lifecycle policy
gsutil lifecycle set life.json gs://$BUCKET_NAME_1

# Verify the policy
gsutil lifecycle get gs://$BUCKET_NAME_1
```

### Task 6: Object Versioning

#### Enable Versioning
```bash
# Check current versioning status
gsutil versioning get gs://$BUCKET_NAME_1

# Enable versioning
gsutil versioning set on gs://$BUCKET_NAME_1

# Verify versioning is enabled
gsutil versioning get gs://$BUCKET_NAME_1
```

#### Create Multiple Versions
```bash
# Modify setup.html (delete some lines)
nano setup.html

# Upload with versioning
gcloud storage cp -v setup.html gs://$BUCKET_NAME_1

# Modify again and upload
nano setup.html
gcloud storage cp -v setup.html gs://$BUCKET_NAME_1

# List all versions
gcloud storage ls -a gs://$BUCKET_NAME_1/setup.html
```

#### Recover Previous Versions
```bash
# Set version name environment variable
export VERSION_NAME=<full-path-to-oldest-version>

# Download specific version
gcloud storage cp $VERSION_NAME recovered.txt

# Compare file sizes
ls -al setup.html
ls -al recovered.txt
```

### Task 7: Directory Synchronization

#### Create Directory Structure
```bash
# Create nested directories
mkdir firstlevel
mkdir ./firstlevel/secondlevel

# Copy files to directories
cp setup.html firstlevel
cp setup.html firstlevel/secondlevel
```

#### Synchronize with Bucket
```bash
# Sync local directory with bucket
gsutil rsync -r ./firstlevel gs://$BUCKET_NAME_1/firstlevel

# List synchronized files
gcloud storage ls -r gs://$BUCKET_NAME_1/firstlevel
```

## 🔧 Key Commands Reference

### Bucket Operations
```bash
# Create bucket
gsutil mb gs://bucket-name

# List buckets
gsutil ls

# Copy files
gcloud storage cp file.txt gs://bucket-name/
gsutil cp file.txt gs://bucket-name/
```

### Access Control
```bash
# Get ACL
gsutil acl get gs://bucket-name/object

# Set private
gsutil acl set private gs://bucket-name/object

# Make public
gsutil acl ch -u AllUsers:R gs://bucket-name/object
```

### Encryption
```bash
# Generate key
python3 -c 'import base64; import os; print(base64.encodebytes(os.urandom(32)))'

# Rewrite with new key
gsutil rewrite -k gs://bucket-name/object
```

### Versioning
```bash
# Enable versioning
gsutil versioning set on gs://bucket-name

# List all versions
gcloud storage ls -a gs://bucket-name/object
```

### Synchronization
```bash
# Sync directories
gsutil rsync -r local-dir gs://bucket-name/remote-dir
```

## 🛡️ Security Best Practices

1. **Access Control**: Use fine-grained ACLs and IAM policies
2. **Encryption**: Implement CSEK for sensitive data
3. **Key Rotation**: Regularly rotate encryption keys
4. **Versioning**: Enable for important data protection
5. **Lifecycle Policies**: Automate data management and cost optimization

## 🧹 Cleanup

```bash
# Delete all objects in bucket
gsutil rm -r gs://$BUCKET_NAME_1/*

# Delete bucket
gsutil rb gs://$BUCKET_NAME_1

# Clean up local files
rm setup*.html *.txt life.json recovered.txt recover*.html 
rm -rf firstlevel
```

## 📖 Additional Resources

- [Google Cloud Storage Documentation](https://cloud.google.com/storage/docs)
- [gsutil Command Reference](https://cloud.google.com/storage/docs/gsutil)
- [Cloud Storage Best Practices](https://cloud.google.com/storage/docs/best-practices)
- [Access Control Options](https://cloud.google.com/storage/docs/access-control)
- [Customer-Supplied Encryption Keys](https://cloud.google.com/storage/docs/encryption/customer-supplied-keys)

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Note**: This lab was completed as part of Google Cloud Platform training. All commands and configurations were tested in a Google Cloud environment.
