require 'net/http'
require 'uri'

DOWNLOAD_DIR = File.join(ENV["HOME"], "Downloads")

def download(url, file)
  Thread.new do
    thread = Thread.current
    url = URI.parse url
    Net::HTTP.new(url.host, url.port).request_get(url.path) do |response|
      File.open(file, 'w') do |file|
        length = thread[:length] = response['Content-Length'].to_i
        response.read_body do |fragment|
          file.write fragment
          thread[:done] = (thread[:done] || 0) + fragment.length
          thread[:progress] = thread[:done].quo(length) * 100
        end
      end
    end
  end
end

url = ARGV[0].split("XXXRETURNED_URIXXX")[1] if ARGV[0]
if url
  `echo 'event ESCAPE' > $UZBL_FIFO`
  if ARGV[1] == "picker"
    file = `zenity --file-selection --save --confirm-overwrite --filename '#{File.basename(URI.decode(url))}'`.strip
  else
    file = File.join(DOWNLOAD_DIR, File.basename(url))
  end
  thread = download(url, file)
  `echo 'set downloads = #{"%.2f%%" % thread[:progress].to_f}' > $UZBL_FIFO` until thread.join 1
  file
end
