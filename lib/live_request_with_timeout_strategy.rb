require 'scraped/request/strategy/live_request'

class LiveRequestWithTimeoutStrategy < Scraped::Request::Strategy::LiveRequest
  def response
    log "Fetching #{url}"
    response = open(url, read_timeout: 5, open_timeout: 5)
    {
      status:  response.status.first.to_i,
      headers: response.meta,
      body:    response.read,
    }
  rescue Timeout::Error
    # Return nil so that the next strategy will be tried.
    return nil
  end
end
