require 'mini_magick'

module Zroger
  class MinimagickResizeFilter < Rake::Pipeline::Filter
    attr_reader :width, :height, :options

    def initialize(width, height, options = {}, &block)
      @width = width
      @height = height
      @options = {
        :method => 'resize_to_limit',
        :gravity => 'center',
        :background => :transparent
      }.merge(options)

      super(&block)
    end

    def generate_output(inputs, output)
      inputs.each do |input|
        image = ::MiniMagick::Image.open(input.fullpath)
        send(options[:method], image) if respond_to?(options[:method])
        image.write output.fullpath
      end
    end

    ##
    # Resize the image to fit within the specified dimensions while retaining
    # the original aspect ratio. Will only resize the image if it is larger than the
    # specified dimensions. The resulting image may be shorter or narrower than specified
    # in the smaller dimension but will not be larger than the specified values.
    def resize_to_limit(image)
      image.resize "#{width}x#{height}>"
    end

    ##
    # Resize the image to fit within the specified dimensions while retaining
    # the original aspect ratio. The image may be shorter or narrower than
    # specified in the smaller dimension but will not be larger than the specified values.
    def resize_to_fit(image)
      image.resize "#{width}x#{height}"
    end

    ##
    # Resize the image to fit within the specified dimensions while retaining
    # the aspect ratio of the original image. If necessary, crop the image in the
    # larger dimension.
    def resize_to_fill(image)
      gravity = options[:gravity]
      cols, rows = image[:dimensions]
      image.combine_options do |cmd|
        if width != cols || height != rows
          scale_x = width/cols.to_f
          scale_y = height/rows.to_f
          if scale_x >= scale_y
            cols = (scale_x * (cols + 0.5)).round
            rows = (scale_x * (rows + 0.5)).round
            cmd.resize "#{cols}"
          else
            cols = (scale_y * (cols + 0.5)).round
            rows = (scale_y * (rows + 0.5)).round
            cmd.resize "x#{rows}"
          end
        end
        cmd.gravity gravity
        cmd.background "rgba(255,255,255,0.0)"
        cmd.extent "#{width}x#{height}" if cols != width || rows != height
      end
    end

    ##
    # Resize the image to fit within the specified dimensions while retaining
    # the original aspect ratio. If necessary, will pad the remaining area
    # with the given color, which defaults to transparent (for gif and png,
    # white for jpeg).
    def resize_and_pad(image)
      background = options[:background]
      gravity = options[:gravity]

      image.combine_options do |cmd|
        cmd.thumbnail "#{width}x#{height}>"
        if background == :transparent
          cmd.background "rgba(255, 255, 255, 0.0)"
        else
          cmd.background background
        end
        cmd.gravity gravity
        cmd.extent "#{width}x#{height}"
      end
    end
  end
end

class Rake::Pipeline::DSL::PipelineDSL
  # Add a new {MinimagickResizeFilter} to the pipeline.
  # @see MinimagickResizeFilter#initialize
  def resize_image(*args, &block)
    filter(Zroger::MinimagickResizeFilter, *args, &block)
  end
end
