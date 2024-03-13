from django.http import JsonResponse
from .models import Event, Recipe, Users
from rest_framework.decorators import api_view
from rest_framework.request import Request
import datetime


def index(request: Request):
    return JsonResponse({'message': 'Hello World!'})


@api_view(['GET'])
def getrecipes(request: Request):
    recipes = Recipe.objects.all()
    data = {
        'recipes': list(recipes.values())
    }
    return JsonResponse(data)


@api_view(['POST'])
def createrecipe(request: Request):
    name = request.data['name']
    content = request.data['content']
    recipe = Recipe.create(name=name, content=content)
    recipe.save()
    return JsonResponse({"status": "success", "recipe": {
        "id": recipe.id,
        "recipe_name": recipe.recipe_name,
        "recipe": recipe.recipe
    }})

@api_view(['DELETE'])
def deleterecipe(request: Request):
    id = request.data['id']
    Recipe.objects.filter(id=id).delete()
    return JsonResponse({'status': 'success'});

@api_view(['POST'])
def adduser(request: Request):
    username = request.data['username']
    email = request.data['email']
    user = Users.create(username, email)
    user.save()
    return JsonResponse({"status": "success"})


@api_view(['POST'])
def removeuser(request: Request):
    email = request.data['email']
    Users.objects.filter(email=email).delete()
    return JsonResponse({"status": "success"})

@api_view(['GET'])
def getevents(request: Request):
    events = Event.objects.all()
    data = {
        'events': list(events.values())
    }
    return JsonResponse(data)

@api_view(['POST'])
def createevent(request: Request):
    eventDate = request.data['eventDate']
    eventData = request.data['eventData']
    event = Event.create(eventDate=eventDate, eventData=eventData)
    event.save()
    return JsonResponse({"status": "success", "event": {
        "id": event.id,
        "eventDate": eventDate,
        "eventData": event.eventData
    }});

@api_view(['DELETE'])
def deleteevent(request: Request):
    id = request.data['id']
    Event.objects.filter(id=id).delete()
    return JsonResponse({"status": "success"})
    
