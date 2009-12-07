class TranslationsController < ApplicationController

  def index
    params[:condition] = "all" if params[:condition].blank?
    @translations = Translation.send(params[:condition].downcase.to_sym) if ["untranslated", "translated", "all"].include?(params[:condition].downcase)
    @translations = @translations.localization(session[:locale]) unless session[:locale].nil?
  end

  
end
