# frozen_string_literal: true

class ArticlesController < ApplicationController
  def show
    @article = PostRecord.find(params[:id])
  end

  def index
    @number_of_events = Sequent::Core::EventRecord.count
    @articles = PostRecord.all
  end

  def new
    @article = Article.new
  end

  def create
    Sequent.command_service.execute_commands(
      AddPost.new(
        aggregate_id: Sequent.new_uuid,
        author: 'Ben',
        title: article_params[:title],
        content: article_params[:text]
      )
    )
    redirect_to action: 'index'
  end

  private

  def article_params
    params.require(:article).permit(:title, :text)
  end
end
