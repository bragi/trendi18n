class TranslationsController < ApplicationController
  
  def index
    params[:condition] = "all" if params[:condition].blank?
    @translations = Translation.localization(params[:localization]).send(params[:condition].downcase.to_sym) if ["untranslated", "translated", "all"].include?(params[:condition].downcase)
  end

  def new
    @translation = Translation.new
  end

  def create
    @translation = Translation.new(params[:translation])
    if @translation.save
      flash[:notice] = "Translation created!"
      redirect_to translations_path
    else
      render :action => "new"
    end
  end

  def edit
    @translation = Translation.find(params[:id])
  end

  def update
    @translation = Translation.find(params[:id])
    if @translation.update_attributes(params[:translation])
      flash[:notice] = "Translation updated"
      redirect_to translations_path
    else
      render :action => "edit"
    end
  end

  # show some static translations for tests
  def show
    @controller_message = I18n.t(:Key1)
  end
  
end
