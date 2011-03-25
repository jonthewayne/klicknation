Paperclip.interpolates :stockitemtype do |attachment, style|
  %w(attack defense movement).insert(20,"attack","defense","movement")[attachment.instance.type.to_i]
end

Paperclip.interpolates :stockitemname do |attachment, style|
  # any style but "small" gets the _style added to the basename
  style == :small ? "#{basename(attachment, style)}" : "#{basename(attachment, style)}_#{style.to_s}"
end