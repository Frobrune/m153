import psycopg2
from fastapi import FastAPI, Security, HTTPException, Depends
from fastapi.security.api_key import APIKeyHeader

app = FastAPI()
api_key_header = APIKeyHeader(name=access_token, auto_error=False)


db = psycopg2.connect(
    host="ec2-99-80-200-225.eu-west-1.compute.amazonaws.com",
    database="df3plm79ur8i7",
    user="ohgxlhiulacfdl",
    password="905da47d1f6b022cc73af4017c36eecf96c211d7f7fd6d94f6e3b3ceb70e9e15")


async def get_api_key(
        api_key_header: str = Security(api_key_header)
):
    if api_key_header == "erdbeermarmeladebrotmithonig":
        return api_key_header
    else:
        raise HTTPException(
            status_code=HTTP_403_FORBIDDEN, detail="Could not validate credentials"
        )


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/Reservation")
def read_item(api_key: APIKey = Depends(get_api_key)):
    results = []
    cur = db.cursor()
    print(cur.rowcount)
    print(cur)
    cur.execute("SELECT * FROM reservation")
    for i in cur:
        results.append(i)
    print(results)
    return results
