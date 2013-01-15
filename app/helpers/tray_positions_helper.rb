module TrayPositionsHelper
	def tray_count
	    current_user.tray_positions.length if user_signed_in? 
	end
end

