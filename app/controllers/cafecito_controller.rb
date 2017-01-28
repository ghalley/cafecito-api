class CafecitoController < ApplicationController
  before_filter :authenticate
  def show
    photos = flickr.photosets.getPhotos(photoset_id: Rails.application.secrets.cafectio_photoset_id, extras: 'tags')
  end
end
