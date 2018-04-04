# frozen_string_literal: true

class CustomRegistrationsController < Devise::RegistrationsController
  def create
    if SiteSetting['registration_enabled']
      super
    elsif SiteSetting['make_trolls_lives_hard']
      uri = ['https://www.youtube.com/watch?v=dQw4w9WgXcQ', 'https://speed.hetzner.de/10GB.bin'].sample
      redirect_to uri
    else
      flash[:danger] = 'Account registration is disabled.'
      redirect_back fallback_location: root_path
    end
  end
end
