require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  erb :home
end

get '/about' do
  erb :about
end

get '/contact' do
  erb :contact
end

__END__
@@layout
<% title = "Songs by Sinatra" %>
<!doctype html>
<html lang="en">
<head>
  <title><%= "#{title}" %></title>
  <meta charset="utf-8">
</head>
<body>
  <header>
    <h1><%= "#{title}" %></h1>
    <nav>
      <ul>
        <li><a href="/" title="Home">Home</a></li>
        <li><a href="/about" title="About">About</a></li>
        <li><a href="/contact" title="Contact">Contact</a></li>
      </ul>
    </nav>
  </header>
  <section>
    <%= yield %>
  </section>
</body>
</html>
@@home
<p>Welcome to this website all about the songs by the great Frank Sinatra</p>

@@about
<p>This is a demonstration of how to create a website using Sinatra</p>

@@contact
<p>You can contact me at turner@nowwithmoredan.com</p>