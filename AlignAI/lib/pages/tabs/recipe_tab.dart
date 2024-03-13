import 'package:align_ai/api.dart';
import 'package:align_ai/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:async/async.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RecipeTab extends StatefulWidget {
  const RecipeTab({Key key}) : super(key: key);

  @override
  State<RecipeTab> createState() => _RecipeTabState();
}

class _RecipeTabState extends State<RecipeTab> {
  List<Recipe> recipes = [];
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  final _formKey = GlobalKey<FormState>();

  final recipeNameController = TextEditingController();
  final recipeContentController = TextEditingController();

  showCreateForm() async {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: Form(
            key: _formKey,
            child: Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 16,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter Recipe Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Recipe Name is required";
                    else if (value.length > 255)
                      return "Name must be 1 to 256 Characters";
                    else
                      return null;
                  },
                  controller: recipeNameController,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter Recipe Content',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Content cannot be empty";
                    else
                      return null;
                  },
                  controller: recipeContentController,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      String recipeName = recipeNameController.text;
                      String recipeContent = recipeContentController.text;
                      Recipe createdRecipe =
                          await createRecipe(recipeName, recipeContent);
                      if (createdRecipe != null) {
                        Navigator.pop(dialogContext);
                        setState(() {
                          recipes.add(createdRecipe);
                        });
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(content: Text('Recipe created!')),
                        );
                        recipeNameController.clear();
                        recipeContentController.clear();
                      } else
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to create Recipe')),
                        );
                    }
                  },
                  child: Text(
                    "Create",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> fetchRecipes() async {
    await this._memoizer.runOnce(() async {
      List<Recipe> fetchedRecipes = await getRecipes();
      recipes.addAll(fetchedRecipes);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchRecipes(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: showCreateForm,
              child: Icon(MdiIcons.plus, color: Colors.amber),
              backgroundColor: Colors.grey.shade800,
            ),
            body: ListView.builder(
              itemCount: this.recipes.length,
              itemBuilder: _listViewItemBuilder,
              padding: EdgeInsets.only(top: 12, bottom: 100),
            ),
          );
        } else {
          return CircularProgressIndicator(
            color: Colors.amber,
          );
        }
      },
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    var recipe = this.recipes[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _recipeName(recipe),
                  _recipeText(recipe),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  final successful = await deleteRecipe(recipe.id);
                  if (successful) {
                    setState(() {
                      recipes.remove(recipe);
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to delete Recipe')),
                    );
                  }
                },
                child: Icon(MdiIcons.trashCan),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(CircleBorder()),
                    padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.grey.shade800)),
              )
            ],
          )),
    );
  }

  Widget _recipeName(Recipe recipe) {
    return Text(
      recipe.name,
      style: TextStyle(
        color: Colors.amber,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _recipeText(Recipe recipe) {
    return Text(
      recipe.content,
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }
}
