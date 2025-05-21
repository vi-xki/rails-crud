class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates :title, presence: true
  validates :content, presence: true
  validates :caption, length: { maximum: 500 }
  validate :acceptable_images

  accepts_nested_attributes_for :tags, allow_destroy: true

  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_list=(names)
    self.tags = names.split(',').map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end

  private

  def acceptable_images
    return unless images.attached?

    images.each do |image|
      unless image.blob.byte_size <= 10.megabyte
        errors.add(:images, "#{image.filename} is too big (maximum is 10MB)")
      end

      acceptable_types = ["image/jpeg", "image/png", "image/gif"]
      unless acceptable_types.include?(image.blob.content_type)
        errors.add(:images, "#{image.filename} must be a JPEG, PNG, or GIF")
      end
    end
  end
end
