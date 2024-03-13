from django.db import models

class Recipe(models.Model):
    id = models.AutoField(primary_key=True)
    recipe_name = models.CharField(max_length=255)
    recipe = models.TextField()

    @classmethod
    def create(cls, name: str, content: str):
        recipe = cls(recipe_name=name, recipe=content)
        return recipe

class Users(models.Model):
    username = models.TextField()
    email = models.EmailField(primary_key=True)

    @classmethod
    def create(cls, username: str, email: str):
        user = cls(username=username, email=email)
        return user
    
class Event(models.Model):
    id = models.AutoField(primary_key=True)
    eventDate = models.DateField()
    eventData = models.TextField()

    @classmethod
    def create(cls, eventDate: str, eventData: str):
        event = cls(eventDate=eventDate, eventData=eventData)
        return event
