class GamesListController < ApplicationController
  def index
    @games = Game.all.order(name: "ASC")
  end
end
