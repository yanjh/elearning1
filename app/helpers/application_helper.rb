module ApplicationHelper
  # Yield the content for a given block. If the block yiels nothing, the optionally specified default text is shown. 
  #
  #   yield_or_default(:user_status)
  #
  #   yield_or_default(:sidebar, "Sorry, no sidebar")
  #
  # +target+ specifies the object to yield.
  # +default_message+ specifies the message to show when nothing is yielded. (Default: "")
  def yield_or_default(message, default_message = "")
    message.nil? ? default_message : message
  end

  # Create tab.
  # 
  # The tab will link to the first options hash in the all_options array,
  # and make it the current tab if the current url is any of the options
  # in the same array.
  # 
  # +name+ specifies the name of the tab
  # +all_options+ is an array of hashes or strings, where the first hash/string of the array is the tab's link and all others will make the tab show up as current.
  # 
  # If now options are specified, the tab will point to '#', and will never have the 'active' state.
  def tab_to(name, all_options = nil)
    url = "#"
    html_options = {}
    current_url = [ url_for(:action => controller.action_name, :only_path => false), request.fullpath ]

    if all_options.is_a?(Array)
      url = all_options[0].is_a?(Hash) ? all_options[0].merge({:only_path => false}) : all_options[0]
      all_options.each do |o|
        path = o.is_a?(Hash) ? url_for(o.merge({:only_path => false})) : o
        if current_url.include?(path)
          html_options = {:class => "active"}
          break
        end
      end  
    end

    link_to(name, url, html_options)
  end

  # Return true if the currently logged in user is an admin
  def admin?
    logged_in? && current_user.admin?
  end
  
  # Write a secure email adress
  def secure_mail_to(email)
    mail_to email, nil, :encode => 'javascript'
  end
  
  def cell(label, value)
    "<tr>
  		<td class='label' nowrap='nowrap'>#{label}</td>
  		<td class='value'>#{value}</td>
  	</tr>".html_safe
  end
  
  def cell_separator
    "<tr>
  		<td colspan='2' class='separator'></td>
  	</tr>".html_safe
  end

  def flash_message
    message = ""
    flash.each do |name, msg| 
      message += content_tag :div, msg, :id => "flash_#{name}"
    end
    message.html_safe
  end
end