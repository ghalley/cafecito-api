class CafecitoController < ApplicationController
  before_filter :authenticate
  def show
    photos = flickr.photosets.getPhotos(photoset_id: Rails.application.secrets.cafectio_photoset_id, extras: 'tags')['photo']

    photo = photos.sample

    url = "https://farm#{photo['farm']}.staticflickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}.jpg"
    render json: url.to_json
  end
end
