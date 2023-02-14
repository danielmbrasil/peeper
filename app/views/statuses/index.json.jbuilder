# frozen_string_literal: true

json.array! @statuses do |status|
  if status.body.length > Status::BODY_INDEX_DISPLAY_LENGTH
    json.body status.body.truncate(Status::BODY_INDEX_DISPLAY_LENGTH, omission: Status::TRUNCATED_BODY_TERMINATOR)
    json.full_body status.body
  else
    json.body status.body
  end

  json.display_name status.user.display_name

  json.reply_peep true if status.status_id.present?
end
