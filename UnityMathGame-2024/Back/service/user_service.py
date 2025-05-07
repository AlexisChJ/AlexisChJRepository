from typing import List
from sqlalchemy.orm import Session
from models import User
from repository.user_repository import UserRepository
from schemas import UserCreateSchema


class UserService:
    def __init__(self, db: Session):
        self.repo=UserRepository(db)
    
    def create_user(self, user_data:UserCreateSchema)-> User:
        new_user= User(**user_data.model_dump())
        return self.repo.create_user(new_user)
    
    def list_user(self)-> List[User]:
        return self.repo.list_users()
    
    def find_by_id(self, id:int)-> User:
        return self.repo.find_by_id(id)