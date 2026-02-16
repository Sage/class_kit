# frozen_string_literal: true

module ClassKit
  module Constants
    # Shared constants, to avoid re-creating them on each call to helper methods.
    BOOL_TRUE_RE  = /\A(?:true|t|yes|y|1)\z/i
    BOOL_FALSE_RE = /\A(?:false|f|no|n|0)\z/i
  end
end
