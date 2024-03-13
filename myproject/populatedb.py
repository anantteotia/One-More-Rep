from myapp.models import Recipe

def run():

    recipe1 = Recipe(recipe='Gym Test', recipe_name='Test 1')
    recipe1.save()

    # create another recipe instance
    recipe2 = Recipe(recipe='Gym Test 2', recipe_name='Test 2')
    # save it to the database
    recipe2.save()
