from datetime import datetime
from typing import Optional
from pydantic import BaseModel

class UserCreateSchema(BaseModel):
    firebase_id : str

class SubjectCreateSchema(BaseModel):
    name : str
    user_id: int
    color: str

class TaskCreateSchema(BaseModel):
    name : str
    due_date : Optional[datetime]
    description : Optional[str]
    subject_id : int 
    priority : Optional[int]