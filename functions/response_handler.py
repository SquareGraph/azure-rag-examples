import os
from typing import Any
import azure.functions as func
import requests

def main(req: func.HttpRequest) -> func.HttpResponse:
    query: str = req.params.get("query")
    if not query:
        try:
            req_body: Any = req.get_json()
            query = req_body.get("query")
        except ValueError:
            pass
    if query:
        openai_request = {
            "model": "gpt-4o",
            "prompt": query,
            "max_tokens": 100,
            "temperature": 0.7
        }
        api_key: str = os.getenv("OPENAI_API_KEY") or ""
        headers: dict[str, str] = {"Authorization": f"Bearer {api_key}"}
        response: requests.Response = requests.post(
            "https://api.openai.com/v1/completions",
            json=openai_request,
            headers=headers
        )
        return func.HttpResponse(response.text, status_code=response.status_code)
    return func.HttpResponse("Bad Request", status_code=400)
