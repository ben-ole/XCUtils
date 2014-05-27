# XCUtils

This is a little helper to resize @2x~ipad artwork to all required sizes using rmagick.
On top, the output will be formatted to suit XCodes requirements for sprite atlases.
Images will be resized carefully by first extending images to be dividable by 4 and then generating smaller half and quarter resolutions.

## Installation

Add this line to your application's Gemfile:

    gem 'XCUtils'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install XCUtils

## Usage

run
    xcatlasify

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
