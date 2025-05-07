
from sqlalchemy import Boolean, Column, DateTime, ForeignKey, Integer, String, Text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
import datetime

Base = declarative_base()


class User(Base):
    __tablename__ = "user"
    id = Column(Integer, primary_key=True, autoincrement= True)
    firebase_id = Column(String(45), unique=True, nullable= False)

    #Relationships
    subjects = relationship("Subject",back_populates="user")


class Subject(Base):
    __tablename__ = "subject"
    id = Column(Integer, primary_key=True, autoincrement= True)
    name = Column(String(45), nullable=False)
    color = Column(String(7))
    user_id = Column(Integer,ForeignKey("user.id"), nullable=False)

    #Relationships
    user = relationship("User", back_populates="subjects")
    tasks= relationship("Task", back_populates="subject")



class Task(Base):
    __tablename__ = "task"
    id = Column(Integer, primary_key=True, autoincrement= True)
    name = Column(String(45), nullable=False)
    due_date = Column(DateTime)
    created_at = Column(DateTime, nullable=False, default= datetime.datetime.utcnow)
    description = Column(Text)
    subject_id = Column(Integer,ForeignKey("subject.id"), nullable=False)  
    priority = Column(Integer)
    finished = Column(Boolean, default=False, nullable=False)

    subject = relationship("Subject", back_populates="tasks")