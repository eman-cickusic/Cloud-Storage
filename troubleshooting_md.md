# Troubleshooting Guide

Common issues and solutions encountered during the Google Cloud Storage lab.

## Common Issues

### 1. Bucket Name Conflicts

**Problem**: Error message "Bucket name already exists" or similar.

**Solution**: 
- Bucket names must be globally unique across all Google Cloud users
- Try adding random numbers or your project ID to the bucket name
- Example: `my-storage-lab-123456` or `storage-lab-${PROJECT_ID}`

```bash
# Use project ID in bucket name
export BUCKET_NAME_1="storage-lab-$(gcloud config get-value project)"
```

### 2. Empty .boto File

**Problem**: The `.boto` file is empty when opened with nano.

**Solutions**:
1. Generate a new .boto file:
   ```bash
   gsutil config -n
   ```

2. Find the correct .boto file location:
   ```bash
   gsutil version -l
   ```

3. If still empty, manually create the required sections:
   ```bash
   echo "[Boto]" >> .boto
   echo "" >> .boto
   echo "[GSUtil]" >> .boto
   echo "encryption_key=" >> .boto
   echo "#decryption_key1=" >> .boto
   ```

### 3. Permission Denied Errors

**Problem**: Getting permission errors when accessing buckets or objects.

**Solutions**:
1. Check that you're using the correct project:
   ```bash
   gcloud config get-value project
   gcloud config set project YOUR_PROJECT_ID
   ```

2. Verify authentication:
   ```bash
   gcloud auth list
   gcloud auth application-default login
   ```

3. Check IAM permissions for Cloud Storage

### 4. CSEK Key Issues

**Problem**: Cannot decrypt files after key rotation.

**Common Causes**:
- Old decryption key was removed before rewriting all objects
- Incorrect key format in .boto file
- Key was not properly copied (includes extra characters)

**Solutions**:
1. Ensure key format is correct (no `b'` prefix or `\n` suffix)
2. Keep old keys in `decryption_key1` until all objects are rewritten
3. Verify key with echo before using:
   ```bash
   echo "tmxElCaabWvJqR7uXEWQF39DhWTcDvChzuCmpHe6sb0="
   ```

### 5. Version Recovery Issues

**Problem**: Cannot find or recover specific file versions.

**Solutions**:
1. List all versions to find the correct one:
   ```bash
   gcloud storage ls -a gs://$BUCKET_NAME_1/setup.html
   ```

2. Copy the full path including the version identifier:
   ```bash
   # Full path looks like: gs://bucket-name/file.html#1234567890123456
   export VERSION_NAME="gs://bucket-name/file.html#1234567890123456"
   ```

3. Ensure versioning is enabled before creating versions:
   ```bash
   gsutil versioning set on gs://$BUCKET_NAME_1
   ```

### 6. Synchronization Problems

**Problem**: Directory sync doesn't work as expected.

**Solutions**:
1. Use the recursive flag:
   ```bash
   gsutil rsync -r ./local-dir gs://bucket-name/remote-dir
   ```

2. Check local directory structure:
   ```bash
   find ./firstlevel -type f
   ```

3. Use `-d` flag to delete remote files not in local directory:
   ```bash
   gsutil rsync -r -d ./local-dir gs://bucket-name/remote-dir
   ```

### 7. Command Not Found Errors

**Problem**: `gcloud` or `gsutil` commands not found.

**Solutions**:
1. Ensure you're in Cloud Shell or have Google Cloud SDK installed
2. Initialize gcloud:
   ```bash
   gcloud init
   ```

3. Update components:
   ```bash
   gcloud components update
   ```

### 8. Lifecycle Policy Not Applied

**Problem**: Lifecycle policy appears to be set but not working.

**Solutions**:
1. Verify JSON syntax:
   ```bash
   cat life.json | python3 -m json.tool
   ```

2. Check policy is correctly applied:
   ```bash
   gsutil lifecycle get gs://$BUCKET_NAME_1
   ```

3. Remember that lifecycle policies may take up to 24 hours to take effect

### 9. ACL Changes Not Visible

**Problem**: ACL changes don't seem to take effect.

**Solutions**:
1. Clear browser cache and refresh
2. Verify ACL was actually set:
   ```bash
   gsutil acl get gs://$BUCKET_NAME_1/file.html
   ```
3. Check bucket-level permissions don't override object-level ACLs

### 10. File Upload Failures

**Problem**: Files fail to upload to the bucket.

**Solutions**:
1. Check file exists locally:
   ```bash
   ls -la filename
   ```

2. Verify bucket name environment variable:
   ```bash
   echo $BUCKET_NAME_1
   ```

3. Try with full path:
   ```bash
   gsutil cp ./filename gs://bucket-name/
   ```

## Environment Variable Issues

### Setting and Verifying Variables
```bash
# Set variable
export BUCKET_NAME_1="your-bucket-name"

# Verify it's set
echo $BUCKET_NAME_1
env | grep BUCKET

# If lost, reset it
export BUCKET_NAME_1="your-bucket-name"
```

### Common Variable Problems
- Variable not exported (use `export`)
- Typos in variable name
- Variable lost after closing Cloud Shell session

## File Permission Issues

### Local File Permissions
```bash
# Check file permissions
ls -la filename

# Make file readable
chmod 644 filename

# Make script executable
chmod +x script.sh
```

## Network and Connectivity

### Connection Issues
```bash
# Test internet connectivity
ping google.com

# Test Cloud Storage access
gsutil ls

# Check current project and authentication
gcloud config list
gcloud auth list
```

## Getting Help

### Google Cloud Documentation
- [Cloud Storage Troubleshooting](https://cloud.google.com/storage/docs/troubleshooting)
- [gsutil Command Reference](https://cloud.google.com/storage/docs/gsutil)

### Useful Debug Commands
```bash
# Verbose output for debugging
gsutil -D cp file.txt gs://bucket-name/

# Get detailed version information
gsutil version -l
gcloud version

# Check current configuration
gcloud config list
```

### Log Analysis
```bash
# Check recent Cloud Shell history
history | tail -20

# View file contents to debug
cat filename
head -5 filename
tail -5 filename
```

## Prevention Tips

1. **Always verify environment variables** before running commands
2. **Test with small files first** before bulk operations  
3. **Keep backups** of important configuration files like .boto
4. **Document your key values** securely for CSEK operations
5. **Use tab completion** to avoid typos in file and bucket names
6. **Check permissions early** rather than debugging later

## Still Having Issues?

If you continue to experience problems:

1. Check the [Google Cloud Status Page](https://status.cloud.google.com/)
2. Review the [Cloud Storage documentation](https://cloud.google.com/storage/docs)
3. Post on [Stack Overflow](https://stackoverflow.com/questions/tagged/google-cloud-storage) with the `google-cloud-storage` tag
4. Contact Google Cloud Support if you have a support plan