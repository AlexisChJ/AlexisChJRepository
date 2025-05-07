from typing import List
from sqlalchemy.orm import Session

from models import User


class UserRepository:
    def __init__(self,db:Session):
        self.db = db
    
    def create_user(self, user:User) -> User:
        self.db.add(user)
        self.db.commit()
        self.db.refresh(user)
        return user
    
    def list_users(self)-> List[User]:
        return self.db.query(User).all()
    
    
    def find_by_id(self, id:int):
        return self.db.query(User).filter(User.id==id).first()
