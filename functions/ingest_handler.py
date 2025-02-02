import base64
import mimetypes
import os
import azure.functions as func
from azure.storage.blob import BlobServiceClient

def main(req: func.HttpRequest) -> func.HttpResponse:
    payload: str | None = req.params.get("payload")
    filename: str | None = req.params.get("filename")

    if payload and filename:
        try:
            decoded_bytes: bytes = base64.b64decode(payload)
            mime_type: str = mimetypes.guess_type(filename)[0] or "application/octet-stream"
            blob_service_client: BlobServiceClient = BlobServiceClient.from_connection_string(os.getenv("AZURE_STORAGE_CONNECTION_STRING") or "")
            blob_client = blob_service_client.get_blob_client(container="your-container", blob=filename)
            blob_client.upload_blob(decoded_bytes, blob_type="BlockBlob", content_type=mime_type)
            return func.HttpResponse("File uploaded successfully", status_code=200)
        except Exception:
            return func.HttpResponse("Internal Server Error", status_code=500)
    return func.HttpResponse("Bad Request", status_code=400)
