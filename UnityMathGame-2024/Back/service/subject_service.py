from typing import List
from sqlalchemy.orm import Session
from models import Subject, User
from repository.subject_repository import SubjectRepository
from repository.user_repository import UserRepository
from schemas import SubjectCreateSchema, UserCreateSchema


class SubjectService:
    def __init__(self, db: Session):
        self.repo=SubjectRepository(db)
    
    def create_subject(self, subject_data:SubjectCreateSchema)-> Subject:
        new_subject= Subject(**subject_data.model_dump())
        return self.repo.create_subject(new_subject)
    
    def find_by_user_id(self, user_id:int):
        return self.repo.find_by_user_id(user_id)
    