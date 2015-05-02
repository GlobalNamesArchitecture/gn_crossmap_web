get "/css/:filename.css" do
  scss :"sass/#{params[:filename]}"
end

get "/" do
  haml :home
end

post "/" do
  uploader = Gnc::Uploader.new(params["checklist_file"])
  checklist = uploader.save_checklist
  redirect "checklists/#{checklist.token}"
end

get "/checklists/:token" do
  @checklist = Checklist.find_by_token(params[:token])
  haml :checklist
end
