class GamesListController < ApplicationController
  def index
    @hardware = params[:hardware]
    if @hardware.nil? || @hardware == "ALL"
      @games = Game.all.order(name: "ASC")
    else
      @games = Game.where(hardware: @hardware).order(name: "ASC")
    end
  end
end
