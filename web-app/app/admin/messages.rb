# frozen_string_literal: true

ActiveAdmin.register Message do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  permit_params do
    permitted = %i[body latitude longitude address status sender_name sender_id category_id]
    # permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

  sidebar 'Photos', only: :show, partial: 'sidebar_photos'
end
