class Manage::UsersController < BaseGenericController
  set_model User,
    :allow_attrs  => []
end