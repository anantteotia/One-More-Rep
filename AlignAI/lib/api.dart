import 'dart:convert';

import 'package:align_ai/models/recipe_model.dart';
import 'package:http/http.dart' as http;

import 'models/event_model.dart';

const API_ENDPOINT = "10.0.2.2";
const API_PORT = "8000";

const API_URL = "http://" + API_ENDPOINT + ":" + API_PORT;

Future<http.Response> addUserToDB(String username, String email) {
  Map<String, String> body = {"username": username, "email": email};
  return http.post(Uri.parse(API_URL + "/adduser"), body: body);
}

Future<http.Response> removeUserFromDB(String email) {
  Map<String, String> body = {"email": email};
  return http.post(Uri.parse(API_URL + "/removeuser"), body: body);
}

Future<List<Recipe>> getRecipes() async {
  final List<Recipe> recipes = [];
  final http.Response response =
      await http.get(Uri.parse(API_URL + "/getrecipes"));
  final Map<String, dynamic> responseData = json.decode(response.body);

  responseData['recipes'].forEach((recipeData) {
    final Recipe recipe = Recipe(
      id: recipeData['id'],
      name: recipeData['recipe_name'],
      content: recipeData['recipe'],
    );

    recipes.add(recipe);
  });

  return recipes;
}

Future<Recipe> createRecipe(String name, String content) async {
  Map<String, String> body = {"name": name, "content": content};
  final response =
      await http.post(Uri.parse(API_URL + "/createrecipe"), body: body);
  final Map<String, dynamic> responseData = json.decode(response.body);
  if (responseData['status'] == "success") {
    Map<String, dynamic> recipe = responseData['recipe'];
    return Recipe(
      id: recipe['id'],
      name: recipe['recipe_name'],
      content: recipe['recipe'],
    );
  } else {
    return null;
  }
}

Future<List<EventModel>> getEvents() async {
  final List<EventModel> events = [];
  final http.Response response =
      await http.get(Uri.parse(API_URL + "/getevents"));
  final Map<String, dynamic> responseData = json.decode(response.body);

  responseData['events'].forEach((eventDetails) {
    final EventModel event = EventModel(
      id: eventDetails['id'],
      eventDate: eventDetails['eventDate'],
      eventData: eventDetails['eventData'],
    );

    events.add(event);
  });

  return events;
}

Future<bool> deleteRecipe(int id) async {
  Map<String, String> body = {"id": id.toString()};
  final response =
      await http.delete(Uri.parse(API_URL + "/deleterecipe"), body: body);
  final Map<String, dynamic> responseData = json.decode(response.body);
  if (responseData['status'] == "success") {
    return true;
  } else {
    return false;
  }
}

Future<EventModel> createEvent(String eventDate, String eventData) async {
  Map<String, String> body = {"eventDate": eventDate, "eventData": eventData};
  final response =
      await http.post(Uri.parse(API_URL + "/createevent"), body: body);
  final Map<String, dynamic> responseData = json.decode(response.body);
  if (responseData['status'] == "success") {
    Map<String, dynamic> event = responseData['event'];
    return EventModel(
      id: event['id'],
      eventDate: event['eventDate'],
      eventData: event['eventData'],
    );
  } else {
    return null;
  }
}

Future<bool> deleteEvent(int id) async {
  Map<String, String> body = {"id": id.toString()};
  final response =
      await http.delete(Uri.parse(API_URL + "/deleteevent"), body: body);
  final Map<String, dynamic> responseData = json.decode(response.body);
  if (responseData['status'] == "success") {
    return true;
  } else {
    return false;
  }
}
