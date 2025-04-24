module Possum::Page::Config
  SCROLL_DISTANCE = 10_000
  NETWORK_IDLE_TIMEOUT = 5

  BLOCKED_IMAGE_EXTENSIONS = %w[.jpg .jpeg .png .gif .bmp .svg .webp]
  BLOCKED_VIDEO_EXTENSIONS = %w[.mp4 .avi .mov .mkv .webm]
  BLOCKED_SOUND_EXTENSIONS = %w[.mp3 .ogg .wav .aac .flac]
  BLOCKED_FONT_EXTENSIONS = %w[.woff .woff2 .ttf .otf .eot]
  BLOCKED_FILETYPES = BLOCKED_IMAGE_EXTENSIONS + BLOCKED_VIDEO_EXTENSIONS + BLOCKED_SOUND_EXTENSIONS + BLOCKED_FONT_EXTENSIONS

  HEADERS = {
    "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
    "Accept-Encoding" => "gzip, deflate, br, zstd",
    "Accept-Language" => "en-GB,en-US;q=0.9,en;q=0.8",
    "Cache-Control" => "no-cache",
    "Pragma" => "no-cache",
    "Priority" => "u=0, i",
    "Sec-Ch-Ua" => '"Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"',
    "Sec-Ch-Ua-Mobile" => "?0",
    "Sec-Ch-Ua-Platform" => "\"macOS\"",
    "Sec-Fetch-Dest" => "document",
    "Sec-Fetch-Mode" => "navigate",
    "Sec-Fetch-Site" => "cross-site",
    "Sec-Fetch-User" => "?1",
    "Upgrade-Insecure-Requests" => "1",
    "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"
  }
end
