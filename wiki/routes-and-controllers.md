# Writing Routes and Controllers

## Routes
### Namespace

---

  - Groups related controllers under a common path/module. For example:
  ```
  # http://localhost:3000/api
  namespace :api do
    ...
  end
  ```
  - In `controllers` you need to create a folder with the same name as your namespace, e.g. `api`.
  
### Resources

---

- Defines RESTful routes for a resource (index, create, update, destroy, etc.). For example:
    ```
    # http://localhost:3000/api/questions/
    namespace :api do
      resources :questions, only: [:create] do
          ...
      end
    end
    ```
  
- You now need to create a controller for that resource, e.g. `controllers/api/questions_controller.rb`. The controller can then be defined:
  ```
  module Api
    class QuestionsController < ApplicationController
        
      # /api/questions
      def create
         ...
      end
  
    end
  end
  ```

### Member

---

- Defines custom routes for a **single resource** (with :id in the path). For example:
  ```
  namespace :api do
    resources :questions, only: [:create] do
      member do
        post :visibility
        post :answer
      end
  end
  ```

- This will look for methods `visibility` and `answer` in your questions controller. For example:
    ```
    module Api
      class QuestionsController < ApplicationController
      
        /api/questions
        def create
          ...
        end
    
        # /api/questions/:id/visibility
        def visibility
          ...
        end
    
        # /api/questions/:id/answer
        def answer
          ...
        end
        
      end
    end
    ```

### Collection

---

- Defines custom routes for actions that operate on the collection (no :id in the path). For example:
    ```
    namespace :api do
        resources :questions, only: [:create] do
          member do
            post :visibility
            post :answer
          end
    
          collection do
            post :orders
          end
        end
    ```
- You now need a function for `orders` in you controller, for example:
    ```
    module Api
      class QuestionsController < ApplicationController
      
        /api/questions
        def create
          ...
        end
    
        # /api/questions/:id/visibility
        def visibility
          ...
        end
    
        # /api/questions/:id/answer
        def answer
          ...
        end
        
        /api/reviews/orders
        def orders
          ...
        end
        
      end
    end
    ```

## Views

- GET routes are simple as well. For example:
  ```
  namespace :admin do
    get :dashboard, to: "dashboard#index"
  end
  ```
- Like before you need a folder in your `controllers` under the name of the namespace, e.g. `controllers/admin/...`.
- It is then looking for a `dashboard_controller.rb` here, so create it, e.g. `controllers/admin/dashboard_controler.rb`.
- `dashboard#index` is now looking for an `index` method inside this controller, so create it.

```
module Admin
  class DashboardController < ApplicationController    
    
    # /admin/dashboard
    def index
      ...
    end
    
  end
end
```

- You need to create a `view` for this. Create it at `/views/{namespace}/{controller}/{method}.html.haml`. So here it would be `views/admin/dashboard/index.html.haml`.
