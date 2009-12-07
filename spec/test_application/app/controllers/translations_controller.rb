class TranslationsController < ApplicationController

  def index
    params[:condition] = "all" if params[:condition].blank?
    @translations = Translation.localization(params[:localization]).send(params[:condition].downcase.to_sym) if ["untranslated", "translated", "all"].include?(params[:condition].downcase)
  end
  
end
