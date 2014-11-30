namespace :image do
  desc "clean old image"
  task :clean => :environment do
    today = Time.now
    @attachments = Attachment.where(created_at: today.prev_month...today.yesterday)
    @attachments.each do |attach|
      File.delete(attach.filename.path)
      attach.destroy
    end
  end
end
