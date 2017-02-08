class CafecitoController < ApplicationController
  before_filter :authenticate
  def show
    @photos = flickr.photosets.getPhotos(photoset_id: Rails.application.secrets.cafectio_photoset_id, extras: 'tags')['photo']

    holiday = Holiday.new

    if holiday.holiday?
      find_tag(holiday.holiday_tag)
    elsif params[:text].present?
      find_tag(params[:text])
    elsif check_weekday
    else
      remove_tags(holiday.holiday_list.values)
      @photos = @photos.select { |p| p['tags'] == 'cafecito' }
    end

    photo = @photos.sample

    url = "https://farm#{photo['farm']}.staticflickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}.jpg"
    render json: {
      response_type: "in_channel",
      text: 'Cafecito Time!',
      unfurl_media: true,
      attachments: [{image_url: url}],
      unfurl_links: true,
      tags: photo['tags']}
  end

  private

  def remove_tags(tags)
    search = []
    @photos.each do |p|
      include_photo = true
      p['tags'].split(' ').each do |tag|
        include_photo = false if tags.include?(tag)
      end
      search << p if include_photo
    end
    @photos = search
  end

  def find_tag(tag)
    @photos = @photos.select { |p| p['tags'].include?(tag)}
  end

  def check_weekday
    today = Date.today
    if today.wednesday?
      find_tag('wednesday')
      return true
    elsif today.friday?
      find_tag('friday')
      return true
    else
      remove_tags(['wednesday', 'friday'])
    end
    false
  end
end
