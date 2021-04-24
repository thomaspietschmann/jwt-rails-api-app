class Api::V1::BooksController < ApplicationController
  skip_before_action :authorized, only: [:index]

  def index
    @books = Book.all
    render json: { books: @books }
  end

  def create
    @book = Book.create(book_params)
    if @book.valid?
      render json: { book: @book }
    else
      render json: { error: @book.errors.messages }, status: :bad_request
    end
  end

  private

  def book_params
    params.permit(:name, :pages)
  end
end
