#Python program to authenticate to Azure using a User Assigned Managed Identntity and upload a file to an Azure File Share
#Command to install the required modules: pip install azure-identity azure-storage-file-share

import sys
from azure.identity import ManagedIdentityCredential
from azure.storage.fileshare import ShareFileClient

if len(sys.argv) != 5:
    print("Usage: python UploadFile.py <storageaccountname> <filesharename> <local_file_path> <dest_file_path>")
    print("Note: dest_file_path should be a relative path in the Azure File Share - ie. 'folder/subfolder/file.txt' ")
    print("\nExample: python UploadFile.py myaccount myshare c:\\path\\to\\local\\file.txt folder/subfolder/file.txt")
    print("This will upload local file c:\\path\\to\\local\\file.txt to https://myaccount.file.core.windows.net/myshare/folder/subfolder/file.txt")
    sys.exit(1)

account_name = sys.argv[1]
file_share_name = sys.argv[2]
local_file_path = sys.argv[3]
file_name_in_share = sys.argv[4]

uami_id = ''  #User Assigned MI
credential = ManagedIdentityCredential(client_id=uami_id)

# Create a ShareFileClient object
file_client = ShareFileClient(
    account_url=f"https://{account_name}.file.core.windows.net/",
    share_name=file_share_name,
    file_path=file_name_in_share,
    credential=credential,
    token_intent='backup'
)

# Upload the local file to the Azure File Share
with open(local_file_path, "rb") as source_file:
    file_client.upload_file(source_file)

print(f"File {local_file_path} uploaded to {file_share_name}/{file_name_in_share}")
