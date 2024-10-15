class ArticlesController < ApplicationController
  def index
    @number_of_events = Sequent::Core::EventRecord.count
    @articles = PostRecord.all
  end

  def show
    @article = PostRecord.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    Sequent.command_service.execute_commands(
      Post::Commands::AddPost.new(
        aggregate_id: Sequent.new_uuid,
        author: 'Ben',
        title: article_params[:title],
        content: article_params[:text]
      )
    )
    redirect_to articles_path
  rescue Sequent::Core::CommandNotValid => e
    @article = Article.new(article_params)
    @article.errors.merge!(e.command.errors)
    render :new, status: :unprocessable_entity
  end

  def destroy
    Sequent.command_service.execute_commands(
      Post::Commands::DestroyPost.new(
        aggregate_id: params[:id]
      )
    )
    redirect_to articles_path
  end

  private

  def article_params
    params.require(:article).permit(:title, :text)
  end
end
