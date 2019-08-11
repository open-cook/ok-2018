module WebpackHelper
  def webpack_bundle_path(bundle_name)
    webpack_assets_file = "#{Rails.root}/webpack-assets.json"
    file_content = File.read(webpack_assets_file)
    bundles = JSON.parse file_content
    bundles[bundle_name]['js']
  end
end
