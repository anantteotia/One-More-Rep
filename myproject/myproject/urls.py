from django.contrib import admin
from django.urls import path
from myapp.views import adduser, createevent, createrecipe, deleteevent, deleterecipe, getevents, index, getrecipes, removeuser

urlpatterns = [
    path('', index, name="index"),
    path('admin/', admin.site.urls),
    path('getrecipes/', getrecipes, name='recipe_list'),
    path('createrecipe', createrecipe, name='createrecipe'),
    path('deleterecipe', deleterecipe, name='deleterecipe'),
    path('getevents/', getevents, name='getevents'),
    path('createevent', createevent, name='createevent'),
    path('deleteevent', deleteevent, name='deleteevent'),
    path('adduser', adduser, name='adduser'),
    path('removeuser', removeuser, name='removeuser')
]
