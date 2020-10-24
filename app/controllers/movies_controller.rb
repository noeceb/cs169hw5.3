class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @isTitleHilite = false
    @isDateHilite = false
    @all_ratings = Movie.all_ratings
    
    allRatings = params[:ratings]
    if allRatings == nil
      allRatings = []
    else
      allRatings = allRatings.keys
    end
    @ratings_to_show = allRatings
    
    if params[:ratings] != nil
      params[:ratings].each do |r|
        @collectionRatings = params[:ratings]
        session[:collectionRatings] = @collectionRatings
      end
    end
    
    @movies = Movie.with_ratings(allRatings)
    if params[:m] != nil
      session[:m] = params[:m]
    end
    if params[:r] != nil
      session[:r] = params[:r]
    end
    
    @map = {}
    @ratings_to_show.each do |i|
      @map[i] = i
    end
   
    #sorting by name and/or date
    if params[:m] != nil
      @isTitleHilite = true
      @isDateHilite = false
      @movies = @movies.order('title ASC')
    elsif params[:r] != nil
      @isTitleHilite = false
      @isDateHilite = true
      @movies = @movies.order('release_date ASC')
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
