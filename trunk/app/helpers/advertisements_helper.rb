module AdvertisementsHelper
	def make_active_label(advertisement)
		advertisement.status ? "Pause" : "Resume"
	end
end
