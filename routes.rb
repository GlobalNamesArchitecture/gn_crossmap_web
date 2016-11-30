# frozen_string_literal: true

module Gnc
  # Sinatra App namespace
  class App < Sinatra::Application
    get "/css/:filename.css" do
      scss :"sass/#{params[:filename]}"
    end

    get "/" do
      haml :home
    end

    post "/" do
      uploader = Gnc::Uploader.new(params["name_list_file"])
      crossmap = uploader.save_list_file
      redirect "crossmaps/#{crossmap.token}"
    end

    get "/crossmaps/:token" do
      @crossmap = Crossmap.find_by_token(params[:token])
      haml :crossmap
    end

    get "/resolver/:token" do
      content_type :json
      Gnc::Resolver.perform_async(params[:token])
      { status: "OK" }.to_json
    end

    # DEPRECATED BELOW

    get "/settings/:token" do
      @data_sources = Gnc::DataSource.fetch
      haml :settings
    end

    post "/crossmaps" do
      crossmap = Crossmap.find_by_token(params[:token])
      crossmap.update(data_source_id: params[:data_source_id])
      redirect "/resolver/#{params[:token]}"
    end

    get "/resolver/:token" do
      @data = Crossmap.find_by_token(params[:token])
      crossmapper = Gnc::Crossmapper.new(@data)
      @outfile = crossmapper.run
      haml :resolver
    end

    get "/stats/:token" do
      content_type :json
      cm = Crossmap.find_by_token(params[:token])
      cm.stats.to_json
    end
  end
end
