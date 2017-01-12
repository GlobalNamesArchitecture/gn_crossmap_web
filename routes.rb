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

    post "/upload" do
      uploader = Gnc::Uploader.new(params["file-upload"])
      crossmap = uploader.save_list_file
      crossmap.token
    end

    get "/crossmaps/:token" do
      content_type :json
      crossmap = Crossmap.find_by_token(params[:token]).to_json
      puts crossmap
      crossmap
    end

    put "/crossmaps" do
      params = JSON.parse(request.body.read, symbolize_names: true)
      logger.info params
      crossmap = Crossmap.find_by_token(params[:token])
      crossmap.update(data_source_id: params[:data_source_id])
      crossmap.save ? "OK" : nil
    end

    get "/resolver/:token" do
      content_type :json
      Gnc::Resolver.perform_async(params[:token])
      { status: "OK" }.to_json
    end

    get "/stats/:token" do
      content_type :json
      cm = Crossmap.find_by_token(params[:token])
      cm.stats.to_json
    end
  end
end
