[
  import_deps: [:ecto],
  inputs: ["*.{ex,exs}", "{config,lib,test}/**/*.{ex,exs}"],
  subdirectories: ["priv/*/migrations"],
  line_length: 100
]
