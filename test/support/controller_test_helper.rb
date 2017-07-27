module ControllerTestHelper
  def json
    JSON.parse(response.body)
  end

  def content_type
    'application/vnd.api+json'
  end
end
