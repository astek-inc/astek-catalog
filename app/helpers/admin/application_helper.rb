module Admin
  module ApplicationHelper

    def new_button object_name
      link_to 'New '+object_name.titleize, eval("new_admin_#{object_name}_path"), { class: 'btn btn-default' }
    end

    def edit_button path
      link_to(content_tag(:span, nil, { class: 'glyphicon glyphicon-pencil', 'aria-hidden': 'true' }), path, { class: 'btn btn-default', 'aria-label': 'Edit', title: 'Edit' })
    end

    def delete_button path
      link_to(content_tag(:span, nil, { class: 'glyphicon glyphicon-remove', 'aria-hidden': 'true' }), path, { method: :delete, class: 'btn btn-default', 'aria-label': 'Delete', title: 'Delete' })
    end

  end
end
