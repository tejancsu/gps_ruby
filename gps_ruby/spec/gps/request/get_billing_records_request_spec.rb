# require 'spec_helper'

# describe Gps::Request::GetBillingRecordsRequest do

#   let(:get_br_request_url_params) do
#     {
#       :purchaser_id => UUIDTools::UUID.timestamp_create.to_s,
#       :country_code => "IN"
#     }
#   end

#   let(:host) { "gps.snc1"}

#   it "creates request object successfully" do
#     request = Gps::Request::GetBillingRecordsRequest.new(host, {}, get_br_request_url_params)
#     request.url.should == "gps.snc1/IN/billing_records?purchaser_id=#{get_br_request_url_params[:purchaser_id]}"
#     request.http_method.should == :get
#     request.body.should == "{}"
#   end

#   context "when keys which are not expected exist in the url params" do
#     it "creates request object successfully" do
#       get_br_request_hash = get_br_request_url_params
#       get_br_request_hash["bleh"] = "pgriffin"
#       expect{ Gps::Request::GetBillingRecordsRequest.new(host, {}, get_br_request_hash) }.to_not raise_error
#     end
#   end

#   context "when a url param is missing" do

#     context "when purchaser_id is not present" do
#       it "raises error as expected" do
#         get_br_request_url_params[:purchaser_id] = nil
#         expect{ Gps::Request::GetBillingRecordsRequest.new(host, {}, get_br_request_url_params) }.to raise_error(Gps::Request::ParamsErrorException, "The required url parameter 'purchaser_id' is not defined for Gps::Request::GetBillingRecordsRequest.")
#       end
#     end
#   end
# end