from typing import List
from sqlalchemy.orm import Session

from models import Subject


class SubjectRepository:
    def __init__(self,db:Session):
        self.db = db
    
    def create_subject(self, subject:Subject) -> Subject:
        self.db.add(subject)
        self.db.commit()
        self.db.refresh(subject)
        return subject
    
    def find_by_user_id(self, user_id:int)-> List[Subject]:
        return self.db.query(Subject).filter(Subject.user_id==user_id).all()

