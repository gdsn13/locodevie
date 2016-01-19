module Locomotive
  class ModelsController < BaseController

    sections 'models'

    before_filter :back_to_default_site_locale, only: %w(new create)

    respond_to :json, only: [:create, :update, :destroy]

    helper 'Locomotive::Accounts', 'Locomotive::CustomFields'

  end
end