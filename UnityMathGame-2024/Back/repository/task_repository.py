from typing import List
from sqlalchemy.orm import Session

from models import Task


class TaskRepository:
    def __init__(self,db:Session):
        self.db = db
    
    def create_task(self, task:Task) -> Task:
        self.db.add(task)
        self.db.commit()
        self.db.refresh(task)
        return task
    
    def finish_task(self, id:int)-> Task:
        task= self.db.query(Task).filter(Task.id==id).first()
        task.finished=True
        self.db.add(task)
        self.db.commit()
        self.db.refresh(task)
        return task
    