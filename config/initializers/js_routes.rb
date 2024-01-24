JsRoutes.setup do |c|
  c.module_type = "ESM"
  c.file = Rails.root.join('app/javascript/utils/routes.js')
end
