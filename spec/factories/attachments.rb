FactoryGirl.define do
  factory :attachment do
    filename File.open(File.join(Rails.root, 'app/assets/images/noimage.png'))
  end

end
