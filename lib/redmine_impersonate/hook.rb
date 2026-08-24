module RedmineImpersonate
  module Hook
    class ViewListener < Redmine::Hook::ViewListener
      # If user is impersonating, show message on the top
      def view_layouts_base_html_head(context = {})
        session = context[:controller].session

        return unless session[:true_user_id]

        impersonated_user = User.current
        style = 'margin: 0; padding: 10px; border-width: 0 0 2px; background-image: none'

        body =
          link_to(l(:button_cancel), { controller: 'impersonation', action: 'destroy' },
                  method: :delete, style: 'float: right') +
          ERB::Util.html_escape(l(:notice_impersonating_user, user: impersonated_user.name))

        content_tag :div, body, id: 'impersonation-bar', class: 'flash error', style: style
      end

      # Returns HTML we need to inject on pages when impersonation is needed
      def impersonation_html(context = {})
        user = context[:user]
        session = context[:controller].session

        return if !User.current.admin? || user == User.current || !user.active? || session[:true_user_id]
        return if context[:controller].action_name == 'new'

        link = link_to sprite_icon('user', l(:button_impersonate)),
                       { controller: 'impersonation', action: 'create', user_id: user.id },
                       method: :post, id: 'impersonate', class: 'icon icon-user'

        # Move link to contextual
        script = "<script>$('#impersonate').prependTo($('#content > .contextual').first())</script>".html_safe

        link + script
      end

      def view_people_show_details_bottom(context = {})
        impersonation_html(context.merge(user: context[:person]))
      end

      # Hook user profile and edit pages
      alias_method :view_account_left_bottom, :impersonation_html
      alias_method :view_users_form, :impersonation_html

      # Listener should only have public method with name of the hook
      private :impersonation_html
    end
  end
end
