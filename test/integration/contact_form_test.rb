require 'test_helper'

class ContactFormTest < ActionDispatch::IntegrationTest

	test "invalid email" do
		assert_no_difference "OutsideMessage.count" do
			post contact_path, params: { outside_message: { name:  "Visitor",
																											email: "",
																											body:  "Hello"}}
		end
		assert_template "outside_messages/new"
		assert_select "div.text-danger"
	end

	test "invalid body" do
		assert_no_difference "OutsideMessage.count" do
			post contact_path, params: { outside_message: { name:  "Visitor",
																											email: "test@example.com",
																											body:  ""}}
		end
		assert_template "outside_messages/new"
		assert_select "div.text-danger"
	end

	test "valid message submission" do
		get contact_path
		assert_template "outside_messages/new"
		assert_difference "OutsideMessage.count", 1 do
			post contact_path, params: { outside_message: { name:  "Visitor",
																											email: "test@example.com",
																											body:  "Hello"}}
		end
		assert_redirected_to root_path
		assert_not flash.empty?
		# Successful message should have to_admin_id
		outside_message = assigns(:outside_message)
		assert_not_nil outside_message.to_admin_id
	end
end
