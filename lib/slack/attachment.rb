module Slack
  # See https://api.slack.com/docs/attachments
  class Attachment
    include Virtus.model

    class Field
      include Virtus.model

      values do
        attribute :title, String
        attribute :value, String
        attribute :short, Boolean
      end
    end

    class Action
      include Virtus.model

      class Confirmation
        include Virtus.model

        values do
          attribute :title, String
          attribute :text, String
          attribute :ok_text, String
          attribute :dismiss_text, String
        end
      end

      values do
        attribute :name, String
        attribute :text, String
        attribute :style, String
        attribute :type, String
        attribute :value, String
        attribute :confirm, Confirmation
      end

      # TODO: Need to figure out if there is a way to omit this unless there is a value given
      # This doesn't work so we are showing the default confirmation options every time
      # def to_json
      #   if confirm.nil?
      #     super(:except => :confirm)
      #   else
      #     super
      #   end
      # end
    end

    values do
      attribute :mrkdwn_in, Array[String]
      attribute :text, String
      attribute :fallback, String
      attribute :callback_id, String
      attribute :color, String
      attribute :pretext, String
      attribute :author_name, String
      attribute :author_link, String
      attribute :author_icon, String
      attribute :title, String
      attribute :title_link, String
      attribute :fields, Array[Field]
      attribute :actions, Array[Action]
      attribute :image_url, String
      attribute :thumb_url, String
      attribute :footer, String
      attribute :footer_icon, String
      attribute :ts, Integer
    end
  end
end
