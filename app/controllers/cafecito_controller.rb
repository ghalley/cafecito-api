class CafecitoController < ApplicationController
  before_filter :authenticate
  def show
    photos = flickr.photosets.getPhotos(photoset_id: Rails.application.secrets.cafectio_photoset_id, extras: 'tags')['photo']

    holiday = Holiday.new

    if holiday.holiday?
      search = photos.select {|p| p['tags'].include?(holiday.holiday_tag)}
    elsif params[:text].present?
      search = photos.select { |p| p['tags'].split(' ').include?(params[:text]) }
    end

    photo = search.present? ? search.sample : photos.sample

    url = "https://farm#{photo['farm']}.staticflickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}.jpg"
    render json: url.to_json
  end
end
