from fastapi import Depends, FastAPI, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import User
from schemas import SubjectCreateSchema, TaskCreateSchema, UserCreateSchema
from service.subject_service import SubjectService
from service.task_service import TaskService
from service.user_service import UserService
from fastapi.middleware.cors import CORSMiddleware


app = FastAPI()

origins = [
    "http://localhost:3000"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.post("/user")
def create_user(user: UserCreateSchema, db: Session= Depends(get_db)):
    service= UserService(db)
    return service.create_user(user)

@app.get("/users")
def find_all_users( db: Session= Depends(get_db)):
    service= UserService(db)
    return service.list_user()
    

@app.get("/user/{id}")
def find_all_users(id:int, db: Session= Depends(get_db)):
    service= UserService(db)
    user = service.find_by_id(id)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return service.find_by_id(id)
    

@app.post("/subject")
def create_user(subject_data: SubjectCreateSchema, db: Session= Depends(get_db)):
    service= SubjectService(db)
    return service.create_subject(subject_data)


@app.get("/subject/user/{id}")
def get_user_subjects(id:int,db:Session=Depends(get_db)):
    service= SubjectService(db)
    return service.find_by_user_id(id)


@app.post("/task")
def create_user(task_data: TaskCreateSchema, db: Session= Depends(get_db)):
    service= TaskService(db)
    return service.create_task(task_data)


@app.get("/task/finish/{id}")
def finish_task(id:int, db: Session= Depends(get_db)):
    service= TaskService(db)
    return service.finish_task(id)