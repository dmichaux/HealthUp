module ApplicationHelper

	# Return the full title on a per-page basis
	def full_title(page_title = '')
		base_title = "HealthUp"
		if page_title.empty?
			base_title
		else
			"#{page_title} | #{base_title}"
		end
	end

  def format_time(time)
  	time.localtime.strftime('%A, %-m/%-d/%Y %I:%M %p')
  end
end
