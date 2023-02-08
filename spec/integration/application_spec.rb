require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context 'GET /albums' do
    it 'shoud return all albums formatted in an HTML page' do
      response = get('/albums')
      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Albums</h1>")
      expect(response.body).to include("Title: <a href ='/albums/2'>Surfer Rosa</a>")
      expect(response.body).to include("Released: 1988")
      expect(response.body).to include("Title: <a href ='/albums/12'>Ring Ring</a>")
      expect(response.body).to include("Released: 1973")
    end
  end

  context 'GET /albums/:id' do
    it 'should return info about one album' do
      response = get('/albums/2')
      
      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: Pixies')
    end

  end

  context 'GET /albums/new' do
    it 'should return the form to add a new album' do
      response = get('/albums/new')

      expect(response.status).to eq 200
      expect(response.body).to include('<form method="POST" action="/albums">')
      expect(response.body).to include('<input type="text" name="title" />')
      expect(response.body).to include('<input type="text" name="release_year" />')
      expect(response.body).to include('<input type="text" name="artist_id" />')
    end
  end

  context 'POST /albums' do
    it "should validate album parameters" do
      response = post(
        '/albums',
        invalid_title: 'a title',
        another_invalid_thing:123
    )
    expect(response.status).to eq 400
    end


    it 'should create a new album' do
      response = post(
        '/albums',
        title:'OK Computer',
        release_year: '1997',
        artist_id: '1'
      )

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/albums')
      expect(response.body).to include('OK Computer')
    end
  end

  context 'GET /artists' do
    it 'should return an html page of all artists with links to each' do
      response = get('/artists')
      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Artists</h1>")
      expect(response.body).to include("Name: <a href ='/artists/1'>Pixies</a>")
      expect(response.body).to include("Genre: Rock")
      expect(response.body).to include("Name: <a href ='/artists/4'>Nina Simone</a>")
      expect(response.body).to include("Genre: Pop")
    end
  end

  context 'GET /artists/:id' do
    it 'should return an html page with details of the given artist' do
      response = get('/artists/1')
      expect(response.status).to eq 200
      expect(response.body).to include("<h1>Pixies</h1>")
      expect(response.body).to include("Genre: Rock")
    end
  end

  context 'POST /artists' do
    it 'creates a new artist' do
      response = post(
        '/artists',
        name:'Radiohead',
        genre:'Rock'
      )

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/artists')
      expect(response.body).to include('Radiohead')     
    end
  end

end
