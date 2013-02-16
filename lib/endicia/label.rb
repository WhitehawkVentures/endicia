module Endicia
  class Label
    attr_accessor :image, 
                  :status, 
                  :tracking_number, 
                  :final_postage, 
                  :transaction_date_time, 
                  :transaction_id, 
                  :postmark_date, 
                  :postage_balance, 
                  :pic,
                  :error_message,
                  :reference_id,
                  :cost_center,
                  :request_body,
                  :request_url,
                  :response_body
    def initialize(result)
      self.response_body = filter_response_body(result.body.dup)
      data = result["LabelRequestResponse"] || {}
      data.each do |k, v|
        if k == "Label"
          v.each do |key, value|
            key = "image" if key == 'Image'
            if send("respond_to?", "#{key.tableize.singularize}=")
              send(:"#{key.tableize.singularize}=", value) if !key['xmlns']
            end
          end
        end
        k = "image" if k == 'Base64LabelImage'
        if send("respond_to?", "#{k.tableize.singularize}=")
          send(:"#{k.tableize.singularize}=", v) if !k['xmlns']
        end
      end
    end
    
    private
    def filter_response_body(string)
      # Strip image data for readability:
      string.sub(/<Base64LabelImage>.+<\/Base64LabelImage>/,
                 "<Base64LabelImage>[data]</Base64LabelImage>")
    end
  end
end
