class CafecitoController < ApplicationController
  before_filter :authenticate
  def show
    photos = flickr.photosets.getPhotos(photoset_id: Rails.application.secrets.cafectio_photoset_id, extras: 'tags')['photo']

    holiday = Holiday.new

    if holiday.holiday?
      search = photos.select {|p| p['tags'].include?(holiday.holiday_tag)}
    elsif params[:text].present?
      search = photos.select { |p| p['tags'].split(' ').include?(params[:text]) }
    else
      search = []
      photos.each do |p|
        include_photo = true
        p['tags'].split(' ').each do |tag|
          include_photo = false if holiday.holiday_list.values.include?(tag)
        end
        search << p if include_photo
      end
    end

    photo = search.present? ? search.sample : photos.sample

    url = "https://farm#{photo['farm']}.staticflickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}.jpg"
    render json: {text: url, unfurl_media: true, attachments: [{image_url: url}], unfurl_links: true}
  end
end
