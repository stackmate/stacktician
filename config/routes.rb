Stacktician::Application.routes.draw do
    root to: 'static_pages#home'

    match '/help',    to: 'static_pages#help'
    match '/about',   to: 'static_pages#about'

end
