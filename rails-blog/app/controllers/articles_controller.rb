# frozen_string_literal: true

class ArticlesController < ApplicationController
  def show
    @article = Article.find(params[:id])

  end

  def index
    @number_of_events = Sequent::Core::EventRecord.count
    @articles = Article.all
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    ActiveRecord::Base.transaction do
      if @article.save
        Sequent.command_service.execute_commands AddPost.new(
          aggregate_id: Sequent.new_uuid,
          author: 'Ben',
          title: @article.title,
          content: @article.text,
        )
        redirect_to @article
      else
        render 'new'
      end
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :text)
  end
end
