module Admin
  module ApplicationHelper

    def nav_link label, icon, path
      link_to(content_tag(:span, '', class: 'glyphicon glyphicon-'+icon+' pull-right')+' '+label, path, class: 'list-group-item')
    end

    def subnav_group_header label, icon, data_target
      link_to(content_tag(:span, '', class: 'glyphicon glyphicon-'+icon+' pull-right')+' '+label, '#', class: 'list-group-item', 'data-toggle': 'collapse', 'data-target': data_target, 'data-parent': '#sidebar-menu')
    end

    def nav_sublink label, path
      link_to(content_tag(:span, '', class: 'glyphicon glyphicon-chevron-right')+' '+label, path, class: 'list-group-item')
    end

    def new_button object_name
      link_to 'New '+object_name.titleize, eval("new_admin_#{object_name}_path"), { class: 'btn btn-default' }
    end

    def edit_button path
      link_to(content_tag(:span, nil, { class: 'glyphicon glyphicon-pencil', 'aria-hidden': 'true' }), path, { class: 'btn btn-default', 'aria-label': 'Edit', title: 'Edit' })
    end

    def view_button path
      link_to(content_tag(:span, nil, { class: 'glyphicon glyphicon-eye-open', 'aria-hidden': 'true' }), path, { class: 'btn btn-default', 'aria-label': 'View', title: 'View' })
    end

    def delete_button path
      link_to(content_tag(:span, nil, { class: 'glyphicon glyphicon-remove', 'aria-hidden': 'true' }), path, { method: :delete, class: 'btn btn-danger', 'aria-label': 'Delete', title: 'Delete' })
    end

    def form_buttons path
      content_tag :div, submit_button + ' ' + cancel_button(path), class: 'form-actions'
    end

    def submit_button
      button_tag('Submit', class: 'btn btn-success')
    end

    def cancel_button path
      link_to( 'Cancel', path, class: 'btn btn-default')
    end

    def subnav_link label, icon, path, state, current
      text = content_tag(:span, nil, { class: 'glyphicon glyphicon-'+icon, 'aria-hidden': 'true' }) + ' ' + label
      link_to text.html_safe, path, { class: current == state ? 'list-group-item active' : 'list-group-item' }
    end

    # https://coderwall.com/p/jzofog/ruby-on-rails-flash-messages-with-bootstrap
    def flash_class level
      case level
        when 'notice' then 'alert alert-info'
        when 'success' then 'alert alert-success'
        when 'error' then 'alert alert-warning'
        when 'alert' then 'alert alert-danger'
      end
    end

    def datepicker_field_value(date)
      unless date.blank?
        date.strftime '%B %-d, %Y'
      end
    end

  end
end
