import psycopg2
from fastapi import FastAPI

app = FastAPI()

db = psycopg2.connect(
    host="ec2-99-80-200-225.eu-west-1.compute.amazonaws.com",
    database="df3plm79ur8i7",
    user="ohgxlhiulacfdl",
    password="905da47d1f6b022cc73af4017c36eecf96c211d7f7fd6d94f6e3b3ceb70e9e15")


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/Reservation")
def read_item():
    results = []
    cur = db.cursor()
    print(cur.rowcount)
    print(cur)
    cur.execute("SELECT * FROM reservation")
    for i in cur:
        results.append(i)
    print(results)
    return results
