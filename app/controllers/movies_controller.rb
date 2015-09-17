class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    should_redirect = false

    sort_opt = nil
    if params.has_key?(:sort)
      sort_opt = params[:sort]
      session[:sort] = params[:sort]
    elsif session.has_key?(:sort)
      sort_opt = session[:sort]
      should_redirect = true
    end
  
    @selected_ratings = {}
    if params.has_key?(:ratings)
        @selected_ratings = params[:ratings]
    elsif session.has_key?(:ratings)
        @selected_ratings = session[:ratings]
        should_redirect = true
    end

    session[:ratings] = @selected_ratings

    if !@selected_ratings.empty?
      @movies = Movie.where(rating: @selected_ratings.keys)
    else
      @movies = Movie.all
    end

    sort(sort_opt) if sort_opt == "movie_title" || sort_opt == "release_date"

    @all_ratings = Movie.all_ratings
    @movie_header='hilite' if sort_opt == "movie_title"
    @release_header='hilite' if sort_opt == 'release_date'

    if should_redirect
      flash.keep
      redirect_to movies_path( {:sort => sort_opt, :ratings => @selected_ratings}) 
    end

  end

  def sort(sort_opt)
  
    @movies.sort!{ |a,b| a.title <=> b.title } if sort_opt == "movie_title"
    @movies.sort!{ |a,b| a.release_date <=> b.release_date } if sort_opt == "release_date"

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
