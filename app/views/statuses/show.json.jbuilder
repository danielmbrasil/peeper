# frozen_string_literal: true

json.body @status.body
json.display_name @status.user.display_name
json.reply_peep true if @status.parent_id.present?
json.media @status.media.size
