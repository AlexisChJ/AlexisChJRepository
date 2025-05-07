from typing import List
from sqlalchemy.orm import Session
from models import Task
from repository.task_repository import TaskRepository
from schemas import TaskCreateSchema


class TaskService:
    def __init__(self, db: Session):
        self.repo=TaskRepository(db)
    
    def create_task(self, task_data:TaskCreateSchema)-> Task:
        new_task= Task(**task_data.model_dump())
        return self.repo.create_task(new_task)
    
    def finish_task(self, id:int):
        return self.repo.finish_task(id)
    