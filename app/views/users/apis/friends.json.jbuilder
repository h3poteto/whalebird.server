json.extract! @response.attrs, :users
json.next_cursor_str @response.attrs[:next_cursor_str]
