[![Gem Version](https://badge.fury.io/rb/XCUtils.svg)](http://badge.fury.io/rb/XCUtils)

# XCUtils

This is a little helper to resize @2x~ipad artwork to all required sizes using rmagick and assign names by xcode convention like @2x, ~ipad etc.
On top, the output will be formatted to suit XCodes requirements for sprite atlases or xcassets.
Images will be resized carefully by using the 'HammingFilter'.

## Installation

Add this line to your application's Gemfile:

    gem 'XCUtils'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install XCUtils

## Usage

run

    xcutils help [COMMAND]  # Describe available commands or one specific command
    xcutils resize          # Resize single image or directory to all available sizes and optionally pack in xcassets or xcatlas folder
    xcutils sort            # sort directory of all sizes artwork into separate image atlases per size

## Configuration

To ease batch tasks, there is the possibility to add a ```.xcutils-config``` into your source directory providing where you can override the default scale factors:

    scale_iphone_1x       = 0.25
    scale_iphone_2x       = 0.5
    scale_iphone_3x       = 1.0
    scale_ipad_1x         = 0.5
    scale_ipad_2x         = 1.0

    create_image_assets   = false
    create_xcatlas        = false
    dry_run               = false


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
