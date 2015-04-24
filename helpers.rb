helpers do
  include Sinatra::RedirectWithFlash
  include Rack::Utils
  alias_method :h, :escape_html
end
