class File
  def save_to_s3 bucket_name, folder_name, dest_name
    s3 = AWS::S3.new(
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])
    bucket = s3.buckets[bucket_name]
    self.binmode
    s3_key = "#{folder_name}/#{Time.zone.now.strftime('%Y-%m-%d')}/#{dest_name}"
    bucket.objects[s3_key].write(self)  
    return s3_key
  end
  
  def self.tmp_from_s3 bucket_name, s3_key
    s3 = AWS::S3.new(
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])
    bucket = s3.buckets[bucket_name]
    f = File.new("/tmp/#{File.basename(s3_key)}", "wb")
    f.write(bucket.objects[s3_key].read)
    f.close
    return f
  end
  
end
