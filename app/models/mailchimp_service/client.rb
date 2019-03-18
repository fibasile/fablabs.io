require 'gibbon'

module MailchimpService
    class Client
        include Singleton
  
        attr_accessor :api_key, :list_id
        
        def setOptions(options = {})
            @api_key = options[:api_key] || Figaro.env.mailchimp_api_key
            @list_id = options[:list_id] || Figaro.env.mailchimp_list_id
            @gibbon = Gibbon::Request.new(api_key: api_key)
            if @list_id.nil?
                 raise "list_id can't be null"
            end
        end

        def subscribe(user)
            begin
                @lowercase_email_hash = Digest::MD5.hexdigest(user.email.downcase)
                res = @gibbon.lists(@list_id).members(@lowercase_email_hash).upsert(body: {
                    email_address: user.email,
                    status: "subscribed",
                    merge_fields: {LNAME: user.last_name, FNAME: user.first_name}
                })
                return res
            rescue => e
                puts "Failed to subscribe user: #{e.message} - #{e.raw_body}"
            end
            return nil
        end


        def members()
            begin
                return @gibbon.lists(@list_id).members()
            rescue => e
                puts "Failed to list members: #{e.message} - #{e.raw_body}"
            end
            return nil
        end

        def unsubscribe(user)
            begin
                @lowercase_email_hash = Digest::MD5.hexdigest(user.email.downcase)
                res = @gibbon.lists(@list_id).members(@lowercase_email_hash).update(body: {
                    status: "unsubscribed",
                })
                return res
            rescue => e
                puts "Failed to unsubscribe user: #{e.message} - #{e.raw_body}"
            end
            return nil
        end
    end
end
    