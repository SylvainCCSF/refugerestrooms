class BathroomsController < ApplicationController
  helper :bathrooms

  before_filter :list_bathrooms, only: [:index, :list]
  before_filter :find_bathroom, only: [:show, :update, :edit, :destroy, :up_vote, :down_vote]

  def index
  end

	def list
		render json: @bathrooms
	end

  def show
  end

  def new
    @bathroom = Bathroom.new
  end

  def create
    @bathroom = Bathroom.new(permitted_params)

    if @bathroom.save
      flash[:notice] = I18n.t('bathroom.flash.new', name: @bathroom.name)
      redirect_to @bathroom
    else
      display_errors
      render 'new'
    end
  end

  def update
    if @bathroom.update(permitted_params)
      flash[:notice] = I18n.t('bathroom.flash.updated')
      redirect_to @bathroom
    else
      display_errors
      render 'edit'
    end
  end

  def edit
  end

  def destroy
    if @bathroom.destroy
      flash[:notice] = I18n.t('bathroom.flash.deleted')
      redirect_to bathrooms_path
    else
      display_errors
      redirect_to @bathroom
    end
  end

  def down_vote
    @bathroom.downvote!

    if @bathroom.save
      flash[:notice] = I18n.t('bathroom.flash.downvotesuccess')
      redirect_to @bathroom
    else
      flash[:alert] = I18n.t('bathroom.flash.downvoteerror')
      redirect_to @bathroom
    end
  end

  def up_vote
    @bathroom.upvote!

    if @bathroom.save
      flash[:notice] = I18n.t('bathroom.flash.upvotesucess')
      redirect_to @bathroom
    else
      flash[:alert] = I18n.t('bathroom.flash.upvoteerror')
      redirect_to @bathroom
    end
  end

private

  def list_bathrooms
    @bathrooms = Bathroom.all

    @bathrooms = if params[:search].present? || params[:map] == "1"
      @bathrooms.near([params[:lat], params[:long]], 20, :order => 'distance')
    else
      @bathrooms.reverse_order
    end

    @bathrooms = @bathrooms.limit(20)
  end

  def display_errors
    if @bathroom.errors.any?
      errors = @bathroom.errors.each do |attribute, message|
        flash[:alert] = I18n.t('bathroom.flash.field')
      end
    else
      flash[:alert] = I18n.t('bathroom.flash.unexpected')
    end
  end

  def find_bathroom
    @bathroom = Bathroom.find(params[:id])
  end

  def permitted_params
    params.require(:bathroom).permit!
  end

end