class ClientsController < ApplicationController
  def index
    @client = Client.new
    @clients = Client.where(user_id: (current_user ? current_user.id : params[:user_id]))
  end

  def show

  end

  def create
    client_params = params[:client]
    if client_params && client_params[:name].blank?
      redirect_to clients_url, alert: "Provide a name" and return
    end
    @client = Client.where(name: client_params[:name]).first_or_initialize
    if @client.new_record?
      @client.user_id = current_user.id
    end

    client = Harvest::Client.new(name: @client.name)
    client = $harvest.clients.create(client)
    @client.harvest_id = client.id

    @client.save!

    redirect_to clients_url, notice: "Client #{@client.name} added"
  end

  def new

  end

  def destroy
    Client.destroy(params[:id])
    render json: {id: params[:id]}, status: :ok
  end


end
